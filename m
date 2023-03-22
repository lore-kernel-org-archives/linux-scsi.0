Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD98C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjCVT76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjCVT72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:59:28 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE23E62B6E
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:06 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso20241263pjb.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=THmZYnay788Z96nrcUtNDJXy0MOLvmys8mHIpIwdLfY=;
        b=X1cFadHhBqS1ENwELJ752wLC4qNMVMeYN4ExbQrt91yr+h/+jkVUX4bE4QLRx/aR/w
         BTHzfuFLSbJPJBGUiavnUDCOLmDWsf1xZ2414N7JOcMOldendjGM8j7/SgALNPmclzbS
         rbuPXPZVBMQlNGzyb2Tfe3wjH2btd7iYTSziexR9ufuNpmTwxdNxOH90O5RVcHX6Ud31
         q5dBmJQ7vSk4H3DUkgEEzJDVq/iMdhafLBXl85e/vBEs/u8i+OFrTytEdqbhg/eVIFIb
         HIHi6PC23wNWP+y4QVUGwSSL30cM3pI3G+iJiXBOJwcQpckGc4FAURNmXslzOh+C/jHw
         CoJQ==
X-Gm-Message-State: AO0yUKXS7fTWL1G8Ajt9DTFzoY2WmmuNj6NbBIZ/uDwgJg0fm1QjBAFE
        arkYjrwTscyEnod3fZ81srQ=
X-Google-Smtp-Source: AK7set+yW/QfqLvZhn20s3y13pUzmtTbD4rTCfksXyCm6OmUzQUkbMqMge0eOXA0zrZ6YkUjFbckHw==
X-Received: by 2002:a17:90b:17d0:b0:23d:1a32:56d5 with SMTP id me16-20020a17090b17d000b0023d1a3256d5mr4931741pjb.27.1679515085116;
        Wed, 22 Mar 2023 12:58:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 51/80] scsi: megaraid: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:46 -0700
Message-Id: <20230322195515.1267197-52-bvanassche@acm.org>
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
 drivers/scsi/megaraid.c                   | 2 +-
 drivers/scsi/megaraid/megaraid_mbox.c     | 2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index bf491af9f0d6..3115ab991fc6 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4100,7 +4100,7 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	return rval;
 }
 
-static struct scsi_host_template megaraid_template = {
+static const struct scsi_host_template megaraid_template = {
 	.module				= THIS_MODULE,
 	.name				= "MegaRAID",
 	.proc_name			= "megaraid_legacy",
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 132de68c14e9..ef2b6380e19a 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -325,7 +325,7 @@ ATTRIBUTE_GROUPS(megaraid_sdev);
 /*
  * Scsi host template for megaraid unified driver
  */
-static struct scsi_host_template megaraid_template_g = {
+static const struct scsi_host_template megaraid_template_g = {
 	.module				= THIS_MODULE,
 	.name				= "LSI Logic MegaRAID driver",
 	.proc_name			= "megaraid",
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3ceece988338..406a346cbc08 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3505,7 +3505,7 @@ ATTRIBUTE_GROUPS(megaraid_host);
 /*
  * Scsi host template for megaraid_sas driver
  */
-static struct scsi_host_template megasas_template = {
+static const struct scsi_host_template megasas_template = {
 
 	.module = THIS_MODULE,
 	.name = "Avago SAS based MegaRAID driver",
