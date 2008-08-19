From: michaelc@cs.wisc.edu
Subject: [PATCH 6/9] lpfc: start to use new trasnport errors.
Date: Tue, 19 Aug 2008 18:45:28 -0500
Message-ID: <1219189531-5243-7-git-send-email-michaelc@cs.wisc.edu>
References: <1219189531-5243-1-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-2-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-3-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-4-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-5-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-6-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYHSXpw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 19:45:52 -0400
In-Reply-To: <1219189531-5243-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts lpfc to use DID_TRANSPORT_DISRUPTED. I did not
do the queuecommand conversion of DID_BUS_BUSY because the
SCSI_MLQUEUE_TARGET_BUSY patches convert that.

Patch was tested with a direct connection by unplugging cables.
I did not hit the port of fabric busy paths, but saw that a distro
lpfc driver converted that bus busy to DID_TRANSPORT_DISRUPTED.
Also it looks like qla2xxx blocks the rport for that case.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/lpfc/lpfc_scsi.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 1bcebbd..3678adf 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -570,7 +570,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			break;
 		case IOSTAT_NPORT_BSY:
 		case IOSTAT_FABRIC_BSY:
-			cmd->result = ScsiResult(DID_BUS_BUSY, 0);
+			cmd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
 			break;
 		case IOSTAT_LOCAL_REJECT:
 			if (lpfc_cmd->result == RJT_UNAVAIL_PERM ||
@@ -586,7 +586,14 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 		if (!pnode || !NLP_CHK_NODE_ACT(pnode)
 		    || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
-			cmd->result = ScsiResult(DID_BUS_BUSY, SAM_STAT_BUSY);
+			/*
+			 * Port is not setup so fail IO with
+			 * DID_TRANSPORT_DISRUPTED, and allow the fc
+			 * class to determine what to do with it when
+			 * its timers fire.
+			 */
+			cmd->result = ScsiResult(DID_TRANSPORT_DISRUPTED,
+						 SAM_STAT_BUSY);
 	} else {
 		cmd->result = ScsiResult(DID_OK, 0);
 	}
-- 
1.5.4.1

