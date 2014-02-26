From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 6/7] scsi_debug: protect device access with atomic_rw lock
Date: Wed, 26 Feb 2014 22:57:03 +0900
Message-ID: <1393423024-8063-7-git-send-email-akinobu.mita@gmail.com>
References: <1393423024-8063-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58554 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaBZN5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2014 08:57:33 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so1013905pbc.38
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2014 05:57:32 -0800 (PST)
In-Reply-To: <1393423024-8063-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

This change ensures that concurrent device access including ramdisk
storage, protection info, and provisioning map by read, write, and
unmap commands are protected with atomic_rw spinlock.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 004b985..0bb1d49c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1888,17 +1888,19 @@ static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
 		return check_condition_result;
 	}
 
+	read_lock_irqsave(&atomic_rw, iflags);
+
 	/* DIX + T10 DIF */
 	if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
 		int prot_ret = prot_verify_read(SCpnt, lba, num, ei_lba);
 
 		if (prot_ret) {
+			read_unlock_irqrestore(&atomic_rw, iflags);
 			mk_sense_buffer(devip, ABORTED_COMMAND, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
-	read_lock_irqsave(&atomic_rw, iflags);
 	ret = do_device_access(SCpnt, devip, lba, num, 0);
 	read_unlock_irqrestore(&atomic_rw, iflags);
 	if (ret == -1)
@@ -2098,17 +2100,19 @@ static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
 	if (ret)
 		return ret;
 
+	write_lock_irqsave(&atomic_rw, iflags);
+
 	/* DIX + T10 DIF */
 	if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
 		int prot_ret = prot_verify_write(SCpnt, lba, num, ei_lba);
 
 		if (prot_ret) {
+			write_unlock_irqrestore(&atomic_rw, iflags);
 			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
-	write_lock_irqsave(&atomic_rw, iflags);
 	ret = do_device_access(SCpnt, devip, lba, num, 1);
 	if (scsi_debug_lbp())
 		map_region(lba, num);
@@ -2187,6 +2191,7 @@ static int resp_unmap(struct scsi_cmnd * scmd, struct sdebug_dev_info * devip)
 	struct unmap_block_desc *desc;
 	unsigned int i, payload_len, descriptors;
 	int ret;
+	unsigned long iflags;
 
 	ret = check_readiness(scmd, 1, devip);
 	if (ret)
@@ -2208,6 +2213,8 @@ static int resp_unmap(struct scsi_cmnd * scmd, struct sdebug_dev_info * devip)
 
 	desc = (void *)&buf[8];
 
+	write_lock_irqsave(&atomic_rw, iflags);
+
 	for (i = 0 ; i < descriptors ; i++) {
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
 		unsigned int num = get_unaligned_be32(&desc[i].blocks);
@@ -2222,6 +2229,7 @@ static int resp_unmap(struct scsi_cmnd * scmd, struct sdebug_dev_info * devip)
 	ret = 0;
 
 out:
+	write_unlock_irqrestore(&atomic_rw, iflags);
 	kfree(buf);
 
 	return ret;
-- 
1.8.3.2

