From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V1 1/3] pm80xx: Fix for direct attached device.
Date: Mon, 11 Nov 2013 08:20:06 -0800
Message-ID: <528103B6.10900@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:59413 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421Ab3KKQQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Nov 2013 11:16:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Sangeetha.Gnanasekaran@pmcs.com, Viswas.G@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

>From cf6a06ddf571464571f826109bb1e5a0667c7751 Mon Sep 17 00:00:00 2001
From: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Date: Wed, 30 Oct 2013 16:13:22 +0530
Subject: [PATCH V1 1/3] pm80xx: Fix for direct attached device.

In case of direct attached SATA device delay is not enough.
It will give crash for set device state command response and
wait_for_completion is the best solution for this.

Updation of module author.

Signed-off-by: Anandkumar.Santhanam@pmcs.com
Signed-off-by: Nikith.Ganigarakoppal@pmcs.com
---
 drivers/scsi/pm8001/pm8001_init.c |    1 +
 drivers/scsi/pm8001/pm8001_sas.c  |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 7b57fcd..17daaa4 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1170,6 +1170,7 @@ module_exit(pm8001_exit);
 MODULE_AUTHOR("Jack Wang <jack_wang@usish.com>");
 MODULE_AUTHOR("Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>");
 MODULE_AUTHOR("Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>");
+MODULE_AUTHOR("Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>");
 MODULE_DESCRIPTION(
 		"PMC-Sierra PM8001/8081/8088/8089/8074/8076/8077 "
 		"SAS/SATA controller driver");
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f4eb18e..f50ac44 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1098,15 +1098,17 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 	struct pm8001_tmf_task tmf_task;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 	struct pm8001_hba_info *pm8001_ha = pm8001_find_ha_by_dev(dev);
+	DECLARE_COMPLETION_ONSTACK(completion_setstate);
 	if (dev_is_sata(dev)) {
 		struct sas_phy *phy = sas_get_local_phy(dev);
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
 			dev, 1, 0);
 		rc = sas_phy_reset(phy, 1);
 		sas_put_local_phy(phy);
+		pm8001_dev->setds_completion = &completion_setstate;
 		rc = PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
 			pm8001_dev, 0x01);
-		msleep(2000);
+		wait_for_completion(&completion_setstate);
 	} else {
 		tmf_task.tmf = TMF_LU_RESET;
 		rc = pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
-- 
1.7.1

