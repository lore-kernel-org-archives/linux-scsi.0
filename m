Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BAEC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjCITao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCITaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:02 -0500
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDE8F20B3
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:30 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id h31so1716758pgl.6
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ZgEqZv012LUY7T6LHCDKEctFV0D//J8gA9RwCm+Bl8=;
        b=Xi75J3Y6Fip3/fHYE/KOy20mRVVgNEW06BGeHhdbGzVb/KZcf+VnRf4VGogMxas5hp
         nTBhhNZ+La1wDFkbhr6PnrhIXH7NGoBBRdqvC8t1ksRxGEWsZQu7gjg/X5B4WlJtKcP9
         ynTAB2QSuhOuXe6Usz6iLTCYRj0wP49usg83GsSPtnq7O4nRjIz33ZN6qZRuqt4UENaW
         ksm+f+TDGQIdGtAr8YedbKakJuxbP9NkJkurny0zfBG2Eq458re8+lYAkMCMOx2JN/06
         n9eGS8aICIXoIoL9VifoEPJcKa5pY3QVOviAdKx1JCiV4f3BuY+xDjiSn1EQc9NVF4YX
         5kPg==
X-Gm-Message-State: AO0yUKUYPRYBbKmwrcG42oyTP8DOlmrY0ulFlNeYqC0Gtg9JyTW5rkEk
        cyK94Lqgpe9liHYQRUqitU0=
X-Google-Smtp-Source: AK7set/s1UqPx44ptetSTF1u48c/Z6DydgabYLol+5Vo7HAtjEv2B5snKyfi0Ni0CCKGZxi5RC7A9A==
X-Received: by 2002:a62:64d0:0:b0:593:d276:1931 with SMTP id y199-20020a6264d0000000b00593d2761931mr18497009pfb.14.1678390169909;
        Thu, 09 Mar 2023 11:29:29 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        John Garry <john.g.garry@oracle.com>,
        Alexey Galakhov <agalakhov@gmail.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 57/82] scsi: mvsas: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:49 -0800
Message-Id: <20230309192614.2240602-58-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvsas/mv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cfe84473a515..49e2a5e7ce54 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -29,7 +29,7 @@ static const struct attribute_group *mvst_host_groups[];
 
 #define SOC_SAS_NUM 2
 
-static struct scsi_host_template mvs_sht = {
+static const struct scsi_host_template mvs_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
