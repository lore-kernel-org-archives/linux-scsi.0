From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V3 08/10] pm80xx: IButton feature support for motherboard
 controllers.
Date: Mon, 30 Sep 2013 23:42:10 -0700
Message-ID: <524A6EC2.9020108@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:52682 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab3JAGji (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2013 02:39:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sangeetha.Gnanasekaran@pmcs.com, xjtuwjp@gmail.com, Nikith.Ganigarakoppal@pmcs.com, Viswas.G@pmcs.com

>From c7a47a0376361a82ff1c67b3af6c23c9191266d6 Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Tue, 17 Sep 2013 14:32:20 +0530
Subject: [PATCH V3 08/10] pm80xx: IButton feature support for motherboard controllers.

IButton security feature support for motherboard controllers.

Signed-off-by: Anandkumar.Santhanam@pmcs.com
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 5a357d1..4e1284e 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -967,6 +967,7 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 regval;
 	u32 bootloader_state;
+	u32 ibutton0, ibutton1;
 
 	/* Check if MPI is in ready state to reset */
 	if (mpi_uninit_check(pm8001_ha) != 0) {
@@ -1025,7 +1026,27 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	if (-1 == check_fw_ready(pm8001_ha)) {
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("Firmware is not ready!\n"));
-		return -EBUSY;
+		/* check iButton feature support for motherboard controller */
+		if (pm8001_ha->pdev->subsystem_vendor !=
+			PCI_VENDOR_ID_ADAPTEC2 &&
+			pm8001_ha->pdev->subsystem_vendor != 0) {
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

