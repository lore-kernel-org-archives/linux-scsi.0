Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1B5C001DE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjGaOix (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjGaOiv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:38:51 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3279911C;
        Mon, 31 Jul 2023 07:38:49 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4fe2de785e7so2514150e87.1;
        Mon, 31 Jul 2023 07:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690814327; x=1691419127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u2pZOghG3s3cE32OpecCVkbhH2lBZudb1L9QW7BuQ2Q=;
        b=TUmtLmckk6u6PlJldZhTZKtPXaXTz7SXGJSGFxyAXW5goysLHWvOoZ9fT3YhaRx8Ah
         z8DPS5AX6pArcyLvl9N1xxJZiQ63CXECYCx6IrHSz5FJ0qxZJ8MugF4cEuZFSabNH9Ka
         ajCda1thLfigbHegbPRYFa7BbHhkU0xRXBVFRZT8npSX5pu6OqexkeTepnatAYEcAA9J
         +x8b2GMV3RZYXqY7OHxptIojMkBee120TmxYiBDvB9MTx1mlG5rSabmtKOSeW0drHPDj
         cCX9FnFxoXl+9P/dPcLGj8qppDH7VTY1iWjh+lfAMBItm6FoWLaWTrTVp7cZnIQMXpnt
         sBxw==
X-Gm-Message-State: ABy/qLahb19H4e6uJWGnAWBJI1q2SAIA8D4XuHosT0h5R5lcCdwMu/j6
        MvQ/owAeg0yC+8z6Htq4rsw5DLHSQGeKNA==
X-Google-Smtp-Source: APBJJlEljT4rb253lnTz1NMg2oOTYKq88hI5JJBYvpnpj3eI420SX9n5DBTPwZEGcuJZpA5SV2IT3w==
X-Received: by 2002:a05:6512:308e:b0:4fb:7626:31a8 with SMTP id z14-20020a056512308e00b004fb762631a8mr21783lfd.27.1690814327320;
        Mon, 31 Jul 2023 07:38:47 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id q16-20020ac25110000000b004fe1fc5d0e3sm1638831lfb.206.2023.07.31.07.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:38:47 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 236604018; Mon, 31 Jul 2023 16:38:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814326; bh=dXBbRZp7PPSuBO724JgCVhzx+YcDxA1gCV+FO8yyma4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOE9T3Wj00OfnoA5UmulNW+lGDe0daa2vPcjS9y7rnj2YjTVICoHAjgkfgv82drUw
         AInpTZ61xFe+6mO1OxaGp2O9BJCO8Y9pnNV/6/1gUXryYeQbD8RJQRMn4uYUF+yWRA
         gvw7yUWokKyN32iFSz/EoXZqXAe8Ns9bmeoRJ1lE=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 69E0720F7;
        Mon, 31 Jul 2023 16:34:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814098; bh=dXBbRZp7PPSuBO724JgCVhzx+YcDxA1gCV+FO8yyma4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5yNrjItzfHlKbm2Cg7aqzcVErOCGhywc0RqJliVJyBP079sESULTr3ooo1PPs4Ny
         jUhhmHwnWcEQXsJjqYM5l+8d8EkaR0HLF+ubmSsbpSamBA+FTsX5Uhc2vRSPFYNQbT
         Zs9mRH2H+FvmfTHT6py3eAWXiTBv9hD5FB61Otls=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 05/10] ata: inline ata_port_probe()
Date:   Mon, 31 Jul 2023 16:34:16 +0200
Message-ID: <20230731143432.58886-6-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731143432.58886-1-nks@flawful.org>
References: <20230731143432.58886-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Just used in one place.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/ata/libata-core.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c7a29c3ac670..0cd10c44a7b1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5884,14 +5884,6 @@ void __ata_port_probe(struct ata_port *ap)
 	spin_unlock_irqrestore(ap->lock, flags);
 }
 
-int ata_port_probe(struct ata_port *ap)
-{
-	__ata_port_probe(ap);
-	ata_port_wait_eh(ap);
-	return 0;
-}
-
-
 static void async_port_probe(void *data, async_cookie_t cookie)
 {
 	struct ata_port *ap = data;
@@ -5906,7 +5898,8 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN) && ap->port_no != 0)
 		async_synchronize_cookie(cookie);
 
-	(void)ata_port_probe(ap);
+	__ata_port_probe(ap);
+	ata_port_wait_eh(ap);
 
 	/* in order to keep device order, we need to synchronize at this point */
 	async_synchronize_cookie(cookie);
-- 
2.41.0

