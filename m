Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BFDC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjCITaL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCIT3Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:29:16 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05F2F16A0
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:13 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so6603996pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=THmZYnay788Z96nrcUtNDJXy0MOLvmys8mHIpIwdLfY=;
        b=152eKzOk4ljhGZCDQ4Fvf3rkPyx3E2dty/LNdwBDnpo5PrrlnNvDrzVIi4xD68POkP
         PS4tTEWiwCd8clwxF9tAAwz6f3+ajah5+XNtkt0CKQC1BFsZ+QOMooU6bjKvjwyHfK0C
         4mnlGtGAZ32sLCihWhYFvInbQu3ZxbMKPFKI4ryzB3E0xD1jljZELTylbxIJnV77I/B1
         /O7WHrxHalpSh3kElMLZkwSdPWzWR+0eBKO7O6vq5+toouk0C07ONTczE4HAKpaindks
         eYwHd4WFCpQuVABwWxJrQmKPZW7sknVxnzKP6DJqhVv63S61WijaotpKo7vodiYhawo/
         VYzg==
X-Gm-Message-State: AO0yUKUTc6NImJGTAltOlayuVU7GOIFjQl/xRwKK4V/oPLqHJtiZ59+Q
        tHwpYMvdKblRY9jOmwdD0iY=
X-Google-Smtp-Source: AK7set8SNoA83pn9KRFbhkU8AMRIuQPXbEctu+B21Sblo8VR2o6mIaiDql+MGlLv0Z2SBzjxUpAPcg==
X-Received: by 2002:a05:6a20:a111:b0:cc:d386:ec1a with SMTP id q17-20020a056a20a11100b000ccd386ec1amr25536198pzk.2.1678390153355;
        Thu, 09 Mar 2023 11:29:13 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 52/82] scsi: megaraid: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:44 -0800
Message-Id: <20230309192614.2240602-53-bvanassche@acm.org>
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
