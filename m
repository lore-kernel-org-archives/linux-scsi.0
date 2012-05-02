From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 07/17] hpsa: do not give up retry of driver cmds after only 3 retries
Date: Wed, 2 May 2012 11:30:09 -0500
Message-ID: <20120502163009.GV11802@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com> <20120501164240.11705.10308.stgit@beardog.cce.hp.com> <20120501172634.GA11302@andi> <20120501182011.GS11802@beardog.cce.hp.com> <20120501213934.GD11302@andi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34551 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2EBQaN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2012 12:30:13 -0400
Content-Disposition: inline
In-Reply-To: <20120501213934.GD11302@andi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Cc: scameron@beardog.cce.hp.com

On Tue, May 01, 2012 at 11:39:34PM +0200, Andi Shyti wrote:
> Hi Steve,
> 
> Thanks for the walk-through, but still some doubts...
> 
> On Tue, May 01, 2012 at 01:20:11PM -0500, scameron@beardog.cce.hp.com wrote:
> > On Tue, May 01, 2012 at 07:26:34PM +0200, Andi Shyti wrote:
> > > >  
> > > >  	do {
> > > >  		memset(c->err_info, 0, sizeof(*c->err_info));
> > > >  		hpsa_scsi_do_simple_cmd_core(h, c);
> > > >  		retry_count++;
> > > > +		if (retry_count > 3) {
> > > > +			msleep(backoff_time);
> > > 
> > > for 10ms isn't it better to avoid using msleep?
> > 
> > [...] 
> > > > +			if (backoff_time < 1000)
> > > > +				backoff_time *= 2;
> > 
> > Eh, maybe.  from Documentation/timers-howto.txt
> > 
> >                         msleep(1~20) may not do what the caller intends, and
> >                         will often sleep longer (~20 ms actual sleep for any
> >                         value given in the 1~20ms range). In many cases this
> >                         is not the desired behavior.
> > 
> > Sleeping longer (~20ms instead of 10ms) in this instance is fine, as I don't
> > really care too much exactly how long it sleeps, and it backs off to up to
> > 1280ms eventually anyway.  The idea is, "wait a bit, and retry, and then if
> > that doesn't work, wait twice as long, and retry, etc."  *exactly* how long
> > "a bit" is is not super important.  I could change the initial back_off time
> > to 20 or 30 to satisfy the letter of the advice in Documentation/timers-howto.txt,
> > if doing so is important.
> 
> No, you're right, it should not really matter, but here in the
> worst case you put the driver on sleep for almost 22 seconds,
> that is a huge difference compared to the original
> implementation.
>  
> > This is kind of a corner case of a corner case, I don't expect
> > things will ordinarily end up waiting that long, because normally
> > one of the 1st 3 retries will succeed.  I just wanted to make it 
> > a little more robust and not just give up immediately if the 3
> > initial retries don't succeed, the specific number of retries,
> > wait times, etc, I just made up.
> 
> Premising that I don't know the device, therefore I could be
> totally wrong, if you don't expect things to wait so long, why not
> to decrease the MAX_DRIVER_CMD_RETRIES and sleep increasingly (as
> you did) but for shorter period?

[...]

Yes the behavior is different, intentionally so.

Here's a patch to test it out.  I add a sysfs attribute to the host to
tell it to simulate being busy for the specified number of seconds, and
add some debug code so we can see what's happening.

commit 37edc48530210ea49d38fdafb0ba11da8d8b6d53
Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Date:   Wed May 2 08:34:17 2012 -0500

    hpsa: debug retry behavior change
    
    This patch is just for testing.

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cb9d619..c2a4128 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -255,6 +255,29 @@ static ssize_t host_store_rescan(struct device *dev,
 	return count;
 }
 
+static ssize_t host_store_act_busy(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	int rc;
+	unsigned long flags;
+	u64 now, val;
+
+	h = shost_to_hba(shost);
+
+	rc = sscanf(buf, "%llu", &val);
+	if (rc != 1 || val > 30)
+		return count;
+	dev_warn(&h->pdev->dev, "Will act busy for %llu seconds.\n", val);
+	now = get_jiffies_64() + val * HZ;
+	spin_lock_irqsave(&h->act_busy_lock, flags);
+	h->act_busy = now;
+	spin_unlock_irqrestore(&h->act_busy_lock, flags);
+	return count;
+}
+
 static ssize_t host_show_firmware_revision(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
@@ -480,6 +503,8 @@ static DEVICE_ATTR(transport_mode, S_IRUGO,
 	host_show_transport_mode, NULL);
 static DEVICE_ATTR(resettable, S_IRUGO,
 	host_show_resettable, NULL);
+static DEVICE_ATTR(act_busy, S_IWUSR,
+	NULL, host_store_act_busy);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -494,6 +519,7 @@ static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_commands_outstanding,
 	&dev_attr_transport_mode,
 	&dev_attr_resettable,
+	&dev_attr_act_busy,
 	NULL,
 };
 
@@ -1228,7 +1254,7 @@ static void complete_scsi_command(struct CommandList *cp)
 		 * Pass it up to the upper layers...
 		 */
 		if (ei->ScsiStatus) {
-			dev_warn(&h->pdev->dev, "cp %p has status 0x%x "
+			dev_dbg(&h->pdev->dev, "cp %p has status 0x%x "
 				"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
 				"Returning result: 0x%x\n",
 				cp, ei->ScsiStatus,
@@ -1389,6 +1415,15 @@ static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
 	do {
 		memset(c->err_info, 0, sizeof(*c->err_info));
 		hpsa_scsi_do_simple_cmd_core(h, c);
+		if (retry_count > 0) {
+			dev_warn(&h->pdev->dev,
+				"RETRYING(%d): %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
+				retry_count,
+				c->Request.CDB[0], c->Request.CDB[1], c->Request.CDB[2], c->Request.CDB[3],
+				c->Request.CDB[4], c->Request.CDB[5], c->Request.CDB[6], c->Request.CDB[7],
+				c->Request.CDB[8], c->Request.CDB[9], c->Request.CDB[10], c->Request.CDB[11],
+				c->Request.CDB[12], c->Request.CDB[13], c->Request.CDB[14], c->Request.CDB[15]);
+		}
 		retry_count++;
 		if (retry_count > 3) {
 			msleep(backoff_time);
@@ -3063,9 +3098,33 @@ static inline int bad_tag(struct ctlr_info *h, u32 tag_index,
 	return 0;
 }
 
+static void act_busy(struct CommandList *c)
+{
+	struct ctlr_info *h = c->h;
+	unsigned long flags;
+	u64 now;
+
+	now = get_jiffies_64();
+	spin_lock_irqsave(&h->act_busy_lock, flags);
+	if (!h->act_busy) {
+		spin_unlock_irqrestore(&h->act_busy_lock, flags);
+		return;
+	}
+
+	if (time_after64(now, h->act_busy)) {
+		h->act_busy = 0;
+		spin_unlock_irqrestore(&h->act_busy_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&h->act_busy_lock, flags);
+	c->err_info->CommandStatus = CMD_TARGET_STATUS;
+	c->err_info->ScsiStatus = SAM_STAT_BUSY;
+}
+
 static inline void finish_cmd(struct CommandList *c, u32 raw_tag)
 {
 	removeQ(c);
+	act_busy(c);
 	if (likely(c->cmd_type == CMD_SCSI))
 		complete_scsi_command(c);
 	else if (c->cmd_type == CMD_IOCTL_PEND)
@@ -4337,6 +4396,7 @@ reinit_after_soft_reset:
 	INIT_LIST_HEAD(&h->reqQ);
 	spin_lock_init(&h->lock);
 	spin_lock_init(&h->scan_lock);
+	spin_lock_init(&h->act_busy_lock);
 	rc = hpsa_pci_init(h);
 	if (rc != 0)
 		goto clean1;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 48f7812..b381694 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -125,6 +125,8 @@ struct ctlr_info {
 	u64 last_heartbeat_timestamp;
 	u32 lockup_detected;
 	struct list_head lockup_list;
+	u64 act_busy;
+	spinlock_t act_busy_lock; /* to protect act_busy */
 };
 #define HPSA_ABORT_MSG 0
 #define HPSA_DEVICE_RESET_MSG 1



Now, testing that out, I tell the host to act busy for 20 seconds
(not a likely scenario, but not inconceivable).  Then, I tell it
to rescan for logical drives while it is busy.  With the patch,
to retry 25 times over a longer period of time, here's what happens:

[root@localhost scameron]# find /sys -name 'act_busy'
/sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/act_busy
/sys/devices/pci0000:00/0000:00:06.0/0000:05:00.0/host1/scsi_host/host1/act_busy
[root@localhost scameron]# find /sys -name 'rescan' | grep host0
/sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/rescan
/sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/target0:0:0/0:0:0:0/rescan
/sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/target0:3:0/0:3:0:0/rescan
[root@localhost scameron]# echo 1 > /sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/rescan
[root@localhost scameron]# tail -f /var/log/messages &
[1] 9862
[root@localhost scameron]# May  2 10:48:01 localhost avahi-daemon[9035]: Registering HINFO record with values 'X86_64'/'LINUX'.
May  2 10:48:02 localhost avahi-daemon[9035]: Withdrawing address record for 192.168.122.1 on virbr0.
May  2 10:48:02 localhost avahi-daemon[9035]: Withdrawing address record for 10.10.12.180 on eth0.
May  2 10:48:02 localhost avahi-daemon[9035]: Host name conflict, retrying with <linux-10>
May  2 10:48:02 localhost avahi-daemon[9035]: Registering new address record for 192.168.122.1 on virbr0.IPv4.
May  2 10:48:02 localhost avahi-daemon[9035]: Registering new address record for fe80::218:feff:fe7d:3438 on eth0.*.
May  2 10:48:02 localhost avahi-daemon[9035]: Registering new address record for 10.10.12.180 on eth0.IPv4.
May  2 10:48:02 localhost avahi-daemon[9035]: Registering HINFO record with values 'X86_64'/'LINUX'.
May  2 10:48:03 localhost avahi-daemon[9035]: Server startup complete. Host name is linux-10.local. Local service cookie is 1386635384.
May  2 10:48:04 localhost avahi-daemon[9035]: Service "linux-10" (/services/ssh.service) successfully established.

[root@localhost scameron]# echo 20 > /sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/act_busy
May  2 10:49:36 localhost kernel: hpsa 0000:0a:00.0: Will act busy for 20 seconds.
[root@localhost scameron]# echo 1 > /sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/rescan
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: RETRYING(1): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: RETRYING(2): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: RETRYING(3): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: RETRYING(4): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: RETRYING(5): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:39 localhost kernel: hpsa 0000:0a:00.0: RETRYING(6): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:40 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:40 localhost kernel: hpsa 0000:0a:00.0: RETRYING(7): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:40 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:40 localhost kernel: hpsa 0000:0a:00.0: RETRYING(8): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:40 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:40 localhost kernel: hpsa 0000:0a:00.0: RETRYING(9): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:41 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:41 localhost kernel: hpsa 0000:0a:00.0: RETRYING(10): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:42 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:42 localhost kernel: hpsa 0000:0a:00.0: RETRYING(11): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:43 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:43 localhost kernel: hpsa 0000:0a:00.0: RETRYING(12): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:45 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:45 localhost kernel: hpsa 0000:0a:00.0: RETRYING(13): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:46 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:46 localhost kernel: hpsa 0000:0a:00.0: RETRYING(14): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:47 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:47 localhost kernel: hpsa 0000:0a:00.0: RETRYING(15): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:48 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:48 localhost kernel: hpsa 0000:0a:00.0: RETRYING(16): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:50 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:50 localhost kernel: hpsa 0000:0a:00.0: RETRYING(17): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:51 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:51 localhost kernel: hpsa 0000:0a:00.0: RETRYING(18): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:52 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:52 localhost kernel: hpsa 0000:0a:00.0: RETRYING(19): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:54 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:54 localhost kernel: hpsa 0000:0a:00.0: RETRYING(20): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:55 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:55 localhost kernel: hpsa 0000:0a:00.0: RETRYING(21): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:56 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:56 localhost kernel: hpsa 0000:0a:00.0: RETRYING(22): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 10:49:57 localhost kernel: hpsa 0000:0a:00.0: hpsa device busy
May  2 10:49:57 localhost kernel: hpsa 0000:0a:00.0: RETRYING(23): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
[root@localhost scameron]# echo 1 > /sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/rescan
[root@localhost scameron]#

It eventually works.

Now, here is a patch which leaves the debug in, but goes back to the old behavior of just
retrying 3 times immediately then giving up:

commit 571c024f893831f0a23c5f3a49bdcffa9af1a38b
Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Date:   Wed May 2 10:51:28 2012 -0500

    go back to old behavior (immediately give up after 3 quick retries)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c2a4128..e31c14d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1426,6 +1426,7 @@ static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
 		}
 		retry_count++;
 		if (retry_count > 3) {
+			goto give_up;
 			msleep(backoff_time);
 			if (backoff_time < 1000)
 				backoff_time *= 2;
@@ -1433,6 +1434,7 @@ static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
 	} while ((check_for_unit_attention(h, c) ||
 			check_for_busy(h, c)) &&
 			retry_count <= MAX_DRIVER_CMD_RETRIES);
+give_up:
 	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
 }


Now, the behavior we get is this: 

[root@localhost ~]# find /sys -name 'rescan' | grep host0 | grep scsi_host
/sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/rescan
[root@localhost ~]# find /sys -name 'act_busy'
/sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/act_busy
/sys/devices/pci0000:00/0000:00:06.0/0000:05:00.0/host1/scsi_host/host1/act_busy
[root@localhost ~]# echo 1 > /sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/rescan
[root@localhost ~]# echo 20 > /sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/act_busy
[root@localhost ~]# May  2 11:19:36 localhost kernel: hpsa 0000:0a:00.0: Will act busy for 20 seconds.
[root@localhost ~]# echo 1 > /sys/devices/pci0000:00/0000:00:01.0/0000:0a:00.0/host0/scsi_host/host0/rescan
[root@localhost ~]# May  2 11:19:54 localhost kernel: hpsa 0000:0a:00.0: hpsadevice busy
May  2 11:19:54 localhost kernel: hpsa 0000:0a:00.0: RETRYING(1): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 11:19:54 localhost kernel: hpsa 0000:0a:00.0: hpsadevice busy
May  2 11:19:54 localhost kernel: hpsa 0000:0a:00.0: RETRYING(2): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 11:19:54 localhost kernel: hpsa 0000:0a:00.0: hpsadevice busy
May  2 11:19:54 localhost kernel: hpsa 0000:0a:00.0: RETRYING(3): c3 00 00 00 00 00 00 00 40 08 00 00 00 00 00 00
May  2 11:19:54 localhost kernel: hpsa 0000:0a:00.0: cmd ffff88003766a000 has completed with errors
May  2 11:19:54 localhost kernel: hpsa 0000:0a:00.0: cmd ffff88003766a000 has SCSI Status = 8
May  2 11:19:54 localhost kernel: hpsa 0000:0a:00.0: report physical LUNs failed.

The rescan just doesn't work in the face of even a 1 second BUSY condition with
the old behavior.

Yeah, in the working case, the driver thread is sleeping for a bit.  Note
that this is not in the main i/o path (the scsi mid layer will have to deal with
SAM_STAT_BUSY however it normally does) this retrying is only in paths involving driver
initiated commands, in this case, rescanning for new/changed/removed logical drives.

So yeah, the "echo 1 > /sys/blah/blah/rescan" process will sleep for up to ~20 seconds
in the event of some (presumably very rare) 20 second BUSY condition, but it will work in
cases the old code will not, and so it sleeps 20 secs, I don't think that's really a 
problem, esp. compared to the alternative of just failing.

-- steve

