Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F2FC7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjCVUC4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjCVUCO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:02:14 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0EA6BC32
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:15 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id a16so15162235pjs.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHexfxqhHa9lPmHb4Wa8nZQ2WhbsAHB+F6q2CfoJf+4=;
        b=Sga2hbEZ60QM3QVEKZuQq1k5b/MqY6uR1Dk4h6RPigQzjoVe5p1mIHEFoEEvc4+nIA
         C1FlbxnkWCyAo5FMGNRWJwOmYLjDRH6b+m5k1jvR3oGxcSlsHzB/uc8WHV+slgFiy9e8
         G3mVH6yj2S3jk4POgHWxgCpszKZ3a5bZL7t5QAD7RKadNF9pUx98dPxOQ3Zdfz5A5yz2
         M3njQsYgrSeOIcEu8WuSrXb62Tk0mfKPWzcFBjb/JYP5WmoBQ0U79MCUBmTTHpt4M0u0
         4QtTaTWD/JV03HWxYDjH1LoiZ/+J13hBDOGGvTngsrrqg2xVQ0hPk0774+K58YtL6DQ9
         5T9w==
X-Gm-Message-State: AO0yUKUs57T/HkXOYCazUpl5Ff/+x0EBKnx/+Of35u9qGv8/qbaBC+Qo
        T8qQf6aXxpnYosD473/p7ltC/MFJVEd4eg==
X-Google-Smtp-Source: AK7set98UN9tmagIsOeYJqUkcM/sQAYdrnX82qrRu9smoUqudcJdIWFTgK0ts8p52S0CGw4ceTlHxA==
X-Received: by 2002:a17:90b:350f:b0:23d:3761:6087 with SMTP id ls15-20020a17090b350f00b0023d37616087mr4946861pjb.1.1679515130154;
        Wed, 22 Mar 2023 12:58:50 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 75/80] scsi: wd719x: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:10 -0700
Message-Id: <20230322195515.1267197-76-bvanassche@acm.org>
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
 drivers/scsi/wd719x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index ff1b22077251..5a380eecfc75 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -878,7 +878,7 @@ static int wd719x_board_found(struct Scsi_Host *sh)
 	return ret;
 }
 
-static struct scsi_host_template wd719x_template = {
+static const struct scsi_host_template wd719x_template = {
 	.module				= THIS_MODULE,
 	.name				= "Western Digital 719x",
 	.cmd_size			= sizeof(struct wd719x_scb),
