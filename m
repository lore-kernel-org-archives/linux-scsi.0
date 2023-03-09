Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A99EC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCIT2F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjCIT2B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:01 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6CCF16B4
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:46 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so2903692pja.5
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PUVyuRxOnhRj9LsT5qhnnwF2XXY/eNUcYo7//Y4UXag=;
        b=EX316gRKZv+kSZi1ppEjvHStOvhFcoNCNfbFHIaQWhAS4EfpvoNyrYP70DjhS7UkIF
         KWiN/qSmPMPJGlTJ2LPtrATyY0WBzQjo1nNT2NYuEhnLaA8rUxXNYCVZhoHIGvfb1VnM
         bEoNPRJ0bMJ1AOjxR3L74d5zNZh0b8XfemmLikIEJzBoZ9QIQVtHg11eTGT7kYA4SAOG
         lYB4N6GCaFSagUhzvGWQEF87bhpowEEir/1I2ziDuhTD9xU6gwBlMUUSpx+fHPiH2gWE
         OXI8+eGlqUyPb+2DM9XK7UgO2yfCLcvywFBsLcEv8Us36mXNitwmDp9ObAtMpz33ABMm
         U1uA==
X-Gm-Message-State: AO0yUKUnPrqAjxjrVFNx/pU3dip0bNaifn9r11olqqpd+skLDdkxtIXJ
        +mw95hhmKFppQeQi8Ybw1nw=
X-Google-Smtp-Source: AK7set+IHO4ZjFNhW1dvtiFySr2QurtsLQADOiLAaDzNLCWPk0U7uG4oCNmhRWrw5vVuVzvCK0AFnw==
X-Received: by 2002:a05:6a20:3c94:b0:b8:8a19:d6ad with SMTP id b20-20020a056a203c9400b000b88a19d6admr25434399pzj.24.1678390066063;
        Thu, 09 Mar 2023 11:27:46 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:45 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 20/82] scsi: aic94xx: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:12 -0800
Message-Id: <20230309192614.2240602-21-bvanassche@acm.org>
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
 drivers/scsi/aic94xx/aic94xx_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 954d0c5ae2e2..f7f81f6c3fbf 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -35,7 +35,7 @@ static struct scsi_transport_template *aic94xx_transport_template;
 static int asd_scan_finished(struct Scsi_Host *, unsigned long);
 static void asd_scan_start(struct Scsi_Host *);
 
-static struct scsi_host_template aic94xx_sht = {
+static const struct scsi_host_template aic94xx_sht = {
 	.module			= THIS_MODULE,
 	/* .name is initialized */
 	.name			= "aic94xx",
