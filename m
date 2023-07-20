Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434F7C001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 00:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjGTArG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 20:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjGTArG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 20:47:06 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BA91BF7;
        Wed, 19 Jul 2023 17:47:05 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4fb7589b187so326148e87.1;
        Wed, 19 Jul 2023 17:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689814023; x=1690418823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mEX5QDv7Z54yUfmrfpPL3p1GUJhWKhMNNRkjdNIDE2w=;
        b=TswhdFFUJ0tLUS2Q/fEGncH9+uSkOlbwzSrsXF5lF4QZ5iLVhCunk547pFl1lOFb+w
         bPVu6Jm2CLdw0rIzCxymr9NgxcYdBW2Cj4Jl2AuoBQovyymu+ca3nDEkCmUaxH8aWRSI
         5HqI4Ja8c+60sn6GL7MP0bTYNcqH9DyPMwEWFXQ4CJ474GoOyxpzQ9XrO7bfA91zovjR
         qKW9trUwyOFg9vR3G7sLS4CqYBGnB///+2J9djAZk1p7+8eMkvX0A+Vv3cwZb2i72hOy
         SNwzUxlre3pOJKTxfRvfPx5pULMkfh/ethwO8RBYm4sYCu/xYiWsRcQ6rQa6jrzuGCzS
         ohTQ==
X-Gm-Message-State: ABy/qLbosABEWM/oeDqPycPakRFjdsD5DCQD7cCUrs3MT2ByzF+SPxkI
        e+cxZ2shWsYMha9oXQ32vWvDY8TJXWRQ85fp
X-Google-Smtp-Source: APBJJlEktwqyxGEBUgwhu0XogKRZLxsUI+shgMOv25AJBGMGyKPOhqPitQKDXbcYawNcFxivNrsr7w==
X-Received: by 2002:a05:6512:74:b0:4f9:710f:f3a9 with SMTP id i20-20020a056512007400b004f9710ff3a9mr924230lfo.58.1689814023291;
        Wed, 19 Jul 2023 17:47:03 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id c25-20020ac25319000000b004fb77d6cab3sm1185362lfh.261.2023.07.19.17.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 17:47:03 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 3E7F13EF3; Thu, 20 Jul 2023 02:47:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689814022; bh=7dtWz14fhEyUAO8Rh6eg1y8Xxl1vsOjRcR1BL43lw7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3+tNffYYC2C19UboKpERU3J3LQw4Tp5D9tWv+H4VksyNX6rIWsGHtD3Olpo9b8m5
         Z4JiuPO3AmRRk0ZLbBLNElKIBqrrCTZxnbVR+gxRhn8zYDCK9gMxtfxuqEg1LUOazR
         gGqGHcWMU8S06Jgfx6CRocFh5O0JVm1gdw/B5ZTk=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 2858F3F0D;
        Thu, 20 Jul 2023 02:44:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813854; bh=7dtWz14fhEyUAO8Rh6eg1y8Xxl1vsOjRcR1BL43lw7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwuxTiAr/rRDfTVCAQ6NTRrABb8+T5MZCMWsWVkYnWmnGu29hABIYbx1uQWDgA291
         CW7mtJ5c0Qb6svfGJVQxYZcfQy5p3LBdLCcx5/CC9LzwkY16sghb1y3qxg4HTeQ8xO
         luKjrDFVhHKMK7LX3Cr/NxvNmhdO+l1C00zjBpvM=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 5/8] ata: inline ata_port_probe()
Date:   Thu, 20 Jul 2023 02:42:46 +0200
Message-ID: <20230720004257.307031-6-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720004257.307031-1-nks@flawful.org>
References: <20230720004257.307031-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Just used in one place.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-core.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1f0306522649..c5e93e1a560d 100644
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

