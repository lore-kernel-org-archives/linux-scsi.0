From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 6/8] be2iscsi: Fix scsi_cmnd leakage in driver.
Date: Wed, 29 Jan 2014 02:16:44 -0500
Message-ID: <1390979807-16718-6-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61840 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaA2HRG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2014 02:17:06 -0500
Received: by mail-pd0-f174.google.com with SMTP id z10so1357680pdj.5
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2014 23:17:05 -0800 (PST)
In-Reply-To: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 scsi_cmnd n io_task was not NULL when
  - Link goes down while IO was happening and session is closed.
  - Task for which TMF was sent.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ee6094c..d9bd4b9 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1418,8 +1418,10 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 	resid = csol_cqe->res_cnt;
 
 	if (!task->sc) {
-		if (io_task->scsi_cmnd)
+		if (io_task->scsi_cmnd) {
 			scsi_dma_unmap(io_task->scsi_cmnd);
+			io_task->scsi_cmnd = NULL;
+		}
 
 		return;
 	}
@@ -1456,6 +1458,7 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 		conn->rxdata_octets += resid;
 unmap:
 	scsi_dma_unmap(io_task->scsi_cmnd);
+	io_task->scsi_cmnd = NULL;
 	iscsi_complete_scsi_task(task, exp_cmdsn, max_cmdsn);
 }
 
@@ -4705,6 +4708,11 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 			spin_unlock(&phba->io_sgl_lock);
 			io_task->psgl_handle = NULL;
 		}
+
+		if (io_task->scsi_cmnd) {
+			scsi_dma_unmap(io_task->scsi_cmnd);
+			io_task->scsi_cmnd = NULL;
+		}
 	} else {
 		if (!beiscsi_conn->login_in_progress)
 			beiscsi_free_mgmt_task_handles(beiscsi_conn, task);
-- 
1.8.5.3

