Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846ACC00528
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjGaOkS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjGaOkO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:40:14 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0487011C;
        Mon, 31 Jul 2023 07:40:13 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so7215722e87.2;
        Mon, 31 Jul 2023 07:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690814411; x=1691419211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VJOGtTDREfbV8OYpGif0IKD7eMnTiyh+wZE8SJ1ImCI=;
        b=cNSjNj4TnYlhcTi3xouSskMSZkWwG28ZipgcJ4tRxSGOIl+IUG9TVszOuTjD1vFpeh
         O9gF6DUH756LGCfHH/kny62IyFsCdwDsp2IAbXWNmSaEYUlPgDlNGdojjpslFjSG3JXG
         6/w5HakhnDtot5Us3vjGBVhn9z600IhDizoO2APwMBPj5/qFTfOZzRiCpSEI6Vn8iMrz
         bN3HfRymqY9Qpmo5QQocrr915rZWW2SPxq0XSG3L6fgDphdgu2MAl6RutGhUPsPUFqV6
         tKbevv0lutWZFlR6QZcgQ4QMbkdQ6TwTpkTI7QSReV9ao52UGWSJcdYMbtp3Fp4h+eGR
         340w==
X-Gm-Message-State: ABy/qLafQ1QhgD7AtxclpprEh/lmS+V74agO0XpuiffIlEwDtSDnSHaH
        iiarSDIlZLAkLwSqiPiVw8fhK3c9KlXHtg==
X-Google-Smtp-Source: APBJJlFZQpXB0q9uKF/n7yxQlHVnmrQO5djcx6klaX9eq3nTGkfY0Vt1eBwKybR5SAy+QAtTX0T87g==
X-Received: by 2002:a05:6512:3254:b0:4fe:1a99:45e3 with SMTP id c20-20020a056512325400b004fe1a9945e3mr10901lfr.30.1690814411006;
        Mon, 31 Jul 2023 07:40:11 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id q17-20020ac25fd1000000b004fb7cd9651bsm2094755lfg.98.2023.07.31.07.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:40:10 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id B54A13F16; Mon, 31 Jul 2023 16:40:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814409; bh=Rbfs5epaggzjkrl275wlRpsTZE3RxtYbUO+5BZIP0PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1ca/4R2PLjU5eeI0AaZZu0xFEGHEUduOLqzHwYWL/wpDyFrDVH7gtZRPPKM3Q5aK
         zs+1VM2iFQELyDGw7BtPyFpoOJPlEyRed5uG0BnmGFe4ufC63qykKtZpBy4SC6xteH
         gMZ+P1s/AKM0BP9Ea6PFDByqnt8Pq+trz0vdt5w0=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id C264241D1;
        Mon, 31 Jul 2023 16:35:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814103; bh=Rbfs5epaggzjkrl275wlRpsTZE3RxtYbUO+5BZIP0PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djTkIUhCcYKh3DLkvJ1A+mR4Q0KRHUptDeuRaNvJ1+bVnrcWQ5/jPB2c6os6s68Ap
         vUX5V4PPspfNQDBWs4wOyHdtan5wd5/HuhyHJCl/qS8f2jUvYS5GXj8Tfb3BxzkAi9
         IJ0M9bO3PF/lQPvIvQJLNUwhwjFA3BR8Hx0OgEx4=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Jason Yan <yanaijie@huawei.com>, linux-doc@vger.kernel.org
Subject: [PATCH v4 09/10] ata: remove ata_bus_probe()
Date:   Mon, 31 Jul 2023 16:34:20 +0200
Message-ID: <20230731143432.58886-10-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731143432.58886-1-nks@flawful.org>
References: <20230731143432.58886-1-nks@flawful.org>
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
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
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
index 25a228350c75..53335f513cdf 100644
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
index 05d2fc0df553..049159905a28 100644
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

