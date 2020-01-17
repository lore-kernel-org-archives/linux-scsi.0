Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3382DC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06C202073A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgAQHKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:10:32 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:10557 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgAQHKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 02:10:32 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: 3YrFCAvrp0WR2FfDbgdjZU5LYPsOhA1q4nSXTUf0QGpwDY0tXKspNBV1v1k802NPNAtZpftrNy
 Ik11yg3zuthrMkS89pGLU4gbqWLJ+/Y3Hz5q9f3tGhsG+VjTVzjXFDJN+jOeX7b7TRtsRdOFXy
 P5h0wuQ6Y6xrklZi74duJLx+MoJ5zs42deCYLQs6d7rhT8HXleKZ27w6npSi+uSwYJ0oTcyRta
 K4tMOvsTz9oiGbWU+kxteAJijaJ4kGGIB/qXOxZlhFOcs/rmHy+lxIoMH2Ol4oQPErgoBB5r5O
 ePw=
X-IronPort-AV: E=Sophos;i="5.70,329,1574146800"; 
   d="scan'208";a="61358143"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2020 00:10:31 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 16 Jan
 2020 23:10:30 -0800
Received: from localhost (10.41.130.51) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 16 Jan
 2020 23:10:30 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V2 02/13] pm80xx : Deal with kexec reboots.
Date:   Fri, 17 Jan 2020 12:49:12 +0530
Message-ID: <20200117071923.7445-3-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200117071923.7445-1-deepak.ukey@microchip.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vikram Auradkar <auradkar@google.com>

A kexec reboot causes the controller fw to assert. This assertion
shows up in two ways, the controller doesn't show up as ready and
an interrupt is waiting as soon as the handler is registered. To
resolve this added below fix:
-split the interrupt handling setup into two parts, setup and
 request.
-If the controller ready register indicates not-ready, but that the
 not readiness is only on the IOC units we can still try a reset to
 bring the system back to the pre-reboot state.

Signed-off-by: Vikram Auradkar <auradkar@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 48 +++++++++++++++++++++++++++++++++++----
 drivers/scsi/pm8001/pm80xx_hwi.c  | 15 ++++++++----
 2 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3f1e755c52c6..a002eb5a3fe4 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -248,6 +248,9 @@ static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 	return ret;
 }
 
+static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha);
+static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha);
+
 /**
  * pm8001_alloc - initiate our hba structure and 6 DMAs area.
  * @pm8001_ha:our hba structure.
@@ -890,9 +893,7 @@ static int pm8001_configure_phy_settings(struct pm8001_hba_info *pm8001_ha)
  */
 static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 {
-	u32 i = 0, j = 0;
 	u32 number_of_intr;
-	int flag = 0;
 	int rc;
 
 	/* SPCv controllers supports 64 msi-x */
@@ -900,11 +901,11 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 		number_of_intr = 1;
 	} else {
 		number_of_intr = PM8001_MAX_MSIX_VEC;
-		flag &= ~IRQF_SHARED;
 	}
 
 	rc = pci_alloc_irq_vectors(pm8001_ha->pdev, number_of_intr,
 			number_of_intr, PCI_IRQ_MSIX);
+	number_of_intr = rc;
 	if (rc < 0)
 		return rc;
 	pm8001_ha->number_of_intr = number_of_intr;
@@ -912,8 +913,22 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 	PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
 		"pci_alloc_irq_vectors request ret:%d no of intr %d\n",
 				rc, pm8001_ha->number_of_intr));
+	return 0;
+}
+
+static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
+{
+	u32 i = 0, j = 0;
+	int flag = 0, rc = 0;
 
-	for (i = 0; i < number_of_intr; i++) {
+	if (pm8001_ha->chip_id != chip_8001)
+		flag &= ~IRQF_SHARED;
+
+	PM8001_INIT_DBG(pm8001_ha,
+		pm8001_printk("pci_enable_msix request number of intr %d\n",
+		pm8001_ha->number_of_intr));
+
+	for (i = 0; i < pm8001_ha->number_of_intr; i++) {
 		snprintf(pm8001_ha->intr_drvname[i],
 			sizeof(pm8001_ha->intr_drvname[0]),
 			"%s-%d", pm8001_ha->name, i);
@@ -938,6 +953,21 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 }
 #endif
 
+static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha)
+{
+	struct pci_dev *pdev;
+
+	pdev = pm8001_ha->pdev;
+
+#ifdef PM8001_USE_MSIX
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
+		return pm8001_setup_msix(pm8001_ha);
+	PM8001_INIT_DBG(pm8001_ha,
+		pm8001_printk("MSIX not supported!!!\n"));
+#endif
+	return 0;
+}
+
 /**
  * pm8001_request_irq - register interrupt
  * @chip_info: our ha struct.
@@ -951,7 +981,7 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 
 #ifdef PM8001_USE_MSIX
 	if (pdev->msix_cap && pci_msi_enabled())
-		return pm8001_setup_msix(pm8001_ha);
+		return pm8001_request_msix(pm8001_ha);
 	else {
 		PM8001_INIT_DBG(pm8001_ha,
 			pm8001_printk("MSIX not supported!!!\n"));
@@ -1033,6 +1063,13 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		rc = -ENOMEM;
 		goto err_out_free;
 	}
+	/* Setup Interrupt */
+	rc = pm8001_setup_irq(pm8001_ha);
+	if (rc)	{
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+			"pm8001_setup_irq failed [ret: %d]\n", rc));
+		goto err_out_shost;
+	}
 	list_add_tail(&pm8001_ha->list, &hba_list);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
@@ -1045,6 +1082,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha_free;
+	/* Request Interrupt */
 	rc = pm8001_request_irq(pm8001_ha);
 	if (rc)	{
 		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 98dcdbd146d5..d805fd036ddf 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1438,11 +1438,18 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	if (!pm8001_ha->controller_fatal_error) {
 		/* Check if MPI is in ready state to reset */
 		if (mpi_uninit_check(pm8001_ha) != 0) {
-			regval = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
+			u32 r0 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0);
+			u32 r1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
+			u32 r2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
+			u32 r3 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);
 			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-				"MPI state is not ready scratch1 :0x%x\n",
-				regval));
-			return -1;
+				"MPI state is not ready scratch: %x:%x:%x:%x\n",
+				r0, r1, r2, r3));
+			/* if things aren't ready but the bootloader is ok then
+			 * try the reset anyway.
+			 */
+			if (r1 & SCRATCH_PAD1_BOOTSTATE_MASK)
+				return -1;
 		}
 	}
 	/* checked for reset register normal state; 0x0 */
-- 
2.16.3

