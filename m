From: Olaf Kirch <okir@lst.de>
Subject: [PATCH] Make SG_SET_FORCE_LOW_DMA behave as advertised
Date: Mon, 12 Mar 2007 14:18:30 +0100
Message-ID: <200703121418.31088.okir@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:44549 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965330AbXCLNSg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Mar 2007 09:18:36 -0400
Received: from [192.168.5.32] (p54A7EC5C.dip.t-dialin.net [84.167.236.92])
	(authenticated bits=0)
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l2CDIZb2020459
	(version=TLSv1/SSLv3 cipher=EXP1024-RC4-SHA bits=56 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Mar 2007 14:18:36 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Make SG_SET_FORCE_LOW_DMA behave as advertised

I came across this by accident. I have serious doubts whether ISA DMA
is really relevant these days :-) but what the heck. Feel free to disregard
if this code is headed for the recycler anyway.

The SCSI-HOWTO says this about SG_SET_FORCE_LOW_DMA:

	If the "reserved" buffer allocated on open() is not in use then
	it will be de-allocated and re-allocated under the 16MB level
	(and the latter operation could fail yielding ENOMEM).

I came across this by accident - the current code will never reallocate
the buffer during the ioctl, because it first sets sfp->low_dma to 1,
and then checks the very same variable for equality with 0.

The patch below changes the order of commands, and also moves
the buffer reallocation around so that it also happens when
the device has unchecked_isa_dma set.

Signed-off-by: olaf.kirch@oracle.com

---
 drivers/scsi/sg.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6.20/drivers/scsi/sg.c
===================================================================
--- linux-2.6.20.orig/drivers/scsi/sg.c
+++ linux-2.6.20/drivers/scsi/sg.c
@@ -842,17 +842,22 @@ sg_ioctl(struct inode *inode, struct fil
 		result = get_user(val, ip);
 		if (result)
 			return result;
+		if (val == 0) {
+			if (sdp->detached)
+				return -ENODEV;
+			val = sdp->device->host->unchecked_isa_dma;
+		}
 		if (val) {
+			int was_low_dma = sfp->low_dma;
+
 			sfp->low_dma = 1;
-			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
+			if ((0 == was_low_dma) && (0 == sg_res_in_use(sfp))) {
 				val = (int) sfp->reserve.bufflen;
 				sg_remove_scat(&sfp->reserve);
 				sg_build_reserve(sfp, val);
 			}
 		} else {
-			if (sdp->detached)
-				return -ENODEV;
-			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
+			sfp->low_dma = 0;
 		}
 		return 0;
 	case SG_GET_LOW_DMA:

-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
