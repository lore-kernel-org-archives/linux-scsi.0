Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315AEC00528
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjGUQjE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjGUQii (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:38:38 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76DA49C4;
        Fri, 21 Jul 2023 09:37:05 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b974031aeaso11889551fa.0;
        Fri, 21 Jul 2023 09:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957419; x=1690562219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BmFUzhYg9DwgbTYGQceKA9/Qd3kuhRwfwxJJzP99IGo=;
        b=iPeCpOAmD150gXzedpvoU9enhvQxMneCtAHf0nLa9CSZXJfRQFYAHqKTq4zm7RegjO
         IItCO4EwIcGYD3AQ5cZJ5OwOMlJWqv6gxfu+upLVI9oGfTp4VcTcokiHHnVhEWyMYw8K
         0k6nC43fvWxUNeOwuIfYsA7NK/+jue5IyC1sncHEwGLIFm5ds7hUFwKN2ihoG+b7PI00
         H3e9gQ+VpBC3GBcr6tD+/cGJuoD2C86iMWP0sWbsy00g1U78nJI9/3FhT4w9rSehaajM
         dC1RqG2uGKV3vZGA92YRIHdAIVixmkkSH8gdxBoZnG5bJ3/UD0gy/vJ5dnOXIkA9wStG
         ploQ==
X-Gm-Message-State: ABy/qLYYebN+RXhrkUAI8iSYKLSKFy8IHynEChVNRB9vC6ENvSW8lCF5
        I6mzg8V7EtNGPcSBSXxueAFgCq25w9yn4A==
X-Google-Smtp-Source: APBJJlF8T0BRjnRq+W8kLDSrQQx/CpwdNClekfsQWixhjezUqhm8SvFhH1tfntXgoioCl2lXRUOncA==
X-Received: by 2002:a2e:7d0f:0:b0:2b7:1dd:b416 with SMTP id y15-20020a2e7d0f000000b002b701ddb416mr1981288ljc.15.1689957418610;
        Fri, 21 Jul 2023 09:36:58 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id e25-20020a2e8199000000b002b6995f38a2sm986534ljg.100.2023.07.21.09.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:36:58 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id DD47E3F2E; Fri, 21 Jul 2023 18:36:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957417; bh=ntXlQ3ufz/Tiiva14J32AE3vi9BT2WyK6txchX6V+Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kByGa4L5EikPKqaG9l3RS4ZxyuliuIY4SIsUbx6XAS355L+Mm/cfZm3DV8OdS9wz2
         HVKm98Ds0gMo+03FJym+rMC2utMfumC73/bDat2vIUpD7lVBnfFCeYla16BwLvPMKY
         nAqOWu/GFaLxxcVJBHAmSB4ohO2BfzLorPdnHGM0=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id DAD0D3F53;
        Fri, 21 Jul 2023 18:32:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957177; bh=ntXlQ3ufz/Tiiva14J32AE3vi9BT2WyK6txchX6V+Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCO0m9Hz9TyOfDD1Zrgmy3AlqMNvDy2nEaSeh9+FSwnhPer2omXWEQSFmgf+Lovpj
         R/YRlaUfgV69N6NCj/UTPqsAjWAtu7fs/8a8p6lciZlgxJJvMXF11lkUDRiUdviJ7v
         4fhZ+ko8RDGRz55vG5+jv3p8ZdGUUHnCWqsaMNg8=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH v3 8/9] ata: remove ata_bus_probe()
Date:   Fri, 21 Jul 2023 18:32:19 +0200
Message-ID: <20230721163229.399676-9-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721163229.399676-1-nks@flawful.org>
References: <20230721163229.399676-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Remove ata_bus_probe() as it is unused.

Also, remove references to ata_bus_probe and port_disable in
Documentation/driver-api/libata.rst, as neither exist anymore.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 Documentation/driver-api/libata.rst |  16 ----
 drivers/ata/libata-core.c           | 138 ----------------------------
 drivers/ata/libata.h                |   1 -
 include/linux/libata.h              |   1 -
 4 files changed, 156 deletions(-)

diff --git a/Documentation/driver-api/libata.rst b/Documentation/driver-api/libata.rst
index 311af516a3fd..eecb8b81e185 100644
--- a/Documentation/driver-api/libata.rst
+++ b/Documentation/driver-api/libata.rst
@@ -32,22 +32,6 @@ register blocks.
 :c:type:`struct ata_port_operations <ata_port_operations>`
 ----------------------------------------------------------
 
-Disable ATA port
-~~~~~~~~~~~~~~~~
-
-::
-
-    void (*port_disable) (struct ata_port *);
-
-
-Called from :c:func:`ata_bus_probe` error path, as well as when unregistering
-from the SCSI module (rmmod, hot unplug). This function should do
-whatever needs to be done to take the port out of use. In most cases,
-:c:func:`ata_port_disable` can be used as this hook.
-
-Called from :c:func:`ata_bus_probe` on a failed probe. Called from
-:c:func:`ata_scsi_release`.
-
 Post-IDENTIFY device configuration
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index dedae669c9da..0af88ef231d1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3057,144 +3057,6 @@ int ata_cable_sata(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ata_cable_sata);
 
-/**
- *	ata_bus_probe - Reset and probe ATA bus
- *	@ap: Bus to probe
- *
- *	Master ATA bus probing function.  Initiates a hardware-dependent
- *	bus reset, then attempts to identify any devices found on
- *	the bus.
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *
- *	RETURNS:
- *	Zero on success, negative errno otherwise.
- */
-
-int ata_bus_probe(struct ata_port *ap)
-{
-	unsigned int classes[ATA_MAX_DEVICES];
-	int tries[ATA_MAX_DEVICES];
-	int rc;
-	struct ata_device *dev;
-
-	ata_for_each_dev(dev, &ap->link, ALL)
-		tries[dev->devno] = ATA_PROBE_MAX_TRIES;
-
- retry:
-	ata_for_each_dev(dev, &ap->link, ALL) {
-		/* If we issue an SRST then an ATA drive (not ATAPI)
-		 * may change configuration and be in PIO0 timing. If
-		 * we do a hard reset (or are coming from power on)
-		 * this is true for ATA or ATAPI. Until we've set a
-		 * suitable controller mode we should not touch the
-		 * bus as we may be talking too fast.
-		 */
-		dev->pio_mode = XFER_PIO_0;
-		dev->dma_mode = 0xff;
-
-		/* If the controller has a pio mode setup function
-		 * then use it to set the chipset to rights. Don't
-		 * touch the DMA setup as that will be dealt with when
-		 * configuring devices.
-		 */
-		if (ap->ops->set_piomode)
-			ap->ops->set_piomode(ap, dev);
-	}
-
-	/* reset and determine device classes */
-	ap->ops->phy_reset(ap);
-
-	ata_for_each_dev(dev, &ap->link, ALL) {
-		if (dev->class != ATA_DEV_UNKNOWN)
-			classes[dev->devno] = dev->class;
-		else
-			classes[dev->devno] = ATA_DEV_NONE;
-
-		dev->class = ATA_DEV_UNKNOWN;
-	}
-
-	/* read IDENTIFY page and configure devices. We have to do the identify
-	   specific sequence bass-ackwards so that PDIAG- is released by
-	   the slave device */
-
-	ata_for_each_dev(dev, &ap->link, ALL_REVERSE) {
-		if (tries[dev->devno])
-			dev->class = classes[dev->devno];
-
-		if (!ata_dev_enabled(dev))
-			continue;
-
-		rc = ata_dev_read_id(dev, &dev->class, ATA_READID_POSTRESET,
-				     dev->id);
-		if (rc)
-			goto fail;
-	}
-
-	/* Now ask for the cable type as PDIAG- should have been released */
-	if (ap->ops->cable_detect)
-		ap->cbl = ap->ops->cable_detect(ap);
-
-	/* We may have SATA bridge glue hiding here irrespective of
-	 * the reported cable types and sensed types.  When SATA
-	 * drives indicate we have a bridge, we don't know which end
-	 * of the link the bridge is which is a problem.
-	 */
-	ata_for_each_dev(dev, &ap->link, ENABLED)
-		if (ata_id_is_sata(dev->id))
-			ap->cbl = ATA_CBL_SATA;
-
-	/* After the identify sequence we can now set up the devices. We do
-	   this in the normal order so that the user doesn't get confused */
-
-	ata_for_each_dev(dev, &ap->link, ENABLED) {
-		ap->link.eh_context.i.flags |= ATA_EHI_PRINTINFO;
-		rc = ata_dev_configure(dev);
-		ap->link.eh_context.i.flags &= ~ATA_EHI_PRINTINFO;
-		if (rc)
-			goto fail;
-	}
-
-	/* configure transfer mode */
-	rc = ata_set_mode(&ap->link, &dev);
-	if (rc)
-		goto fail;
-
-	ata_for_each_dev(dev, &ap->link, ENABLED)
-		return 0;
-
-	return -ENODEV;
-
- fail:
-	tries[dev->devno]--;
-
-	switch (rc) {
-	case -EINVAL:
-		/* eeek, something went very wrong, give up */
-		tries[dev->devno] = 0;
-		break;
-
-	case -ENODEV:
-		/* give it just one more chance */
-		tries[dev->devno] = min(tries[dev->devno], 1);
-		fallthrough;
-	case -EIO:
-		if (tries[dev->devno] == 1) {
-			/* This is the last chance, better to slow
-			 * down than lose it.
-			 */
-			sata_down_spd_limit(&ap->link, 0);
-			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
-		}
-	}
-
-	if (!tries[dev->devno])
-		ata_dev_disable(dev);
-
-	goto retry;
-}
-
 /**
  *	sata_print_link_status - Print SATA link status
  *	@link: SATA link to printk link status about
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 1ec9b4427b84..6e7d352803bd 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -122,7 +122,6 @@ extern void ata_scsi_media_change_notify(struct ata_device *dev);
 extern void ata_scsi_hotplug(struct work_struct *work);
 extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
-extern int ata_bus_probe(struct ata_port *ap);
 extern int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, u64 lun);
 void ata_scsi_sdev_config(struct scsi_device *sdev);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 67e34948eac8..2d5e4b516a69 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -344,7 +344,6 @@ enum {
 	ATA_LINK_RESUME_TRIES	= 5,
 
 	/* how hard are we gonna try to probe/recover devices */
-	ATA_PROBE_MAX_TRIES	= 3,
 	ATA_EH_DEV_TRIES	= 3,
 	ATA_EH_PMP_TRIES	= 5,
 	ATA_EH_PMP_LINK_TRIES	= 3,
-- 
2.41.0

