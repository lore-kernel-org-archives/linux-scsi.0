Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CD4C001DE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjGaOhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbjGaOhk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:37:40 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADFB10D;
        Mon, 31 Jul 2023 07:37:39 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b9db1de50cso29223991fa.3;
        Mon, 31 Jul 2023 07:37:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690814257; x=1691419057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l3262UZbqhpzRYxsP7pqYyAwibxaw8SDUP49ZVnrvd4=;
        b=iTOOTSVqdwSzvPIYUyUe6K9pQfupA33whZ4nbMl6ckxYrGD/mHNn4RSRVWjG4sXsSZ
         zzN3WOe7YlaGqAuK/QJVMHI1klxLXthrTIuhThA4g7rC3kYjuZUSWlkN5lA4oNbpnKVL
         txE8De8dSxYG55EfIdgS+bJtggBH85+lVTzNb90jCj7Lw7mVOGQQpbbkqypTYB1hTbnC
         ICD4+j5YThSdzGzmGvQvy8bJzroyk6ZVl6y0ApUQA5rg3t0owSfjMxiBonaIzx4KwFir
         Di3FJR08PU4dBBFIaMfW436kF6SScqRsuGs1opGOugscbO1jxZWxj7sSWJ1x09bG9WG+
         cNcw==
X-Gm-Message-State: ABy/qLac1riRri//+2nQJtHYoYfUJyauW8ymFZ7iEoABMWXv8Th40rgQ
        oTi1lP2A3C/QwAw0zNGYPwZiBWComCN6Qw==
X-Google-Smtp-Source: APBJJlEpfVZw7xjiV8YIPchfSVb5WSUzwuiIL8zOu1QQIZlC/mBPcmMdeeCapppS0s5vgFyGx/W91g==
X-Received: by 2002:a2e:9208:0:b0:2b9:20fe:4bcc with SMTP id k8-20020a2e9208000000b002b920fe4bccmr131124ljg.21.1690814257245;
        Mon, 31 Jul 2023 07:37:37 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id o7-20020a2e90c7000000b002b9db7df0dasm1462020ljg.8.2023.07.31.07.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:37:36 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 20CFC3F6D; Mon, 31 Jul 2023 16:37:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814256; bh=aYpQaAOAdQJkKNUxNr2UGOSCBZVeg17udL95x37+lpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECkbLa5OjO/fgDsUqyLMyPUticRPv/r3Xich/X63D6fNcrebilnvatpC0Y5RfuDSV
         ED4j99NgojirJnM+kuRQh3UbHGki/7i1S4cGc8zF+Kj+sT6sLs41KaACjeO6BT0GU2
         nnn2FaEq9yjZ8anPk+yOf2tRp6P9K/OinvawvItg=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id ADBAF41C7;
        Mon, 31 Jul 2023 16:34:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814088; bh=aYpQaAOAdQJkKNUxNr2UGOSCBZVeg17udL95x37+lpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBruudOLA8MGLY2ynZiUwAzuyeuKDRPI+pbThJeiAbh6wumpUV97BeGocGKhh14iz
         uy9/26C6/LSQQoh9pMQ7pAtHJrhocexzuxtVx/Yfpo3zrOd8XajsRKcM7wOBnh2Lji
         EjhLDm58yxOWHQNsUzXDMqeo4OSYB9x0mcQob8K8=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 03/10] ata,scsi: remove ata_sas_port_destroy()
Date:   Mon, 31 Jul 2023 16:34:14 +0200
Message-ID: <20230731143432.58886-4-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731143432.58886-1-nks@flawful.org>
References: <20230731143432.58886-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Is now a wrapper around kfree(), so call it directly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/ata/libata-sata.c          | 14 --------------
 drivers/scsi/libsas/sas_ata.c      |  2 +-
 drivers/scsi/libsas/sas_discover.c |  2 +-
 include/linux/libata.h             |  1 -
 4 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index a8256cb08763..b5de0f40ea25 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1194,20 +1194,6 @@ void ata_sas_tport_delete(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
 
-/**
- *	ata_sas_port_destroy - Destroy a SATA port allocated by ata_sas_port_alloc
- *	@ap: SATA port to destroy
- *
- */
-
-void ata_sas_port_destroy(struct ata_port *ap)
-{
-	if (ap->ops->port_stop)
-		ap->ops->port_stop(ap);
-	kfree(ap);
-}
-EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
-
 /**
  *	ata_sas_slave_configure - Default slave_config routine for libata devices
  *	@sdev: SCSI device to configure
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 7ead1f1be97f..a2eb9a2191c0 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -619,7 +619,7 @@ int sas_ata_init(struct domain_device *found_dev)
 	return 0;
 
 destroy_port:
-	ata_sas_port_destroy(ap);
+	kfree(ap);
 free_host:
 	ata_host_put(ata_host);
 	return rc;
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 8c6afe724944..07e18cdb85c7 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
 
 	if (dev_is_sata(dev) && dev->sata_dev.ap) {
 		ata_sas_tport_delete(dev->sata_dev.ap);
-		ata_sas_port_destroy(dev->sata_dev.ap);
+		kfree(dev->sata_dev.ap);
 		ata_host_put(dev->sata_dev.ata_host);
 		dev->sata_dev.ata_host = NULL;
 		dev->sata_dev.ap = NULL;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5faf2d5d3da5..bc755a1864a0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1238,7 +1238,6 @@ extern int sata_link_debounce(struct ata_link *link,
 extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			     bool spm_wakeup);
 extern int ata_slave_link_init(struct ata_port *ap);
-extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_sas_async_probe(struct ata_port *ap);
-- 
2.41.0

