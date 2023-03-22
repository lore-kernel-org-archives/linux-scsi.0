Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C75C7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjCVUCb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjCVUB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:01:56 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2958B6BC09
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:03 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id l7so2457561pjg.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x8zmmOkwIoIKAWyiwthdityD4hZhxjndZB0ZAklYRAQ=;
        b=5VPQ9T8pKxk4l1KKJ9SMA6aGxrmWTHqT2qggDiak7x7mJw5ygLftn4Hi/VlFDyK+6m
         9yXd8+d7FJBSInzMQyzA5VYcEzUFBViiEvbTzVB1RUYjLwAGo8/mZ2+oTCDJFTCHx/6M
         KL8XPaTd5Xdr3erwOw9Kp/s7XNV/WgfNdxrEyLAaUT6DibISAPIgait8SiR82c6NiHz5
         TYDyzwbEl1WV+Z7Tk1yhatjn5NyCNJ7w3T53mEd8EIS7oB9+yGkz09KjjoW+gfxTpyqc
         gpfDbd3lw7sUrWbe7E0yO03E1g35hT5Js3N7GKQWAviidii0k7gFUJ13WW3YTwaPVfpT
         EHvA==
X-Gm-Message-State: AO0yUKV1WEJcoqHB34goY8dlM7Jibm95/pOwachhRaLLe4gd9y+aVg3F
        MYfxi3C0BOcgPIczBQVr6A4=
X-Google-Smtp-Source: AK7set94jTr17trw6yiZL4N6DnYL+337liZoii/aVMyOruf3I2uV4QrUs9beleTsXzRYiVsiDxPdlA==
X-Received: by 2002:a17:90b:4b06:b0:23f:635e:51e5 with SMTP id lx6-20020a17090b4b0600b0023f635e51e5mr4799243pjb.36.1679515125451;
        Wed, 22 Mar 2023 12:58:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 71/80] scsi: snic: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:06 -0700
Message-Id: <20230322195515.1267197-72-bvanassche@acm.org>
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
 drivers/scsi/snic/snic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 174f7811fe50..cc824dcfe7da 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -100,7 +100,7 @@ snic_change_queue_depth(struct scsi_device *sdev, int qdepth)
 	return sdev->queue_depth;
 }
 
-static struct scsi_host_template snic_host_template = {
+static const struct scsi_host_template snic_host_template = {
 	.module = THIS_MODULE,
 	.name = SNIC_DRV_NAME,
 	.queuecommand = snic_queuecommand,
