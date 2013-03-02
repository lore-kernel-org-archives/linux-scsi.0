From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [RESEND] [PATCH 07/13] pm80xx: SPCv/ve specific changes in common
 files
Date: Sat, 02 Mar 2013 08:49:45 -0800
Message-ID: <51322DA9.7080602@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060508010902060101000604"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:59006 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962Ab3CBQtC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Mar 2013 11:49:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com, jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com

This is a multi-part message in MIME format.
--------------060508010902060101000604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 9ff177e662a98b89d92aaab688d2523f02835f3d Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Tue, 5 Feb 2013 11:00:39 +0530
Subject: [PATCH 07/13] pm80xx: SPCv/ve specific changes in common files

Changing common functionalities for SPCv/ve operations. Conditional
checks for SPC specific operations.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c  |    4 ++--
 drivers/scsi/pm8001/pm8001_hwi.h  |    2 +-
 drivers/scsi/pm8001/pm8001_init.c |   13 +++++++++----
 drivers/scsi/pm8001/pm8001_sas.c  |   17 +++++++++++------
 drivers/scsi/pm8001/pm8001_sas.h  |    4 ++--
 5 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 26f5197..c335ae8 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -785,14 +785,14 @@ static u32 soft_reset_ready_check(struct pm8001_hba_info *pm8001_ha)
  * pm8001_chip_soft_rst - soft reset the PM8001 chip, so that the clear all
  * the FW register status to the originated status.
  * @pm8001_ha: our hba card information
- * @signature: signature in host scratch pad0 register.
  */
 static int
-pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha, u32 signature)
+pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 {
 	u32	regVal, toggleVal;
 	u32	max_wait_count;
 	u32	regVal1, regVal2, regVal3;
+	u32	signature = 0x252acbcd; /* for host scratch pad0 */
 	unsigned long flags;
 
 	/* step1: Check FW is ready for soft reset */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index d437309..2399aab 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -298,7 +298,7 @@ struct local_phy_ctl_resp {
 
 
 #define OP_BITS 0x0000FF00
-#define ID_BITS 0x0000000F
+#define ID_BITS 0x000000FF
 
 /*
  * brief the data structure of PORT Control Command
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f0c5075..9dcd72c 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1741,7 +1741,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		goto err_out_free;
 	}
 	list_add_tail(&pm8001_ha->list, &hba_list);
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc)
 		goto err_out_ha_free;
@@ -1795,7 +1795,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	list_del(&pm8001_ha->list);
 	scsi_remove_host(pm8001_ha->shost);
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
@@ -1843,7 +1843,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		return -ENODEV;
 	}
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
@@ -1904,7 +1904,12 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	if (rc)
 		goto err_out_disable;
 
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	/* chip soft rst only for spc */
+	if (pm8001_ha->chip_id == chip_8001) {
+		PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("chip soft reset successful\n"));
+	}
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc)
 		goto err_out_disable;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b961112..6bba59c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1,5 +1,5 @@
 /*
- * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver
+ * PMC-Sierra PM8001/8081/8088/8089 SAS/SATA based host adapters driver
  *
  * Copyright (c) 2008-2009 USI Co., Ltd.
  * All rights reserved.
@@ -212,10 +212,12 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_GET_EVENTS:
 		spin_lock_irqsave(&pm8001_ha->lock, flags);
-		if (-1 == pm8001_bar4_shift(pm8001_ha,
+		if (pm8001_ha->chip_id == chip_8001) {
+			if (-1 == pm8001_bar4_shift(pm8001_ha,
 					(phy_id < 4) ? 0x30000 : 0x40000)) {
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-			return -EINVAL;
+				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+				return -EINVAL;
+			}
 		}
 		{
 			struct sas_phy *phy = sas_phy->phy;
@@ -228,7 +230,8 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			phy->loss_of_dword_sync_count = qp[3];
 			phy->phy_reset_problem_count = qp[4];
 		}
-		pm8001_bar4_shift(pm8001_ha, 0);
+		if (pm8001_ha->chip_id == chip_8001)
+			pm8001_bar4_shift(pm8001_ha, 0);
 		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 		return 0;
 	default:
@@ -249,7 +252,9 @@ void pm8001_scan_start(struct Scsi_Host *shost)
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	pm8001_ha = sha->lldd_ha;
-	PM8001_CHIP_DISP->sas_re_init_req(pm8001_ha);
+	/* SAS_RE_INITIALIZATION not available in SPCv/ve */
+	if (pm8001_ha->chip_id == chip_8001)
+		PM8001_CHIP_DISP->sas_re_init_req(pm8001_ha);
 	for (i = 0; i < pm8001_ha->chip->n_phy; ++i)
 		PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
 }
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index b567be0..466934d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -1,5 +1,5 @@
 /*
- * PMC-Sierra 8001/8081/8088/8089 SAS/SATA based host adapters driver
+ * PMC-Sierra PM8001/8081/8088/8089 SAS/SATA based host adapters driver
  *
  * Copyright (c) 2008-2009 USI Co., Ltd.
  * All rights reserved.
@@ -132,7 +132,7 @@ struct pm8001_ioctl_payload {
 struct pm8001_dispatch {
 	char *name;
 	int (*chip_init)(struct pm8001_hba_info *pm8001_ha);
-	int (*chip_soft_rst)(struct pm8001_hba_info *pm8001_ha, u32 signature);
+	int (*chip_soft_rst)(struct pm8001_hba_info *pm8001_ha);
 	void (*chip_rst)(struct pm8001_hba_info *pm8001_ha);
 	int (*chip_ioremap)(struct pm8001_hba_info *pm8001_ha);
 	void (*chip_iounmap)(struct pm8001_hba_info *pm8001_ha);
-- 
1.7.1


--------------060508010902060101000604
Content-Type: text/plain; charset=windows-1252;
 name="0007-pm80xx-SPCv-ve-specific-changes-in-common-files.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0007-pm80xx-SPCv-ve-specific-changes-in-common-files.patch"

>From 9ff177e662a98b89d92aaab688d2523f02835f3d Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Tue, 5 Feb 2013 11:00:39 +0530
Subject: [PATCH 07/13] pm80xx: SPCv/ve specific changes in common files

Changing common functionalities for SPCv/ve operations. Conditional
checks for SPC specific operations.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c  |    4 ++--
 drivers/scsi/pm8001/pm8001_hwi.h  |    2 +-
 drivers/scsi/pm8001/pm8001_init.c |   13 +++++++++----
 drivers/scsi/pm8001/pm8001_sas.c  |   17 +++++++++++------
 drivers/scsi/pm8001/pm8001_sas.h  |    4 ++--
 5 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 26f5197..c335ae8 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -785,14 +785,14 @@ static u32 soft_reset_ready_check(struct pm8001_hba_info *pm8001_ha)
  * pm8001_chip_soft_rst - soft reset the PM8001 chip, so that the clear all
  * the FW register status to the originated status.
  * @pm8001_ha: our hba card information
- * @signature: signature in host scratch pad0 register.
  */
 static int
-pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha, u32 signature)
+pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 {
 	u32	regVal, toggleVal;
 	u32	max_wait_count;
 	u32	regVal1, regVal2, regVal3;
+	u32	signature = 0x252acbcd; /* for host scratch pad0 */
 	unsigned long flags;
 
 	/* step1: Check FW is ready for soft reset */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index d437309..2399aab 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -298,7 +298,7 @@ struct local_phy_ctl_resp {
 
 
 #define OP_BITS 0x0000FF00
-#define ID_BITS 0x0000000F
+#define ID_BITS 0x000000FF
 
 /*
  * brief the data structure of PORT Control Command
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f0c5075..9dcd72c 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1741,7 +1741,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		goto err_out_free;
 	}
 	list_add_tail(&pm8001_ha->list, &hba_list);
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc)
 		goto err_out_ha_free;
@@ -1795,7 +1795,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	list_del(&pm8001_ha->list);
 	scsi_remove_host(pm8001_ha->shost);
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
@@ -1843,7 +1843,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		return -ENODEV;
 	}
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
@@ -1904,7 +1904,12 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	if (rc)
 		goto err_out_disable;
 
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	/* chip soft rst only for spc */
+	if (pm8001_ha->chip_id == chip_8001) {
+		PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("chip soft reset successful\n"));
+	}
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc)
 		goto err_out_disable;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b961112..6bba59c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1,5 +1,5 @@
 /*
- * PMC-Sierra SPC 8001 SAS/SATA based host adapters driver
+ * PMC-Sierra PM8001/8081/8088/8089 SAS/SATA based host adapters driver
  *
  * Copyright (c) 2008-2009 USI Co., Ltd.
  * All rights reserved.
@@ -212,10 +212,12 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_GET_EVENTS:
 		spin_lock_irqsave(&pm8001_ha->lock, flags);
-		if (-1 == pm8001_bar4_shift(pm8001_ha,
+		if (pm8001_ha->chip_id == chip_8001) {
+			if (-1 == pm8001_bar4_shift(pm8001_ha,
 					(phy_id < 4) ? 0x30000 : 0x40000)) {
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-			return -EINVAL;
+				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+				return -EINVAL;
+			}
 		}
 		{
 			struct sas_phy *phy = sas_phy->phy;
@@ -228,7 +230,8 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			phy->loss_of_dword_sync_count = qp[3];
 			phy->phy_reset_problem_count = qp[4];
 		}
-		pm8001_bar4_shift(pm8001_ha, 0);
+		if (pm8001_ha->chip_id == chip_8001)
+			pm8001_bar4_shift(pm8001_ha, 0);
 		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 		return 0;
 	default:
@@ -249,7 +252,9 @@ void pm8001_scan_start(struct Scsi_Host *shost)
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	pm8001_ha = sha->lldd_ha;
-	PM8001_CHIP_DISP->sas_re_init_req(pm8001_ha);
+	/* SAS_RE_INITIALIZATION not available in SPCv/ve */
+	if (pm8001_ha->chip_id == chip_8001)
+		PM8001_CHIP_DISP->sas_re_init_req(pm8001_ha);
 	for (i = 0; i < pm8001_ha->chip->n_phy; ++i)
 		PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
 }
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index b567be0..466934d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -1,5 +1,5 @@
 /*
- * PMC-Sierra 8001/8081/8088/8089 SAS/SATA based host adapters driver
+ * PMC-Sierra PM8001/8081/8088/8089 SAS/SATA based host adapters driver
  *
  * Copyright (c) 2008-2009 USI Co., Ltd.
  * All rights reserved.
@@ -132,7 +132,7 @@ struct pm8001_ioctl_payload {
 struct pm8001_dispatch {
 	char *name;
 	int (*chip_init)(struct pm8001_hba_info *pm8001_ha);
-	int (*chip_soft_rst)(struct pm8001_hba_info *pm8001_ha, u32 signature);
+	int (*chip_soft_rst)(struct pm8001_hba_info *pm8001_ha);
 	void (*chip_rst)(struct pm8001_hba_info *pm8001_ha);
 	int (*chip_ioremap)(struct pm8001_hba_info *pm8001_ha);
 	void (*chip_iounmap)(struct pm8001_hba_info *pm8001_ha);
-- 
1.7.1


--------------060508010902060101000604--
