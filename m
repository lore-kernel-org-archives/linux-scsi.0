From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 3/5] libata: use scsi_build_sense_buffer
Date: Tue, 25 Mar 2008 09:26:51 +0900
Message-ID: <1206404816-21710-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: 1206378609.3494.50.camel@localhost.localdomain
 <1206404816-21710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206404816-21710-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37484 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbYCYAtJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 20:49:09 -0400
In-Reply-To: <1206404816-21710-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-ide@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/ata/libata-scsi.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8f0e8f2..90a809a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2324,11 +2324,7 @@ void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 {
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
-	cmd->sense_buffer[0] = 0x70;	/* fixed format, current */
-	cmd->sense_buffer[2] = sk;
-	cmd->sense_buffer[7] = 18 - 8;	/* additional sense length */
-	cmd->sense_buffer[12] = asc;
-	cmd->sense_buffer[13] = ascq;
+	scsi_build_sense_buffer(0, cmd->sense_buffer, sk, asc, ascq);
 }
 
 /**
-- 
1.5.3.7

