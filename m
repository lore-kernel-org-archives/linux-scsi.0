Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E7AC6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjCVT5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjCVT5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:07 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DFB5B5CC
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:43 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id d13so19538318pjh.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+RYutzjDsUywQB4KXngUgj4Hi0F5p617CUW9BmtH8E=;
        b=fD1W2udmAAtsGtBPwagYIxFw28Qoh6N4EsBRwIzRQUDLcR7/60giG6vzuESJk+/U2M
         uhtMoiMhrJCfX1yAuynKv8LQoCX4LWE2WWkAKfUqu8rlL5wwhLW43kMrdoRnGiFPqFe1
         WkoGX6xYb2kibl0yOk+MhlWCxIjZPR5XGbsQ5uMBcL13ZF8prQgWfolslcVfiRzx/+gw
         e8reblGojuXtv2sRAu/g17e67KEvwKx/PD9ebgt17QQVfFWbZxJfzdhiaiQ4tOEZHRO8
         F1cXFglYfrx8BvKnOpLg+O8tTw5RsKC4gFq9ysZPREgyU71LEkRb1n8bg2NNoHkZkFHo
         3xuA==
X-Gm-Message-State: AO0yUKWW/oH4JRipXrEkyH0vYXmIdHwO6tBiWlPZuVVTv6wPhnaL/nZj
        sDyl8VVf7xvcRvGOQ0t0zbw=
X-Google-Smtp-Source: AK7set+U++6oWAQ+D5hbM/DvOwqfiJB1mc00+fwzBt+yDR8SnI+bgWmR1cnd1AzYB4O2GihxHWRMuQ==
X-Received: by 2002:a17:90b:33c7:b0:23c:feb9:2cea with SMTP id lk7-20020a17090b33c700b0023cfeb92ceamr4560692pjb.42.1679515003095;
        Wed, 22 Mar 2023 12:56:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 18/80] scsi: aha152x: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:13 -0700
Message-Id: <20230322195515.1267197-19-bvanassche@acm.org>
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
 drivers/scsi/aha152x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index caeebfb67149..055adb349b0e 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -400,7 +400,7 @@ MODULE_DEVICE_TABLE(isapnp, id_table);
 
 #endif /* !AHA152X_PCMCIA */
 
-static struct scsi_host_template aha152x_driver_template;
+static const struct scsi_host_template aha152x_driver_template;
 
 /*
  * internal states of the host
@@ -2946,7 +2946,7 @@ static int aha152x_adjust_queue(struct scsi_device *device)
 	return 0;
 }
 
-static struct scsi_host_template aha152x_driver_template = {
+static const struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
 	.proc_name			= "aha152x",
