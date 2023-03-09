Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D2AC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjCITbZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCITam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:42 -0500
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9186420C
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:51 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id b20so2200067pfo.6
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/bKU77JUcmdCiHf19hl22iuzy8frSUKxUFEkHosyM1I=;
        b=W4l8lO33xG1MycfT532jzuj0gtKky31tLSJRpJSzxEGJZqUFra/NXW98afpP+RHhif
         tAjlYGq4YF+BaFdFgjcnPVCC2bWBKsZTh0Oos1Fwr1yNqKr4V9uarmGsEhpc8a49lW2L
         BCwzdNqjq/XK1UepA1bpcGdslFO7aSG1GZbRd7eG4UpjOm8SPDQmkZ9aGfohYW1FgdfF
         h8esWv8c5XQ6TawxKfeR8JaE8lM2cMxEVLqBHwoRXkIuBdZx7PAGWU41dn75GxUYjFP/
         QhO/jjIylvefAON1Q4Iyu3P8DUMSk7G+XjlFW319T4dQpQi4ey+1IuQfooHNP9/TRzco
         w+ag==
X-Gm-Message-State: AO0yUKWRqevsBFWIQrm1OXug6MkIh1UzM79op3mgD5EgJIepsG22+yMV
        rtLOonQtcdonqvvSayaVNas=
X-Google-Smtp-Source: AK7set8FbowOaj9Cci/94IuIG+Pz+D8N3eLuq9i4dqjKCRoHf+CJU9RwjOJ9b6UZFasG2/dxu0QerQ==
X-Received: by 2002:a62:7b0c:0:b0:61d:e8bb:1cb0 with SMTP id w12-20020a627b0c000000b0061de8bb1cb0mr4606904pfc.1.1678390191176;
        Thu, 09 Mar 2023 11:29:51 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:50 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 65/82] scsi: ppa: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:57 -0800
Message-Id: <20230309192614.2240602-66-bvanassche@acm.org>
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
 drivers/scsi/ppa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index c6c1bc608224..909c49541984 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -972,7 +972,7 @@ static int ppa_adjust_queue(struct scsi_device *device)
 	return 0;
 }
 
-static struct scsi_host_template ppa_template = {
+static const struct scsi_host_template ppa_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "ppa",
 	.show_info		= ppa_show_info,
