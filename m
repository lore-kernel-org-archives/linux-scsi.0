Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B24C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCDAem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCDAeJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:09 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BA765465
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:50 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id x11so3265pln.12
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D4THt1XWxiaNA5/lNNqEHujl/AmU30SJrb0Ru4wIejY=;
        b=JZYxyXDJQmfDa0NZlslecGIbj9R8FRGKmdWGoOho7NJKNO6BKtmKaE+8bTJFPmUhJf
         cYPKCMjHfHF+7OQNRa46QW6G4EYXt/+LANE5cFVvSnUjpZG7iMl5KjY2CNbkUrDtK+YR
         9S1cF7PxfLa+q0leJenEAU2+tgHYxl1Lr6iZUc2h13ctsiWeUm/YBgSTrdOn5u8/YV9a
         bvoDJ5gviK+gPBXbNF6ZOjG076AYt94h9Qj9IS5IYJNTi2DIh0fL/lu+3sa62h6LQJK4
         UGLvAMxnsnQXUW44U+blCQuq2i+WKOp/WB7eGnYzanjZaQkbSjvUUK0DUUpgceO8QxEc
         RwMg==
X-Gm-Message-State: AO0yUKVFjGkDE3+WXG5CPw3qPmB1au85a4I3jOyNvpOK2/LT2D1mZpJ6
        w9kiEyDa4uyWJwOFADkshIY=
X-Google-Smtp-Source: AK7set8pop2XCqck+rU1Vzzlq5/9lhr3HF3fDnO9eEHCUXSfe2KPPNpWClrxWVAkguuuoy5XJCXLyw==
X-Received: by 2002:a17:902:e54a:b0:19d:1834:92b9 with SMTP id n10-20020a170902e54a00b0019d183492b9mr3744198plf.56.1677890019477;
        Fri, 03 Mar 2023 16:33:39 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:38 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 50/81] scsi: mac_scsi: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:32 -0800
Message-Id: <20230304003103.2572793-51-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mac_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 2e511697fce3..1d13f1ebc094 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -422,7 +422,7 @@ static int macscsi_dma_residual(struct NCR5380_hostdata *hostdata)
 #define DRV_MODULE_NAME         "mac_scsi"
 #define PFX                     DRV_MODULE_NAME ": "
 
-static struct scsi_host_template mac_scsi_template = {
+struct scsi_host_template mac_scsi_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= DRV_MODULE_NAME,
 	.name			= "Macintosh NCR5380 SCSI",
