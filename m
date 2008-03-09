From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 09/10] 3w-xxxx: use sg buffer copy helper functions
Date: Sun,  9 Mar 2008 13:44:36 +0900
Message-ID: <1205037877-12843-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47278 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbYCIEqE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 23:46:04 -0500
In-Reply-To: <1205037877-12843-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Adam Radford <linuxraid@amcc.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

This rewrites tw_transfer_internal with scsi_sg_copy_from/to_buffer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Adam Radford <linuxraid@amcc.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/3w-xxxx.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index d095321..a2fc060 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1463,18 +1463,10 @@ static void tw_transfer_internal(TW_Device_Extension *tw_dev, int request_id,
 				 void *data, unsigned int len)
 {
 	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
-	void *buf;
-	unsigned int transfer_len;
-	unsigned long flags = 0;
-	struct scatterlist *sg = scsi_sglist(cmd);
+	unsigned long flags;
 
 	local_irq_save(flags);
-	buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
-	transfer_len = min(sg->length, len);
-
-	memcpy(buf, data, transfer_len);
-
-	kunmap_atomic(buf - sg->offset, KM_IRQ0);
+	scsi_sg_copy_from_buffer(cmd, data, len);
 	local_irq_restore(flags);
 }
 
-- 
1.5.3.7

