Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DA7C41513
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbjGaOkH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjGaOkC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:40:02 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05490D3;
        Mon, 31 Jul 2023 07:40:01 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4fe28f92d8eso2810258e87.1;
        Mon, 31 Jul 2023 07:40:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690814399; x=1691419199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2k+q14ps53lS2O6/mpuHT4ZklVrr/y/XhvkOCRi7rPM=;
        b=LCTo6jj539VMNtZ5OESohNoW98yw9fav9SazJn/DUu27tccxzsLAvHnbQok041PCtR
         DjwK0Oc1fdKy42ZKjdf1zmbxcoeTzKPj3TLkws+ONxpBtxLHrzcE+qd2RMNroEc59g7c
         mjNKjnn+Dcgj126LhpjAyJALYUqaMQQpcADub0rz/Nn0Hn2GEuh6SDEVRU7hgXvdQxI2
         PK7bLaDaCB+Y2pknO7zO6yx03QJKcqAh5ezsBbxb2MSkjm4EvKn3Jal+zlywPx9PRcW6
         FMvSqDFHh1CmiJlCCRjp/BHuNyMll+akBCfhtgdW5oMty3SeEaFugxKyyM+qUb0bVjBS
         NWAQ==
X-Gm-Message-State: ABy/qLZZsLH1TneZ166/p3T1Y95yzgYLXK1mFU3VN4t3/qKcBYHgZkmu
        FcK44yR9CA0EPuAJycA5ApKW/g+dScdOTA==
X-Google-Smtp-Source: APBJJlH5/pJT2s/RmZHQZVLm3pWlA1X5Eu/6rrwBDTurYN8nPkrQGHpfmujeKkp1YsSK7Ej9MTeHpQ==
X-Received: by 2002:a2e:990c:0:b0:2b7:3656:c594 with SMTP id v12-20020a2e990c000000b002b73656c594mr136983lji.3.1690814399118;
        Mon, 31 Jul 2023 07:39:59 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id c4-20020a2ea1c4000000b002b71c128ea0sm2577011ljm.117.2023.07.31.07.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:39:58 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id D164B3F16; Mon, 31 Jul 2023 16:39:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814397; bh=Rs5bVez7dh0ggEARvKEKRWHe0daPIEAEP7tmoRQH+uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWfZmbpJXjZeGdpUrVlRrpzQPCUiMMelROeeDo21bmzZPNo5FT+JXZFZGQ0o/hvrf
         ByxE4oh4YRKCWi91/JlA6nV23hTkEEgTcLGTjmHtxACa4pUBbZyRM+RbalmKNu31kJ
         BMP7qbXynnYhfASH+Pi+Y6SCTf1tUPxpYb54kWeg=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id E21FD4A2E;
        Mon, 31 Jul 2023 16:35:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814101; bh=Rs5bVez7dh0ggEARvKEKRWHe0daPIEAEP7tmoRQH+uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCifNetFSJfOM3wBIAVocJjatZbRFQO0Pnwm/HtNIdBFet/Ll4YU2UoMhYgWCrJDt
         TiU6hPsMt1f87pBk/4sKccq/Xffk2M7axMDRE/4clZYsEJ4EN+zzOFsG688s9JCnna
         QbJ8n6M3262OAPnFZuOyzNHBDn5MfVIRe73eFX/0=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 07/10] ata,scsi: remove ata_sas_port_init()
Date:   Mon, 31 Jul 2023 16:34:18 +0200
Message-ID: <20230731143432.58886-8-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731143432.58886-1-nks@flawful.org>
References: <20230731143432.58886-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

ata_sas_port_init() now only contains a single initialization.

Move this single initialization to ata_sas_port_alloc(), since:
1) ata_sas_port_alloc() already initializes some of the struct members.
2) ata_sas_port_alloc() is only used by libsas.

Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-sata.c     | 19 +------------------
 drivers/scsi/libsas/sas_ata.c |  3 ---
 include/linux/libata.h        |  1 -
 3 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index c0253adbf47c..5e6f21ca3567 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1139,29 +1139,12 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 	ap->flags |= port_info->flags;
 	ap->ops = port_info->port_ops;
 	ap->cbl = ATA_CBL_SATA;
+	ap->print_id = atomic_inc_return(&ata_print_id);
 
 	return ap;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
 
-/**
- *	ata_sas_port_init - Initialize a SATA device
- *	@ap: SATA port to initialize
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *
- *	RETURNS:
- *	Zero on success, non-zero on error.
- */
-
-int ata_sas_port_init(struct ata_port *ap)
-{
-	ap->print_id = atomic_inc_return(&ata_print_id);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ata_sas_port_init);
-
 int ata_sas_tport_add(struct device *parent, struct ata_port *ap)
 {
 	return ata_tport_add(parent, ap);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index d6bb37b3974a..cd16a1ac379d 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -605,9 +605,6 @@ int sas_ata_init(struct domain_device *found_dev)
 	ap->private_data = found_dev;
 	ap->cbl = ATA_CBL_SATA;
 	ap->scsi_host = shost;
-	rc = ata_sas_port_init(ap);
-	if (rc)
-		goto destroy_port;
 
 	rc = ata_sas_tport_add(ata_host->dev, ap);
 	if (rc)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 67e34948eac8..05d2fc0df553 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1241,7 +1241,6 @@ extern int ata_slave_link_init(struct ata_port *ap);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_port_probe(struct ata_port *ap);
-extern int ata_sas_port_init(struct ata_port *);
 extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_sas_tport_delete(struct ata_port *ap);
 extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
-- 
2.41.0

