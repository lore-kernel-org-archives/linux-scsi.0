From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH RESEND] dpt_i2o: fix build warning
Date: Thu, 18 Feb 2016 13:59:13 +0530
Message-ID: <1455784153-9615-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

We were getting build warning about:
drivers/scsi/dpt_i2o.c:183:29: warning: 'dptids' defined but not used

dptids[] is only used in the MODULE_DEVICE_TABLE so when MODULE is not
defined then dptids[] becomes unused.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

Resending v1 as v2 had a NACK from Alan about the spec not maintained
while converting to pci driver.

 drivers/scsi/dpt_i2o.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index d4cda5e..21c8d21 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -180,11 +180,14 @@ static u8 adpt_read_blink_led(adpt_hba* host)
  *============================================================================
  */
 
+#ifdef MODULE
 static struct pci_device_id dptids[] = {
 	{ PCI_DPT_VENDOR_ID, PCI_DPT_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, }
 };
+#endif
+
 MODULE_DEVICE_TABLE(pci,dptids);
 
 static int adpt_detect(struct scsi_host_template* sht)
-- 
1.9.1
