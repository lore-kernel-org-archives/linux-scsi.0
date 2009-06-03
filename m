From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 14/20] qla2xxx: Avoid redundant RISC reset during (re)-initialization.
Date: Wed,  3 Jun 2009 09:55:25 -0700
Message-ID: <1244048131-56590-15-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbZFCQzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:41 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

ISP24xx and above ISPs perform a RISC reset in
qla24xx_reset_chip(), which is called prior to
qla24xx_chip_diag().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4649b2a..46bd085 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -730,9 +730,6 @@ qla24xx_chip_diag(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
 
-	/* Perform RISC reset. */
-	qla24xx_reset_risc(vha);
-
 	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * req->length;
 
 	rval = qla2x00_mbx_reg_test(vha);
-- 
1.6.3.1.244.gf9275

