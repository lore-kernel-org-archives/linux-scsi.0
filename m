Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8ECC001DE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 00:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjGTAro (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 20:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjGTArn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 20:47:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40D52106;
        Wed, 19 Jul 2023 17:47:41 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f954d7309fso381290e87.1;
        Wed, 19 Jul 2023 17:47:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689814060; x=1690418860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYJ05I8n5DhJbkESL91gXZT8SFoV1vMB4kWMK+SK8UA=;
        b=H6nz0fHn7CJGtSjUHEujFpw/u7i8m2CaSBxlGrYfaj0/pmMBjWTjndrtFtv/LMr2Qk
         SkMqTlaoOy6SRPB8mS4ItlXLProYj+I5WJW+IiVAjmlYd0Veo9NbTaARmGj7X5vuEAgj
         hkj1tpIhZ9n+CwsQAq37S4CtSUppK5uVabjA+yrqKxv19xox5nMyyQ0rKnPapqlbTwRk
         wR6OeoksryfHmvYQjGtXeT1mlGJwFOrIUZn8OkYi2nxcbbwm50B74NzzcnorwRtUWXgu
         20kCPFfpTHU4UNDu9hvhwD+8yqzNVaRYJI3K9WNTk5hA0vCBMhy9G0JGXuVCODkCWo8f
         ++Pw==
X-Gm-Message-State: ABy/qLZ2yMu5Vi7jgrx72HqkbFWyNti0dYEuC+G/7ncpZmbP5oJL9eGo
        6phyvUQ4phzV4rFdi1NyAO50cINQBxqJBgSg
X-Google-Smtp-Source: APBJJlEtKoVM3ANFTCrPFMQwLxnPiLK67lhPbjkiop+JHZ4sJp/9HWst6X59CMh3SV3wtKOWYfccqA==
X-Received: by 2002:ac2:5599:0:b0:4f8:6d9d:abe0 with SMTP id v25-20020ac25599000000b004f86d9dabe0mr404169lfg.33.1689814059935;
        Wed, 19 Jul 2023 17:47:39 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id o30-20020ac2495e000000b004fc8049fc0dsm1179133lfi.82.2023.07.19.17.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 17:47:39 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id E11BD4BD; Thu, 20 Jul 2023 02:47:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689814059; bh=EAb0dJXzCYxeykfA5FcCpAMDp5W96gKxySZLbumkKRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZq6412qYYAqFa2rpSkcV5D2tdytWmPBJhpYl8/7O7oQX1i5/Qqn7FMRARkNP9JNH
         fqyr7EyM34eH5TDhpopfp5lwhjed6ZLx5EfIeP8VKEj6qPLN+Fp95mzUeOO5YAB9wh
         nqpLYc5244TgXodDlxitPABe9oIad/x9v/XdzaYg=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 13FF73F0F;
        Thu, 20 Jul 2023 02:44:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813857; bh=EAb0dJXzCYxeykfA5FcCpAMDp5W96gKxySZLbumkKRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwjdUHVZbX9Cp7gxZ77Fm8SpLc6w9be6ZgcZANQ0+TZ8uW7q0VpgjsdqdOx++hRG8
         HfxpGhEBcYo4SIxq9K27HKkKOKWi+vnmb4nLG167bkmqgui55OHCg+S+S2Sgnhkx/z
         z7u1/tfKLxIZOfwdihkSwNv5eCux4R7TTNEoK7Gg=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 8/8] ata: remove ata_bus_probe()
Date:   Thu, 20 Jul 2023 02:42:49 +0200
Message-ID: <20230720004257.307031-9-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720004257.307031-1-nks@flawful.org>
References: <20230720004257.307031-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Remove ata_bus_probe() as it is unused.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-core.c | 138 --------------------------------------
 drivers/ata/libata.h      |   1 -
 2 files changed, 139 deletions(-)

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
-- 
2.41.0

