Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4096C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCITby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjCITbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:03 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0D8F1447
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:30:03 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so2908605pja.5
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:30:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x8zmmOkwIoIKAWyiwthdityD4hZhxjndZB0ZAklYRAQ=;
        b=VSNRwa4GMTmYyhPlTJS7IneNUHA121yORDLAAH2zewVDKOCvyL5rzOK+9M9dz2/tZV
         id6+Bz9jQfcCARXWeVtjKaElKVTYMN6fSWosswq24jnDzAaUOPN322l8woTQxu2T8RRF
         Vo0t0IFCUaRHTXIKXuK59j95rjSYy16ffAMEJjGbzi+P/mkINwHqoS54+QGbEv/YSq1R
         MWMykNLwvGlxWRwrSFpifr8Meun93iy/mWVBlR0eM1au33TGr2aNHI2i5AtdLqsmKRCI
         SiPZlQeaMm2WYdxEniDyXkJDif4ATIrZhS71wLLhQxFqyVHb0VHbEWcsO1js0mstdEtS
         Mccg==
X-Gm-Message-State: AO0yUKU1yCM+DM/Kuk7E5t8tsJViYW7tqG8T0Ym5Bti80PEgaL5ABcV7
        u9iQCMKDn5l7GsbogRJrWOmXFq908hf0FQ==
X-Google-Smtp-Source: AK7set9ZMkVPz5fvUU1iy6Sl6whnlic4wd7Ni907+WBaeBcWHXNXkM/lju8/HjaYsUu3tF+nsofvxA==
X-Received: by 2002:a05:6a20:548a:b0:cc:d891:b2b1 with SMTP id i10-20020a056a20548a00b000ccd891b2b1mr29840631pzk.35.1678390203001;
        Thu, 09 Mar 2023 11:30:03 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 72/82] scsi: snic: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:04 -0800
Message-Id: <20230309192614.2240602-73-bvanassche@acm.org>
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
 drivers/scsi/snic/snic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 174f7811fe50..cc824dcfe7da 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -100,7 +100,7 @@ snic_change_queue_depth(struct scsi_device *sdev, int qdepth)
 	return sdev->queue_depth;
 }
 
-static struct scsi_host_template snic_host_template = {
+static const struct scsi_host_template snic_host_template = {
 	.module = THIS_MODULE,
 	.name = SNIC_DRV_NAME,
 	.queuecommand = snic_queuecommand,
