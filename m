From: Bino.Sebastian@Emulex.Com
Subject: RE: [PATCH] Fix race condition between scsi scan and sdev block/unblock
Date: Wed, 3 Jan 2007 17:07:49 -0500
Message-ID: <332A49C36DB0F64198D1A011FB1AA79132A7B0@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60246 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbXACW26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2007 17:28:58 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l03M7oYc014395
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jan 2007 14:07:50 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com

NACK this patch.
Reason for NACK : Upstream code in the sdev state change
routine validates the state change and returns success
when old state and new state are same and this result in 
unblocking the request queue correctly in 
scsi_internal_device_unblock function, which is not what is 
described here. This bug was found in an existing distro.

-bino

-----Original Message-----
From: Sebastian, Bino 
Sent: Tuesday, November 28, 2006 4:20 PM
To: 'linux-scsi@vger.kernel.org'
Subject: [PATCH] Fix race condition between scsi scan and sdev
block/unblock


James,

Our testing has encountered an error between sdev initialization/
scanning and the sdev block/unblock behavior. What we have seen is that 
new target detection will kick off a scan, and that an sdev will be in 
the creation process with the state SDEV_CREATED. At this point a link 
event occurs, which blocks the sdev, changes its state to SDEV_BLOCK, 
and stops its request queue.  However, the creation thread is still 
executing, and decides to transition the sdev state to SDEV_RUNNING. 
Note that the request queue is still blocked. The sdev then gets unblocked, 
attempting to change the state to SDEV_RUNNING, which fails as it is already 
SDEV_RUNNING, which causes the unblock routine to bypass the call to 
blk_start_queue().

This patch modifies the creation path so that it only changes to SDEV_RUNNING
if the state is SDEV_CREATED. This allows the block/unblock to work 
appropriately. It does have a side effect that unblock could early-transition 
the sdev to SDEV_RUNNING.

-- bino 

Signed-off-by: Bino Sebastian <bino.sebastian@emulex.com>

diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2006-11-20 16:40:21.977901000 -0500
+++ b/drivers/scsi/scsi_scan.c	2006-11-21 09:08:41.232680000 -0500
@@ -762,7 +762,8 @@ static int scsi_add_lun(struct scsi_devi
 
 	/* set the device running here so that slave configure
 	 * may do I/O */
-	scsi_device_set_state(sdev, SDEV_RUNNING);
+	if (sdev->sdev_state == SDEV_CREATED)
+		scsi_device_set_state(sdev, SDEV_RUNNING);
 
 	if (*bflags & BLIST_MS_192_BYTES_FOR_3F)
 		sdev->use_192_bytes_for_3f = 1;
diff -upNr a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	2006-11-20 16:40:21.988903000 -0500
+++ b/drivers/scsi/scsi_sysfs.c	2006-11-21 09:08:41.245680000 -0500
@@ -676,7 +676,8 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 {
 	int error, i;
 
-	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
+	if ((sdev->sdev_state == SDEV_CREATED) &&
+		((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0))
 		return error;
 
 	error = device_add(&sdev->sdev_gendev);



