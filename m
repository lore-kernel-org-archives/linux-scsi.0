From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] 3w-xxxx: remove unnecessary local_irq_save/restore for
 scsi sg copy API
Date: Thu, 9 Oct 2008 11:25:42 +0900
Message-ID: <20081009112510D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34479 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbYJIC0F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Oct 2008 22:26:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Adam Radford <linuxraid@amcc.com>

Since the commit 50bed2e2862a8f3a4f7d683d0d27292e71ef18b9 (sg: disable
interrupts inside sg_copy_buffer), no need to disable interrupts
before calling scsi_sg_copy_from_buffer. So we can simplify
tw_transfer_internal, which disables interrupts just for
scsi_sg_copy_from_buffer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/3w-xxxx.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index a0537f0..c03f1d2 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1466,12 +1466,7 @@ static int tw_scsiop_inquiry(TW_Device_Extension *tw_dev, int request_id)
 static void tw_transfer_internal(TW_Device_Extension *tw_dev, int request_id,
 				 void *data, unsigned int len)
 {
-	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
-	unsigned long flags;
-
-	local_irq_save(flags);
-	scsi_sg_copy_from_buffer(cmd, data, len);
-	local_irq_restore(flags);
+	scsi_sg_copy_from_buffer(tw_dev->srb[request_id], data, len);
 }
 
 /* This function is called by the isr to complete an inquiry command */
-- 
1.5.5.GIT

