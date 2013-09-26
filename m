From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V2 02/10] pm80xx: IButton feature support for motherboard
 controllers.
Date: Wed, 25 Sep 2013 22:28:52 -0700
Message-ID: <5243C614.4080207@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:56769 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab3IZF0V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 01:26:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com, Viswas.G@pmcs.com, xjtuwjp@gmail.com

>From d6b5e5d88f424b334c9b9c241f988b9eec1a70c7 Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Tue, 17 Sep 2013 14:32:20 +0530
Subject: [PATCH V2 02/10] pm80xx: IButton feature support for motherboard controllers.

IButton security feature support for motherboard controllers.

Signed-off-by: Anandkumar.Santhanam@pmcs.com

---
 drivers/scsi/pm8001/pm80xx_hwi.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8efac42..912dfec 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -967,6 +967,7 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 regval;
 	u32 bootloader_state;
+	u32 ibutton0, ibutton1;
 
 	/* Check if MPI is in ready state to reset */
 	if (mpi_uninit_check(pm8001_ha) != 0) {
@@ -1025,7 +1026,26 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	if (-1 == check_fw_ready(pm8001_ha)) {
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("Firmware is not ready!\n"));
-		return -EBUSY;
+		/* check iButton feature support for motherboard controller */
+		if (pm8001_ha->pdev->subsystem_vendor !=
+			PCI_VENDOR_ID_ADAPTEC2) {
+			ibutton0 = pm8001_cr32(pm8001_ha, 0,
+					MSGU_HOST_SCRATCH_PAD_6);
+			ibutton1 = pm8001_cr32(pm8001_ha, 0,
+					MSGU_HOST_SCRATCH_PAD_7);
+			if (!ibutton0 && !ibutton1) {
+				PM8001_FAIL_DBG(pm8001_ha,
+					pm8001_printk("iButton Feature is"
+					" not Available!!!\n"));
+				return -EBUSY;
+			}
+			if (ibutton0 == 0xdeadbeef && ibutton1 == 0xdeadbeef) {
+				PM8001_FAIL_DBG(pm8001_ha,
+					pm8001_printk("CRC Check for iButton"
+					" Feature Failed!!!\n"));
+				return -EBUSY;
+			}
+		}
 	}
 	PM8001_INIT_DBG(pm8001_ha,
 		pm8001_printk("SPCv soft reset Complete\n"));
-- 
1.7.1

