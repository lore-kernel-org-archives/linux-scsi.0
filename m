Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24883C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjCVT5z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjCVT53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:29 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD00E6904E
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:05 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id c18so20276137ple.11
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wc8ynnG/AUp5Bu6EUuP/BB+ayz5OX1mJgbC2WVbd21o=;
        b=UjFRIlNPqJjSKEA2MPxhPFtzwVXsodhDr7lhC40SlNvSWBW+Q/SIjTrRqsmi3CYLyG
         qLC5a2BYJHUKgbwJLtFA91+rp7sDRsF7VjdLUwm2ritq9fLXT85hpB3bmixb2Al83IwH
         K98DuTmaQfFC0LatgsPqr2VtXOr+gx8JLJkfjR12CkYZ4GF5mIb64H4E97/EHzJT8du6
         /69HSJq8IE0DFOyYWPNSJ3t4cCfwbUPvI6rsoO6E3iLf4MoPgWEo1BPCBTFgE9F1Z+Uh
         jewI3pfVn8dPStBCzohwpCOPy0A4tkMAJ3nF74bNi5ojx5M6AzpXd0Y3zgAwquK7K2Q4
         quRw==
X-Gm-Message-State: AO0yUKUlJAVT7ZNZJyDZHhjDHdFW9ffgP+/ZE8PFnmcOQh/elEx77mVI
        cqOxdTKmFKpPFlVI+SgTBpM=
X-Google-Smtp-Source: AK7set/IB8szTJi8zyQh2hTEieGFRs3E7xXOQa8IkNudi9o/sC3bztkjihrXyMob9gZTpAjxfBhyxA==
X-Received: by 2002:a17:90a:bc85:b0:23b:2f4a:57bb with SMTP id x5-20020a17090abc8500b0023b2f4a57bbmr4811751pjr.10.1679515025188;
        Wed, 22 Mar 2023 12:57:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 23/80] scsi: arxescsi: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:18 -0700
Message-Id: <20230322195515.1267197-24-bvanassche@acm.org>
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
 drivers/scsi/arm/arxescsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 2527b542bcdd..925d0bd68aa5 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -238,7 +238,7 @@ arxescsi_show_info(struct seq_file *m, struct Scsi_Host *host)
 	return 0;
 }
 
-static struct scsi_host_template arxescsi_template = {
+static const struct scsi_host_template arxescsi_template = {
 	.show_info			= arxescsi_show_info,
 	.name				= "ARXE SCSI card",
 	.info				= arxescsi_info,
