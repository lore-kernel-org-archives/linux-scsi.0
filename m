From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 03/13] qla4xxx: Do not retry ISP82XX initialization if H/W
 state is failed
Date: Sun, 13 Mar 2011 22:24:09 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B1509@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:18883
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192Ab1CNFYS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:24:18 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Prasanna Mumbai <prasanna.mumbai@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

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
+       uint32_t dev_state;

        if (pci_enable_device(pdev))
                return -1;
@@ -1713,6 +1714,18 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
        status = qla4xxx_initialize_adapter(ha, REBUILD_DDB_LIST);
        while ((!test_bit(AF_ONLINE, &ha->flags)) &&
            init_retry_count++ < MAX_INIT_RETRIES) {
+
+               if (is_qla8022(ha)) {
+                       qla4_8xxx_idc_lock(ha);
+                       dev_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+                       qla4_8xxx_idc_unlock(ha);
+                       if (dev_state == QLA82XX_DEV_FAILED) {
+                               ql4_printk(KERN_WARNING, ha, "%s: don't retry "
+                                   "initialize adapter. H/W is in failed state\n",
+                                   __func__);
+                               break;
+                       }
+               }
                DEBUG2(printk("scsi: %s: retrying adapter initialization "
                              "(%d)\n", __func__, init_retry_count));

--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

