From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/23] advansys: Stop checking the scsi_cmnd belongs to our Scsi_Host
Date: Mon, 30 Jul 2007 10:56:49 -0600
Message-ID: <11858146283106-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:58778 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934884AbXG3Q5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:10 -0400
In-Reply-To: <11858146282602-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The interrupt routines used to walk the list of Scsi_Hosts belonging to
this driver to make sure that the scsi_cmnd belonged to one of them.
This is a waste of time and gets in the way of later cleanups, so
delete it.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   38 --------------------------------------
 1 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index a407ff3..7a964bb 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -5506,7 +5506,6 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	asc_board_t *boardp;
 	struct scsi_cmnd *scp;
 	struct Scsi_Host *shost;
-	int i;
 
 	ASC_DBG2(1, "asc_isr_callback: asc_dvc_varp 0x%lx, qdonep 0x%lx\n",
 		 (ulong)asc_dvc_varp, (ulong)qdonep);
@@ -5525,23 +5524,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	}
 	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
 
-	/*
-	 * If the request's host pointer is not valid, display a
-	 * message and return.
-	 */
 	shost = scp->device->host;
-	for (i = 0; i < asc_board_count; i++) {
-		if (asc_host[i] == shost) {
-			break;
-		}
-	}
-	if (i == asc_board_count) {
-		ASC_PRINT2
-		    ("asc_isr_callback: scp 0x%lx has bad host pointer, host 0x%lx\n",
-		     (ulong)scp, (ulong)shost);
-		return;
-	}
-
 	ASC_STATS(shost, callback);
 	ASC_DBG1(1, "asc_isr_callback: shost 0x%lx\n", (ulong)shost);
 
@@ -5680,7 +5663,6 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	adv_sgblk_t *sgblkp;
 	struct scsi_cmnd *scp;
 	struct Scsi_Host *shost;
-	int i;
 	ADV_DCNT resid_cnt;
 
 	ASC_DBG2(1, "adv_isr_callback: adv_dvc_varp 0x%lx, scsiqp 0x%lx\n",
@@ -5716,27 +5698,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	}
 	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
 
-	/*
-	 * If the request's host pointer is not valid, display a message
-	 * and return.
-	 */
 	shost = scp->device->host;
-	for (i = 0; i < asc_board_count; i++) {
-		if (asc_host[i] == shost) {
-			break;
-		}
-	}
-	/*
-	 * Note: If the host structure is not found, the adv_req_t request
-	 * structure and adv_sgblk_t structure, if any, is dropped.
-	 */
-	if (i == asc_board_count) {
-		ASC_PRINT2
-		    ("adv_isr_callback: scp 0x%lx has bad host pointer, host 0x%lx\n",
-		     (ulong)scp, (ulong)shost);
-		return;
-	}
-
 	ASC_STATS(shost, callback);
 	ASC_DBG1(1, "adv_isr_callback: shost 0x%lx\n", (ulong)shost);
 
-- 
1.4.4.4

