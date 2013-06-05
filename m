From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 04/10] qla2xxx: Remove two superfluous tests
Date: Wed, 05 Jun 2013 15:05:23 +0200
Message-ID: <51AF3793.4040309@acm.org>
References: <51AF36BF.3030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:34589 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab3FENFZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 09:05:25 -0400
In-Reply-To: <51AF36BF.3030602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

Since ha->model_desc is an array comparing it against NULL is
superfluous. Hence remove these tests.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    3 +--
 drivers/scsi/qla2xxx/qla_os.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index d0ea8b9..f26442a 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1370,8 +1370,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	/* Model description. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MODEL_DESCRIPTION);
-	if (ha->model_desc)
-		strncpy(eiter->a.model_desc, ha->model_desc, 80);
+	strncpy(eiter->a.model_desc, ha->model_desc, 80);
 	alen = strlen(eiter->a.model_desc);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ad72c1d..1d97626 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2840,8 +2840,7 @@ skip_dpc:
 	qla2x00_dfs_setup(base_vha);
 
 	ql_log(ql_log_info, base_vha, 0x00fb,
-	    "QLogic %s - %s.\n",
-	    ha->model_number, ha->model_desc ? ha->model_desc : "");
+	    "QLogic %s - %s.\n", ha->model_number, ha->model_desc);
 	ql_log(ql_log_info, base_vha, 0x00fc,
 	    "ISP%04X: %s @ %s hdma%c host#=%ld fw=%s.\n",
 	    pdev->device, ha->isp_ops->pci_info_str(base_vha, pci_info),
-- 
1.7.10.4

