Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A4CC6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCVT7R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjCVT6S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:58:18 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D0E6A405
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:45 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id j13so19506328pjd.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q5YcXSUW/MYMp0sgEwmo/vVQvOhQmpTmjGGC3D+urCQ=;
        b=IuK2DHQ02sUGM9dhLDGOUr8NRRWaKs65k4rupQAlh7CT3mrEfOPV/z54dPFDT8L+QN
         YmacHevEST2SsCqsPVtaiwXGVqcvtAPH3/bpl2CjSPrG8eD7fRV6Qyk7yLaq3MvNcORI
         6yGCJOYgoAeDWjeDeoxDJ1PRO02coerCJAE2lkwuYWdLqgvzYqPcidfmeUWBPcSOnPtK
         XCMRkahvHUSwGIxt0hR1hTO8X43S+aooAo8MWWDwTbystcs8sTyI7p2YjmZpd9Dh+AB7
         cfmrPBt/KSWPU42Z4umbwa9ZDpJgjxids53NKg1vH1USkg7rXftsxMxicrKI99FtfbqO
         8cEw==
X-Gm-Message-State: AO0yUKUishX4HERltrIPdsxZQ/11Kr7jnsuRqjbYitZo+GQO5HBCRLEa
        XPV4NAj5VMMg4m+78mc9pxc=
X-Google-Smtp-Source: AK7set97yaJSUTPULtCv4BM7NmuogAhwlP6VUEdnob+2Im9PXD0af3k1k/rvoEgOYnqvfNeVO4IG8w==
X-Received: by 2002:a17:90a:1a51:b0:23b:5155:30a9 with SMTP id 17-20020a17090a1a5100b0023b515530a9mr4777392pjl.40.1679515065052;
        Wed, 22 Mar 2023 12:57:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 48/80] scsi: isci: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:43 -0700
Message-Id: <20230322195515.1267197-49-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the ISCI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/isci/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index e294d5d961eb..ac1e04b86d8f 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -149,7 +149,7 @@ static struct attribute *isci_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(isci_host);
 
-static struct scsi_host_template isci_sht = {
+static const struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
 	.name				= DRV_NAME,
