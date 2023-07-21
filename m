Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0443C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbjGUQiT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbjGUQh6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:37:58 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5114683;
        Fri, 21 Jul 2023 09:36:34 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4f9fdb0ef35so3513685e87.0;
        Fri, 21 Jul 2023 09:36:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957391; x=1690562191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Am6EnJsGjwrKxSv1ESoUp2ZBSdU9JoM0AAWS2qpIZs=;
        b=RMcs6TYX1h1AI/8R3e/860w6zqJPAuEzLEAbe4xH07RtVBi37cRmPHppJ/+XDmZgAN
         ZZ+4y48bR9ETHpnMBIXGpRD9O/RjkIUtqc/xQJMpY5YIIA/OwKCxvWiVGC6xesb0CZRJ
         ZBnEay2wUR9WY7Y/RzL63b1fMv62DWEitze9aTJ81ZzZQ4fUVHY4aRYl678dnRjkoIDJ
         Nx6zeJaVVlcipTdCTlWeQG0iRB30PF80VPXX7Fs8Z32Zgtv/FkjWK7c5Tp5PxG0yxsES
         zcvc7pvRRMa+J76NOK0eM+h6Yqjy6Nbb8DjH+jQutnEPFJ03ilMTH19ZV70YlJyN8HAT
         L67w==
X-Gm-Message-State: ABy/qLZQjhczECWC3PoWf/g+tTHYE0YziFLL+gZ7y/6gIokypj+GWC5J
        gLh3FlfV8vr2AVcDkqcoFveeIyUYUjYkQg==
X-Google-Smtp-Source: APBJJlFeoq6htxFDlT+k8c9u8CYqKWqhMcrCHeYcNq5wbVy+fhFw5XbDolHLHTgh8kPNj3eGbCPH5Q==
X-Received: by 2002:a05:6512:ac2:b0:4f8:7734:8dd0 with SMTP id n2-20020a0565120ac200b004f877348dd0mr1983040lfu.2.1689957390856;
        Fri, 21 Jul 2023 09:36:30 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id b6-20020ac25e86000000b004fb759964a9sm787907lfq.168.2023.07.21.09.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:36:30 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id B8FD93F2E; Fri, 21 Jul 2023 18:36:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957389; bh=NFnoFUore0bdFTgqluQ1UQEwtt7CmjvgzUHsnUxEVMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOVTySCoofUtzOjgoJSvmGCS+ANp5n0pdVa9y5/iG9QC72vxhtCKb71EY9O13uUyd
         Y6ANhFv9/vzae8Nz4Yijgta3pAv1D9vPa235P1jTHNE8ua4yQgxrb0Pr/0qSYsYeE1
         LWEa8CPhKU8FH9DDiqTXbZXuz8f2/rcqEmu8Ymqg=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 3773D3F49;
        Fri, 21 Jul 2023 18:32:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957175; bh=NFnoFUore0bdFTgqluQ1UQEwtt7CmjvgzUHsnUxEVMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abMRM8eIJsMiizW34mwOhOkt6heGMc61edrpOJ8PvrLHs6J+zEHsF+0JQ/S6GtS7/
         qTl1L/XztzIFAhOwmK03JjxC375SwgZoo0NAuiUDL2QCHOI7d2wTiUBdEVBKeTW609
         ITHDYEhKFt1AAPIi6T7HtG8ytqpWniFVQZ9KX73M=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 6/9] ata,scsi: cleanup __ata_port_probe()
Date:   Fri, 21 Jul 2023 18:32:17 +0200
Message-ID: <20230721163229.399676-7-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721163229.399676-1-nks@flawful.org>
References: <20230721163229.399676-1-nks@flawful.org>
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
---
 drivers/ata/libata-core.c     |  5 +++--
 drivers/ata/libata-sata.c     | 13 -------------
 drivers/ata/libata.h          |  2 --
 drivers/scsi/libsas/sas_ata.c |  2 +-
 include/linux/libata.h        |  2 +-
 5 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c5e93e1a560d..dedae669c9da 100644
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

