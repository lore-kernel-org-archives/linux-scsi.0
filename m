From: peter grne <petergrne@gmail.com>
Subject: Variety of small usb disks reporting media absent
Date: Tue, 9 Jul 2013 09:30:33 +1000
Message-ID: <CAEDzpXCA7iJz36_W-NPZWHmLRrhbT=1ce=Fy7bOwxEQtcdNCig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f67.google.com ([209.85.212.67]:58559 "EHLO
	mail-vb0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3GHXae (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jul 2013 19:30:34 -0400
Received: by mail-vb0-f67.google.com with SMTP id f12so1025489vbg.6
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2013 16:30:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The linux OS is used in our product with a variety of small USB drives
for storing scratch information.

For a range of kernels, we have found that a number of drives from
various manufacturers have failed in our field product, though working
in our development environment, with identical equipment and kernel,
but different user space and kernel configuration.

Upon investigation, I found that although the device was present in
/sys/block/sdN/device, it was not present in /proc/partitions. No
error messages were found.

Using printk and comparing working and failing units, the problem
appears to be in sd_spinup_disk in drivers/scsi/sd.c
The failing scsi drives were initially reporting "media-not-present"
and the whole disk registration procedure was failing.

I fixed this by waiting up to 500 milliseconds before accepting a
"media-not-present".

I do not know if this is proper scsi behavior by the disks or what. As
I am not sure this is a bug, I have not reported it to bugzilla. I
would not advise commiting my code to the linux kernel, as a better
solution is probable. Nevertheless, I enclose the patch below in order
to demonstrate the modification made to address this issue.

This problem did not result from any difference in configuration, but
more probably different timing in the development environment as
compared to our field product. Whether the development environment is
quicker or slower, I do not know.

I have plenty of samples and could easily post one or more failing
units to any person.

--- ../linux-3.9.2.orig/drivers/scsi/sd.c	2013-05-12 00:19:28.000000000 +1000
+++ linux-3.9.2/drivers/scsi/sd.c	2013-07-05 15:21:17.000000000 +1000
@@ -1300,39 +1300,49 @@ static void set_media_not_present(struct
 {
 	if (sdkp->media_present)
 		sdkp->device->changed = 1;

 	if (sdkp->device->removable) {
 		sdkp->media_present = 0;
 		sdkp->capacity = 0;
 	}
 }

-static int media_not_present(struct scsi_disk *sdkp,
+static int check_media_not_present(struct scsi_disk *sdkp,
 			     struct scsi_sense_hdr *sshdr)
 {
 	if (!scsi_sense_valid(sshdr))
 		return 0;

 	/* not invoked for commands that could return deferred errors */
 	switch (sshdr->sense_key) {
 	case UNIT_ATTENTION:
 	case NOT_READY:
 		/* medium not present */
 		if (sshdr->asc == 0x3A) {
-			set_media_not_present(sdkp);
 			return 1;
 		}
 	}
 	return 0;
 }

+static int media_not_present(struct scsi_disk *sdkp,
+			     struct scsi_sense_hdr *sshdr)
+{
+	if(check_media_not_present(sdkp, sshdr))
+	{
+		set_media_not_present(sdkp);
+		return 1;
+	}
+	return 0;
+}
+
 /**
  *	sd_check_events - check media events
  *	@disk: kernel device descriptor
  *	@clearing: disk events currently being cleared
  *
  *	Returns mask of DISK_EVENT_*.
  *
  *	Note: this function is invoked from the block subsystem.
  **/
 static unsigned int sd_check_events(struct gendisk *disk, unsigned
int clearing)
@@ -1736,27 +1746,35 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	int sense_valid = 0;

 	spintime = 0;

 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
 		retries = 0;

 		do {
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
-
-			the_result = scsi_execute_req(sdkp->device, cmd,
-						      DMA_NONE, NULL, 0,
-						      &sshdr, SD_TIMEOUT,
-						      SD_MAX_RETRIES, NULL);
+			/* Try for at least 500 milliseconds before reporting no media present. */
+			/* Logically, the_result would be expected to be true for media absent,
+			 * but try to minimally change the original logic, for consistency sake.
+			 */
+			unsigned long jlimit = msecs_to_jiffies(jiffies_to_msecs(jiffies) + 500);
+			do {
+				cmd[0] = TEST_UNIT_READY;
+				memset((void *) &cmd[1], 0, 9);
+
+				the_result = scsi_execute_req(sdkp->device, cmd,
+							      DMA_NONE, NULL, 0,
+							      &sshdr, SD_TIMEOUT,
+							      SD_MAX_RETRIES, NULL);
+			}
+			while(check_media_not_present(sdkp, &sshdr) &&
time_is_after_jiffies(jlimit));

 			/*
 			 * If the drive has indicated to us that it
 			 * doesn't have any media in it, don't bother
 			 * with any more polling.
 			 */
 			if (media_not_present(sdkp, &sshdr))
 				return;

 			if (the_result)
