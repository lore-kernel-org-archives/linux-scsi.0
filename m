Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22341C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjCVT6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjCVT5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:53 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718B567003
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:33 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id u5so20279587plq.7
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=07ZQaPfc2uMfGLVpQX+PlaqpVOWVCeYsM+H7InAN6kE=;
        b=ixKKgrHwgZHWuVD6WepiKB5F9E7/aWhaD/BWCmaXA2YuTFF3/wSh/kN6Jghg5XgHVS
         aejFEc8I5VWlLHZpg/GTzf72jELwF4mxoBD7Sd+kj4pHJHNFsPUClIGoijC5KwrZjw0/
         Hz4T0yBBbzfRVSVEafjWvkhNQn3m8fAhwBiPHV3QjoMvJ85py9O8TzpViISM5CLbT9VN
         zqK9TRgmB9SYZ8imJSlk8vAeoA2zYZr1gZeoKosfAbdi62qTvWFStQYMv2JCj0MHMQ+I
         b2tkUzFtVEPvvzN6nN82J3/zVT+E4RjSdrm4u5ODHSbyTNIzujsW6KG2/dCTOP+K044L
         YdBQ==
X-Gm-Message-State: AO0yUKUvjz9374qEI8aqf2MFKsuLl5dPflyQYqoiLR36PdQEakqYA21X
        f4rPXou/zj6PPEISeE3O9fM=
X-Google-Smtp-Source: AK7set+D4OL/Zqbym1eSaEAqDEVarGJ8BBrKxcqsh9rkIobj77VdFK8Evu66meJUyy0VyJYKH6ootQ==
X-Received: by 2002:a17:90b:1c8c:b0:237:99b8:4eef with SMTP id oo12-20020a17090b1c8c00b0023799b84eefmr5019694pjb.9.1679515052677;
        Wed, 22 Mar 2023 12:57:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 38/80] scsi: fdomain: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:33 -0700
Message-Id: <20230322195515.1267197-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
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
