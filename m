Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6C7C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjGUQfj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjGUQf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:35:28 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA0C30FF;
        Fri, 21 Jul 2023 09:35:04 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4fb863edcb6so3444584e87.0;
        Fri, 21 Jul 2023 09:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957303; x=1690562103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KpzF2rgPJTiOjlV43Ae8Cak+dUfUHpv6b31nNa1ErFQ=;
        b=dAOsCVNryRaIGj0z+I2lcSytX57xyDfOj4i8pwSlAgkCs68PPnWOtt/x+xrmZFIqiy
         aSXAG7me/GT0Rr8qYiLRGXEMEkxTJxQgJLRK8+48S1DKsqbDDfXDwihVVmTH5VKTVMQ9
         dIuoAtrhPFaUSY3tbn1ghV88dETGvLMpY4xvnsCRca9dVDssxA3FngEwPXnOVxp2A7hi
         AMOsP08OJexD4XDCWNX/Y+Z2kQQmWdG/uLUFlZZVmZZcKc/sUYXrsTWdw0XcSK8xCql+
         XLC0rfkwPL3QMir3Ea6ieEA6HsvGDi2zg4AulMB38oQd3wqtYljXkcU0dCEdaJsvijfy
         So9w==
X-Gm-Message-State: ABy/qLadahbNp9rwptPHa/EjS1dsqyEmVARZmhX3V7YOjQZUlwsopHhy
        UQ/RSv4j6ATC3HCROvaMhpBZ4IW7Lxdhkw==
X-Google-Smtp-Source: APBJJlH2SBc6QaIVnPZbLCoX05kHRVQHECojaXQYp62YwCVtrg76M7u6WJUYHYi6AuVirNkwcHebTw==
X-Received: by 2002:a19:ca5a:0:b0:4fd:d862:72a6 with SMTP id h26-20020a19ca5a000000b004fdd86272a6mr1645176lfj.53.1689957302618;
        Fri, 21 Jul 2023 09:35:02 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id d12-20020ac244cc000000b004fddb0eb960sm800044lfm.165.2023.07.21.09.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:35:02 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 14BE13F57; Fri, 21 Jul 2023 18:35:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957301; bh=7cpMffNeJO8A4cB2BFaFa1KTEwdrYSuoMIiy/LHLj4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F33jcl0jRxk7mAtNoQ5Kaj9o8Q3DpOiQo7kotHHgd4DVtc16hCOE/TAxN7Dxy2mSV
         u8nciUOwzeRTExSewsj04DlxxUH4z4VhlU2cu4BeUt+k34N0N9gt7C87lbRHsVtP23
         XxSSuKq3iaRES/Xot1jCLGG4+DcgMT2k1onL58AM=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id BBBFD3F2E;
        Fri, 21 Jul 2023 18:32:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957171; bh=7cpMffNeJO8A4cB2BFaFa1KTEwdrYSuoMIiy/LHLj4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkZQN/iqrqRinhSaJpvDFNjNVM3pjL5zXKXkOvfOVbJ97NXJLUYgVSxYR3Oj6YbKK
         FSed0sTNkWj4kNd3T4CHdQshh/O0q2hnMf8R7v/J2YNDRujHnbsghn+aOIETnyOn3a
         7Wkg2uRVGFkWSNClhAplbu9ynwkTVZ/E3yzUaqL4=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 2/9] ata,scsi: remove ata_sas_port_{start,stop} callbacks
Date:   Fri, 21 Jul 2023 18:32:13 +0200
Message-ID: <20230721163229.399676-3-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721163229.399676-1-nks@flawful.org>
References: <20230721163229.399676-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Callbacks are empty now, so remove them.

Also, remove the call to ap->ops->port_start() in ata_sas_port_init(),
as this would otherwise cause a NULL pointer dereference, now when the
callback is gone.

Signed-off-by: Hannes Reinecke <hare@suse.de>
[niklas: remove the call to ap->ops->port_start() in ata_sas_port_init()]
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-sata.c     | 38 -----------------------------------
 drivers/scsi/libsas/sas_ata.c |  2 --
 include/linux/libata.h        |  2 --
 3 files changed, 42 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 99d4ab04bcce..a8256cb08763 100644
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
@@ -1211,10 +1177,6 @@ EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
 
 int ata_sas_port_init(struct ata_port *ap)
 {
-	int rc = ap->ops->port_start(ap);
-
-	if (rc)
-		return rc;
 	ap->print_id = atomic_inc_return(&ata_print_id);
 	return 0;
 }
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
index 3eeea76c30de..5faf2d5d3da5 100644
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

