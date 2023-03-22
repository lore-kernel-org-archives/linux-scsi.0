Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFB8C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjCVT5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCVT47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:59 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B50064B39
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:42 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so20261292pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0DwKfQtFgIgqVRLk7CJqp+SWpc3PgTs6DS8lVIZ4b8Q=;
        b=JjjVEeg6qqptlutwM00RQs4MQ4N3Y1nntoYujRoLrIKp4x8kaytDChw8B0oi1FSF6t
         tV9uiIkFJ2WmNXlegPRnXzA/ej0WKAnEx7vNQtbAhfdyyqAUSx/5O1Jif5qbuOnn7hwH
         MV5wtYzLvAxl9JyTVFvTJ/gL5PbGJPZvzQAnusQcsnGU71coIx/JTnuzx1/RRVlI5ohc
         B6YJ2PSIgjUaY3VLR0RAtbBaxuckhV2fPHj7GP4gg01FB0lWW5l2z06m48aDy4djr7kz
         6GeqzhQIV28TaYSUsBbhy6+dYBymVhetpq43jAWejz1wuhKa0yck+25nCMO2uTU7tT8X
         Kjxw==
X-Gm-Message-State: AO0yUKVYgXiDC9frz5C2Qn3AUl6mGZRtaxJ13308WsfvPPtpA0eOCt6u
        RaHg1RVZ6f1SyLWZeHbwq59kXilBdIE=
X-Google-Smtp-Source: AK7set+rgPJYEVk8CNWvKywYkSlFy1a4/nvyzHwFGSTa2FFLxQsHAXDjXs5zLpZGQOQ0hWPlBtvhtQ==
X-Received: by 2002:a17:90a:191e:b0:233:76bd:9faa with SMTP id 30-20020a17090a191e00b0023376bd9faamr5022064pjg.47.1679515001763;
        Wed, 22 Mar 2023 12:56:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 17/80] scsi: advansys: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:12 -0700
Message-Id: <20230322195515.1267197-18-bvanassche@acm.org>
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
 drivers/scsi/advansys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index f301aec044bb..ab066bb27a57 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -10602,7 +10602,7 @@ static int AdvInitGetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 }
 #endif
 
-static struct scsi_host_template advansys_template = {
+static const struct scsi_host_template advansys_template = {
 	.proc_name = DRV_NAME,
 #ifdef CONFIG_PROC_FS
 	.show_info = advansys_show_info,
