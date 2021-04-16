Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C42C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 03:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5984660238
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 03:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbhDPDpX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 23:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbhDPDpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 23:45:23 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2828CC061574
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 20:44:59 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t22so18362194pgu.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 20:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=R0I5avFWdOq59pRrfqJjDzTxhHDm28I+KfqkPMk3PIw=;
        b=0vMrPbNh3fxHn0RZ06cR3XrhTtGNqDOB5m6aOiwmhrpStSupH4b1OOj9SdPaHr54Sz
         3AAQIm1jCGQZ/OaOC6Bu2foz6Vb0lvFhY8uni3scMhD9R0EuZABWQUoi5+fl9VFtMEWH
         ib/vwIlEC7ILLSS2Yi0rMX2ShxTYxeH/g1qv3OtYNgSOWadDrwmVyAY8DGxoBkMIb3EE
         srpVrPG0icrdLfME3QVZqyoRWpjjM3dVsOpZv/ZHAraGrKuf867khwoZcz7Tbld3Ou68
         uOwJHupPIQRQ4LuFW42IRIXwFZWLrY830QpaMr2UacvBbT5orh5eIQA5ji2sPoJA0V60
         KlYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=R0I5avFWdOq59pRrfqJjDzTxhHDm28I+KfqkPMk3PIw=;
        b=D+YhhlI19EjITdbkgFGiebwDBx9eCaZejQ3VzGOQtKnRzWTnx5vbydQE5EPL8F2Gm8
         10JK7xaOTs6Da/MJTjJehVEppcMJ+0/Lz1t5K0Qo8QLfScsSuTJR2ralrchV/BwjX+S8
         UZOcYA0vZ3u5Tp4zDDk9aT2JXmnUhNVfb+QB0D/HZFukinPPv441nLO3tJO6rLdlm56V
         TULvaQ3s6S8eu4HckS5zI96aRTH/7oo/Mf0SGpxZklX/FqLvM2Y3lDqCQ3/Ong42NKNS
         7vxhaxah15A7Y6m3taT8+yQTyVZvVFLr6Qv8OhGUfROt890FfOCTAf9YS6bmHH0JtArn
         gfRA==
X-Gm-Message-State: AOAM533AC9/0ooP9YxEdzcoKNNZbDz3zAoGd8BwWy5zhWppXEaUkYsZz
        bT/f8p8q1HjUUuI3bmcUqRWiUQ==
X-Google-Smtp-Source: ABdhPJwOJ0QxDEkeFtGnsbDEIiZcPEb396n2Ut8LCVG6Sidla1ptN4UEfin+GzAzF5mbT2+sdhw9lA==
X-Received: by 2002:a65:45cf:: with SMTP id m15mr6242988pgr.7.1618544698630;
        Thu, 15 Apr 2021 20:44:58 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id 14sm3320318pfl.1.2021.04.15.20.44.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Apr 2021 20:44:58 -0700 (PDT)
Message-ID: <d2c97df3c817595c6faf582839316209022f70da.camel@areca.com.tw>
Subject: [PATCH 1/2] scsi: arcmsr: fixed the wrong cdb payload report to IOP
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 16 Apr 2021 11:44:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

This patch fixed the wrong cdb payload report to IOP.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 4b79661..930972c 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1923,8 +1923,12 @@ static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandContr
 
 		if (ccb->arc_cdb_size <= 0x300)
 			arc_cdb_size = (ccb->arc_cdb_size - 1) >> 6 | 1;
-		else
-			arc_cdb_size = (((ccb->arc_cdb_size + 0xff) >> 8) + 2) << 1 | 1;
+		else {
+			arc_cdb_size = ((ccb->arc_cdb_size + 0xff) >> 8) + 2;
+			if (arc_cdb_size > 0xF)
+				arc_cdb_size = 0xF;
+			arc_cdb_size = (arc_cdb_size << 1) | 1;
+		}
 		ccb_post_stamp = (ccb->smid | arc_cdb_size);
 		writel(0, &pmu->inbound_queueport_high);
 		writel(ccb_post_stamp, &pmu->inbound_queueport_low);

