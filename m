From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 2/8] BNX2I: Fixed the 32-bit swapping of the LUN field
 for nopouts for 5771X
Date: Wed, 5 Jan 2011 12:44:21 -0800
Message-ID: <1294260267-17413-3-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1844 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab1AEUl6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 15:41:58 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Fixed a bug where the 64-bit LUN field for nopouts were 32-bit swapped.
This only pertains to 5771X devices.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 5442f1a..f2200f5 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -498,10 +498,10 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
 
 	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type)) {
-		u32 tmp = nopout_hdr->lun[0];
+		u32 tmp = nopout_wqe->lun[0];
 		/* 57710 requires LUN field to be swapped */
-		nopout_hdr->lun[0] = nopout_hdr->lun[1];
-		nopout_hdr->lun[1] = tmp;
+		nopout_wqe->lun[0] = nopout_wqe->lun[1];
+		nopout_wqe->lun[1] = tmp;
 	}
 
 	nopout_wqe->itt = ((u16)task->itt |
-- 
1.7.0.5


