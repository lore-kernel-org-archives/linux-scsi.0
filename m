From: James.Smart@Emulex.Com
Subject: [Patch] Another Suspend I/O block/unblock fix
Date: Mon, 18 Oct 2004 16:25:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F21D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38074 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267497AbUJRUZQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 16:25:16 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i9IKPFgI007883
	for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2004 13:25:15 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Further testing is showing that we are having some i/o threads prematurely die with the following message: "rejecting I/O to device being removed"

The patch below addresses this issue

Note: James, I haven't had any feedback on your workqueue patch yet.

-- James S

--- scsi_lib.c.original	2004-10-18 16:14:20.887007936 -0400
+++ scsi_lib.c.patched	2004-10-18 16:16:45.142077832 -0400
@@ -1030,7 +1030,8 @@
 	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
 
 		if(unlikely(specials_only)) {
-			if(specials_only == SDEV_QUIESCE)
+			if(specials_only == SDEV_QUIESCE ||
+					specials_only == SDEV_BLOCK)
 				return BLKPREP_DEFER;
 			
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to device being removed\n",
