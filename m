From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH v2 03/14] BNX2I: Fixed the endian bug in the TMF LUN cmd
 send
Date: Thu, 18 Nov 2010 17:29:58 -0800
Message-ID: <1290130209-32133-4-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2853 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0KSB6Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 20:58:24 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Added a be32_to_cpu call for the TMF LUN wqe.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 32cf930..c9a3c0f 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -385,6 +385,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 	struct bnx2i_cmd *bnx2i_cmd;
 	struct bnx2i_tmf_request *tmfabort_wqe;
 	u32 dword;
+	u32 scsi_lun[2];
 
 	bnx2i_cmd = (struct bnx2i_cmd *)mtask->dd_data;
 	tmfabort_hdr = (struct iscsi_tm *)mtask->hdr;
@@ -426,7 +427,10 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 	default:
 		tmfabort_wqe->ref_itt = RESERVED_ITT;
 	}
-	memcpy(tmfabort_wqe->lun, tmfabort_hdr->lun, sizeof(struct scsi_lun));
+	memcpy(scsi_lun, tmfabort_hdr->lun, sizeof(struct scsi_lun));
+	tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
+	tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);
+
 	tmfabort_wqe->ref_cmd_sn = be32_to_cpu(tmfabort_hdr->refcmdsn);
 
 	tmfabort_wqe->bd_list_addr_lo = (u32) bnx2i_conn->hba->mp_bd_dma;
-- 
1.7.0.5


