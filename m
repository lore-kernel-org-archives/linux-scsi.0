From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] Unblock SCSI devices even if the LLD is being
 unloaded
Date: Fri, 17 Mar 2017 05:54:28 -0700
Message-ID: <1489755268.2373.11.camel@HansenPartnership.com>
References: <20170316205650.3322-1-bart.vanassche@sandisk.com>
         <1489704797.4650.8.camel@HansenPartnership.com>
         <1489706379.2574.24.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39856 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751209AbdCQMyd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Mar 2017 08:54:33 -0400
In-Reply-To: <1489706379.2574.24.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>

On Thu, 2017-03-16 at 23:19 +0000, Bart Van Assche wrote:
> On Thu, 2017-03-16 at 15:53 -0700, James Bottomley wrote:
> > On Thu, 2017-03-16 at 13:56 -0700, Bart Van Assche wrote:
> > > scsi_target_unblock() must unblock SCSI devices even if this
> > > function
> > > is called after unloading of the LLD that created these devices
> > > has
> > > started. This is necessary to prevent that __scsi_remove_device()
> > > hangs on the SYNCHRONIZE CACHE command issued by the sd driver
> > > during
> > > shutdown.
> > 
> > Your special get function misses the try_module_get().  But this is
> > all
> > really a bit ugly. Since the only problem is the SYNC CACHE 
> > triggered by device_del, isn't a better solution a new state:
> > SDEV_CANCEL_BLOCK.  This will make the device visible to 
> > scsi_get_device() and we can take it back from CANCEL_BLOCKED
> > ->CANCEL when the queue is unblocked.  I suspect we could also 
> > simply throw away the sync cache command when the device is blocked 
> > (the cache should destage naturally in the time it takes for the
> > device to be unblocked).
> 
> Hello James,
> 
> The purpose of this patch series is to make sure that unblock also 
> occurs after module unloading has started. My understanding of
> try_module_get() is that it fails once module unloading has started.
>  In other words, it is on purpose that try_module_get() is not
> called. From the kernel module
> code:
> 
> bool try_module_get(struct module *module)
> {
> 	bool ret = true;
> 
> 	if (module) {
> 		preempt_disable();
> 		/* Note: here, we can fail to get a reference */
> 		if (likely(module_is_live(module) &&
> 			   atomic_inc_not_zero(&module->refcnt) != 0))
> 			trace_module_get(module, _RET_IP_);
> 		else
> 			ret = false;
> 		preempt_enable();
> 	}
> 	return ret;
> }
> 
> static inline int module_is_live(struct module *mod)
> {
> 	return mod->state != MODULE_STATE_GOING;
> }

So it's better to use the module without a reference in place and take
the risk that it may exit and release its code area while we're calling
it?

> Regarding introducing a new device state: this is something I would 
> like to avoid. Any code that manipulates the SCSI device state is
> unnecessarily hard to modify because multiple types of state 
> information have been mixed up in a single state variable (blocked / 
> not blocked; created / running / cancel / offline). Additionally, the 
> SCSI device state is visible to user space.
> Adding a new SCSI device state could break existing user space
> applications.

I'm not sure that's a real concern for a new cancel state, but it's
addressable by not exposing the state to user space (it can just show
up as blocked)

> There is another problem with the introduction of the 
> SDEV_CANCEL_BLOCKED state: we do not want open() calls to succeed for 
> devices that are in the SDEV_DEL, SDEV_CANCEL nor for devices that 
> are in the SDEV_CANCEL_BLOCKED state. scsi_disk_get() in the sd 
> driver relies on scsi_device_get() to check the SCSI device state. If 
> scsi_device_get() would succeed for devices in the
> SDEV_CANCEL_BLOCKED state then an explicit check for that state would 
> have to be added in several users of scsi_device_get().

That really doesn't matter: getting a reference via open is a race. 
 Currently if you do it just before SDEV_CANCEL you end up in the same
position: a properly refcounted open device that can't send any
commands, so this doesn't add any new problems.

>  In other words, I think adding the SDEV_CANCEL_BLOCKED state would
> result in a much more complex and also harder to test patch.

Fine, here's what I thing it would look like; it seems a lot shorter
and simpler to me, but if you want to pursue your approach fixing the
race with module exit is a requirement.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba22866..b952a6a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1248,6 +1248,13 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 				    "rejecting I/O to dead device\n");
 			ret = BLKPREP_KILL;
 			break;
+		case SDEV_CANCEL_BLOCK:
+			/*
+			 * silently kill the I/O: the only allowed thing
+			 * is a ULD remove one (like SYNC CACHE)
+			 */
+			ret = BLKPREP_KILL;
+			break;
 		case SDEV_BLOCK:
 		case SDEV_CREATED_BLOCK:
 			ret = BLKPREP_DEFER;
@@ -2604,6 +2611,15 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		}
 		break;
 
+	case SDEV_CANCEL_BLOCK:
+		switch (oldstate) {
+		case SDEV_CANCEL:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
 	case SDEV_CANCEL:
 		switch (oldstate) {
 		case SDEV_CREATED:
@@ -2612,6 +2628,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_BLOCK:
+		case SDEV_CANCEL_BLOCK:
 			break;
 		default:
 			goto illegal;
@@ -3017,6 +3034,8 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 			sdev->sdev_state = new_state;
 		else
 			sdev->sdev_state = SDEV_CREATED;
+	} else if (sdev->sdev_state == SDEV_CANCEL_BLOCK) {
+		sdev->sdev_state = SDEV_CANCEL;
 	} else if (sdev->sdev_state != SDEV_CANCEL &&
 		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 82dfe07..fd1ba1d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -39,6 +39,7 @@ static const struct {
 	{ SDEV_TRANSPORT_OFFLINE, "transport-offline" },
 	{ SDEV_BLOCK,	"blocked" },
 	{ SDEV_CREATED_BLOCK, "created-blocked" },
+	{ SDEV_CANCEL_BLOCK, "blocked" },
 };
 
 const char *scsi_device_state_name(enum scsi_device_state state)
@@ -972,7 +973,8 @@ sdev_store_dh_state(struct device *dev, struct device_attribute *attr,
 	int err = -EINVAL;
 
 	if (sdev->sdev_state == SDEV_CANCEL ||
-	    sdev->sdev_state == SDEV_DEL)
+	    sdev->sdev_state == SDEV_DEL ||
+	    sdev->sdev_state == SDEV_CANCEL_BLOCK)
 		return -ENODEV;
 
 	if (!sdev->handler) {
@@ -1282,7 +1284,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		return;
 
 	if (sdev->is_visible) {
-		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0
+		    && scsi_device_set_state(sdev, SDEV_CANCEL_BLOCK) != 0)
 			return;
 
 		bsg_unregister_queue(sdev->request_queue);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6f22b39..a78a17a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -48,6 +48,7 @@ enum scsi_device_state {
 				 * should be issued to the scsi
 				 * lld. */
 	SDEV_CREATED_BLOCK,	/* same as above but for created devices */
+	SDEV_CANCEL_BLOCK,	/* same as above but for cancelling devices */
 };
 
 enum scsi_scan_mode {
