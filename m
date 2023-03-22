Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136ADC7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjCVUDw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbjCVUDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:03:06 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFB86A9FB
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:31 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so24660511pjt.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515148;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JatlvvSAy10pUZ2TE7FlESNCOBJ5cJUZcDrqKgCUceo=;
        b=AaCTDiByxW1AzOkxQff3V9mXTxgD3/5gITyklDrUTV9l1UmnCwS0jcIe+RFI51TYeQ
         x38wN64NwOToQYUcgg/gQNSw0I7c+4SFuYaeRrfyEt1i5rHtvteNsExeh/i87p7VFuV2
         q2LP/roGduwD1hD8Qut1nhyGdK/TOGJh/5pZEJWiUxSqMMYmcJCKaklBU4yUP3Yi8j9K
         FI+9ScIignWRlI8bZisHRNbOBjXIznAeuB2qehhJgCO9l/0PDChIslGmqxtPz/5+M4pY
         5lmKqvtRNXWki2Zbew8BbhqMvuuKXc+kXT1xwx7gDr1pUdxVYmxBQo8YTX6/Lt3iQLsA
         KuZA==
X-Gm-Message-State: AO0yUKU90FG1PhogUY6WjSD7WZzP2wxoOTi6Vva6LNJy8p3Uxcx+l41X
        Pjt866Y52/tix5yxZlX5tCr8LdgNZ+uNOQ==
X-Google-Smtp-Source: AK7set/1jogrfyCOWMT3eyDpgf9yy3+8GKQ0gJPs8UyAE9u4s/a73/4d34Wgd9qg5Xqe9ntTCrTirA==
X-Received: by 2002:a17:90b:17c5:b0:23f:5ea8:3ccd with SMTP id me5-20020a17090b17c500b0023f5ea83ccdmr4906048pjb.30.1679515148162;
        Wed, 22 Mar 2023 12:59:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:59:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 78/80] scsi: target: tcm-loop: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:13 -0700
Message-Id: <20230322195515.1267197-79-bvanassche@acm.org>
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
 drivers/target/loopback/tcm_loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 5c8646c2d4e9..5272f7dd85d2 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -298,7 +298,7 @@ static int tcm_loop_target_reset(struct scsi_cmnd *sc)
 	return FAILED;
 }
 
-static struct scsi_host_template tcm_loop_driver_template = {
+static const struct scsi_host_template tcm_loop_driver_template = {
 	.show_info		= tcm_loop_show_info,
 	.proc_name		= "tcm_loopback",
 	.name			= "TCM_Loopback",
