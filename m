Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB26C41513
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjGaOjA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjGaOi6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:38:58 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A3498;
        Mon, 31 Jul 2023 07:38:56 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4fe216edaf7so3687330e87.0;
        Mon, 31 Jul 2023 07:38:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690814334; x=1691419134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R9onvB4rgsW2JTUwB2kecOd0Elw2sgVRtptyLBBDeaI=;
        b=VF+S5Q0vrT8+MzPGE5D6aWK0lizcl4Grkjj02z7zreL6imnkaukNodI9aY19SIBbnr
         gBxf9kUCqZrg4VI7yItwa6pH3YT245+6Le/D30ipkbr4eaWv8JHfqXanrxu0HwwODcI4
         yLXEp6pQ0WcMj3KF8GOeFx+7GrSumsQznxx7b3wLr+E47Zbi/wWPv3Rfe3bnITbbiXGK
         +d8yXa6tQfz/5AtSoufGUY2xeOIKgRoKcHbv5PEJkLmbwjRytLFdhi3wf5cNy2K2PEzR
         CIhh53pZStz4HbVNW4v1ilkGAEaUq3caFmxVR7mqn2uFBTUbPJKkLZ0Ollbc1AM3IpTg
         FtUQ==
X-Gm-Message-State: ABy/qLYnsFjVF01bjgSKHIl3e0koDKCS7fraerqdKW8lqhb5lQdgGFr+
        YHuGSmqy9YZzBt1hly84tziFfcRLnEdFdw==
X-Google-Smtp-Source: APBJJlGIZYgB5oGJvBSHuUvb0lOYVUYQBbiFpVhBXUS8Q4fvLquX7VCu9yadmvgPh9DUdR0HAWXyGQ==
X-Received: by 2002:a19:da11:0:b0:4f4:a656:2466 with SMTP id r17-20020a19da11000000b004f4a6562466mr7569lfg.15.1690814334379;
        Mon, 31 Jul 2023 07:38:54 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id a24-20020ac25218000000b004fde7ef2435sm2116555lfl.102.2023.07.31.07.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:38:54 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 3AC993F6E; Mon, 31 Jul 2023 16:38:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814333; bh=gEMJhh3YgEvucIdNEAwwpc/0r99iipK891nh+tiop/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMiF90dOdQm6/Fx1gmLlsZ0x/La569WuMC8kOJnbjGV60V71YI+hYRTLRFsgqBhOL
         6X006gCtMPVjqRTvhchZr7BmYh+mZb7MGwzznEWpwUPtyxtU26uB+MPqwQJaBoO3pM
         +n5+dUzqVwwV++TNQbX1mMBiBEtfQ5bg2ffIau4o=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id EBAA74A11;
        Mon, 31 Jul 2023 16:34:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814100; bh=gEMJhh3YgEvucIdNEAwwpc/0r99iipK891nh+tiop/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBTrZkPh8/di73mhXBlL8WnOo6AzeMWPDxuNH51LxyiPQKDsJVhBa2W3hAepa83qp
         taxsF/xkOG1yRZK4Bokbdpvjx+5b58NAWOYf/h837IZ2LDStDtBKb678rYbisTzC/i
         lD6SDyQnQv3AEwqsZc8qePebqvqAE73GzS5D9+yw=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 06/10] ata,scsi: cleanup __ata_port_probe()
Date:   Mon, 31 Jul 2023 16:34:17 +0200
Message-ID: <20230731143432.58886-7-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731143432.58886-1-nks@flawful.org>
References: <20230731143432.58886-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Rename __ata_port_probe() to ata_port_probe() and drop the wrapper
ata_sas_async_probe().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/ata/libata-core.c             |  5 +++--
 drivers/ata/libata-sata.c             | 13 -------------
 drivers/ata/libata.h                  |  2 --
 drivers/scsi/hisi_sas/hisi_sas_main.c |  2 +-
 drivers/scsi/libsas/sas_ata.c         |  2 +-
 include/linux/libata.h                |  2 +-
 6 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0cd10c44a7b1..25a228350c75 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5865,7 +5865,7 @@ void ata_host_init(struct ata_host *host, struct device *dev,
 }
 EXPORT_SYMBOL_GPL(ata_host_init);
 
-void __ata_port_probe(struct ata_port *ap)
+void ata_port_probe(struct ata_port *ap)
 {
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	unsigned long flags;
@@ -5883,6 +5883,7 @@ void __ata_port_probe(struct ata_port *ap)
 
 	spin_unlock_irqrestore(ap->lock, flags);
 }
+EXPORT_SYMBOL_GPL(ata_port_probe);
 
 static void async_port_probe(void *data, async_cookie_t cookie)
 {
@@ -5898,7 +5899,7 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN) && ap->port_no != 0)
 		async_synchronize_cookie(cookie);
 
-	__ata_port_probe(ap);
+	ata_port_probe(ap);
 	ata_port_wait_eh(ap);
 
 	/* in order to keep device order, we need to synchronize at this point */
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 23252ebe312d..c0253adbf47c 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1144,19 +1144,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
 
-/**
- * ata_sas_async_probe - simply schedule probing and return
- * @ap: Port to probe
- *
- * For batch scheduling of probe for sas attached ata devices, assumes
- * the port has already been through ata_sas_port_init()
- */
-void ata_sas_async_probe(struct ata_port *ap)
-{
-	__ata_port_probe(ap);
-}
-EXPORT_SYMBOL_GPL(ata_sas_async_probe);
-
 /**
  *	ata_sas_port_init - Initialize a SATA device
  *	@ap: SATA port to initialize
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index cf993885d2b2..1ec9b4427b84 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -78,8 +78,6 @@ extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern const char *sata_spd_string(unsigned int spd);
-extern int ata_port_probe(struct ata_port *ap);
-extern void __ata_port_probe(struct ata_port *ap);
 extern unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
 				      u8 page, void *buf, unsigned int sectors);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 8f22ece957bd..b2f07c6f30e7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -787,7 +787,7 @@ static int hisi_sas_init_device(struct domain_device *device)
 		 * However we don't need to issue a hard reset here for these
 		 * reasons:
 		 * a. When probing the device, libsas/libata already issues a
-		 * hard reset in sas_probe_sata() -> ata_sas_async_probe().
+		 * hard reset in sas_probe_sata() -> ata_port_probe().
 		 * Note that in hisi_sas_debug_I_T_nexus_reset() we take care
 		 * to issue a hard reset by checking the dev status (== INIT).
 		 * b. When resetting the controller, this is simply unnecessary.
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index a2eb9a2191c0..d6bb37b3974a 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -653,7 +653,7 @@ void sas_probe_sata(struct asd_sas_port *port)
 		if (!dev_is_sata(dev))
 			continue;
 
-		ata_sas_async_probe(dev->sata_dev.ap);
+		ata_port_probe(dev->sata_dev.ap);
 	}
 	mutex_unlock(&port->ha->disco_mutex);
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 8e219c486a90..67e34948eac8 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1240,7 +1240,7 @@ extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 extern int ata_slave_link_init(struct ata_port *ap);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
-extern void ata_sas_async_probe(struct ata_port *ap);
+extern void ata_port_probe(struct ata_port *ap);
 extern int ata_sas_port_init(struct ata_port *);
 extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_sas_tport_delete(struct ata_port *ap);
-- 
2.41.0

