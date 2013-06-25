From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 10/16] qla2xxx: Remove two superfluous tests.
Date: Tue, 25 Jun 2013 11:27:25 -0400
Message-ID: <1372174051-4211-11-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19902 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132Ab3FYPxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:52 -0400
Received: from mail117-tx2 (localhost [127.0.0.1])	by
 mail117-tx2-R.bigfish.com (Postfix) with ESMTP id B2F153600C9	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:51 +0000 (UTC)
Received: from TX2EHSMHS009.bigfish.com (unknown [10.9.14.243])	by
 mail117-tx2.bigfish.com (Postfix) with ESMTP id 96911C0059	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:49 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Since ha->model_desc is an array comparing it against NULL is
superfluous. Hence remove these tests.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
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
index c2e2e20..6df5223 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2839,8 +2839,7 @@ skip_dpc:
 	qla2x00_dfs_setup(base_vha);
 
 	ql_log(ql_log_info, base_vha, 0x00fb,
-	    "QLogic %s - %s.\n",
-	    ha->model_number, ha->model_desc ? ha->model_desc : "");
+	    "QLogic %s - %s.\n", ha->model_number, ha->model_desc);
 	ql_log(ql_log_info, base_vha, 0x00fc,
 	    "ISP%04X: %s @ %s hdma%c host#=%ld fw=%s.\n",
 	    pdev->device, ha->isp_ops->pci_info_str(base_vha, pci_info),
-- 
1.7.7


