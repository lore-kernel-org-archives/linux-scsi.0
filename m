From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 17/18] qla2xxx: Don't hardcode fw_transfer_size for ISP2[45]xx parts.
Date: Thu, 10 Jul 2008 16:56:02 -0700
Message-ID: <1215734163-40825-17-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635AbYGJX4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:16 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Use the full buffer size available, as there's no reason to limit
the firwmare-image load-segment size for these parts.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index fd3ff5e..44c0117 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -729,7 +729,7 @@ qla24xx_chip_diag(scsi_qla_host_t *ha)
 	/* Perform RISC reset. */
 	qla24xx_reset_risc(ha);
 
-	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * 1024;
+	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * ha->request_q_length;
 
 	rval = qla2x00_mbx_reg_test(ha);
 	if (rval) {
-- 
1.5.6.2.292.ga9a3

