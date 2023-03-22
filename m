Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3DAC6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjCVT5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjCVT4t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:49 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3392764B2E
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:41 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id u5so20277702plq.7
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BuZNm7pWcFvgUfK4cHpVc5oD6Ukdo+4KIxZBo5YAOF4=;
        b=747AO4m1cBCcs2gtchQJANvBhQeN+OnRvyPKgYqDHlNJ3gyAKquX+qy0+N4c4G6kl9
         bWOBalJASiSJABrEXt03IB4Igmj3s94jEEcO42hLMn1leek+yMt2Hl+db7S8eEaq8Cml
         DwR9SG47QiTuPjbw5ZRDFdQoqUyaWIiVy0ENN4ofberBbACEczjZ5L0aNqxyiH++GLYS
         vqnICXwwymieFXmsa/vifHB5rQbay0kaRlMhQckGr/0VhlVW8s3zjdiH8NzNpUGFikqt
         45IYbg9Z7aX1nXkh8O1rIZ6JDp5lIEODH+ky0D4XrtDcPMGW7yFB2f7LzaO0W2ScqejZ
         FUFQ==
X-Gm-Message-State: AO0yUKV8aYDXz6pKLXh6FAtvq3YEev+vCha7vll4kAbQaMKrxxRYpVwF
        l+TUeunrxwbr6e8YhSH2hduaWFjB5sY=
X-Google-Smtp-Source: AK7set/t+RgLyBv4ZNktRWHKx68fqY6Ssli3pQCyfmGXgMwRLfNmv+vJLfGtrzZc0+pWzR8vfuW2rw==
X-Received: by 2002:a17:90b:3ece:b0:229:f4f3:e904 with SMTP id rm14-20020a17090b3ece00b00229f4f3e904mr5589233pjb.11.1679515000591;
        Wed, 22 Mar 2023 12:56:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 16/80] scsi: aacraid: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:11 -0700
Message-Id: <20230322195515.1267197-17-bvanassche@acm.org>
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
 drivers/scsi/aacraid/linit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 43160bf4d6a8..68f4dbcfff49 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1475,7 +1475,7 @@ static const struct file_operations aac_cfg_fops = {
 	.llseek		= noop_llseek,
 };
 
-static struct scsi_host_template aac_driver_template = {
+static const struct scsi_host_template aac_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "AAC",
 	.proc_name			= AAC_DRIVERNAME,
