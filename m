From: vikas.chaudhary@qlogic.com
Subject: [PATCH 03/13] qla4xxx: Do not retry ISP82XX initialization if H/W state is failed
Date: Mon, 21 Mar 2011 03:34:26 -0700
Message-ID: <1300703676-27398-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46171 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753111Ab1CUKtP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 06:49:15 -0400
In-Reply-To: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com, Prasanna Mumbai <prasanna.mumbai@qlogic.com>

From: Prasanna Mumbai <prasanna.mumbai@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Prasanna Mumbai <prasanna.mumbai@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3fc1d25..d1501fb 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1630,6 +1630,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	uint8_t init_retry_count = 0;
 	char buf[34];
 	struct qla4_8xxx_legacy_intr_set *nx_legacy_intr;
+	uint32_t dev_state;
 
 	if (pci_enable_device(pdev))
 		return -1;
@@ -1713,6 +1714,18 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	status = qla4xxx_initialize_adapter(ha, REBUILD_DDB_LIST);
 	while ((!test_bit(AF_ONLINE, &ha->flags)) &&
 	    init_retry_count++ < MAX_INIT_RETRIES) {
+
+		if (is_qla8022(ha)) {
+			qla4_8xxx_idc_lock(ha);
+			dev_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+			qla4_8xxx_idc_unlock(ha);
+			if (dev_state == QLA82XX_DEV_FAILED) {
+				ql4_printk(KERN_WARNING, ha, "%s: don't retry "
+				    "initialize adapter. H/W is in failed state\n",
+				    __func__);
+				break;
+			}
+		}
 		DEBUG2(printk("scsi: %s: retrying adapter initialization "
 			      "(%d)\n", __func__, init_retry_count));
 
-- 
1.7.3.2

