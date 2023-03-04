Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FF9C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjCDAek (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCDAeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:08 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580A965464
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:50 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so7857528pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=THmZYnay788Z96nrcUtNDJXy0MOLvmys8mHIpIwdLfY=;
        b=w7uWc+Q09QKz47fyicwCr1JtqqTGwST+WG/s65koKN8961V3IE8fTGzeKfwRIU1yOm
         7fgNxftkkQNG5z5UJ0PFrOv3pv5AbwjoEkDLHTEGgPOtwjoOmwPAdVqlYciBDpTrjp4R
         K9zqwrre1xihCtD9XJK48GPpUNTmqxN4Oscht9aCqBCUGPmQoP6b7VgAOnl/dawE+v2p
         UKdP8Jsdc4cVnJj7SikauGLPiYxMYirki7vqPwoh35nQn0y9EoBFlF1OVHBaOs8kl0dZ
         cUJZ0occw52NGrK8iUKtjrlIjvDB4A5MKxpLwo7PvgLkoSn2rUFTRI7Pe3Xj/6K8NXlP
         HSdw==
X-Gm-Message-State: AO0yUKUUf3QV2ArhfxnHJAJXAt6BPtrh4aBLhGfRSotNoNMoB3Yp536P
        MqGpY4wNRnEdnik1D70ci+M=
X-Google-Smtp-Source: AK7set/LAai459y+nFlo0TSiUZ7dI1FCdx9tV0d85RNDPM+mkfMlx4LI4c4dKciaKwDEggPJpHF69Q==
X-Received: by 2002:a17:902:d492:b0:19c:b7da:fbdf with SMTP id c18-20020a170902d49200b0019cb7dafbdfmr4653616plg.26.1677890021575;
        Fri, 03 Mar 2023 16:33:41 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:40 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 51/81] scsi: megaraid: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:33 -0800
Message-Id: <20230304003103.2572793-52-bvanassche@acm.org>
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
