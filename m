From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] 2.5.53 SCSI_IOCTL_GET_IDLUN+GET_BUS_NUMBER revisited
Date: Sat, 28 Dec 2002 11:24:29 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E0CEF3D.5070404@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040805080106000900060704"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@suse.de

This is a multi-part message in MIME format.
--------------040805080106000900060704
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Currently for block devices both the SCSI_IOCTL_GET_IDLUN and 
SCSI_IOCTL_GET_BUS_NUMBER ioctls yield the value 0 (type: int).

Various applications that utilize the sg driver use these ioctls
to work out the relationship between sg devices and their higher
level counterparts in the sd, sr, st and osst drivers. Examples
that spring to mind are cdrecord, cdparanoia, SANE and sg_utils.

This has been discussed in an earlier threaded started by me:
http://marc.theaimsgroup.com/?l=linux-scsi&m=103967899608891&w=2
in which my patch removed the ioctls in question from the block
level. This broke non-scsi block devices that used applications
that thought they were talking to an sg device **.

The attachment fine tunes the original patch: for scsi block
devices (i.e. owned by the sd or sr drivers) these 2 ioctls
are redirected to the scsi mid level; for non-scsi block
devices they will yield the value as 0 as they do now in
lk 2.5.53 .


** This "yield 0" strategy will come unstuck when 2 or more
cd writers (for example) are connected to the same box.
Hence to be well formed, these ioctls (together) should
produce unique tuples for each device (be they ATA(PI) or
SCSI).

Doug Gilbert

--------------040805080106000900060704
Content-Type: text/plain;
 name="sd_sr_2553_ioctl.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd_sr_2553_ioctl.diff"

--- linux/drivers/scsi/sd.c	2002-12-24 18:12:54.000000000 +1100
+++ linux/drivers/scsi/sd.c2553ioctl	2002-12-28 09:25:13.000000000 +1100
@@ -537,9 +537,20 @@
 		return sd_hdio_getgeo(bdev, (struct hd_geometry *)arg);
 	}
 
-	error = scsi_cmd_ioctl(bdev, cmd, arg);
-	if (error != -ENOTTY)
-		return error;
+	/*
+	 * Send SCSI addressing ioctls directly to mid level, send other
+	 * ioctls to block level and then onto mid level if they can't be
+	 * resolved.
+	 */
+	switch (cmd) {
+		case SCSI_IOCTL_GET_IDLUN:
+		case SCSI_IOCTL_GET_BUS_NUMBER:
+			return scsi_ioctl(sdp, cmd, (void *)arg);
+		default:
+			error = scsi_cmd_ioctl(bdev, cmd, arg);
+			if (error != -ENOTTY)
+				return error;
+	}
 	return scsi_ioctl(sdp, cmd, (void *)arg);
 }
 
--- linux/drivers/scsi/sr.c	2002-12-24 18:12:54.000000000 +1100
+++ linux/drivers/scsi/sr.c2553ioctl	2002-12-28 09:36:19.000000000 +1100
@@ -434,6 +434,17 @@
 			  unsigned long arg)
 {
 	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
+	struct scsi_device *sdev = cd->device;
+
+        /*
+         * Send SCSI addressing ioctls directly to mid level, send other
+         * ioctls to cdrom/block level.
+         */
+        switch (cmd) {
+                case SCSI_IOCTL_GET_IDLUN:
+                case SCSI_IOCTL_GET_BUS_NUMBER:
+                        return scsi_ioctl(sdev, cmd, (void *)arg);
+	}
 	return cdrom_ioctl(&cd->cdi, inode, cmd, arg);
 }
 

--------------040805080106000900060704--

