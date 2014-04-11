From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 33/42] qla2xxx: Delay driver unload if there is any pending activity going on.
Date: Fri, 11 Apr 2014 16:54:38 -0400
Message-ID: <1397249687-32666-34-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:12447 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbaDKVcD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:03 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d1a76a6..575404f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -844,6 +844,28 @@ qla2x00_wait_for_hba_online(scsi_qla_host_t *vha)
 }
 
 /*
+ * qla2x00_wait_for_hba_ready
+ * Wait till the HBA is ready before doing driver unload
+ *
+ * Input:
+ *     ha - pointer to host adapter structure
+ *
+ * Note:
+ *    Does context switching-Release SPIN_LOCK
+ *    (if any) before calling this routine.
+ *
+ */
+static void
+qla2x00_wait_for_hba_ready(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	while ((!(vha->flags.online) || ha->dpc_active ||
+	    ha->flags.mbox_busy))
+		msleep(1000);
+}
+
+/*
  * qla2x00_wait_for_reset_ready
  *    Wait till the HBA is online after going through
  *    <= MAX_RETRIES_OF_ISP_ABORT  or
@@ -3161,6 +3183,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	base_vha = pci_get_drvdata(pdev);
 	ha = base_vha->hw;
 
+	qla2x00_wait_for_hba_ready(base_vha);
+
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 
 	if (IS_QLAFX00(ha))
-- 
1.7.7

