Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD68C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjCIT3Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjCIT2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:39 -0500
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB57F9BA63
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:33 -0800 (PST)
Received: by mail-pf1-f177.google.com with SMTP id ay18so2212077pfb.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=07ZQaPfc2uMfGLVpQX+PlaqpVOWVCeYsM+H7InAN6kE=;
        b=MD88z63gUB2U96sHTOg512OcNJXtWJpO4tc3rfv6yX2h/No4guXJC5L35FI21J1Irn
         nj7NdF5Ar9v9Z7d3mPybq7svFIU4XeL2MOVtiQpDKG2Owx/lwdB6A/bShs73EJ8BF0hT
         +5N8951dvok/SgJKHkS4+Qks682mTadshqh5/pkNFIL/rPwqPHLkcwFssXsydStM+SLc
         B03IwbiKPHDcDspf6LLNz+LDeU7UmFd0u+if1JMZixVwNCVOC6w7vYwlj5F2spnTIU0R
         yacotXxjI7cxEW/o41Lsv8Rc43I77VGUx+iDrtJkcaCx6j+8RGHtduANUfF3AINELkJy
         OKnw==
X-Gm-Message-State: AO0yUKWERnz0h6JV8gRUNiTt5ziNk8bSDD6wZZ58tYG7oUcCyR0YvkoI
        27sj4tqGlDY4AYtI9Tpo4U4=
X-Google-Smtp-Source: AK7set/ExtIqvWUMAUCsG/GLC14EmJcLoVftDjkHGveHHyFE0cYAQB9HskxO2Lnx2Wk+TdaZoJpTjQ==
X-Received: by 2002:a62:1758:0:b0:593:d2ab:fdfb with SMTP id 85-20020a621758000000b00593d2abfdfbmr18103512pfx.13.1678390113287;
        Thu, 09 Mar 2023 11:28:33 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:32 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 38/82] scsi: fdomain: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:30 -0800
Message-Id: <20230309192614.2240602-39-bvanassche@acm.org>
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
 drivers/scsi/fdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 444eac9b2466..504c4e0c5d17 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -496,7 +496,7 @@ static int fdomain_biosparam(struct scsi_device *sdev,
 	return 0;
 }
 
-static struct scsi_host_template fdomain_template = {
+static const struct scsi_host_template fdomain_template = {
 	.module			= THIS_MODULE,
 	.name			= "Future Domain TMC-16x0",
 	.proc_name		= "fdomain",
