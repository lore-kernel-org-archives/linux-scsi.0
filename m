From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: [Patch] sg: fix device number in blktrace data
Date: Fri, 30 Jan 2009 15:46:23 +0100
Message-ID: <1233326783.929.6.camel@kitka.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:61897 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZA3Oq0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jan 2009 09:46:26 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.8/8.13.8) with ESMTP id n0UEkPGQ195996
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2009 14:46:25 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0UEkODt2916476
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2009 15:46:24 +0100
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0UEkOrc031938
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2009 15:46:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

Hi,

we have run into an issue with blktrace being started for sg devices.
Please apply.

Thanks,
Martin



From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

The device number denoting a generic SCSI devices (sg) in a blktrace
trace is broken; major and minor are always 0. It looks like
sdp->device->sdev_gendev.devt is not initialized properly.
The fix below uses other data to make up a valid device number,
similar to the way an sg device number is generated for sysfs output.

Reported-by: Stefan Raspl <raspl@linux.vnet.ibm.com>
Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>

---
 drivers/scsi/sg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1078,7 +1078,7 @@ sg_ioctl(struct inode *inode, struct fil
 	case BLKTRACESETUP:
 		return blk_trace_setup(sdp->device->request_queue,
 				       sdp->disk->disk_name,
-				       sdp->device->sdev_gendev.devt,
+				       MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
 				       (char *)arg);
 	case BLKTRACESTART:
 		return blk_trace_startstop(sdp->device->request_queue, 1);


