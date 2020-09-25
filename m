Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9829CC4363D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F6021775
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgIYGGZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 02:06:25 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:27012 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgIYGGY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2020 02:06:24 -0400
IronPort-SDR: oW3I+fHW4Drwzsc0LTqsz5UbiyKXE5MAHb6D1qBaO130w3ud/mVJRYRZ9uKbE0qyTsqAfqfhMj
 nauot+fB+CoPImTymSUZg+r7Bc1OjRGU5WuyElVGHfShn5alHqRoY3zUiU30993DutTAMq301O
 OJy51oatpmMyi86i/FE8ieRZDmQfBp+0KN2K2Uz2XLT6z+Avpoq46oOHTbN23G/wOXchVzrTog
 rgpShLjVOBroprG4nPJIF8Qn3YXgSnzPP9LnjbTyQiIQGa4V2qdJWTBqQnXsdgane5NzaRbpfs
 3fw=
X-IronPort-AV: E=Sophos;i="5.77,300,1596524400"; 
   d="scan'208";a="88117761"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Sep 2020 23:06:23 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 24 Sep
 2020 23:06:22 -0700
Received: from bby1unixsmtp01.microsemi.net (10.180.100.98) by
 avmbx1.microsemi.net (10.100.34.31) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Thu, 24 Sep 2020 23:06:22 -0700
Received: from localhost (bby1unixlb02.microsemi.net [10.180.100.121])
        by bby1unixsmtp01.microsemi.net (Postfix) with ESMTP id 228D6A09C6;
        Thu, 24 Sep 2020 23:06:22 -0700 (PDT)
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 3/4] pm80xx : Increase the number of outstanding IO supported
Date:   Fri, 25 Sep 2020 11:46:04 +0530
Message-ID: <20200925061605.31628-4-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20200925061605.31628-1-Viswas.G@microchip.com.com>
References: <20200925061605.31628-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Increasing the number of Outstanding IOs from 256 to 1024.
CCB and tag are allocated according to outstanding IOs.
Also updating the can_queue value (max_out_io - PM8001_RESERVE_SLOT)
to scsi midlayer.

Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
---
 drivers/scsi/pm8001/pm8001_defs.h |  4 +-
 drivers/scsi/pm8001/pm8001_hwi.c  |  6 +--
 drivers/scsi/pm8001/pm8001_init.c | 79 ++++++++++++++++++++++++++++-----------
 drivers/scsi/pm8001/pm8001_sas.h  |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 28 ++++----------
 5 files changed, 72 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 1bf1bcfaf010..501b574239e8 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -75,7 +75,7 @@ enum port_type {
 };
 
 /* driver compile-time configuration */
-#define	PM8001_MAX_CCB		 256	/* max ccbs supported */
+#define	PM8001_MAX_CCB		 1024	/* max ccbs supported */
 #define PM8001_MPI_QUEUE         1024   /* maximum mpi queue entries */
 #define	PM8001_MAX_INB_NUM	 64
 #define	PM8001_MAX_OUTB_NUM	 64
@@ -90,9 +90,11 @@ enum port_type {
 #define	PM8001_MAX_PORTS	 16	/* max. possible ports */
 #define	PM8001_MAX_DEVICES	 2048	/* max supported device */
 #define	PM8001_MAX_MSIX_VEC	 64	/* max msi-x int for spcv/ve */
+#define	PM8001_RESERVE_SLOT	 8
 
 #define	CONFIG_SCSI_PM8001_MAX_DMA_SG	528
 #define PM8001_MAX_DMA_SG	CONFIG_SCSI_PM8001_MAX_DMA_SG
+
 enum memory_region_num {
 	AAP1 = 0x0, /* application acceleration processor */
 	IOP,	    /* IO processor */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index e9106575a30f..2b7b2954ec31 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4375,8 +4375,7 @@ static int pm8001_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	/* fill in PRD (scatter/gather) table, if any */
 	if (task->num_scatter > 1) {
 		pm8001_chip_make_sg(task->scatter, ccb->n_elem, ccb->buf_prd);
-		phys_addr = ccb->ccb_dma_handle +
-				offsetof(struct pm8001_ccb_info, buf_prd[0]);
+		phys_addr = ccb->ccb_dma_handle;
 		ssp_cmd.addr_low = cpu_to_le32(lower_32_bits(phys_addr));
 		ssp_cmd.addr_high = cpu_to_le32(upper_32_bits(phys_addr));
 		ssp_cmd.esgl = cpu_to_le32(1<<31);
@@ -4449,8 +4448,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	/* fill in PRD (scatter/gather) table, if any */
 	if (task->num_scatter > 1) {
 		pm8001_chip_make_sg(task->scatter, ccb->n_elem, ccb->buf_prd);
-		phys_addr = ccb->ccb_dma_handle +
-				offsetof(struct pm8001_ccb_info, buf_prd[0]);
+		phys_addr = ccb->ccb_dma_handle;
 		sata_cmd.addr_low = lower_32_bits(phys_addr);
 		sata_cmd.addr_high = upper_32_bits(phys_addr);
 		sata_cmd.esgl = cpu_to_le32(1 << 31);
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index d6789a261c1c..d04d6ecd8c0f 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -56,6 +56,7 @@ MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
 		" 8: Link rate 12.0G\n");
 
 static struct scsi_transport_template *pm8001_stt;
+static int pm8001_init_ccb_tag(struct pm8001_hba_info *, struct Scsi_Host *, struct pci_dev *);
 
 /*
  * chip info structure to identify chip key functionality as
@@ -302,9 +303,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 		INIT_LIST_HEAD(&pm8001_ha->port[i].list);
 	}
 
-	pm8001_ha->tags = kzalloc(PM8001_MAX_CCB, GFP_KERNEL);
-	if (!pm8001_ha->tags)
-		goto err_out;
 	/* MPI Memory region 1 for AAP Event Log for fw */
 	pm8001_ha->memoryMap.region[AAP1].num_elements = 1;
 	pm8001_ha->memoryMap.region[AAP1].element_size = PM8001_EVENT_LOG_SIZE;
@@ -416,29 +414,11 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 		pm8001_ha->devices[i].device_id = PM8001_MAX_DEVICES;
 		pm8001_ha->devices[i].running_req = 0;
 	}
-	/* Memory region for ccb_info*/
-	pm8001_ha->ccb_info = kzalloc(PM8001_MAX_CCB
-				* sizeof(struct pm8001_ccb_info), GFP_KERNEL);
-	if (!pm8001_ha->ccb_info) {
-		rc = -ENOMEM;
-		goto err_out_noccb;
-	}
-	for (i = 0; i < PM8001_MAX_CCB; i++) {
-		pm8001_ha->ccb_info[i].ccb_dma_handle =
-			virt_to_phys(pm8001_ha->ccb_info) +
-			(i * sizeof(struct pm8001_ccb_info));
-		pm8001_ha->ccb_info[i].task = NULL;
-		pm8001_ha->ccb_info[i].ccb_tag = 0xffffffff;
-		pm8001_ha->ccb_info[i].device = NULL;
-		++pm8001_ha->tags_num;
-	}
 	pm8001_ha->flags = PM8001F_INIT_TIME;
 	/* Initialize tags */
 	pm8001_tag_init(pm8001_ha);
 	return 0;
 
-err_out_noccb:
-	kfree(pm8001_ha->devices);
 err_out_shost:
 	scsi_remove_host(pm8001_ha->shost);
 err_out_nodev:
@@ -1133,6 +1113,10 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		goto err_out_ha_free;
 	}
 
+	rc = pm8001_init_ccb_tag(pm8001_ha, shost, pdev);
+	if (rc)
+		goto err_out_enable;
+
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha_free;
@@ -1178,6 +1162,59 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	return rc;
 }
 
+/*
+ * pm8001_init_ccb_tag - allocate memory to CCB and tag.
+ * @pm8001_ha: our hba card information.
+ * @shost: scsi host which has been allocated outside.
+ */
+static int
+pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
+			struct pci_dev *pdev)
+{
+	int i, ret = 0;
+	u32 max_out_io, ccb_count;
+	u32 can_queue;
+
+	max_out_io = pm8001_ha->main_cfg_tbl.pm80xx_tbl.max_out_io;
+	ccb_count = min_t(int, PM8001_MAX_CCB, max_out_io);
+
+	/*Update to the scsi host*/
+	can_queue = ccb_count - PM8001_RESERVE_SLOT;
+	shost->can_queue = can_queue;
+
+	pm8001_ha->tags = kzalloc(ccb_count, GFP_KERNEL);
+	if (!pm8001_ha->tags)
+		goto err_out;
+
+	/* Memory region for ccb_info*/
+	pm8001_ha->ccb_info = (struct pm8001_ccb_info *)
+		kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
+	if (!pm8001_ha->ccb_info) {
+		ret = -ENOMEM;
+		goto err_out_noccb;
+	}
+	for (i = 0; i < ccb_count; i++) {
+		pm8001_ha->ccb_info[i].buf_prd = pci_alloc_consistent(pdev,
+				sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
+				&pm8001_ha->ccb_info[i].ccb_dma_handle);
+		if (!pm8001_ha->ccb_info[i].buf_prd) {
+			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
+					(KERN_ERR "pm80xx: ccb prd memory allocation error\n"));
+			goto err_out;
+		}
+		pm8001_ha->ccb_info[i].task = NULL;
+		pm8001_ha->ccb_info[i].ccb_tag = 0xffffffff;
+		pm8001_ha->ccb_info[i].device = NULL;
+		++pm8001_ha->tags_num;
+	}
+	return 0;
+
+err_out_noccb:
+	kfree(pm8001_ha->devices);
+err_out:
+	return -ENOMEM;
+}
+
 static void pm8001_pci_remove(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index bdfce3c3f619..9d7796a74ed4 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -315,7 +315,7 @@ struct pm8001_ccb_info {
 	u32			ccb_tag;
 	dma_addr_t		ccb_dma_handle;
 	struct pm8001_device	*device;
-	struct pm8001_prd	buf_prd[PM8001_MAX_DMA_SG];
+	struct pm8001_prd	*buf_prd;
 	struct fw_control_ex	*fw_control_context;
 	u8			open_retry;
 };
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 26e9e8877107..7593f248afb2 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4483,8 +4483,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 		if (task->num_scatter > 1) {
 			pm8001_chip_make_sg(task->scatter,
 						ccb->n_elem, ccb->buf_prd);
-			phys_addr = ccb->ccb_dma_handle +
-				offsetof(struct pm8001_ccb_info, buf_prd[0]);
+			phys_addr = ccb->ccb_dma_handle;
 			ssp_cmd.enc_addr_low =
 				cpu_to_le32(lower_32_bits(phys_addr));
 			ssp_cmd.enc_addr_high =
@@ -4513,9 +4512,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 						end_addr_high, end_addr_low));
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
-				phys_addr = ccb->ccb_dma_handle +
-					offsetof(struct pm8001_ccb_info,
-						buf_prd[0]);
+				phys_addr = ccb->ccb_dma_handle;
 				ssp_cmd.enc_addr_low =
 					cpu_to_le32(lower_32_bits(phys_addr));
 				ssp_cmd.enc_addr_high =
@@ -4543,8 +4540,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 		if (task->num_scatter > 1) {
 			pm8001_chip_make_sg(task->scatter, ccb->n_elem,
 					ccb->buf_prd);
-			phys_addr = ccb->ccb_dma_handle +
-				offsetof(struct pm8001_ccb_info, buf_prd[0]);
+			phys_addr = ccb->ccb_dma_handle;
 			ssp_cmd.addr_low =
 				cpu_to_le32(lower_32_bits(phys_addr));
 			ssp_cmd.addr_high =
@@ -4572,9 +4568,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 						 end_addr_high, end_addr_low));
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
-				phys_addr = ccb->ccb_dma_handle +
-					offsetof(struct pm8001_ccb_info,
-						 buf_prd[0]);
+				phys_addr = ccb->ccb_dma_handle;
 				ssp_cmd.addr_low =
 					cpu_to_le32(lower_32_bits(phys_addr));
 				ssp_cmd.addr_high =
@@ -4666,8 +4660,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 		if (task->num_scatter > 1) {
 			pm8001_chip_make_sg(task->scatter,
 						ccb->n_elem, ccb->buf_prd);
-			phys_addr = ccb->ccb_dma_handle +
-				offsetof(struct pm8001_ccb_info, buf_prd[0]);
+			phys_addr = ccb->ccb_dma_handle;
 			sata_cmd.enc_addr_low = lower_32_bits(phys_addr);
 			sata_cmd.enc_addr_high = upper_32_bits(phys_addr);
 			sata_cmd.enc_esgl = cpu_to_le32(1 << 31);
@@ -4692,9 +4685,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 						end_addr_high, end_addr_low));
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
-				phys_addr = ccb->ccb_dma_handle +
-						offsetof(struct pm8001_ccb_info,
-						buf_prd[0]);
+				phys_addr = ccb->ccb_dma_handle;
 				sata_cmd.enc_addr_low =
 					lower_32_bits(phys_addr);
 				sata_cmd.enc_addr_high =
@@ -4732,8 +4723,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 		if (task->num_scatter > 1) {
 			pm8001_chip_make_sg(task->scatter,
 					ccb->n_elem, ccb->buf_prd);
-			phys_addr = ccb->ccb_dma_handle +
-				offsetof(struct pm8001_ccb_info, buf_prd[0]);
+			phys_addr = ccb->ccb_dma_handle;
 			sata_cmd.addr_low = lower_32_bits(phys_addr);
 			sata_cmd.addr_high = upper_32_bits(phys_addr);
 			sata_cmd.esgl = cpu_to_le32(1 << 31);
@@ -4758,9 +4748,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 						end_addr_high, end_addr_low));
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
-				phys_addr = ccb->ccb_dma_handle +
-					offsetof(struct pm8001_ccb_info,
-					buf_prd[0]);
+				phys_addr = ccb->ccb_dma_handle;
 				sata_cmd.addr_low =
 					lower_32_bits(phys_addr);
 				sata_cmd.addr_high =
-- 
2.16.3

