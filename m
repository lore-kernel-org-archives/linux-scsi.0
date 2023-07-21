Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A820EB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjGUQiG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbjGUQhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:37:41 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA5B4490;
        Fri, 21 Jul 2023 09:36:24 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4fdd14c1fbfso3482418e87.1;
        Fri, 21 Jul 2023 09:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957382; x=1690562182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+/ZKJBIB6DuR4VlhaT8PV2SyzaNI8TYstT+J3zNH7k=;
        b=GcW0vR8UMPDjGdgaEEm2ApfhIqpzLaUd+mm6ZS+Yx2yisQwXseOPIXVD9YqQaBESAh
         1gkHPMo9/sga81wNB2Lk1BG9ud+wQ2BsIl7NolHxcWGJtehjqu+pGZdUeqbOwhRJL/dk
         VmvEBwcEZs4qrJGriVoJj81eWTk6KaeAPdLbQLJXjZFm69adtCXogtdeEkCt8pAllDf1
         gGNterBMRY2QYBQbfFFeWXsj87frnS3yQihTrfnUmsCi8haMyMjR//eQFk8GzsuExGmT
         Ci10YpAM3/ylmHn5Yr2nn2SeUnn8Jyk/ryU5CABYPBPDKe9JqApZQJFpF3XlnTbtYbOY
         u/gA==
X-Gm-Message-State: ABy/qLYfJN67ZFREmEdx0jZ5gYTOntwWMZO5zqoePLJQ2uGkfrgSR3Gn
        kp/+U+XuGwT0fzLgjcWnxMRp7DYLMM5auQ==
X-Google-Smtp-Source: APBJJlFXRtoeU+aVHzjVI0a9RPh1cp3/6Ud/8TIJ7r6ucIlbT6OI17OBrYcw8S+Gl6chpA4lRk16VQ==
X-Received: by 2002:ac2:53bc:0:b0:4f8:68a3:38d5 with SMTP id j28-20020ac253bc000000b004f868a338d5mr1663609lfh.66.1689957382304;
        Fri, 21 Jul 2023 09:36:22 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id r6-20020ac25a46000000b004fdc0023a50sm792976lfn.232.2023.07.21.09.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:36:22 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 33C363F2E; Fri, 21 Jul 2023 18:36:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957381; bh=lRQ4WFOJhadvbdehtTtW8JcqdrYsawHZH7QjQ7Pw84Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D93EJ7SYjPN5En47mDGisvQeKDBIEGebWEJ0iOFdvvyeUMqNK/pjFCvqDY1ilGome
         VnaEqt8RWixtPpW/iSMX6CLpzW087OjRygwG6NxMLNZllvjFw6Ie8wG9xQZQTDG1BW
         rrchQWvwKvH7atVoehYT92psMHjJD2iVmiV5O2O0=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 322513F45;
        Fri, 21 Jul 2023 18:32:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957174; bh=lRQ4WFOJhadvbdehtTtW8JcqdrYsawHZH7QjQ7Pw84Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtoK7wGEcsP3J6olcb8JNpkEHAGjlVQrXMMZPOBZEn2AGRrKKqkol7iSkXSQzcGMj
         BIW+2BFjPj4733PTkAayMPZ9dR09EveBRamSbgiLQ1QrgG23ilAbpgf9tLOZCh4lh5
         EVWhiX966XuavOj6O3O+lUHrRnqzKur8YxWHyKGM=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 5/9] ata: inline ata_port_probe()
Date:   Fri, 21 Jul 2023 18:32:16 +0200
Message-ID: <20230721163229.399676-6-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721163229.399676-1-nks@flawful.org>
References: <20230721163229.399676-1-nks@flawful.org>
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

