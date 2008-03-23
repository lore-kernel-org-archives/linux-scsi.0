From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/8] rework scsi_target allocation
Date: Sat, 22 Mar 2008 23:08:49 -0500
Message-ID: <1206245329.4393.31.camel@localhost.localdomain>
References: <20080318133228.764CA15915C@pentland.suse.de>
	 <1206038103.3038.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47710 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125AbYCWEIy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Mar 2008 00:08:54 -0400
In-Reply-To: <1206038103.3038.37.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-03-20 at 13:35 -0500, James Bottomley wrote:
> On Tue, 2008-03-18 at 14:32 +0100, Hannes Reinecke wrote:
> > The current target allocation code registeres each possible target
> > with sysfs; it will be deleted again if no useable LUN on this target
> > was found. This results in a string of 'target add/target remove' uevents.
> > 
> > This patch reworks the target allocation code so that only
> > uevents for existing targets are sent. The sysfs registration
> > is split off from the existing scsi_target_alloc() into a
> > in a new scsi_add_target() function, which should be called
> > whenever an existing target is found. Only then a uevent is
> > sent, so we'll be generating events for existing targets only.
> > 
> > And while we're at it the cleanup code has been moved to the
> > ->release function, so that the target will always be useable
> > as long as the reference to it is held.
> 
> This just doesn't work.  The problem is that calling
> transport_destroy_device() from the release method means the target is
> never released.  I know you tried to work around it in patch 6 (Fix
> refcounting for attribute_container) but that doesn't fix it (and it's
> not really correct: the attributes are using the device, they should
> have a ref to it).  The underlying problem is that in the new view of
> classes, the directory for the class devices already has a ref on the
> target.
> 
> You can see this simply by removing and inserting the aic79xx module
> with these patches applied:
> 
> list_add corruption. prev->next should be next (c045e3c0), but was 6b6b6b6b. (prev=f5374b84).
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:33!
> invalid opcode: 0000 [#1] SMP 
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.4/0000:04:00.0/irq
> Modules linked in: aic79xx(+) sr_mod cdrom serio_raw iTCO_wdt iTCO_vendor_support i3000_edac ext3 jbd mbcache sd_mod uhci_hcd scsi_transport_spi aic94xx libsas libata firmware_class scsi_transport_sas tg3 usbcore scsi_mod [last unloaded: aic79xx]
> 
> Pid: 4139, comm: modprobe Not tainted (2.6.25-rc6-mc7 #12)
> EIP: 0060:[<c01ed92a>] EFLAGS: 00010282 CPU: 1
> EIP is at __list_add+0x5a/0x60
> EAX: 00000061 EBX: f7a06d9c ECX: c0119540 EDX: f7d7af30
> ESI: f8963d20 EDI: 00000011 EBP: f7a6be40 ESP: f7a6be2c
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process modprobe (pid: 4139, ti=f7a6a000 task=f7d7af30 task.ti=f7a6a000)
> Stack: c0416d00 c045e3c0 6b6b6b6b f5374b84 f7a06d9c f7a6be4c c025722b f7a06d50 
>        f7a6be5c f8870b24 ffffffed f89652c0 f7a6be88 f884e0fa f89652c0 00000001 
>        f89652c0 f89652c0 00000011 f7a6be88 f89652c0 f89652c0 00000011 f7a6bfb0 
> Call Trace:
>  [<c025722b>] ? attribute_container_register+0x3b/0x50
>  [<f8870b24>] ? spi_attach_transport+0x44/0x80 [scsi_transport_spi]
>  [<f884e0fa>] ? ahd_linux_init+0xfa/0x2bc [aic79xx]
>  [<c01487aa>] ? sys_init_module+0xea/0x1c90
>  [<c0128140>] ? __request_region+0x0/0x80
>  [<c01041d7>] ? restore_nocheck+0x12/0x15
>  [<c01405ed>] ? trace_hardirqs_on+0xbd/0x140
>  [<c0104176>] ? syscall_call+0x7/0xb
>  =======================
> Code: 44 24 08 c7 04 24 b0 6c 41 c0 e8 92 54 f3 ff 0f 0b eb fe 89 54 24 08 89 4c 24 04 89 44 24 0c c7 04 24 00 6d 41 c0 e8 76 54 f3 ff <0f> 0b eb fe 66 90 8b 0a 55 89 e5 e8 96 ff ff ff 5d c3 90 90 90 
> EIP: [<c01ed92a>] __list_add+0x5a/0x60 SS:ESP 0068:f7a6be2c
> ---[ end trace 5eac9928f4e352f7 ]---

OK, try this, it fixes the problem and allows the target to be
destroyed and fixes the above panic (I can now insert and remove the
aic79xx and scsi_transport_spi module without issue).

James

---

 drivers/scsi/scsi_scan.c   |   72 ++++++++++++++++++++-----------------------
 drivers/scsi/scsi_sysfs.c  |   27 ++++++++++++++++
 include/scsi/scsi_device.h |    3 +-
 3 files changed, 63 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e1644b2..fcd7455 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -322,6 +322,21 @@ out:
 	return NULL;
 }
 
+static void scsi_target_destroy(struct scsi_target *starget)
+{
+	struct device *dev = &starget->dev;
+	struct Scsi_Host *shost = dev_to_shost(dev->parent);
+	unsigned long flags;
+
+	transport_destroy_device(dev);
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (shost->hostt->target_destroy)
+		shost->hostt->target_destroy(starget);
+	list_del_init(&starget->siblings);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	put_device(dev);
+}
+
 static void scsi_target_dev_release(struct device *dev)
 {
 	struct device *parent = dev->parent;
@@ -406,7 +421,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->channel = channel;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
-	starget->state = STARGET_RUNNING;
+	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -419,18 +434,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
 	transport_setup_device(dev);
-	error = device_add(dev);
-	if (error) {
-		dev_err(dev, "target device_add failed, error %d\n", error);
-		spin_lock_irqsave(shost->host_lock, flags);
-		list_del_init(&starget->siblings);
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		transport_destroy_device(dev);
-		put_device(parent);
-		kfree(starget);
-		return NULL;
-	}
-	transport_add_device(dev);
 	if (shost->hostt->target_alloc) {
 		error = shost->hostt->target_alloc(starget);
 
@@ -438,9 +441,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
 			/* don't want scsi_target_reap to do the final
 			 * put because it will be under the host lock */
-			get_device(dev);
-			scsi_target_reap(starget);
-			put_device(dev);
+			scsi_target_destroy(starget);
 			return NULL;
 		}
 	}
@@ -467,18 +468,10 @@ static void scsi_target_reap_usercontext(struct work_struct *work)
 {
 	struct scsi_target *starget =
 		container_of(work, struct scsi_target, ew.work);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	unsigned long flags;
 
 	transport_remove_device(&starget->dev);
 	device_del(&starget->dev);
-	transport_destroy_device(&starget->dev);
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (shost->hostt->target_destroy)
-		shost->hostt->target_destroy(starget);
-	list_del_init(&starget->siblings);
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	put_device(&starget->dev);
+	scsi_target_destroy(starget);
 }
 
 /**
@@ -493,21 +486,25 @@ void scsi_target_reap(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
+	enum scsi_target_state state;
+	int empty;
 
 	spin_lock_irqsave(shost->host_lock, flags);
+	state = starget->state;
+	empty = --starget->reap_ref == 0 &&
+		list_empty(&starget->devices) ? 1 : 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
-		BUG_ON(starget->state == STARGET_DEL);
-		starget->state = STARGET_DEL;
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		execute_in_process_context(scsi_target_reap_usercontext,
-					   &starget->ew);
+	if (!empty)
 		return;
 
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	return;
+	BUG_ON(state == STARGET_DEL);
+	starget->state = STARGET_DEL;
+	if (state == STARGET_CREATED)
+		scsi_target_destroy(starget);
+	else
+		execute_in_process_context(scsi_target_reap_usercontext,
+					   &starget->ew);
 }
 
 /**
@@ -1056,8 +1053,9 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 					scsi_inq_str(vend, result, 8, 16),
 					scsi_inq_str(mod, result, 16, 32));
 			});
+
 		}
-		
+
 		res = SCSI_SCAN_TARGET_PRESENT;
 		goto out_free_result;
 	}
@@ -1497,7 +1495,6 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	if (scsi_host_scan_allowed(shost))
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	mutex_unlock(&shost->scan_mutex);
-	transport_configure_device(&starget->dev);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
 
@@ -1578,7 +1575,6 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
  out_reap:
 	/* now determine if the target has any children at all
 	 * and if not, nuke it */
-	transport_configure_device(&starget->dev);
 	scsi_target_reap(starget);
 
 	put_device(&starget->dev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 3b582b4..2c4b419 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -809,6 +809,27 @@ sdev_store_queue_type_rw(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+static int scsi_target_add(struct scsi_target *starget)
+{
+	int error;
+
+	if (starget->state != STARGET_CREATED)
+		return 0;
+
+	error = device_add(&starget->dev);
+	if (error) {
+		dev_err(&starget->dev, "target device_add failed, error %d\n", error);
+		get_device(&starget->dev);
+		scsi_target_reap(starget);
+		put_device(&starget->dev);
+		return error;
+	}
+	transport_add_device(&starget->dev);
+	starget->state = STARGET_RUNNING;
+
+	return 0;
+}
+
 static struct device_attribute sdev_attr_queue_type_rw =
 	__ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
 	       sdev_store_queue_type_rw);
@@ -824,10 +845,16 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
 	int error, i;
 	struct request_queue *rq = sdev->request_queue;
+	struct scsi_target *starget = sdev->sdev_target;
 
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
 		return error;
 
+	error = scsi_target_add(starget);
+	if (error)
+		return error;
+
+	transport_configure_device(&starget->dev);
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		put_device(sdev->sdev_gendev.parent);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index b8b19e2..f6a9fe0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -181,7 +181,8 @@ struct scsi_device {
 	sdev_printk(prefix, (scmd)->device, fmt, ##a)
 
 enum scsi_target_state {
-	STARGET_RUNNING = 1,
+	STARGET_CREATED = 1,
+	STARGET_RUNNING,
 	STARGET_DEL,
 };
 
-- 
1.5.4.3



