Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4B3C001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 00:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjGTAra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 20:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjGTAr3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 20:47:29 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469282100;
        Wed, 19 Jul 2023 17:47:27 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f954d7309fso381137e87.1;
        Wed, 19 Jul 2023 17:47:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689814045; x=1690418845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AnakjjiCvwFGg3Kp+5aoPO6lH+gF2137H/wko1LBoi8=;
        b=FfOvu4tNmVcX545f6eOFU709B8eGqIaKT/YEqSHRSqsy3zc39c/+K3eoVfGiE5bCUe
         1jlgYYx4z1zeGmGqJfLZlkQUSgKmCke6E3TRecKdk801loWaywYsoG7KBw0inXje0Ex4
         zGSnTK4ShUUKiWSHrZXHnyyEaZf7qeB3tkKN+Pg9Ej3afRhraViiCnoucHUuuejFgJ3k
         6bTuaboj5AxLE2FLzaytUtfq4LMuXtWanNdimYD+gdK09w3cjbB1JoCiEgjarr7nV1Jy
         ZvkbdBwbdPT2mrB80MVumIcyU/v1zoMCtFwhin3cDCTuFq9+LRVMrR2CTnG6gg45Weg1
         g5TA==
X-Gm-Message-State: ABy/qLZSGoHM11n9LXJNtValBEGzUcyzUibnxOhUKEVpQLXd+vBF4QSl
        2jy07hdWOIVxJDIUmfuNFxMKUch6Qa/YF5Us
X-Google-Smtp-Source: APBJJlEd5yP+M9sZnfH6q+wtH+V9+8rZhVJ5O1KnmdNg9A+/f9a5fuNMm1xV4kW5nbZjfYRgrEsf5Q==
X-Received: by 2002:a05:6512:754:b0:4f8:1e2a:1de1 with SMTP id c20-20020a056512075400b004f81e2a1de1mr387915lfs.29.1689814045446;
        Wed, 19 Jul 2023 17:47:25 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id a10-20020a056512020a00b004fdc7543ab9sm1178552lfo.229.2023.07.19.17.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 17:47:25 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 5BC953EF2; Thu, 20 Jul 2023 02:47:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689814044; bh=kctZLnduc1ey1L2S7SMv8ZYO5WBhHnUV5gxPYW/gxPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkAUuXDXILrzvfJd4TBuMB35GhLkVY6zP+5sQk/ugWN4+i/Ox/q4wrZYCdbp/DTCC
         W8pcwhiuOXFPYdQEdD6c7Ow4hOnWavBrNglzxMsYrsp8jOO24ZNDXPjJIr8WkWbdzE
         YeezfSOrWD3/XMeK9EJW5mDfH5yiPbmLu/hmCPwg=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 31D0C3F0A;
        Thu, 20 Jul 2023 02:44:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813855; bh=kctZLnduc1ey1L2S7SMv8ZYO5WBhHnUV5gxPYW/gxPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDnDEOrp1BjYk8y4N15dyLJCMbx9b3Mw7lCdzhKT31PXnGvFEiy54aD4lLJXk1vTa
         CIg8lIOYmaRXLmjQDlAjTJ0elhGsrlyrQpCDvawKnhWAWLlRuV6xDOjuXNrGCOsEjH
         spOL82VF9GmuJygrWCYsJ9zu3pKNgV+7hMn+0ttw=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 6/8] ata,scsi: cleanup ata_port_probe()
Date:   Thu, 20 Jul 2023 02:42:47 +0200
Message-ID: <20230720004257.307031-7-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720004257.307031-1-nks@flawful.org>
References: <20230720004257.307031-1-nks@flawful.org>
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
index 86490718cd0d..458cb24958ca 100644
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

