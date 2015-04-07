From: James Smart <james.smart@emulex.com>
Subject: [PATCH v3 17/20] lpfc: Fix crash in device reset handler.
Date: Tue, 7 Apr 2015 15:07:26 -0400
Message-ID: <55242aee.1zJdV+9p14TYHFyp%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:33630 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbbDGTIY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:08:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix crash in device reset handler.

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 5612ba6..ea818f0 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5118,9 +5118,10 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	int status;
 
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
-	if (!rdata) {
+	if (!rdata || !rdata->pnode) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			"0798 Device Reset rport failure: rdata x%p\n", rdata);
+				 "0798 Device Reset rport failure: rdata x%p\n",
+				 rdata);
 		return FAILED;
 	}
 	pnode = rdata->pnode;
-- 
1.7.11.7

