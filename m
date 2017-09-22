From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 12/19] lpfc: Fix oops if nvmet_fc_register_targetport fails
Date: Thu, 21 Sep 2017 23:17:34 -0700
Message-ID: <20170922061741.12347-13-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34610 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbdIVGSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:08 -0400
Received: by mail-pg0-f67.google.com with SMTP id u18so126701pgo.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:07 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

if nvmet targetport registration fails, the driver encounters a
NULL pointer oops in lpfc_hb_timeout_handler.

To fix: if registration fails, ensure nvmet_support is cleared
on the port structure.

Also enhanced the log message on failure.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index ee88343f3e8c..55badeace591 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1172,9 +1172,14 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 #endif
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
-				"6025 Cannot register NVME targetport "
-				"x%x\n", error);
+				"6025 Cannot register NVME targetport x%x: "
+				"portnm %llx nodenm %llx segs %d qs %d\n",
+				error,
+				pinfo.port_name, pinfo.node_name,
+				lpfc_tgttemplate.max_sgl_segments,
+				lpfc_tgttemplate.max_hw_queues);
 		phba->targetport = NULL;
+		phba->nvmet_support = 0;
 
 		lpfc_nvmet_cleanup_io_context(phba);
 
@@ -1186,9 +1191,11 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
 				"6026 Registered NVME "
 				"targetport: %p, private %p "
-				"portnm %llx nodenm %llx\n",
+				"portnm %llx nodenm %llx segs %d qs %d\n",
 				phba->targetport, tgtp,
-				pinfo.port_name, pinfo.node_name);
+				pinfo.port_name, pinfo.node_name,
+				lpfc_tgttemplate.max_sgl_segments,
+				lpfc_tgttemplate.max_hw_queues);
 
 		atomic_set(&tgtp->rcv_ls_req_in, 0);
 		atomic_set(&tgtp->rcv_ls_req_out, 0);
-- 
2.13.1
