From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 3/4 v2] BNX2I: Changed the nopout_wqe->lun memcpy to use
 sizeof instead
Date: Thu, 23 Jun 2011 15:51:36 -0700
Message-ID: <1308869497-2709-4-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3919 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760118Ab1FWWvu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2011 18:51:50 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Modified the memcpy of nopout_wqe->lun to use sizeof(struct scsi_lun)
instead of the hardcoded value 8 as noted by review comments.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 2a1bb9f..ba2f96e 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -551,7 +551,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 
 	nopout_wqe->op_code = nopout_hdr->opcode;
 	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
-	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
+	memcpy(nopout_wqe->lun, nopout_hdr->lun, sizeof(struct scsi_lun));
 
 	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type)) {
 		u32 tmp = nopout_wqe->lun[0];
-- 
1.7.0.5


