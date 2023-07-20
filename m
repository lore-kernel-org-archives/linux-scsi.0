Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5806EC001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 00:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjGTAqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 20:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGTAqB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 20:46:01 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EA61BF7;
        Wed, 19 Jul 2023 17:46:00 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4fb5bcb9a28so322863e87.3;
        Wed, 19 Jul 2023 17:46:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689813959; x=1690418759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SS/+Rptd/CPkpo4GsV1LLONL5aRC92WpJNaX7mPRMY4=;
        b=GqG5KYJVeL7Gk8zPyaqmpwH3ZZ4QShO6aV5jkz7iHowRW2ggA2BXsjNqhyu8DMLDoU
         AoeUpioUuOnUcgM1gUeZZbSw/qFT5Afhw3m9Ae1iCMBkt4SrE7vc9STXC0PY6mAJEcXT
         vTMACtU47Z9/tEeP88642j7l2U98mLY82f1+ScDvmlwfHaTZX5QD/5cRye+ZIHMZdGSH
         4sxHhx9ZBe/HLgE5vbMneX+Jpb1SF/4SwQ6rav9VwpmodAL9mlXbPcTQaaUiZZxKf0wS
         SxFu/UYZbeiFXyGgmuNAzG75h9G2m0ZB3g8kQxTm6sPE5Rk4OTRx2qdsOtZxHQ5ygwn7
         UrCA==
X-Gm-Message-State: ABy/qLZ4AzxpMoDaOnoDGBIyNGiGI9pQflPIl7l/B1yKQnakLW+S2YQc
        I+4ynfOd5Kvaiz1t8NBTDzzkt93cH7gZejKD
X-Google-Smtp-Source: APBJJlGh2gQDHIqOE4iNT6pNu3HvU4B0lzhmScyAsxEoer3761Ym8FXWHEPAltPIXLBx9lc9mZImRA==
X-Received: by 2002:a05:6512:2013:b0:4fb:92df:a27b with SMTP id a19-20020a056512201300b004fb92dfa27bmr1002558lfb.39.1689813958556;
        Wed, 19 Jul 2023 17:45:58 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id r1-20020a19ac41000000b004fbae51d1a5sm1170345lfc.295.2023.07.19.17.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 17:45:58 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 013073F11; Thu, 20 Jul 2023 02:45:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813957; bh=FxOOeXvaUA43cnXR6Mh91CQMDyAdV9tGoXL4WLcvyMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=refA2O+2f1TephaEZVDIS8bmBTtU6qraLhF75JCPZ4xOO6LlEJGxRo/OiKbrUpgib
         DQKxtR69jeyGC827KThm7qux9M5Lx6qlkHqD+mv8OlgYk2cMJ2AwNOv3UmtcLedvas
         jZutpw8O6JguwdGktXkPwuoomCBqJCDcG/YvyiKU=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id A7F8D3EF2;
        Thu, 20 Jul 2023 02:44:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813851; bh=FxOOeXvaUA43cnXR6Mh91CQMDyAdV9tGoXL4WLcvyMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4pqJsaIVXkUvJEMyFwfaB0Q/hMinnkuXzlt/IhajNKTx+CxxKlIAbf9QQv6IiVcc
         ew2i/NTJFrUHfMu2jHdVLGMcdYkZqnLIOSiNNsu8CCR3wbz6slISYBqxSpKZj2DYMp
         TfhgsE4W4wS1hbp+mNweFBE2xNa0GgpGMZUl8J5o=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 2/8] ata,scsi: remove ata_sas_port_{start,stop} callbacks
Date:   Thu, 20 Jul 2023 02:42:43 +0200
Message-ID: <20230720004257.307031-3-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720004257.307031-1-nks@flawful.org>
References: <20230720004257.307031-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Callbacks are empty now, so remove them.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-sata.c     | 34 ----------------------------------
 drivers/scsi/libsas/sas_ata.c |  2 --
 include/linux/libata.h        |  2 --
 3 files changed, 38 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 99d4ab04bcce..d3b595294eee 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1144,40 +1144,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
 
-/**
- *	ata_sas_port_start - Set port up for dma.
- *	@ap: Port to initialize
- *
- *	Called just after data structures for each port are
- *	initialized.
- *
- *	May be used as the port_start() entry in ata_port_operations.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-int ata_sas_port_start(struct ata_port *ap)
-{
-	/* the port is marked as frozen at allocation time */
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ata_sas_port_start);
-
-/**
- *	ata_sas_port_stop - Undo ata_sas_port_start()
- *	@ap: Port to shut down
- *
- *	May be used as the port_stop() entry in ata_port_operations.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-
-void ata_sas_port_stop(struct ata_port *ap)
-{
-}
-EXPORT_SYMBOL_GPL(ata_sas_port_stop);
-
 /**
  * ata_sas_async_probe - simply schedule probing and return
  * @ap: Port to probe
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 77714a495cbb..7ead1f1be97f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -565,8 +565,6 @@ static struct ata_port_operations sas_sata_ops = {
 	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= sas_ata_qc_issue,
 	.qc_fill_rtf		= sas_ata_qc_fill_rtf,
-	.port_start		= ata_sas_port_start,
-	.port_stop		= ata_sas_port_stop,
 	.set_dmamode		= sas_ata_set_dmamode,
 	.sched_eh		= sas_ata_sched_eh,
 	.end_eh			= sas_ata_end_eh,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 820f7a3a2749..9424c490ef0b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1244,10 +1244,8 @@ extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 extern void ata_sas_async_probe(struct ata_port *ap);
 extern int ata_sas_sync_probe(struct ata_port *ap);
 extern int ata_sas_port_init(struct ata_port *);
-extern int ata_sas_port_start(struct ata_port *ap);
 extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_sas_tport_delete(struct ata_port *ap);
-extern void ata_sas_port_stop(struct ata_port *ap);
 extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
 extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap);
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
-- 
2.41.0

