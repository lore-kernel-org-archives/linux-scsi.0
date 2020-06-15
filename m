Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E8EC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85A542067B
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 06:46:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uZgAo0iG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgFOGqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 02:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgFOGqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 02:46:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CD0C03E97C;
        Sun, 14 Jun 2020 23:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cqXSPP4zZpW5SVurE/Ck5YyoT09UupiEIInhvdxSYjI=; b=uZgAo0iG2h1g1JlhHAyw366H0G
        A99kmrM0U+ZJWvqhSPhM0Uvokz2CoWKMmZMKKNMilotlYnlTKeT5VtSATYf3g5d6OFe8PGMXyKDY7
        XA6pLFMn96PMBY6hrCWtRmey9NWMITwcrIxRlsD6QdMaBDWDlorp4KJic7iL6Hxw2mly1EBmDJZ1a
        nRkro3I54qzBizXlH1Bv2CLTbfR1jdOVIImU+mI/90CnrHGwZtPnl01VF3/gPuoEZHNQV/C/HguUi
        +Y6ay6Rwj+//WsBcpRTo313CDjuPss6f1+YET1uR+GBQSd2WAtUgCDuMBCd7oT7LbEecxJ3kCUPW0
        NB4m/4Kw==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jkit6-0001WL-Rs; Mon, 15 Jun 2020 06:46:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     brking@us.ibm.com, jinpu.wang@cloud.ionos.com,
        John Garry <john.garry@huawei.com>, mpe@ellerman.id.au,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 2/2] scsi: wire up ata_scsi_dma_need_drain for SAS HBA drivers
Date:   Mon, 15 Jun 2020 08:46:24 +0200
Message-Id: <20200615064624.37317-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200615064624.37317-1-hch@lst.de>
References: <20200615064624.37317-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need ata_scsi_dma_need_drain for all drivers wired up to drive ATAPI
devices through libata.  That also includes the SAS HBA drivers in
addition to native libata HBA drivers.

Fixes: cc97923a5bcc ("block: move dma drain handling to scsi")
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Acked-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c    | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 drivers/scsi/ipr.c                     | 1 +
 drivers/scsi/isci/init.c               | 1 +
 drivers/scsi/mvsas/mv_init.c           | 1 +
 drivers/scsi/pm8001/pm8001_init.c      | 1 +
 8 files changed, 8 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index d022407e5645c7..bef47f38dd0dbc 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -40,6 +40,7 @@ static struct scsi_host_template aic94xx_sht = {
 	/* .name is initialized */
 	.name			= "aic94xx",
 	.queuecommand		= sas_queuecommand,
+	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
 	.scan_finished		= asd_scan_finished,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 2e1718f9ade218..09a7669dad4c67 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1756,6 +1756,7 @@ static struct scsi_host_template sht_v1_hw = {
 	.proc_name		= DRV_NAME,
 	.module			= THIS_MODULE,
 	.queuecommand		= sas_queuecommand,
+	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= hisi_sas_slave_configure,
 	.scan_finished		= hisi_sas_scan_finished,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e7e7849a4c14e2..968d3870235359 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3532,6 +3532,7 @@ static struct scsi_host_template sht_v2_hw = {
 	.proc_name		= DRV_NAME,
 	.module			= THIS_MODULE,
 	.queuecommand		= sas_queuecommand,
+	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= hisi_sas_slave_configure,
 	.scan_finished		= hisi_sas_scan_finished,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3e6b78a1f993b9..55e2321a65bc5f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3075,6 +3075,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.proc_name		= DRV_NAME,
 	.module			= THIS_MODULE,
 	.queuecommand		= sas_queuecommand,
+	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= hisi_sas_slave_configure,
 	.scan_finished		= hisi_sas_scan_finished,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 7d77997d26d457..7d86f4ca266c86 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6731,6 +6731,7 @@ static struct scsi_host_template driver_template = {
 	.compat_ioctl = ipr_ioctl,
 #endif
 	.queuecommand = ipr_queuecommand,
+	.dma_need_drain = ata_scsi_dma_need_drain,
 	.eh_abort_handler = ipr_eh_abort,
 	.eh_device_reset_handler = ipr_eh_dev_reset,
 	.eh_host_reset_handler = ipr_eh_host_reset,
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 974c3b9116d5ba..085e285f427d93 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -153,6 +153,7 @@ static struct scsi_host_template isci_sht = {
 	.name				= DRV_NAME,
 	.proc_name			= DRV_NAME,
 	.queuecommand			= sas_queuecommand,
+	.dma_need_drain			= ata_scsi_dma_need_drain,
 	.target_alloc			= sas_target_alloc,
 	.slave_configure		= sas_slave_configure,
 	.scan_finished			= isci_host_scan_finished,
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 5973eed9493820..b0de3bdb01db06 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -33,6 +33,7 @@ static struct scsi_host_template mvs_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
+	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
 	.scan_finished		= mvs_scan_finished,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index a8f5344fdfda2a..9e99262a2b9dd3 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -87,6 +87,7 @@ static struct scsi_host_template pm8001_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
+	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
 	.scan_finished		= pm8001_scan_finished,
-- 
2.26.2

