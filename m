Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5909DC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCITaz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjCITaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:20 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E18DF6B4C
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:34 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id n6so3119765plf.5
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtXkLpjqkzEtUpPCfZWQmuI25j02ukzVqxS1meSBiZY=;
        b=LYtIIDDqhM2l0r7+3KGYnmVSKwo6pegUvaXNpil1CKCiFCh8Fm7LvNBog0f0uZ9rxi
         6PfP+7SSPmr2Zxym67Lm7et8eG7Xkf0Gn2iegFMgKCkiqYUZ2x1a3IBAC0aCxxE1/uQ9
         voYn/DDu04ULPDVhNGS/UqXtMNOFHnymS/hRByJ3JkOfh+Jeer8CR+WqiynTZOlqT84f
         dN1l1lIeU1rrdALaoCQEzE3sfpdXGAnpjgeKSiR8IETEDfcWZTZhRG+PB0FlRij0tfKd
         SN4MBcnOefoz0cnBs6MmTxp2WLAOhuNkZyTSxAcwAImJl5VAYGDxhceMpMlrSB6rlh8M
         YbvA==
X-Gm-Message-State: AO0yUKWiG7L87AUQSq40To04Pt9p/GJzCi3ZJyJ3Hy9B+1jq/nMIUOW5
        h7zSJ/WwR9c6U038nZA7uMs=
X-Google-Smtp-Source: AK7set+9i17kj2Li7d6HtKCvq2sdyY0l1/y9+Oh5aKbO2pMVITsIp554MuNTg1GfOGrg0wymBGw+9g==
X-Received: by 2002:a05:6a21:3281:b0:cc:c69b:f7e5 with SMTP id yt1-20020a056a21328100b000ccc69bf7e5mr25808886pzb.9.1678390173519;
        Thu, 09 Mar 2023 11:29:33 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:32 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 59/82] scsi: myrb: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:51 -0800
Message-Id: <20230309192614.2240602-60-bvanassche@acm.org>
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
 drivers/scsi/myrb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index e885c1dbf61f..ca2e932dd9b7 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -2203,7 +2203,7 @@ static struct attribute *myrb_shost_attrs[] = {
 
 ATTRIBUTE_GROUPS(myrb_shost);
 
-static struct scsi_host_template myrb_template = {
+static const struct scsi_host_template myrb_template = {
 	.module			= THIS_MODULE,
 	.name			= "DAC960",
 	.proc_name		= "myrb",
