From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 02/21] advansys: Remove array of scsi targets
Date: Tue,  2 Oct 2007 21:55:23 -0400
Message-ID: <11913765422432-git-send-email-matthew@wil.cx>
References: <11913765421743-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:57651 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbXJCBzo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 21:55:44 -0400
In-Reply-To: <11913765421743-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

The driver was saving a scsi_device for each target, but wasn't doing
anything useful with them.  Just delete the array.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/advansys.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 4f047cc..737c0e4 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2514,7 +2514,6 @@ typedef struct asc_board {
 	} dvc_cfg;
 	ushort asc_n_io_port;	/* Number I/O ports. */
 	ADV_SCSI_BIT_ID_TYPE init_tidmask;	/* Target init./valid mask */
-	struct scsi_device *device[ADV_MAX_TID + 1];	/* Mid-Level Scsi Device */
 	ushort reqcnt[ADV_MAX_TID + 1];	/* Starvation request count */
 	ADV_SCSI_BIT_ID_TYPE queue_full;	/* Queue full mask */
 	ushort queue_full_cnt[ADV_MAX_TID + 1];	/* Queue full count */
@@ -10183,13 +10182,6 @@ static int advansys_slave_configure(struct scsi_device *sdev)
 	asc_board_t *boardp = ASC_BOARDP(sdev->host);
 	boardp->flags |= ASC_SELECT_QUEUE_DEPTHS;
 
-	/*
-	 * Save a pointer to the sdev and set its initial/maximum
-	 * queue depth.  Only save the pointer for a lun0 dev though.
-	 */
-	if (sdev->lun == 0)
-		boardp->device[sdev->id] = sdev;
-
 	if (ASC_NARROW_BOARD(boardp))
 		advansys_narrow_slave_configure(sdev,
 						&boardp->dvc_var.asc_dvc_var);
@@ -11343,14 +11335,12 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 	ASC_DVC_VAR *asc_dvc_varp;
 	ADV_DVC_VAR *adv_dvc_varp;
 	ADV_SCSI_REQ_Q *adv_scsiqp;
-	struct scsi_device *device;
 	int ret;
 
 	ASC_DBG2(1, "asc_execute_scsi_cmnd: scp 0x%lx, done 0x%lx\n",
 		 (ulong)scp, (ulong)scp->scsi_done);
 
 	boardp = ASC_BOARDP(scp->device->host);
-	device = boardp->device[scp->device->id];
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		/*
-- 
1.5.3.1

