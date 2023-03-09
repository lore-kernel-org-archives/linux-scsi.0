Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6748C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjCIT3T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjCIT2k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:40 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5195CF999
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:37 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id p20so3077332plw.13
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQk/3RH/O3rdmcLxCxnQwypnwRP+bkVFL+TTmjyYx3c=;
        b=TAedsUxeRIcudwnTN8nH9RxB3Cc736SjNeMO8bjfp4EfdIyO5q7Nq5pZzacfMBADHh
         3ruTk0qBaacsCQLPRcmt3GMtmMtbcwjShiqFWIuPOWWWZrs0imy8A7xIrzjpq7nRdGRL
         fLlueC8Uy1IFoF9DiZSZqzRB9A4Rl0l/Ar4s/v/ciSiM92ro3SiUHzBRwPrdy3nXsb19
         vI+TFnyv90a/Kd6D2IYGzbTHQsu85Bxj9vnUJWkxW5LnGRCcfaafK43Xk7b/EEE7+Qss
         PFPth1ZJyG/nLuOFSWRO6IVISZBmgJfGkcgfIQDMvzNXjABYUx/nRz3BUfJwTxX2rMpq
         f3eQ==
X-Gm-Message-State: AO0yUKX+nTdpyRZzJPpdmYYd8QdZvQj6hTJ//6qTWZ7g19s84yMPsebD
        upDpuYjjhBFRUNYSXAdIFUQ=
X-Google-Smtp-Source: AK7set/6tiBwbGcKwWhq1jUPbyEECUo4AXwpGdm3RWt19djQmcVm0/2Z2sDQzgDMNXXwxY21MTvU9g==
X-Received: by 2002:a05:6a20:4c1f:b0:cc:6d4d:57b3 with SMTP id fm31-20020a056a204c1f00b000cc6d4d57b3mr16601278pzb.12.1678390116651;
        Thu, 09 Mar 2023 11:28:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 40/82] scsi: gvp11: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:32 -0800
Message-Id: <20230309192614.2240602-41-bvanassche@acm.org>
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
 drivers/scsi/gvp11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 7d56a236a011..d2eddad099a2 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -222,7 +222,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static struct scsi_host_template gvp11_scsi_template = {
+static const struct scsi_host_template gvp11_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "GVP Series II SCSI",
 	.show_info		= wd33c93_show_info,
