Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD34C4708E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 17:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiL2RAX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 12:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiL2RAU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 12:00:20 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7333F5A7;
        Thu, 29 Dec 2022 09:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672333218; x=1703869218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pli0p8qWBG/fw32ZyJYrgU57uHIz5Ggmoyz9LzzBTXc=;
  b=VESXedALYS9FYESpX7wcexybsUJxJ2Yp3HVEw/kzmQNjmsHbKvYBOsV9
   hpwqMKvtcvy9SdOxX0V5a6qVFhzaJgCdUTHias5xqxmUdahEjRXuIBJVp
   R65xoYuv8L3rVU2FRdM//ZEX47eM8AB+Nbmx5taiCihEBhaVCX8jKDZnD
   mHSTpzFIC08kNviu+0Ae4GNzenWwWhPUXyC92RNZQ5JRqLI4xynDFJR3+
   rnMxbzbismthKsbu/FggN7KqI61KiufWMHt3d8xItKbg78W2xScez1oQw
   tcZ2tgvfXw8ibdRiIMLcTWpYQgz9IG71Zk3GlUtBRQJYMUwloGt4A1BLZ
   A==;
X-IronPort-AV: E=Sophos;i="5.96,284,1665417600"; 
   d="scan'208";a="323990980"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Dec 2022 01:00:18 +0800
IronPort-SDR: F6XP4QRhK1P7ZM62Hg5w6tW2M6Gf7H/g0LZf08aS8ZIapnZ+EOGyw3/aGvI8Gp4HUShFnNhP7g
 X+GAB9E4iY3LzlGWa0rlriaVBzIHNcD0PMB93vvsxHRU9V6KGSWUXKn64/aaipetjLc9rRIMf0
 h9LAnMREiQiPHfbb14VE7TgP9b5ArSp7HSIhPjNvkk+YHcjueIFV2oMATdgcCQo/M0ihq0trLM
 EVrqXuZg6WF4nryZZGmb/UFTN78eTHi1HZXkoow2qSyLZQziMAhtH8vLH9CkixKbUeBRH/oX7H
 GpE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Dec 2022 08:18:22 -0800
IronPort-SDR: Nru65MeL5cdfhQVCSSwAEpfCvFsyvIDy/MoJ4kTlDq7w6Ou6rG/lX1RwzA87u2t49TGRszVRCn
 ZC1oldwvfGUv1a0bFyLbyk1o4k2fS1Jmd7q/0C327WLEAkU/hIDPcyGau6m/XZMggO3CooufCT
 hXpyFlvK8TxqxQKMDX+r5kihjBfApGxXxLYhcyfcWG0ej+UYwYILJ/9WocOmgTYetZ6zBq0RNF
 SQK6XUJSU7x8wZt5/sbkgSO20UNYxHJI8e7AZunhIQIkA1jVpS/gY2iwWSaZHfVKqwvomoCudF
 m00=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.9])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Dec 2022 09:00:17 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v2 2/7] ata: libata: simplify qc_fill_rtf port operation interface
Date:   Thu, 29 Dec 2022 17:59:58 +0100
Message-Id: <20221229170005.49118-3-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221229170005.49118-1-niklas.cassel@wdc.com>
References: <20221229170005.49118-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

The boolean return value of the qc_fill_rtf operation is used nowhere.
Simplify this operation interface by making it a void function. All
drivers defining this operation are also updated.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/ata/acard-ahci.c      |  6 ++----
 drivers/ata/libahci.c         |  6 ++----
 drivers/ata/libata-sff.c      |  6 +-----
 drivers/ata/sata_fsl.c        |  3 +--
 drivers/ata/sata_inic162x.c   | 12 +++++-------
 drivers/ata/sata_sil24.c      |  5 ++---
 drivers/scsi/ipr.c            |  7 +------
 drivers/scsi/libsas/sas_ata.c |  3 +--
 include/linux/libata.h        |  4 ++--
 9 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index da74a86b70ba..993eadd173da 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -57,7 +57,7 @@ struct acard_sg {
 };
 
 static enum ata_completion_errors acard_ahci_qc_prep(struct ata_queued_cmd *qc);
-static bool acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
+static void acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int acard_ahci_port_start(struct ata_port *ap);
 static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 
@@ -248,7 +248,7 @@ static enum ata_completion_errors acard_ahci_qc_prep(struct ata_queued_cmd *qc)
 	return AC_ERR_OK;
 }
 
-static bool acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
+static void acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	struct ahci_port_priv *pp = qc->ap->private_data;
 	u8 *rx_fis = pp->rx_fis;
@@ -268,8 +268,6 @@ static bool acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 		qc->result_tf.status = (rx_fis + RX_FIS_PIO_SETUP)[15];
 	} else
 		ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
-
-	return true;
 }
 
 static int acard_ahci_port_start(struct ata_port *ap)
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 03aa9eb415d3..0167aac25c34 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -55,7 +55,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 
 static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
-static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
+static void ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
 static void ahci_port_stop(struct ata_port *ap);
 static enum ata_completion_errors ahci_qc_prep(struct ata_queued_cmd *qc);
@@ -2053,7 +2053,7 @@ unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 }
 EXPORT_SYMBOL_GPL(ahci_qc_issue);
 
-static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
+static void ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	struct ahci_port_priv *pp = qc->ap->private_data;
 	u8 *rx_fis = pp->rx_fis;
@@ -2087,8 +2087,6 @@ static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 		qc->result_tf.error = fis[3];
 	} else
 		ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
-
-	return true;
 }
 
 static void ahci_freeze(struct ata_port *ap)
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 34beda28e712..cd82d3b5ed14 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1377,14 +1377,10 @@ EXPORT_SYMBOL_GPL(ata_sff_qc_issue);
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
- *
- *	RETURNS:
- *	true indicating that result TF is successfully filled.
  */
-bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc)
+void ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	qc->ap->ops->sff_tf_read(qc->ap, &qc->result_tf);
-	return true;
 }
 EXPORT_SYMBOL_GPL(ata_sff_qc_fill_rtf);
 
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 7eab9c4e1473..b052c5a65c17 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -566,7 +566,7 @@ static unsigned int sata_fsl_qc_issue(struct ata_queued_cmd *qc)
 	return 0;
 }
 
-static bool sata_fsl_qc_fill_rtf(struct ata_queued_cmd *qc)
+static void sata_fsl_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	struct sata_fsl_port_priv *pp = qc->ap->private_data;
 	struct sata_fsl_host_priv *host_priv = qc->ap->host->private_data;
@@ -577,7 +577,6 @@ static bool sata_fsl_qc_fill_rtf(struct ata_queued_cmd *qc)
 	cd = pp->cmdentry + tag;
 
 	ata_tf_from_fis(cd->sfis, &qc->result_tf);
-	return true;
 }
 
 static int sata_fsl_scr_write(struct ata_link *link,
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index f480ff456190..2833c722118d 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -566,7 +566,7 @@ static void inic_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 	tf->status	= readb(port_base + PORT_TF_COMMAND);
 }
 
-static bool inic_qc_fill_rtf(struct ata_queued_cmd *qc)
+static void inic_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	struct ata_taskfile *rtf = &qc->result_tf;
 	struct ata_taskfile tf;
@@ -580,12 +580,10 @@ static bool inic_qc_fill_rtf(struct ata_queued_cmd *qc)
 	 */
 	inic_tf_read(qc->ap, &tf);
 
-	if (!(tf.status & ATA_ERR))
-		return false;
-
-	rtf->status = tf.status;
-	rtf->error = tf.error;
-	return true;
+	if (tf.status & ATA_ERR) {
+		rtf->status = tf.status;
+		rtf->error = tf.error;
+	}
 }
 
 static void inic_freeze(struct ata_port *ap)
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 0a01518a8d97..22cc9e9789dd 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -328,7 +328,7 @@ static int sil24_scr_write(struct ata_link *link, unsigned sc_reg, u32 val);
 static int sil24_qc_defer(struct ata_queued_cmd *qc);
 static enum ata_completion_errors sil24_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc);
-static bool sil24_qc_fill_rtf(struct ata_queued_cmd *qc);
+static void sil24_qc_fill_rtf(struct ata_queued_cmd *qc);
 static void sil24_pmp_attach(struct ata_port *ap);
 static void sil24_pmp_detach(struct ata_port *ap);
 static void sil24_freeze(struct ata_port *ap);
@@ -901,10 +901,9 @@ static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc)
 	return 0;
 }
 
-static bool sil24_qc_fill_rtf(struct ata_queued_cmd *qc)
+static void sil24_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	sil24_read_tf(qc->ap, qc->hw_tag, &qc->result_tf);
-	return true;
 }
 
 static void sil24_pmp_attach(struct ata_port *ap)
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index c68ca2218a05..1c8040d250ea 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7142,11 +7142,8 @@ static unsigned int ipr_qc_issue(struct ata_queued_cmd *qc)
 /**
  * ipr_qc_fill_rtf - Read result TF
  * @qc: ATA queued command
- *
- * Return value:
- * 	true
  **/
-static bool ipr_qc_fill_rtf(struct ata_queued_cmd *qc)
+static void ipr_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	struct ipr_sata_port *sata_port = qc->ap->private_data;
 	struct ipr_ioasa_gata *g = &sata_port->ioasa;
@@ -7163,8 +7160,6 @@ static bool ipr_qc_fill_rtf(struct ata_queued_cmd *qc)
 	tf->hob_lbal = g->hob_lbal;
 	tf->hob_lbam = g->hob_lbam;
 	tf->hob_lbah = g->hob_lbah;
-
-	return true;
 }
 
 static struct ata_port_operations ipr_sata_ops = {
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 14da33a3b6a6..ac8576e7f0b7 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -226,12 +226,11 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	return ret;
 }
 
-static bool sas_ata_qc_fill_rtf(struct ata_queued_cmd *qc)
+static void sas_ata_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	struct domain_device *dev = qc->ap->private_data;
 
 	ata_tf_from_fis(dev->sata_dev.fis, &qc->result_tf);
-	return true;
 }
 
 static struct sas_internal *dev_to_sas_internal(struct domain_device *dev)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7985e6e2ae0e..8483d8300ea3 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -876,7 +876,7 @@ struct ata_port_operations {
 	int (*check_atapi_dma)(struct ata_queued_cmd *qc);
 	enum ata_completion_errors (*qc_prep)(struct ata_queued_cmd *qc);
 	unsigned int (*qc_issue)(struct ata_queued_cmd *qc);
-	bool (*qc_fill_rtf)(struct ata_queued_cmd *qc);
+	void (*qc_fill_rtf)(struct ata_queued_cmd *qc);
 
 	/*
 	 * Configuration and exception handling
@@ -1936,7 +1936,7 @@ extern void ata_sff_queue_delayed_work(struct delayed_work *dwork,
 		unsigned long delay);
 extern void ata_sff_queue_pio_task(struct ata_link *link, unsigned long delay);
 extern unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc);
-extern bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc);
+extern void ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc);
 extern unsigned int ata_sff_port_intr(struct ata_port *ap,
 				      struct ata_queued_cmd *qc);
 extern irqreturn_t ata_sff_interrupt(int irq, void *dev_instance);
-- 
2.38.1

