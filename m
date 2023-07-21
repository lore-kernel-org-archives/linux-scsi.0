Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78580EB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbjGUQgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjGUQgB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:36:01 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71214201;
        Fri, 21 Jul 2023 09:35:43 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b962c226ceso31572031fa.3;
        Fri, 21 Jul 2023 09:35:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957341; x=1690562141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+NNWT9HNkZFQePJUnE2s2NSdtJZok/YpMckeOkF0vP0=;
        b=ax04Ks6dXiyjhQC6PZcfWb90QSxaPVk0pu4GwMx2+MuuCYIe4DuOlwoiXGVdLzgMzF
         h49dC0wnWqYLVTsnC8wrudId6SgR+LuyoRijG9py8PsGS4b+sMCU/oYaJRC0pdewGZ5C
         zmM4Nh5ahMPfVFv/+iW8H3dwrKSQJdykgWdZjBCxcNEsXzC/ybMDGhVCfH8Kjan5rOia
         3jOryPy1PYAHqPJwntkaNzCAr8hePAUQrCHEMaBgj62o9is2EurPblFYHtCOluQTs0c6
         +I2L96PMam6znmZ9yZajlYsWaoPaz5MbQTLrBSJOpoI9d8qAW671EezsD54o623/7PuB
         HLvw==
X-Gm-Message-State: ABy/qLaA23AaULAlH+tvgELQRhQnSRSv54E1CrYDj+1elldNBCFLnreZ
        y5SgH8/xImxuLDYr6Q/uOLVF3R+wbPYY7w==
X-Google-Smtp-Source: APBJJlG0wk0BIURix05GwNA1DVwkC61hEv5UtTJ44aQx8VGUgvYKaGVC3IZLADawkU9TLkMdWAR3ug==
X-Received: by 2002:a05:651c:22d:b0:2b9:4841:9652 with SMTP id z13-20020a05651c022d00b002b948419652mr1876754ljn.25.1689957341397;
        Fri, 21 Jul 2023 09:35:41 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id s10-20020a2e98ca000000b002b6ec3d4a53sm1016805ljj.50.2023.07.21.09.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:35:41 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 4B2603F16; Fri, 21 Jul 2023 18:35:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957340; bh=8hj74OxvJpB8m2076DzL5Oqv76UxPXze+5EIvSClmj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HL8nXAywRhQzaa7riecYnlNYCa28IothENQ+bYFn/o17+J0hGRsAgnAiH7fdC4tas
         JmsaYrmsiGWZPf+2DpBruLkQX/pZBtLf766gJawg3nbaX/sCDUzLsTTTQMUI/2XFVh
         fQkWtyOqw5fXqZeTxiK55+yuJUgGysbLzcjW3Ig8=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 9718E3F3F;
        Fri, 21 Jul 2023 18:32:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957173; bh=8hj74OxvJpB8m2076DzL5Oqv76UxPXze+5EIvSClmj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdB/VqSQbe3W+bY0KOJ0F2HsANuVfuT+mH4qUXfRILrTIfVY1dZOENcdmEPJgaALG
         fKu/wSQB0hTaxJNwm7QGkOnbUXAbSTrnw/lG6yErQdtx6thHpkvFDX7y3mw07QYXHs
         QpkiavdRerq0fHcC7cA2CC3t9rTGP4V2tHjMrZVg=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 4/9] ata: remove ata_sas_sync_probe()
Date:   Fri, 21 Jul 2023 18:32:15 +0200
Message-ID: <20230721163229.399676-5-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721163229.399676-1-nks@flawful.org>
References: <20230721163229.399676-1-nks@flawful.org>
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

