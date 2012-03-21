From: michaelc@cs.wisc.edu
Subject: [PATCH 08/17] be2iscsi:Code cleanup, removing the goto statement
Date: Tue, 20 Mar 2012 20:47:59 -0500
Message-ID: <1332294488-13684-9-git-send-email-michaelc@cs.wisc.edu>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030428Ab2CUBse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 21:48:34 -0400
In-Reply-To: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3a0fc74..2e08496 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -147,15 +147,15 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	struct invalidate_command_table *inv_tbl;
 	struct be_dma_mem nonemb_cmd;
 	unsigned int cid, tag, i, num_invalidate;
-	int rc = FAILED;
 
 	/* invalidate iocbs */
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 	spin_lock_bh(&session->lock);
-	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN)
-		goto unlock;
-
+	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN) {
+		spin_unlock_bh(&session->lock);
+		return FAILED;
+	}
 	conn = session->leadconn;
 	beiscsi_conn = conn->dd_data;
 	phba = beiscsi_conn->phba;
@@ -208,9 +208,6 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 			    nonemb_cmd.va, nonemb_cmd.dma);
 	return iscsi_eh_device_reset(sc);
-unlock:
-	spin_unlock_bh(&session->lock);
-	return rc;
 }
 
 static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
-- 
1.7.7.6

