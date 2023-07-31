Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDCBC41513
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjGaOiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjGaOiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:38:12 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D829DE65;
        Mon, 31 Jul 2023 07:38:09 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4fe1a35a135so6743253e87.1;
        Mon, 31 Jul 2023 07:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690814288; x=1691419088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+cvLEKb01KwEwiwYhn+J5gm5Rmx74arCYHgQsrDmFnM=;
        b=fVPH/HP6O4sBSHkmMOAGY4gnHNsNg0D2PfaIjR9M/UWpYOB4TuPh4g+xZL/+qQtDkC
         tnDZoX9z5Tt093nkGjWhIyIkg6SUcanlUPon7oS8UZCoJWaCSsQUUoUV+992OEALfSCV
         0YPnNUYyGleKEqIvmXUjCoSmdr6RfD/X8zNy7pR3yMCn0P7rUFkxcv4JStpKeEZs3Snp
         eejM0NzMq12qQV3ZWzOltYk9N5pUaVENpoWvbAvJalVrUxCtfBGpz5FenMay1xE6p9Tt
         JwcXwyzudMq7ikway/nH/5+xMxW0vqHFcQTrudDCLyWvEuUASMoXcBPjy3od3g+LP8Dw
         UKxA==
X-Gm-Message-State: ABy/qLbzkOsDUjri2Eq4wTqjC/sZ3EdpeMcZrTm/Tmkt4YofQj/en4yh
        lvpDSsANjBrg9H7JY7WKP2un22jMJTRdqg==
X-Google-Smtp-Source: APBJJlFJ8C0Y45Km3ln9f2LKEupWqGAEAmku7CDy6SRrKJJz/+PhAUmqCuIjHboGAztbXwnMHx2Pyw==
X-Received: by 2002:a05:6512:3c8d:b0:4f9:5426:6622 with SMTP id h13-20020a0565123c8d00b004f954266622mr7597598lfv.69.1690814287537;
        Mon, 31 Jul 2023 07:38:07 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id x9-20020ac259c9000000b004fe1e7f98c2sm1736882lfn.146.2023.07.31.07.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:38:00 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id EAB113F16; Mon, 31 Jul 2023 16:37:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814278; bh=UwjA0ta5TWrlev0xT9Hy6DQIhdsAyjp7Nr9lw0njM+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9RBoRh9ENuq7ULwj3ZZbRuRwDUuEQ5DO/JTGThm5qFXIMt7iyEH9WzzAHNuizvIU
         OBs4cvygagTU7PwCOOWlgPvEP1armk9+ZRb2W1GEmrlAntTXKKYmBuLrilZXlcnHx8
         JcwF/2HiF+sERDaHVLmcEVZOnC68sgyqnahd07EY=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 76DC241CC;
        Mon, 31 Jul 2023 16:34:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814092; bh=UwjA0ta5TWrlev0xT9Hy6DQIhdsAyjp7Nr9lw0njM+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcgNmoZkQEi/gJo8XuDxZcEfdBZriZZm0PU2lHrraG9TsDRIC/em3Vi/E9Zu/EFIx
         yw5t1q7zG0yqx8H9z6tt2UnyTl/XLsK0QdQoAcDITxhSuwyHPGsvzzx30bQkTwWgFp
         GJ7cjCoyuU2jExZw4z+A6suTLVpQxGnSsVCXVi7A=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 04/10] ata: remove ata_sas_sync_probe()
Date:   Mon, 31 Jul 2023 16:34:15 +0200
Message-ID: <20230731143432.58886-5-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731143432.58886-1-nks@flawful.org>
References: <20230731143432.58886-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Unused.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/ata/libata-sata.c | 7 -------
 include/linux/libata.h    | 1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index b5de0f40ea25..23252ebe312d 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1157,13 +1157,6 @@ void ata_sas_async_probe(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ata_sas_async_probe);
 
-int ata_sas_sync_probe(struct ata_port *ap)
-{
-	return ata_port_probe(ap);
-}
-EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
-
-
 /**
  *	ata_sas_port_init - Initialize a SATA device
  *	@ap: SATA port to initialize
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bc755a1864a0..8e219c486a90 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1241,7 +1241,6 @@ extern int ata_slave_link_init(struct ata_port *ap);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_sas_async_probe(struct ata_port *ap);
-extern int ata_sas_sync_probe(struct ata_port *ap);
 extern int ata_sas_port_init(struct ata_port *);
 extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_sas_tport_delete(struct ata_port *ap);
-- 
2.41.0

