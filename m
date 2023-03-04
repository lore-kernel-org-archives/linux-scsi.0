Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A462C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCDAbx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCDAbu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:31:50 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112DC6513D
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:46 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so3936545pjz.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x46ekvp3cB1G9kAdgDgONLmAQxZjVMQEpyoSlejufSU=;
        b=wOtwP6HO34GQcMm0ymiooINy9JTBOGBPxSSs3ZqlP0EeQa6vQWRKIGeQ2V3unHxS6F
         Wttt8iDLVk/KdKcK8GP+51i2jqIIwYBiHb8b9X0HJNeBVtP/hM3R/575AiAQoSD/Rwfc
         nH26+polnojQGhmoAbUGapheRs/FaJog8xcRJqAt3c9HtPHM6O7mboqt+dB/+lqyohI4
         9nKoLlP21ogk0IJzKwiAfrH7B68jR0IG6TFOO7unPHhkevmK/UhETSB9fMvetoh1ofgJ
         i2Ylk+HxdqW2Rdbo/04/cdK0UNHNfMNnqnjEwsZw1N5HC2Yrs/l4N6mFaVQT0OmdLbgL
         +Jdg==
X-Gm-Message-State: AO0yUKXC4HCHsKxy1Ayc/23UBiHnoiat+mDUqeFHf1edwNXFyFAJUbVN
        4wA3BX7SU8iGvdZLzv2sf40=
X-Google-Smtp-Source: AK7set/PpDMP0PTMNJqjUM8vEaNkPp1QXO+23EReoXku++G8ir8stLbuEMLe8NskPgtJwZ03jDNQ1g==
X-Received: by 2002:a17:902:dace:b0:19a:abb0:1e with SMTP id q14-20020a170902dace00b0019aabb0001emr4184262plx.38.1677889905233;
        Fri, 03 Mar 2023 16:31:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mikael Pettersson <mikpelinux@gmail.com>
Subject: [PATCH 04/81] ata: Declare SCSI host templates const
Date:   Fri,  3 Mar 2023 16:29:46 -0800
Message-Id: <20230304003103.2572793-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that ATA host templates are not modified.

Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/acard-ahci.c        |   2 +-
 drivers/ata/ahci.c              |   2 +-
 drivers/ata/ahci.h              |   2 +-
 drivers/ata/ahci_brcm.c         |   2 +-
 drivers/ata/ahci_ceva.c         |   2 +-
 drivers/ata/ahci_da850.c        |   2 +-
 drivers/ata/ahci_dm816.c        |   2 +-
 drivers/ata/ahci_imx.c          |   2 +-
 drivers/ata/ahci_mtk.c          |   2 +-
 drivers/ata/ahci_mvebu.c        |   2 +-
 drivers/ata/ahci_platform.c     |   2 +-
 drivers/ata/ahci_qoriq.c        |   2 +-
 drivers/ata/ahci_seattle.c      |   2 +-
 drivers/ata/ahci_st.c           |   2 +-
 drivers/ata/ahci_sunxi.c        |   2 +-
 drivers/ata/ahci_tegra.c        |   2 +-
 drivers/ata/ahci_xgene.c        |   2 +-
 drivers/ata/ata_generic.c       |   2 +-
 drivers/ata/ata_piix.c          |   6 +-
 drivers/ata/libahci.c           |   4 +-
 drivers/ata/libahci_platform.c  |   2 +-
 drivers/ata/libata-core.c       |   4 +-
 drivers/ata/libata-scsi.c       |   2 +-
 drivers/ata/libata-sff.c        |   8 +-
 drivers/ata/libata.h            |   2 +-
 drivers/ata/pata_acpi.c         |   2 +-
 drivers/ata/pata_ali.c          |   2 +-
 drivers/ata/pata_amd.c          |   2 +-
 drivers/ata/pata_arasan_cf.c    |   2 +-
 drivers/ata/pata_artop.c        |   2 +-
 drivers/ata/pata_atiixp.c       |   2 +-
 drivers/ata/pata_atp867x.c      |   2 +-
 drivers/ata/pata_bk3710.c       | 380 ++++++++++++++++++++++++++++++++
 drivers/ata/pata_buddha.c       |   2 +-
 drivers/ata/pata_cmd640.c       |   2 +-
 drivers/ata/pata_cmd64x.c       |   2 +-
 drivers/ata/pata_cs5520.c       |   2 +-
 drivers/ata/pata_cs5530.c       |   2 +-
 drivers/ata/pata_cs5535.c       |   2 +-
 drivers/ata/pata_cs5536.c       |   2 +-
 drivers/ata/pata_cypress.c      |   2 +-
 drivers/ata/pata_efar.c         |   2 +-
 drivers/ata/pata_ep93xx.c       |   2 +-
 drivers/ata/pata_falcon.c       |   2 +-
 drivers/ata/pata_ftide010.c     |   2 +-
 drivers/ata/pata_gayle.c        |   2 +-
 drivers/ata/pata_hpt366.c       |   2 +-
 drivers/ata/pata_hpt37x.c       |   2 +-
 drivers/ata/pata_hpt3x2n.c      |   2 +-
 drivers/ata/pata_hpt3x3.c       |   2 +-
 drivers/ata/pata_icside.c       |   2 +-
 drivers/ata/pata_imx.c          |   2 +-
 drivers/ata/pata_isapnp.c       |   2 +-
 drivers/ata/pata_it8213.c       |   2 +-
 drivers/ata/pata_it821x.c       |   2 +-
 drivers/ata/pata_ixp4xx_cf.c    |   2 +-
 drivers/ata/pata_jmicron.c      |   2 +-
 drivers/ata/pata_legacy.c       |   2 +-
 drivers/ata/pata_macio.c        |   2 +-
 drivers/ata/pata_marvell.c      |   2 +-
 drivers/ata/pata_mpc52xx.c      |   2 +-
 drivers/ata/pata_mpiix.c        |   2 +-
 drivers/ata/pata_netcell.c      |   2 +-
 drivers/ata/pata_ninja32.c      |   2 +-
 drivers/ata/pata_ns87410.c      |   2 +-
 drivers/ata/pata_ns87415.c      |   2 +-
 drivers/ata/pata_octeon_cf.c    |   2 +-
 drivers/ata/pata_of_platform.c  |   2 +-
 drivers/ata/pata_oldpiix.c      |   2 +-
 drivers/ata/pata_opti.c         |   2 +-
 drivers/ata/pata_optidma.c      |   2 +-
 drivers/ata/pata_pcmcia.c       |   2 +-
 drivers/ata/pata_pdc2027x.c     |   2 +-
 drivers/ata/pata_pdc202xx_old.c |   2 +-
 drivers/ata/pata_piccolo.c      |   2 +-
 drivers/ata/pata_platform.c     |   4 +-
 drivers/ata/pata_pxa.c          |   2 +-
 drivers/ata/pata_radisys.c      |   2 +-
 drivers/ata/pata_rb532_cf.c     |   2 +-
 drivers/ata/pata_rdc.c          |   2 +-
 drivers/ata/pata_rz1000.c       |   2 +-
 drivers/ata/pata_sc1200.c       |   2 +-
 drivers/ata/pata_sch.c          |   2 +-
 drivers/ata/pata_serverworks.c  |   6 +-
 drivers/ata/pata_sil680.c       |   2 +-
 drivers/ata/pata_sis.c          |   2 +-
 drivers/ata/pata_sl82c105.c     |   2 +-
 drivers/ata/pata_triflex.c      |   2 +-
 drivers/ata/pata_via.c          |   2 +-
 drivers/ata/pdc_adma.c          |   2 +-
 drivers/ata/sata_dwc_460ex.c    |   2 +-
 drivers/ata/sata_fsl.c          |   2 +-
 drivers/ata/sata_highbank.c     |   2 +-
 drivers/ata/sata_inic162x.c     |   2 +-
 drivers/ata/sata_mv.c           |   4 +-
 drivers/ata/sata_nv.c           |   8 +-
 drivers/ata/sata_promise.c      |   2 +-
 drivers/ata/sata_qstor.c        |   2 +-
 drivers/ata/sata_rcar.c         |   2 +-
 drivers/ata/sata_sil.c          |   2 +-
 drivers/ata/sata_sil24.c        |   2 +-
 drivers/ata/sata_sis.c          |   2 +-
 drivers/ata/sata_svw.c          |   2 +-
 drivers/ata/sata_sx4.c          |   2 +-
 drivers/ata/sata_uli.c          |   2 +-
 drivers/ata/sata_via.c          |   2 +-
 drivers/ata/sata_vsc.c          |   2 +-
 include/linux/ahci_platform.h   |   2 +-
 include/linux/ata_platform.h    |   2 +-
 include/linux/libata.h          |  10 +-
 110 files changed, 507 insertions(+), 127 deletions(-)
 create mode 100644 drivers/ata/pata_bk3710.c

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 993eadd173da..547f56341705 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -66,7 +66,7 @@ static int acard_ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg
 static int acard_ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 
-static struct scsi_host_template acard_ahci_sht = {
+static const struct scsi_host_template acard_ahci_sht = {
 	AHCI_SHT("acard-ahci"),
 };
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 14a1c0d14916..addba109406b 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -101,7 +101,7 @@ static int ahci_pci_device_resume(struct device *dev);
 #endif
 #endif /* CONFIG_PM */
 
-static struct scsi_host_template ahci_sht = {
+static const struct scsi_host_template ahci_sht = {
 	AHCI_SHT("ahci"),
 };
 
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index ff8e6ae1c636..4bae95b06ae3 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -430,7 +430,7 @@ void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			  struct ata_port_info *pi);
 int ahci_reset_em(struct ata_host *host);
 void ahci_print_info(struct ata_host *host, const char *scc_s);
-int ahci_host_activate(struct ata_host *host, struct scsi_host_template *sht);
+int ahci_host_activate(struct ata_host *host, const struct scsi_host_template *sht);
 void ahci_error_handler(struct ata_port *ap);
 u32 ahci_handle_port_intr(struct ata_host *host, u32 irq_masked);
 
diff --git a/drivers/ata/ahci_brcm.c b/drivers/ata/ahci_brcm.c
index 6f216eb25610..4e3dc2b6d67f 100644
--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -417,7 +417,7 @@ static int __maybe_unused brcm_ahci_resume(struct device *dev)
 	return ret;
 }
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_ceva.c b/drivers/ata/ahci_ceva.c
index cb24ecf36faf..bc027468decb 100644
--- a/drivers/ata/ahci_ceva.c
+++ b/drivers/ata/ahci_ceva.c
@@ -185,7 +185,7 @@ static void ahci_ceva_setup(struct ahci_host_priv *hpriv)
 	}
 }
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
index dc8a019b8340..ca0924dc5bd2 100644
--- a/drivers/ata/ahci_da850.c
+++ b/drivers/ata/ahci_da850.c
@@ -153,7 +153,7 @@ static const struct ata_port_info ahci_da850_port_info = {
 	.port_ops	= &ahci_da850_port_ops,
 };
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_dm816.c b/drivers/ata/ahci_dm816.c
index d26efcd20f64..b08547b877a1 100644
--- a/drivers/ata/ahci_dm816.c
+++ b/drivers/ata/ahci_dm816.c
@@ -134,7 +134,7 @@ static const struct ata_port_info ahci_dm816_port_info = {
 	.port_ops	= &ahci_dm816_port_ops,
 };
 
-static struct scsi_host_template ahci_dm816_platform_sht = {
+static const struct scsi_host_template ahci_dm816_platform_sht = {
 	AHCI_SHT(AHCI_DM816_DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index a950767f7948..1c1139dae29a 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -979,7 +979,7 @@ static u32 imx_ahci_parse_props(struct device *dev,
 	return reg_value;
 }
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_mtk.c b/drivers/ata/ahci_mtk.c
index c056378e3e72..f6a75341256f 100644
--- a/drivers/ata/ahci_mtk.c
+++ b/drivers/ata/ahci_mtk.c
@@ -37,7 +37,7 @@ static const struct ata_port_info ahci_port_info = {
 	.port_ops	= &ahci_platform_ops,
 };
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_mvebu.c b/drivers/ata/ahci_mvebu.c
index 22ecc4f3ae79..596cf017f427 100644
--- a/drivers/ata/ahci_mvebu.c
+++ b/drivers/ata/ahci_mvebu.c
@@ -178,7 +178,7 @@ static const struct ata_port_info ahci_mvebu_port_info = {
 	.port_ops  = &ahci_platform_ops,
 };
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 8f5572a9f8f1..299ee686ac49 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -36,7 +36,7 @@ static const struct ata_port_info ahci_port_info_nolpm = {
 	.port_ops	= &ahci_platform_ops,
 };
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_qoriq.c b/drivers/ata/ahci_qoriq.c
index 9cf9bf36a874..0ba764d283c8 100644
--- a/drivers/ata/ahci_qoriq.c
+++ b/drivers/ata/ahci_qoriq.c
@@ -159,7 +159,7 @@ static const struct ata_port_info ahci_qoriq_port_info = {
 	.port_ops	= &ahci_qoriq_ops,
 };
 
-static struct scsi_host_template ahci_qoriq_sht = {
+static const struct scsi_host_template ahci_qoriq_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_seattle.c b/drivers/ata/ahci_seattle.c
index ced12705ed9d..9eda7bbd2151 100644
--- a/drivers/ata/ahci_seattle.c
+++ b/drivers/ata/ahci_seattle.c
@@ -72,7 +72,7 @@ static const struct ata_port_info ahci_port_seattle_info = {
 	.port_ops	= &ahci_seattle_ops,
 };
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index 8607b68eee53..f2c1edb36986 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -138,7 +138,7 @@ static const struct ata_port_info st_ahci_port_info = {
 	.port_ops       = &st_ahci_port_ops,
 };
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_sunxi.c b/drivers/ata/ahci_sunxi.c
index c7273c1cb0c7..076c12b4ba08 100644
--- a/drivers/ata/ahci_sunxi.c
+++ b/drivers/ata/ahci_sunxi.c
@@ -206,7 +206,7 @@ static const struct ata_port_info ahci_sunxi_port_info = {
 	.port_ops	= &ahci_platform_ops,
 };
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c
index 4fb94db1217d..8e5e2b359f2d 100644
--- a/drivers/ata/ahci_tegra.c
+++ b/drivers/ata/ahci_tegra.c
@@ -506,7 +506,7 @@ static const struct of_device_id tegra_ahci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, tegra_ahci_of_match);
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 1e08704d5117..83f5ff54ef5b 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -710,7 +710,7 @@ static int xgene_ahci_mux_select(struct xgene_ahci_context *ctx)
 	return val & CFG_SATA_ENET_SELECT_MASK ? -1 : 0;
 }
 
-static struct scsi_host_template ahci_platform_sht = {
+static const struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 20a32e4d501d..2f57ec00ab82 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -95,7 +95,7 @@ static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 	return 0;
 }
 
-static struct scsi_host_template generic_sht = {
+static const struct scsi_host_template generic_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ade5e894563b..ec3c5bd1f813 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1059,7 +1059,7 @@ static u8 piix_vmw_bmdma_status(struct ata_port *ap)
 	return ata_bmdma_status(ap) & ~ATA_DMA_ERR;
 }
 
-static struct scsi_host_template piix_sht = {
+static const struct scsi_host_template piix_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
@@ -1095,7 +1095,7 @@ static struct attribute *piix_sidpr_shost_attrs[] = {
 
 ATTRIBUTE_GROUPS(piix_sidpr_shost);
 
-static struct scsi_host_template piix_sidpr_sht = {
+static const struct scsi_host_template piix_sidpr_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 	.shost_groups		= piix_sidpr_shost_groups,
 };
@@ -1645,7 +1645,7 @@ static int piix_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct device *dev = &pdev->dev;
 	struct ata_port_info port_info[2];
 	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
-	struct scsi_host_template *sht = &piix_sht;
+	const struct scsi_host_template *sht = &piix_sht;
 	unsigned long port_flags;
 	struct ata_host *host;
 	struct piix_host_priv *hpriv;
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 8f216de76648..9c2cb6cbea76 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2692,7 +2692,7 @@ void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 EXPORT_SYMBOL_GPL(ahci_set_em_messages);
 
 static int ahci_host_activate_multi_irqs(struct ata_host *host,
-					 struct scsi_host_template *sht)
+					 const struct scsi_host_template *sht)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
 	int i, rc;
@@ -2736,7 +2736,7 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ahci_host_activate(struct ata_host *host, struct scsi_host_template *sht)
+int ahci_host_activate(struct ata_host *host, const struct scsi_host_template *sht)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
 	int irq = hpriv->irq;
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index b9e336bacf17..d6c3a6ffb0b3 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -680,7 +680,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
 int ahci_platform_init_host(struct platform_device *pdev,
 			    struct ahci_host_priv *hpriv,
 			    const struct ata_port_info *pi_template,
-			    struct scsi_host_template *sht)
+			    const struct scsi_host_template *sht)
 {
 	struct device *dev = &pdev->dev;
 	struct ata_port_info pi = *pi_template;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 14c17c3bda4e..8bf612bdd61a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5775,7 +5775,7 @@ static void async_port_probe(void *data, async_cookie_t cookie)
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
+int ata_host_register(struct ata_host *host, const struct scsi_host_template *sht)
 {
 	int i, rc;
 
@@ -5883,7 +5883,7 @@ EXPORT_SYMBOL_GPL(ata_host_register);
  */
 int ata_host_activate(struct ata_host *host, int irq,
 		      irq_handler_t irq_handler, unsigned long irq_flags,
-		      struct scsi_host_template *sht)
+		      const struct scsi_host_template *sht)
 {
 	int i, rc;
 	char *irq_desc;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e093c7a7deeb..7bb12deab70c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4186,7 +4186,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 	scsi_done(cmd);
 }
 
-int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
+int ata_scsi_add_hosts(struct ata_host *host, const struct scsi_host_template *sht)
 {
 	int i, rc;
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index cd82d3b5ed14..9d28badfe41d 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2281,7 +2281,7 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_prepare_host);
  */
 int ata_pci_sff_activate_host(struct ata_host *host,
 			      irq_handler_t irq_handler,
-			      struct scsi_host_template *sht)
+			      const struct scsi_host_template *sht)
 {
 	struct device *dev = host->dev;
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -2378,7 +2378,7 @@ static const struct ata_port_info *ata_sff_find_valid_pi(
 
 static int ata_pci_init_one(struct pci_dev *pdev,
 		const struct ata_port_info * const *ppi,
-		struct scsi_host_template *sht, void *host_priv,
+		const struct scsi_host_template *sht, void *host_priv,
 		int hflags, bool bmdma)
 {
 	struct device *dev = &pdev->dev;
@@ -2452,7 +2452,7 @@ static int ata_pci_init_one(struct pci_dev *pdev,
  */
 int ata_pci_sff_init_one(struct pci_dev *pdev,
 		 const struct ata_port_info * const *ppi,
-		 struct scsi_host_template *sht, void *host_priv, int hflag)
+		 const struct scsi_host_template *sht, void *host_priv, int hflag)
 {
 	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflag, 0);
 }
@@ -3175,7 +3175,7 @@ EXPORT_SYMBOL_GPL(ata_pci_bmdma_prepare_host);
  */
 int ata_pci_bmdma_init_one(struct pci_dev *pdev,
 			   const struct ata_port_info * const * ppi,
-			   struct scsi_host_template *sht, void *host_priv,
+			   const struct scsi_host_template *sht, void *host_priv,
 			   int hflags)
 {
 	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflags, 1);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 2cd6124a01e8..926d0d33cd29 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -111,7 +111,7 @@ static inline void ata_acpi_bind_dev(struct ata_device *dev) {}
 extern struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
 extern int ata_scsi_add_hosts(struct ata_host *host,
-			      struct scsi_host_template *sht);
+			      const struct scsi_host_template *sht);
 extern void ata_scsi_scan_host(struct ata_port *ap, int sync);
 extern int ata_scsi_offline_dev(struct ata_device *dev);
 extern bool ata_scsi_sense_is_valid(u8 sk, u8 asc, u8 ascq);
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index f8706ee427d2..ab38871b5e00 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -205,7 +205,7 @@ static int pacpi_port_start(struct ata_port *ap)
 	return ata_bmdma_port_start(ap);
 }
 
-static struct scsi_host_template pacpi_sht = {
+static const struct scsi_host_template pacpi_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 76ad0e73fe2a..bb790edd6036 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -355,7 +355,7 @@ static void ali_c2_c3_postreset(struct ata_link *link, unsigned int *classes)
 	ata_sff_postreset(link, classes);
 }
 
-static struct scsi_host_template ali_sht = {
+static const struct scsi_host_template ali_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index f216f9d7b9ec..5b02b89748b7 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -388,7 +388,7 @@ static void nv_host_stop(struct ata_host *host)
 	pci_write_config_dword(to_pci_dev(host->dev), 0x60, udma);
 }
 
-static struct scsi_host_template amd_sht = {
+static const struct scsi_host_template amd_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index e89617ed9175..6ab294322e79 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -218,7 +218,7 @@ struct arasan_cf_dev {
 	struct ata_queued_cmd *qc;
 };
 
-static struct scsi_host_template arasan_cf_sht = {
+static const struct scsi_host_template arasan_cf_sht = {
 	ATA_BASE_SHT(DRIVER_NAME),
 	.dma_boundary = 0xFFFFFFFFUL,
 };
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 20a8f31a3f57..40544282f455 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -292,7 +292,7 @@ static int artop6210_qc_defer(struct ata_queued_cmd *qc)
 	return 0;
 }
 
-static struct scsi_host_template artop_sht = {
+static const struct scsi_host_template artop_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index efdb94cff68b..8c5cc803aab3 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -251,7 +251,7 @@ static void atiixp_bmdma_stop(struct ata_queued_cmd *qc)
 	ata_bmdma_stop(qc);
 }
 
-static struct scsi_host_template atiixp_sht = {
+static const struct scsi_host_template atiixp_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
index 779d660415c8..aaef5924f636 100644
--- a/drivers/ata/pata_atp867x.c
+++ b/drivers/ata/pata_atp867x.c
@@ -259,7 +259,7 @@ static int atp867x_cable_detect(struct ata_port *ap)
 	return ATA_CBL_PATA_UNK;
 }
 
-static struct scsi_host_template atp867x_sht = {
+static const struct scsi_host_template atp867x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_bk3710.c b/drivers/ata/pata_bk3710.c
new file mode 100644
index 000000000000..6cadb8741a43
--- /dev/null
+++ b/drivers/ata/pata_bk3710.c
@@ -0,0 +1,380 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Palmchip BK3710 PATA controller driver
+ *
+ * Copyright (c) 2017 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Based on palm_bk3710.c:
+ *
+ * Copyright (C) 2006 Texas Instruments.
+ * Copyright (C) 2007 MontaVista Software, Inc., <source@mvista.com>
+ */
+
+#include <linux/ata.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/libata.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+
+#define DRV_NAME "pata_bk3710"
+
+#define BK3710_TF_OFFSET	0x1F0
+#define BK3710_CTL_OFFSET	0x3F6
+
+#define BK3710_BMISP		0x02
+#define BK3710_IDETIMP		0x40
+#define BK3710_UDMACTL		0x48
+#define BK3710_MISCCTL		0x50
+#define BK3710_REGSTB		0x54
+#define BK3710_REGRCVR		0x58
+#define BK3710_DATSTB		0x5C
+#define BK3710_DATRCVR		0x60
+#define BK3710_DMASTB		0x64
+#define BK3710_DMARCVR		0x68
+#define BK3710_UDMASTB		0x6C
+#define BK3710_UDMATRP		0x70
+#define BK3710_UDMAENV		0x74
+#define BK3710_IORDYTMP		0x78
+
+static const struct scsi_host_template pata_bk3710_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+static unsigned int ideclk_period; /* in nanoseconds */
+
+struct pata_bk3710_udmatiming {
+	unsigned int rptime;	/* tRP -- Ready to pause time (nsec) */
+	unsigned int cycletime;	/* tCYCTYP2/2 -- avg Cycle Time (nsec) */
+				/* tENV is always a minimum of 20 nsec */
+};
+
+static const struct pata_bk3710_udmatiming pata_bk3710_udmatimings[6] = {
+	{ 160, 240 / 2 },	/* UDMA Mode 0 */
+	{ 125, 160 / 2 },	/* UDMA Mode 1 */
+	{ 100, 120 / 2 },	/* UDMA Mode 2 */
+	{ 100,  90 / 2 },	/* UDMA Mode 3 */
+	{ 100,  60 / 2 },	/* UDMA Mode 4 */
+	{  85,  40 / 2 },	/* UDMA Mode 5 */
+};
+
+static void pata_bk3710_setudmamode(void __iomem *base, unsigned int dev,
+				    unsigned int mode)
+{
+	u32 val32;
+	u16 val16;
+	u8 tenv, trp, t0;
+
+	/* DMA Data Setup */
+	t0 = DIV_ROUND_UP(pata_bk3710_udmatimings[mode].cycletime,
+			  ideclk_period) - 1;
+	tenv = DIV_ROUND_UP(20, ideclk_period) - 1;
+	trp = DIV_ROUND_UP(pata_bk3710_udmatimings[mode].rptime,
+			   ideclk_period) - 1;
+
+	/* udmastb Ultra DMA Access Strobe Width */
+	val32 = ioread32(base + BK3710_UDMASTB) & (0xFF << (dev ? 0 : 8));
+	val32 |= t0 << (dev ? 8 : 0);
+	iowrite32(val32, base + BK3710_UDMASTB);
+
+	/* udmatrp Ultra DMA Ready to Pause Time */
+	val32 = ioread32(base + BK3710_UDMATRP) & (0xFF << (dev ? 0 : 8));
+	val32 |= trp << (dev ? 8 : 0);
+	iowrite32(val32, base + BK3710_UDMATRP);
+
+	/* udmaenv Ultra DMA envelop Time */
+	val32 = ioread32(base + BK3710_UDMAENV) & (0xFF << (dev ? 0 : 8));
+	val32 |= tenv << (dev ? 8 : 0);
+	iowrite32(val32, base + BK3710_UDMAENV);
+
+	/* Enable UDMA for Device */
+	val16 = ioread16(base + BK3710_UDMACTL) | (1 << dev);
+	iowrite16(val16, base + BK3710_UDMACTL);
+}
+
+static void pata_bk3710_setmwdmamode(void __iomem *base, unsigned int dev,
+				     unsigned short min_cycle,
+				     unsigned int mode)
+{
+	const struct ata_timing *t;
+	int cycletime;
+	u32 val32;
+	u16 val16;
+	u8 td, tkw, t0;
+
+	t = ata_timing_find_mode(mode);
+	cycletime = max_t(int, t->cycle, min_cycle);
+
+	/* DMA Data Setup */
+	t0 = DIV_ROUND_UP(cycletime, ideclk_period);
+	td = DIV_ROUND_UP(t->active, ideclk_period);
+	tkw = t0 - td - 1;
+	td--;
+
+	val32 = ioread32(base + BK3710_DMASTB) & (0xFF << (dev ? 0 : 8));
+	val32 |= td << (dev ? 8 : 0);
+	iowrite32(val32, base + BK3710_DMASTB);
+
+	val32 = ioread32(base + BK3710_DMARCVR) & (0xFF << (dev ? 0 : 8));
+	val32 |= tkw << (dev ? 8 : 0);
+	iowrite32(val32, base + BK3710_DMARCVR);
+
+	/* Disable UDMA for Device */
+	val16 = ioread16(base + BK3710_UDMACTL) & ~(1 << dev);
+	iowrite16(val16, base + BK3710_UDMACTL);
+}
+
+static void pata_bk3710_set_dmamode(struct ata_port *ap,
+				    struct ata_device *adev)
+{
+	void __iomem *base = (void __iomem *)ap->ioaddr.bmdma_addr;
+	int is_slave = adev->devno;
+	const u8 xferspeed = adev->dma_mode;
+
+	if (xferspeed >= XFER_UDMA_0)
+		pata_bk3710_setudmamode(base, is_slave,
+					xferspeed - XFER_UDMA_0);
+	else
+		pata_bk3710_setmwdmamode(base, is_slave,
+					 adev->id[ATA_ID_EIDE_DMA_MIN],
+					 xferspeed);
+}
+
+static void pata_bk3710_setpiomode(void __iomem *base, struct ata_device *pair,
+				   unsigned int dev, unsigned int cycletime,
+				   unsigned int mode)
+{
+	const struct ata_timing *t;
+	u32 val32;
+	u8 t2, t2i, t0;
+
+	t = ata_timing_find_mode(XFER_PIO_0 + mode);
+
+	/* PIO Data Setup */
+	t0 = DIV_ROUND_UP(cycletime, ideclk_period);
+	t2 = DIV_ROUND_UP(t->active, ideclk_period);
+
+	t2i = t0 - t2 - 1;
+	t2--;
+
+	val32 = ioread32(base + BK3710_DATSTB) & (0xFF << (dev ? 0 : 8));
+	val32 |= t2 << (dev ? 8 : 0);
+	iowrite32(val32, base + BK3710_DATSTB);
+
+	val32 = ioread32(base + BK3710_DATRCVR) & (0xFF << (dev ? 0 : 8));
+	val32 |= t2i << (dev ? 8 : 0);
+	iowrite32(val32, base + BK3710_DATRCVR);
+
+	/* FIXME: this is broken also in the old driver */
+	if (pair) {
+		u8 mode2 = pair->pio_mode - XFER_PIO_0;
+
+		if (mode2 < mode)
+			mode = mode2;
+	}
+
+	/* TASKFILE Setup */
+	t0 = DIV_ROUND_UP(t->cyc8b, ideclk_period);
+	t2 = DIV_ROUND_UP(t->act8b, ideclk_period);
+
+	t2i = t0 - t2 - 1;
+	t2--;
+
+	val32 = ioread32(base + BK3710_REGSTB) & (0xFF << (dev ? 0 : 8));
+	val32 |= t2 << (dev ? 8 : 0);
+	iowrite32(val32, base + BK3710_REGSTB);
+
+	val32 = ioread32(base + BK3710_REGRCVR) & (0xFF << (dev ? 0 : 8));
+	val32 |= t2i << (dev ? 8 : 0);
+	iowrite32(val32, base + BK3710_REGRCVR);
+}
+
+static void pata_bk3710_set_piomode(struct ata_port *ap,
+				    struct ata_device *adev)
+{
+	void __iomem *base = (void __iomem *)ap->ioaddr.bmdma_addr;
+	struct ata_device *pair = ata_dev_pair(adev);
+	const struct ata_timing *t = ata_timing_find_mode(adev->pio_mode);
+	const u16 *id = adev->id;
+	unsigned int cycle_time = 0;
+	int is_slave = adev->devno;
+	const u8 pio = adev->pio_mode - XFER_PIO_0;
+
+	if (id[ATA_ID_FIELD_VALID] & 2) {
+		if (ata_id_has_iordy(id))
+			cycle_time = id[ATA_ID_EIDE_PIO_IORDY];
+		else
+			cycle_time = id[ATA_ID_EIDE_PIO];
+
+		/* conservative "downgrade" for all pre-ATA2 drives */
+		if (pio < 3 && cycle_time < t->cycle)
+			cycle_time = 0; /* use standard timing */
+	}
+
+	if (!cycle_time)
+		cycle_time = t->cycle;
+
+	pata_bk3710_setpiomode(base, pair, is_slave, cycle_time, pio);
+}
+
+static void pata_bk3710_chipinit(void __iomem *base)
+{
+	/*
+	 * REVISIT:  the ATA reset signal needs to be managed through a
+	 * GPIO, which means it should come from platform_data.  Until
+	 * we get and use such information, we have to trust that things
+	 * have been reset before we get here.
+	 */
+
+	/*
+	 * Program the IDETIMP Register Value based on the following assumptions
+	 *
+	 * (ATA_IDETIMP_IDEEN		, ENABLE ) |
+	 * (ATA_IDETIMP_PREPOST1	, DISABLE) |
+	 * (ATA_IDETIMP_PREPOST0	, DISABLE) |
+	 *
+	 * DM6446 silicon rev 2.1 and earlier have no observed net benefit
+	 * from enabling prefetch/postwrite.
+	 */
+	iowrite16(BIT(15), base + BK3710_IDETIMP);
+
+	/*
+	 * UDMACTL Ultra-ATA DMA Control
+	 * (ATA_UDMACTL_UDMAP1	, 0 ) |
+	 * (ATA_UDMACTL_UDMAP0	, 0 )
+	 *
+	 */
+	iowrite16(0, base + BK3710_UDMACTL);
+
+	/*
+	 * MISCCTL Miscellaneous Conrol Register
+	 * (ATA_MISCCTL_HWNHLD1P	, 1 cycle)
+	 * (ATA_MISCCTL_HWNHLD0P	, 1 cycle)
+	 * (ATA_MISCCTL_TIMORIDE	, 1)
+	 */
+	iowrite32(0x001, base + BK3710_MISCCTL);
+
+	/*
+	 * IORDYTMP IORDY Timer for Primary Register
+	 * (ATA_IORDYTMP_IORDYTMP	, DISABLE)
+	 */
+	iowrite32(0, base + BK3710_IORDYTMP);
+
+	/*
+	 * Configure BMISP Register
+	 * (ATA_BMISP_DMAEN1	, DISABLE )	|
+	 * (ATA_BMISP_DMAEN0	, DISABLE )	|
+	 * (ATA_BMISP_IORDYINT	, CLEAR)	|
+	 * (ATA_BMISP_INTRSTAT	, CLEAR)	|
+	 * (ATA_BMISP_DMAERROR	, CLEAR)
+	 */
+	iowrite16(0xE, base + BK3710_BMISP);
+
+	pata_bk3710_setpiomode(base, NULL, 0, 600, 0);
+	pata_bk3710_setpiomode(base, NULL, 1, 600, 0);
+}
+
+static struct ata_port_operations pata_bk3710_ports_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.cable_detect		= ata_cable_80wire,
+
+	.set_piomode		= pata_bk3710_set_piomode,
+	.set_dmamode		= pata_bk3710_set_dmamode,
+};
+
+static int __init pata_bk3710_probe(struct platform_device *pdev)
+{
+	struct clk *clk;
+	struct resource *mem;
+	struct ata_host *host;
+	struct ata_port *ap;
+	void __iomem *base;
+	unsigned long rate;
+	int irq;
+
+	clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk))
+		return -ENODEV;
+
+	clk_enable(clk);
+	rate = clk_get_rate(clk);
+	if (!rate)
+		return -EINVAL;
+
+	/* NOTE:  round *down* to meet minimum timings; we count in clocks */
+	ideclk_period = 1000000000UL / rate;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		pr_err(DRV_NAME ": failed to get IRQ resource\n");
+		return irq;
+	}
+
+	base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	/* configure the Palmchip controller */
+	pata_bk3710_chipinit(base);
+
+	/* allocate host */
+	host = ata_host_alloc(&pdev->dev, 1);
+	if (!host)
+		return -ENOMEM;
+	ap = host->ports[0];
+
+	ap->ops = &pata_bk3710_ports_ops;
+	ap->pio_mask = ATA_PIO4;
+	ap->mwdma_mask = ATA_MWDMA2;
+	ap->udma_mask = rate < 100000000 ? ATA_UDMA4 : ATA_UDMA5;
+	ap->flags |= ATA_FLAG_SLAVE_POSS;
+
+	ap->ioaddr.data_addr		= base + BK3710_TF_OFFSET;
+	ap->ioaddr.error_addr		= base + BK3710_TF_OFFSET + 1;
+	ap->ioaddr.feature_addr		= base + BK3710_TF_OFFSET + 1;
+	ap->ioaddr.nsect_addr		= base + BK3710_TF_OFFSET + 2;
+	ap->ioaddr.lbal_addr		= base + BK3710_TF_OFFSET + 3;
+	ap->ioaddr.lbam_addr		= base + BK3710_TF_OFFSET + 4;
+	ap->ioaddr.lbah_addr		= base + BK3710_TF_OFFSET + 5;
+	ap->ioaddr.device_addr		= base + BK3710_TF_OFFSET + 6;
+	ap->ioaddr.status_addr		= base + BK3710_TF_OFFSET + 7;
+	ap->ioaddr.command_addr		= base + BK3710_TF_OFFSET + 7;
+
+	ap->ioaddr.altstatus_addr	= base + BK3710_CTL_OFFSET;
+	ap->ioaddr.ctl_addr		= base + BK3710_CTL_OFFSET;
+
+	ap->ioaddr.bmdma_addr		= base;
+
+	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx",
+		      (unsigned long)base + BK3710_TF_OFFSET,
+		      (unsigned long)base + BK3710_CTL_OFFSET);
+
+	/* activate */
+	return ata_host_activate(host, irq, ata_sff_interrupt, 0,
+				 &pata_bk3710_sht);
+}
+
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:palm_bk3710");
+
+static struct platform_driver pata_bk3710_driver = {
+	.driver = {
+		.name = "palm_bk3710",
+	},
+};
+
+static int __init pata_bk3710_init(void)
+{
+	return platform_driver_probe(&pata_bk3710_driver, pata_bk3710_probe);
+}
+
+module_init(pata_bk3710_init);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/ata/pata_buddha.c b/drivers/ata/pata_buddha.c
index 27d4c417fc60..49bc619b83e2 100644
--- a/drivers/ata/pata_buddha.c
+++ b/drivers/ata/pata_buddha.c
@@ -57,7 +57,7 @@ static unsigned int xsurf_bases[2] = {
 	XSURF_BASE1, XSURF_BASE2
 };
 
-static struct scsi_host_template pata_buddha_sht = {
+static const struct scsi_host_template pata_buddha_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 1a3372a72213..45a7217b136e 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -172,7 +172,7 @@ static bool cmd640_sff_irq_check(struct ata_port *ap)
 	return irq_stat & irq_mask;
 }
 
-static struct scsi_host_template cmd640_sht = {
+static const struct scsi_host_template cmd640_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 5baa4a7819c1..fafea2b79145 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -319,7 +319,7 @@ static void cmd646r1_bmdma_stop(struct ata_queued_cmd *qc)
 	ata_bmdma_stop(qc);
 }
 
-static struct scsi_host_template cmd64x_sht = {
+static const struct scsi_host_template cmd64x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index f4289a532f87..422d42761a1d 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -94,7 +94,7 @@ static void cs5520_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	cs5520_set_timings(ap, adev, adev->pio_mode);
 }
 
-static struct scsi_host_template cs5520_sht = {
+static const struct scsi_host_template cs5520_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index d5b7ac14e78f..1e67b0f8db43 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -146,7 +146,7 @@ static unsigned int cs5530_qc_issue(struct ata_queued_cmd *qc)
 	return ata_bmdma_qc_issue(qc);
 }
 
-static struct scsi_host_template cs5530_sht = {
+static const struct scsi_host_template cs5530_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize	= LIBATA_DUMB_MAX_PRD,
 	.dma_boundary	= ATA_DMA_BOUNDARY,
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index c2c3238ff84b..d793fc441b46 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -141,7 +141,7 @@ static void cs5535_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	wrmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg, 0);
 }
 
-static struct scsi_host_template cs5535_sht = {
+static const struct scsi_host_template cs5535_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index ab47aeb5587f..b811efd2cc34 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -217,7 +217,7 @@ static void cs5536_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	cs5536_write(pdev, ETC, etc);
 }
 
-static struct scsi_host_template cs5536_sht = {
+static const struct scsi_host_template cs5536_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 3be5d52a777b..ae347b5c2871 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -115,7 +115,7 @@ static void cy82c693_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	outb(0x50, 0x23);
 }
 
-static struct scsi_host_template cy82c693_sht = {
+static const struct scsi_host_template cy82c693_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 21da59f35b41..2e6eccf2902f 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -234,7 +234,7 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	spin_unlock_irqrestore(&efar_lock, flags);
 }
 
-static struct scsi_host_template efar_sht = {
+static const struct scsi_host_template efar_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index 47845d920075..c6e043e05d43 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -872,7 +872,7 @@ static int ep93xx_pata_port_start(struct ata_port *ap)
 	return 0;
 }
 
-static struct scsi_host_template ep93xx_pata_sht = {
+static const struct scsi_host_template ep93xx_pata_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	/* ep93xx dma implementation limit */
 	.sg_tablesize		= 32,
diff --git a/drivers/ata/pata_falcon.c b/drivers/ata/pata_falcon.c
index 823c88622e34..996516e64f13 100644
--- a/drivers/ata/pata_falcon.c
+++ b/drivers/ata/pata_falcon.c
@@ -33,7 +33,7 @@
 #define DRV_NAME "pata_falcon"
 #define DRV_VERSION "0.1.0"
 
-static struct scsi_host_template pata_falcon_sht = {
+static const struct scsi_host_template pata_falcon_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_ftide010.c b/drivers/ata/pata_ftide010.c
index 88924b5daa1a..6f6734c09b11 100644
--- a/drivers/ata/pata_ftide010.c
+++ b/drivers/ata/pata_ftide010.c
@@ -84,7 +84,7 @@ struct ftide010 {
 #define FTIDE010_CLK_MOD_DEV0_UDMA_EN	BIT(4)
 #define FTIDE010_CLK_MOD_DEV1_UDMA_EN	BIT(5)
 
-static struct scsi_host_template pata_ftide010_sht = {
+static const struct scsi_host_template pata_ftide010_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_gayle.c b/drivers/ata/pata_gayle.c
index 65bc9f3042ce..e5aa07f92106 100644
--- a/drivers/ata/pata_gayle.c
+++ b/drivers/ata/pata_gayle.c
@@ -35,7 +35,7 @@
 
 #define GAYLE_CONTROL	0x101a
 
-static struct scsi_host_template pata_gayle_sht = {
+static const struct scsi_host_template pata_gayle_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 7e441fb304d3..bdccd1ba1524 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -312,7 +312,7 @@ static int hpt366_prereset(struct ata_link *link, unsigned long deadline)
 	return ata_sff_prereset(link, deadline);
 }
 
-static struct scsi_host_template hpt36x_sht = {
+static const struct scsi_host_template hpt36x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index ce3c5eaa7e76..c0329cf01135 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -526,7 +526,7 @@ static void hpt37x_bmdma_stop(struct ata_queued_cmd *qc)
 }
 
 
-static struct scsi_host_template hpt37x_sht = {
+static const struct scsi_host_template hpt37x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 617c95522f43..5b1ecccf3c83 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -337,7 +337,7 @@ static unsigned int hpt3x2n_qc_issue(struct ata_queued_cmd *qc)
 	return ata_bmdma_qc_issue(qc);
 }
 
-static struct scsi_host_template hpt3x2n_sht = {
+static const struct scsi_host_template hpt3x2n_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index 83974d5eb387..d65c586b5ad0 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -136,7 +136,7 @@ static int hpt3x3_atapi_dma(struct ata_queued_cmd *qc)
 
 #endif /* CONFIG_PATA_HPT3X3_DMA */
 
-static struct scsi_host_template hpt3x3_sht = {
+static const struct scsi_host_template hpt3x3_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 498383cb6e29..9cfb064782c3 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -298,7 +298,7 @@ static int icside_dma_init(struct pata_icside_info *info)
 }
 
 
-static struct scsi_host_template pata_icside_sht = {
+static const struct scsi_host_template pata_icside_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= SG_MAX_SEGMENTS,
 	.dma_boundary		= IOMD_DMA_BOUNDARY,
diff --git a/drivers/ata/pata_imx.c b/drivers/ata/pata_imx.c
index 150939275b1b..4013f28679a9 100644
--- a/drivers/ata/pata_imx.c
+++ b/drivers/ata/pata_imx.c
@@ -97,7 +97,7 @@ static void pata_imx_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	__raw_writel(val, priv->host_regs + PATA_IMX_ATA_CONTROL);
 }
 
-static struct scsi_host_template pata_imx_sht = {
+static const struct scsi_host_template pata_imx_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 43bb224430d3..25a63d043c8e 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -20,7 +20,7 @@
 #define DRV_NAME "pata_isapnp"
 #define DRV_VERSION "0.2.5"
 
-static struct scsi_host_template isapnp_sht = {
+static const struct scsi_host_template isapnp_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 8a3e8778163c..b7ac56103c8a 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -228,7 +228,7 @@ static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	pci_write_config_byte(dev, 0x48, udma_enable);
 }
 
-static struct scsi_host_template it8213_sht = {
+static const struct scsi_host_template it8213_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 8a5b4e0079ab..2fe3fb6102ce 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -800,7 +800,7 @@ static int it821x_rdc_cable(struct ata_port *ap)
 	return ATA_CBL_PATA80;
 }
 
-static struct scsi_host_template it821x_sht = {
+static const struct scsi_host_template it821x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index e225913a619d..9a2c1b6cd71f 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -173,7 +173,7 @@ static unsigned int ixp4xx_mmio_data_xfer(struct ata_queued_cmd *qc,
 	return words << 1;
 }
 
-static struct scsi_host_template ixp4xx_sht = {
+static const struct scsi_host_template ixp4xx_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index d1b3ce8958dd..f51fb8219762 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -107,7 +107,7 @@ static int jmicron_pre_reset(struct ata_link *link, unsigned long deadline)
 
 /* No PIO or DMA methods needed for this device */
 
-static struct scsi_host_template jmicron_sht = {
+static const struct scsi_host_template jmicron_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 03c580625c2c..448a511cbc17 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -250,7 +250,7 @@ static int legacy_set_mode(struct ata_link *link, struct ata_device **unused)
 	return 0;
 }
 
-static struct scsi_host_template legacy_sht = {
+static const struct scsi_host_template legacy_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 9ccaac9e2bc3..c4d86ea049f0 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -908,7 +908,7 @@ static int pata_macio_do_resume(struct pata_macio_priv *priv)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static struct scsi_host_template pata_macio_sht = {
+static const struct scsi_host_template pata_macio_sht = {
 	__ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= MAX_DCMDS,
 	/* We may not need that strict one */
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 014ccb0f45dc..8119caaad605 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -92,7 +92,7 @@ static int marvell_cable_detect(struct ata_port *ap)
 
 /* No PIO or DMA methods needed for this device */
 
-static struct scsi_host_template marvell_sht = {
+static const struct scsi_host_template marvell_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 3ebd6522a1fd..66c9dea4ea6e 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -606,7 +606,7 @@ mpc52xx_ata_task_irq(int irq, void *vpriv)
 	return IRQ_HANDLED;
 }
 
-static struct scsi_host_template mpc52xx_ata_sht = {
+static const struct scsi_host_template mpc52xx_ata_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 8fda0e32c1ab..69e4baf27d72 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -136,7 +136,7 @@ static unsigned int mpiix_qc_issue(struct ata_queued_cmd *qc)
 	return ata_sff_qc_issue(qc);
 }
 
-static struct scsi_host_template mpiix_sht = {
+static const struct scsi_host_template mpiix_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index 06929e77c491..c0b2897fcf40 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -31,7 +31,7 @@ static unsigned int netcell_read_id(struct ata_device *adev,
 	return err_mask;
 }
 
-static struct scsi_host_template netcell_sht = {
+static const struct scsi_host_template netcell_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index f9255d6fd194..76a91013d27d 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -77,7 +77,7 @@ static void ninja32_dev_select(struct ata_port *ap, unsigned int device)
 	}
 }
 
-static struct scsi_host_template ninja32_sht = {
+static const struct scsi_host_template ninja32_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index ca3ab2736fef..44cc24d21d5f 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -114,7 +114,7 @@ static unsigned int ns87410_qc_issue(struct ata_queued_cmd *qc)
 	return ata_sff_qc_issue(qc);
 }
 
-static struct scsi_host_template ns87410_sht = {
+static const struct scsi_host_template ns87410_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index 9dd6bffefb48..d60e1f69d7b0 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -320,7 +320,7 @@ static struct ata_port_operations ns87560_pata_ops = {
 };
 #endif
 
-static struct scsi_host_template ns87415_sht = {
+static const struct scsi_host_template ns87415_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 4cbcdc5da038..b1ce9f1761af 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -58,7 +58,7 @@ struct octeon_cf_port {
 	u64 dma_base;
 };
 
-static struct scsi_host_template octeon_cf_sht = {
+static const struct scsi_host_template octeon_cf_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index ac5a633c00a5..178b28eff170 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -15,7 +15,7 @@
 
 #define DRV_NAME "pata_of_platform"
 
-static struct scsi_host_template pata_platform_sht = {
+static const struct scsi_host_template pata_platform_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 22a020374410..dca82d92b004 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -204,7 +204,7 @@ static unsigned int oldpiix_qc_issue(struct ata_queued_cmd *qc)
 }
 
 
-static struct scsi_host_template oldpiix_sht = {
+static const struct scsi_host_template oldpiix_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index 01976c4e4033..3d23f57eb128 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -148,7 +148,7 @@ static void opti_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	opti_write_reg(ap, 0x85, CNTRL_REG);
 }
 
-static struct scsi_host_template opti_sht = {
+static const struct scsi_host_template opti_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index ad1090b90e52..dfc36b4ec9c6 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -334,7 +334,7 @@ static int optidma_set_mode(struct ata_link *link, struct ata_device **r_failed)
 	return rc;
 }
 
-static struct scsi_host_template optidma_sht = {
+static const struct scsi_host_template optidma_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 8eb066abbd9c..5b602206c522 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -132,7 +132,7 @@ static void pcmcia_8bit_drain_fifo(struct ata_queued_cmd *qc)
 
 }
 
-static struct scsi_host_template pcmcia_sht = {
+static const struct scsi_host_template pcmcia_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 4191aa61c8e4..6820c5597b14 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -122,7 +122,7 @@ static struct pci_driver pdc2027x_pci_driver = {
 #endif
 };
 
-static struct scsi_host_template pdc2027x_sht = {
+static const struct scsi_host_template pdc2027x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index f894ff2de0a9..a32723e46357 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -289,7 +289,7 @@ static int pdc2026x_check_atapi_dma(struct ata_queued_cmd *qc)
 	return 1;
 }
 
-static struct scsi_host_template pdc202xx_sht = {
+static const struct scsi_host_template pdc202xx_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_piccolo.c b/drivers/ata/pata_piccolo.c
index 389b63b13c70..ced906bf56be 100644
--- a/drivers/ata/pata_piccolo.c
+++ b/drivers/ata/pata_piccolo.c
@@ -62,7 +62,7 @@ static void tosh_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 }
 
 
-static struct scsi_host_template tosh_sht = {
+static const struct scsi_host_template tosh_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 21fb059859bd..87479bc893b2 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -45,7 +45,7 @@ static int pata_platform_set_mode(struct ata_link *link, struct ata_device **unu
 	return 0;
 }
 
-static struct scsi_host_template pata_platform_sht = {
+static const struct scsi_host_template pata_platform_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
@@ -97,7 +97,7 @@ static void pata_platform_setup_port(struct ata_ioports *ioaddr,
 int __pata_platform_probe(struct device *dev, struct resource *io_res,
 			  struct resource *ctl_res, struct resource *irq_res,
 			  unsigned int ioport_shift, int __pio_mask,
-			  struct scsi_host_template *sht, bool use16bit)
+			  const struct scsi_host_template *sht, bool use16bit)
 {
 	struct ata_host *host;
 	struct ata_port *ap;
diff --git a/drivers/ata/pata_pxa.c b/drivers/ata/pata_pxa.c
index 985f42c4fd70..ea402e02c46e 100644
--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -136,7 +136,7 @@ static int pxa_check_atapi_dma(struct ata_queued_cmd *qc)
 	return -EOPNOTSUPP;
 }
 
-static struct scsi_host_template pxa_ata_sht = {
+static const struct scsi_host_template pxa_ata_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 3aca8fe3fdb6..84b001097093 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -183,7 +183,7 @@ static unsigned int radisys_qc_issue(struct ata_queued_cmd *qc)
 }
 
 
-static struct scsi_host_template radisys_sht = {
+static const struct scsi_host_template radisys_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index 2e110aefe59b..3974d294a341 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -73,7 +73,7 @@ static struct ata_port_operations rb532_pata_port_ops = {
 
 /* ------------------------------------------------------------------------ */
 
-static struct scsi_host_template rb532_pata_sht = {
+static const struct scsi_host_template rb532_pata_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index ecb229c2c1a2..0a9689862f71 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -288,7 +288,7 @@ static const struct ata_port_info rdc_port_info = {
 	.port_ops	= &rdc_pata_ops,
 };
 
-static struct scsi_host_template rdc_sht = {
+static const struct scsi_host_template rdc_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index fb00c3e5fd19..8e2606793091 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -50,7 +50,7 @@ static int rz1000_set_mode(struct ata_link *link, struct ata_device **unused)
 }
 
 
-static struct scsi_host_template rz1000_sht = {
+static const struct scsi_host_template rz1000_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index f28daf62a37d..a388dfb97ad8 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -192,7 +192,7 @@ static int sc1200_qc_defer(struct ata_queued_cmd *qc)
 	return 0;
 }
 
-static struct scsi_host_template sc1200_sht = {
+static const struct scsi_host_template sc1200_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize	= LIBATA_DUMB_MAX_PRD,
 	.dma_boundary	= ATA_DMA_BOUNDARY,
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index 4f9c2aefd807..8356f1f2a025 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -57,7 +57,7 @@ static struct pci_driver sch_pci_driver = {
 #endif
 };
 
-static struct scsi_host_template sch_sht = {
+static const struct scsi_host_template sch_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index c0bc4af0d196..549ff24a9823 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -252,13 +252,13 @@ static void serverworks_set_dmamode(struct ata_port *ap, struct ata_device *adev
 	pci_write_config_byte(pdev, 0x54, ultra_cfg);
 }
 
-static struct scsi_host_template serverworks_osb4_sht = {
+static const struct scsi_host_template serverworks_osb4_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize	= LIBATA_DUMB_MAX_PRD,
 	.dma_boundary	= ATA_DMA_BOUNDARY,
 };
 
-static struct scsi_host_template serverworks_csb_sht = {
+static const struct scsi_host_template serverworks_csb_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
@@ -413,7 +413,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 		}
 	};
 	const struct ata_port_info *ppi[] = { &info[id->driver_data], NULL };
-	struct scsi_host_template *sht = &serverworks_csb_sht;
+	const struct scsi_host_template *sht = &serverworks_csb_sht;
 	int rc;
 
 	rc = pcim_enable_device(pdev);
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 67ef2e26d7df..abe64b5f83cf 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -223,7 +223,7 @@ static bool sil680_sff_irq_check(struct ata_port *ap)
 	return val & 0x08;
 }
 
-static struct scsi_host_template sil680_sht = {
+static const struct scsi_host_template sil680_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 92e4cf05de2c..31de06b66221 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -539,7 +539,7 @@ static unsigned int sis_133_mode_filter(struct ata_device *adev, unsigned int ma
 	return mask;
 }
 
-static struct scsi_host_template sis_sht = {
+static const struct scsi_host_template sis_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 8487470e2e01..3b62ea482f1a 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -238,7 +238,7 @@ static bool sl82c105_sff_irq_check(struct ata_port *ap)
 	return val & mask;
 }
 
-static struct scsi_host_template sl82c105_sht = {
+static const struct scsi_host_template sl82c105_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index 782162d2f3f8..26d448a869e2 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -160,7 +160,7 @@ static void triflex_bmdma_stop(struct ata_queued_cmd *qc)
 	triflex_load_timing(qc->ap, qc->dev, qc->dev->pio_mode);
 }
 
-static struct scsi_host_template triflex_sht = {
+static const struct scsi_host_template triflex_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 34f00f389932..696b99720dcb 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -443,7 +443,7 @@ static int via_port_start(struct ata_port *ap)
 	return 0;
 }
 
-static struct scsi_host_template via_sht = {
+static const struct scsi_host_template via_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 35b823ac20c9..8e6b2599f0d5 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -123,7 +123,7 @@ static void adma_freeze(struct ata_port *ap);
 static void adma_thaw(struct ata_port *ap);
 static int adma_prereset(struct ata_link *link, unsigned long deadline);
 
-static struct scsi_host_template adma_ata_sht = {
+static const struct scsi_host_template adma_ata_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.dma_boundary		= ADMA_DMA_BOUNDARY,
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 21d77633a98f..24334a8a3f0b 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1076,7 +1076,7 @@ static void sata_dwc_dev_select(struct ata_port *ap, unsigned int device)
 /*
  * scsi mid-layer and libata interface structures
  */
-static struct scsi_host_template sata_dwc_sht = {
+static const struct scsi_host_template sata_dwc_sht = {
 	ATA_NCQ_SHT(DRV_NAME),
 	/*
 	 * test-only: Currently this driver doesn't handle NCQ
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index b052c5a65c17..ccd99b9aa9ff 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1376,7 +1376,7 @@ static void sata_fsl_host_stop(struct ata_host *host)
 /*
  * scsi mid-layer and libata interface structures
  */
-static struct scsi_host_template sata_fsl_sht = {
+static const struct scsi_host_template sata_fsl_sht = {
 	ATA_NCQ_SHT_QD("sata_fsl", SATA_FSL_QUEUE_DEPTH),
 	.sg_tablesize = SATA_FSL_MAX_PRD_USABLE,
 	.dma_boundary = ATA_DMA_BOUNDARY,
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index dfbf9493e451..8237ece4a46f 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -438,7 +438,7 @@ static const struct ata_port_info ahci_highbank_port_info = {
 	.port_ops       = &ahci_highbank_ops,
 };
 
-static struct scsi_host_template ahci_highbank_platform_sht = {
+static const struct scsi_host_template ahci_highbank_platform_sht = {
 	AHCI_SHT("sata_highbank"),
 };
 
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 2833c722118d..2c8c78ed86c1 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -242,7 +242,7 @@ struct inic_port_priv {
 	dma_addr_t	cpb_tbl_dma;
 };
 
-static struct scsi_host_template inic_sht = {
+static const struct scsi_host_template inic_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= LIBATA_MAX_PRD, /* maybe it can be larger? */
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index e3cff01201b8..d404e631d152 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -659,13 +659,13 @@ static u8 mv_sff_check_status(struct ata_port *ap);
  * PRDs for 64K boundaries in mv_fill_sg().
  */
 #ifdef CONFIG_PCI
-static struct scsi_host_template mv5_sht = {
+static const struct scsi_host_template mv5_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= MV_MAX_SG_CT / 2,
 	.dma_boundary		= MV_DMA_BOUNDARY,
 };
 #endif
-static struct scsi_host_template mv6_sht = {
+static const struct scsi_host_template mv6_sht = {
 	__ATA_BASE_SHT(DRV_NAME),
 	.can_queue		= MV_MAX_Q_DEPTH - 1,
 	.sg_tablesize		= MV_MAX_SG_CT / 2,
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 9b2d289e89e1..abf5651c87ab 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -371,11 +371,11 @@ static struct pci_driver nv_pci_driver = {
 	.remove			= ata_pci_remove_one,
 };
 
-static struct scsi_host_template nv_sht = {
+static const struct scsi_host_template nv_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
-static struct scsi_host_template nv_adma_sht = {
+static const struct scsi_host_template nv_adma_sht = {
 	__ATA_BASE_SHT(DRV_NAME),
 	.can_queue		= NV_ADMA_MAX_CPBS,
 	.sg_tablesize		= NV_ADMA_SGTBL_TOTAL_LEN,
@@ -386,7 +386,7 @@ static struct scsi_host_template nv_adma_sht = {
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 };
 
-static struct scsi_host_template nv_swncq_sht = {
+static const struct scsi_host_template nv_swncq_sht = {
 	__ATA_BASE_SHT(DRV_NAME),
 	.can_queue		= ATA_MAX_QUEUE - 1,
 	.sg_tablesize		= LIBATA_MAX_PRD,
@@ -520,7 +520,7 @@ static struct ata_port_operations nv_swncq_ops = {
 
 struct nv_pi_priv {
 	irq_handler_t			irq_handler;
-	struct scsi_host_template	*sht;
+	const struct scsi_host_template	*sht;
 };
 
 #define NV_PI_PRIV(_irq_handler, _sht) \
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 4e60e6c4c35a..2df1a070b25a 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -158,7 +158,7 @@ static void pdc_error_handler(struct ata_port *ap);
 static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
 static int pdc_pata_cable_detect(struct ata_port *ap);
 
-static struct scsi_host_template pdc_ata_sht = {
+static const struct scsi_host_template pdc_ata_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= PDC_MAX_PRD,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 8ca0810aad26..8a6286159044 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -108,7 +108,7 @@ static void qs_thaw(struct ata_port *ap);
 static int qs_prereset(struct ata_link *link, unsigned long deadline);
 static void qs_error_handler(struct ata_port *ap);
 
-static struct scsi_host_template qs_ata_sht = {
+static const struct scsi_host_template qs_ata_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= QS_MAX_PRD,
 	.dma_boundary		= QS_DMA_BOUNDARY,
diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
index 0195eb29f6c2..34790f15c1b8 100644
--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -608,7 +608,7 @@ static u8 sata_rcar_bmdma_status(struct ata_port *ap)
 	return host_stat;
 }
 
-static struct scsi_host_template sata_rcar_sht = {
+static const struct scsi_host_template sata_rcar_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	/*
 	 * This controller allows transfer chunks up to 512MB which cross 64KB
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 3b989a52879d..cc77c0248284 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -156,7 +156,7 @@ static struct pci_driver sil_pci_driver = {
 #endif
 };
 
-static struct scsi_host_template sil_sht = {
+static const struct scsi_host_template sil_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	/** These controllers support Large Block Transfer which allows
 	    transfer chunks up to 2GB and which cross 64KB boundaries,
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 22cc9e9789dd..e72a0257990d 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -373,7 +373,7 @@ static struct pci_driver sil24_pci_driver = {
 #endif
 };
 
-static struct scsi_host_template sil24_sht = {
+static const struct scsi_host_template sil24_sht = {
 	__ATA_BASE_SHT(DRV_NAME),
 	.can_queue		= SIL24_MAX_CMDS,
 	.sg_tablesize		= SIL24_MAX_SGE,
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 316237362aa9..ef8724986de3 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -72,7 +72,7 @@ static struct pci_driver sis_pci_driver = {
 #endif
 };
 
-static struct scsi_host_template sis_sht = {
+static const struct scsi_host_template sis_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 2e3418a82b44..c47c3fb434d5 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -330,7 +330,7 @@ static int k2_sata_show_info(struct seq_file *m, struct Scsi_Host *shost)
 	return 0;
 }
 
-static struct scsi_host_template k2_sata_sht = {
+static const struct scsi_host_template k2_sata_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 	.show_info		= k2_sata_show_info,
 };
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index a92c60455b1d..ccc016072637 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -226,7 +226,7 @@ static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
 static int pdc_check_atapi_dma(struct ata_queued_cmd *qc);
 
 
-static struct scsi_host_template pdc_sata_sht = {
+static const struct scsi_host_template pdc_sata_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 815e6af75310..60ea45926cd1 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -59,7 +59,7 @@ static struct pci_driver uli_pci_driver = {
 	.remove			= ata_pci_remove_one,
 };
 
-static struct scsi_host_template uli_sht = {
+static const struct scsi_host_template uli_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index c7891cc84ea0..57cbf2cef618 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -107,7 +107,7 @@ static struct pci_driver svia_pci_driver = {
 	.remove			= ata_pci_remove_one,
 };
 
-static struct scsi_host_template svia_sht = {
+static const struct scsi_host_template svia_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 87e4ed66b306..d39b87537168 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -277,7 +277,7 @@ static irqreturn_t vsc_sata_interrupt(int irq, void *dev_instance)
 }
 
 
-static struct scsi_host_template vsc_sata_sht = {
+static const struct scsi_host_template vsc_sata_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
index 17fa26215292..fe0760ce34c8 100644
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -37,7 +37,7 @@ struct ahci_host_priv *ahci_platform_get_resources(
 int ahci_platform_init_host(struct platform_device *pdev,
 			    struct ahci_host_priv *hpriv,
 			    const struct ata_port_info *pi_template,
-			    struct scsi_host_template *sht);
+			    const struct scsi_host_template *sht);
 
 void ahci_platform_shutdown(struct platform_device *pdev);
 
diff --git a/include/linux/ata_platform.h b/include/linux/ata_platform.h
index 9cafec92282d..b9745cc08e38 100644
--- a/include/linux/ata_platform.h
+++ b/include/linux/ata_platform.h
@@ -19,7 +19,7 @@ extern int __pata_platform_probe(struct device *dev,
 				 struct resource *irq_res,
 				 unsigned int ioport_shift,
 				 int __pio_mask,
-				 struct scsi_host_template *sht,
+				 const struct scsi_host_template *sht,
 				 bool use16bit);
 
 /*
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a759dfbdcc91..311cd93377c7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1065,10 +1065,10 @@ extern void ata_host_get(struct ata_host *host);
 extern void ata_host_put(struct ata_host *host);
 extern int ata_host_start(struct ata_host *host);
 extern int ata_host_register(struct ata_host *host,
-			     struct scsi_host_template *sht);
+			     const struct scsi_host_template *sht);
 extern int ata_host_activate(struct ata_host *host, int irq,
 			     irq_handler_t irq_handler, unsigned long irq_flags,
-			     struct scsi_host_template *sht);
+			     const struct scsi_host_template *sht);
 extern void ata_host_detach(struct ata_host *host);
 extern void ata_host_init(struct ata_host *, struct device *, struct ata_port_operations *);
 extern int ata_scsi_detect(struct scsi_host_template *sht);
@@ -1980,10 +1980,10 @@ extern int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 				    struct ata_host **r_host);
 extern int ata_pci_sff_activate_host(struct ata_host *host,
 				     irq_handler_t irq_handler,
-				     struct scsi_host_template *sht);
+				     const struct scsi_host_template *sht);
 extern int ata_pci_sff_init_one(struct pci_dev *pdev,
 		const struct ata_port_info * const * ppi,
-		struct scsi_host_template *sht, void *host_priv, int hflags);
+		const struct scsi_host_template *sht, void *host_priv, int hflags);
 #endif /* CONFIG_PCI */
 
 #ifdef CONFIG_ATA_BMDMA
@@ -2019,7 +2019,7 @@ extern int ata_pci_bmdma_prepare_host(struct pci_dev *pdev,
 				      struct ata_host **r_host);
 extern int ata_pci_bmdma_init_one(struct pci_dev *pdev,
 				  const struct ata_port_info * const * ppi,
-				  struct scsi_host_template *sht,
+				  const struct scsi_host_template *sht,
 				  void *host_priv, int hflags);
 #endif /* CONFIG_PCI */
 #endif /* CONFIG_ATA_BMDMA */
