From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH] BNX2I: Fixed the endian on TTT for NOP out transmission
Date: Fri, 26 Aug 2011 11:16:47 -0700
Message-ID: <1314382607-20841-1-git-send-email-eddie.wai@broadcom.com>
References: <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3409 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab1HZSRJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2011 14:17:09 -0400
In-Reply-To: <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The iscsi_nopout task's TTT is defined as __be32 while the DMA
memory to the chip is CPU specific.  This creates a problem for
unsolicited NOP-In responses where the TTT is not the RESERVED
tag of 0xFFs.  This patch adds a call to be32_to_cpu for the TTT
specified.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 9ae80cd..dba72a4 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -563,7 +563,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 	nopout_wqe->itt = ((u16)task->itt |
 			   (ISCSI_TASK_TYPE_MPATH <<
 			    ISCSI_TMF_REQUEST_TYPE_SHIFT));
-	nopout_wqe->ttt = nopout_hdr->ttt;
+	nopout_wqe->ttt = be32_to_cpu(nopout_hdr->ttt);
 	nopout_wqe->flags = 0;
 	if (!unsol)
 		nopout_wqe->flags = ISCSI_NOP_OUT_REQUEST_LOCAL_COMPLETION;
-- 
1.7.0.5


