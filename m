From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch 0/4] Updated AN patches, now without gendisk
Date: Tue, 14 Aug 2007 14:10:39 +0200
Message-ID: <1187093439.4312.13.camel@lov.localdomain>
References: <20070808120739.c3097d19.kristen.c.accardi@intel.com>
	 <3ae72650708110700x7ddf3d57ue9a8875761425f52@mail.gmail.com>
	 <20070813092643.6f15aa8a.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:52217 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbXHNMHm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 08:07:42 -0400
In-Reply-To: <20070813092643.6f15aa8a.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, David Zeuthen <david@fubar.dk>

On Mon, 2007-08-13 at 09:26 -0700, Kristen Carlson Accardi wrote:
> On Sat, 11 Aug 2007 16:00:53 +0200
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> 
> > On 8/8/07, Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> > > Here is an updated set of patches that implement Asynchronous Notification
> > > support for ATAPI devices.  In this version I no longer export the AN
> > > capability through genhd, and the uevent is sent by the scsi_device
> > > instead of gendisk.  I added a generic SCSI device event mechanism so
> > > that it can be expanded in the future with other types of events.  Please
> > > let me know what you think.
> > 
> > Does that mean:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8ce7ad7b2d11fae2c3d285a6a0caea9322c0b8fc
> > 
> > will go away?
> 
> Yes - this method was rejected by James, so I had to change away from
> using the genhd to transmit events.

Ok. :)
 
> > Then we will need to come up with an idea to propagate that to the
> > blockdev, it gets a bit nasty for userspace to find out which
> > blockdevice it should update. It's certainly possible, but just not as
> > easy as it is now, because userspace just doesn't really care in most
> > cases what kind of bus device a block device is coming from.
> 
> Is it possible to use the linkage that is in the scsi_device directory
> of the disk that is sending the event to find the relevant block devices?
> For example, /sys/class/scsi_device/0:0:0:0/device/block:sda
> on my system tells me which block devices belong to this device.

Yeah, we will find a way to do that.

We want to unify the event handling, if we add AN support proper. That
means that polled device should send similar events as AN capable, and
userspace runs the same code in both cases. The polling for non-AN
devices would be just a periodic open() and the result would not be used
for anything. We would rely on the events triggered by the polling.

Can you try the attached patch, what does it do in your setup, and how
it behaves with AN and without?

Btw, what is the behavior of the eject button on a locked drive with AN.
Today we poll for changes to get notification about the pressed button,
which otherwise would be ignored on a locked drive.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: scsi: send media state change modification events

This will send for a card reader slot (remove/add media):
  UEVENT[1187091572.155884] change   /devices/pci0000:00/0000:00:1d.7/usb5/5-2/5-2:1.0/host7/target7:0:0/7:0:0:0 (scsi)
  UEVENT[1187091572.162314] remove   /block/sdb/sdb1 (block)
  UEVENT[1187091572.172464] add      /block/sdb/sdb1 (block)
  UEVENT[1187091572.175408] change   /devices/pci0000:00/0000:00:1d.7/usb5/5-2/5-2:1.0/host7/target7:0:0/7:0:0:0 (scsi)

and for a DVD drive (add/eject media):
  UEVENT[1187091590.189159] change   /devices/pci0000:00/0000:00:1f.1/host4/target4:0:0/4:0:0:0 (scsi)
  UEVENT[1187091590.957124] add      /module/isofs (module)
  UEVENT[1187091604.468207] change   /devices/pci0000:00/0000:00:1f.1/host4/target4:0:0/4:0:0:0 (scsi)

Userspace gets events, even for unpartitioned media. This unifies
the event handling for asynchronoous events (AN) and events caused by
perodical polling the device from userspace.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/scsi/sd.c |   24 +++++++++++++++---------
 drivers/scsi/sr.c |   13 ++++++++++---
 drivers/scsi/sr.h |    1 +
 include/scsi/sd.h |    1 +
 4 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c6116f..5271bfa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -722,8 +722,11 @@ static int sd_media_changed(struct gendisk *disk)
 	 * can deal with it then.  It is only because of unrecoverable errors
 	 * that we would ever take a device offline in the first place.
 	 */
-	if (!scsi_device_online(sdp))
-		goto not_present;
+	if (!scsi_device_online(sdp)) {
+		set_media_not_present(sdkp);
+		retval = 1;
+		goto out;
+	}
 
 	/*
 	 * Using TEST_UNIT_READY enables differentiation between drive with
@@ -735,6 +738,7 @@ static int sd_media_changed(struct gendisk *disk)
 	 * sd_revalidate() is called.
 	 */
 	retval = -ENODEV;
+
 	if (scsi_block_when_processing_errors(sdp))
 		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES);
 
@@ -744,8 +748,11 @@ static int sd_media_changed(struct gendisk *disk)
 	 * and we will figure it out later once the drive is
 	 * available again.
 	 */
-	if (retval)
-		 goto not_present;
+	if (retval) {
+		set_media_not_present(sdkp);
+		retval = 1;
+		goto out;
+	}
 
 	/*
 	 * For removable scsi disk we have to recognise the presence
@@ -756,12 +763,11 @@ static int sd_media_changed(struct gendisk *disk)
 
 	retval = sdp->changed;
 	sdp->changed = 0;
-
+out:
+	if (retval != sdkp->previous_state)
+		scsi_device_event_notify(sdp, SDEV_MEDIA_CHANGE);
+	sdkp->previous_state = retval;
 	return retval;
-
-not_present:
-	set_media_not_present(sdkp);
-	return 1;
 }
 
 static int sd_sync_cache(struct scsi_disk *sdkp)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 902eb11..918f2e4 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -192,8 +192,9 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 		 * and we will figure it out later once the drive is
 		 * available again.  */
 		cd->device->changed = 1;
-		return 1;	/* This will force a flush, if called from
-				 * check_disk_change */
+		/* This will force a flush, if called from check_disk_change */
+		retval = 1;
+		goto out;
 	};
 
 	retval = cd->device->changed;
@@ -203,9 +204,15 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 	if (retval) {
 		/* check multisession offset etc */
 		sr_cd_check(cdi);
-
 		get_sectorsize(cd);
 	}
+
+out:
+	/* Notify userspace, that media has changed. */
+	if (retval != cd->previous_state)
+		scsi_device_event_notify(cd->device, SDEV_MEDIA_CHANGE);
+	cd->previous_state = retval;
+
 	return retval;
 }
  
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index d65de96..0d04e28 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -37,6 +37,7 @@ typedef struct scsi_cd {
 	unsigned xa_flag:1;	/* CD has XA sectors ? */
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
+	unsigned previous_state:1;	/* media has changed */
 	struct cdrom_device_info cdi;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
diff --git a/include/scsi/sd.h b/include/scsi/sd.h
index ce02ad1..f01c3e7 100644
--- a/include/scsi/sd.h
+++ b/include/scsi/sd.h
@@ -41,6 +41,7 @@ struct scsi_disk {
 	u32		index;
 	u8		media_present;
 	u8		write_prot;
+	unsigned	previous_state : 1;
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */

