From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 13/21] lpfc: Fix oops if nvmet_fc_register_targetport fails
Date: Fri, 29 Sep 2017 17:34:39 -0700
Message-ID: <20170930003447.10747-14-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:38533 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752630AbdI3AfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:35:08 -0400
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, stable@vger.kernel.org, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

if nvmet targetport registration fails, the driver encounters a
NULL pointer oops in lpfc_hb_timeout_handler.

To fix: if registration fails, ensure nvmet_support is cleared
on the port structure.

Also enhanced the log message on failure.

Cc: <stable@vger.kernel.org> # 4.12+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index e410a6f1e2c2..1746c888beac 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1153,9 +1153,14 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
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
 
@@ -1167,9 +1172,11 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
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
