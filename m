Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06664C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjCVT5n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjCVT5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:18 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48DC6703A
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:53 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id kq3so7893476plb.13
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PUVyuRxOnhRj9LsT5qhnnwF2XXY/eNUcYo7//Y4UXag=;
        b=kT9jJoX6HqPzqs4TuNnIW1QlWCOd1qRW6LxdzM0G1tKsuhuJ91iFDUw78450Ep+jPd
         mlbZbQAlJIgN8YjxoSkNn+EyJvm00jOsh5iFt66bw1tjMR8bHdWgioHeL3P1TK5BuT7v
         afPclIMjyLD1msIHlr31yQDHBA4emzk5krsJjxO4Sz+9aAYneppKL0y0eBKIfeFKVpiI
         XwWGzJF0XnSLpzlVtC/wFKnJuMupsd3DdM2eEMP2ox0vWAX97cMw6avSHP9tLfFJ7TPF
         IgFXaLBzqfTrutnxF8gIprIWQxLVeX6ZWhyleelIthuLbI3sapSi1Me/U1TuIaMTKRWo
         OfAw==
X-Gm-Message-State: AO0yUKWjulFyMQl24oRFPL4Jjtnfy1uAl7hjm+g4aR1Tb5TJEzSC5Ynl
        kSag9/gknvC+8LeKAk6NDD1Z5+9tx+U=
X-Google-Smtp-Source: AK7set8+JlnWyclBGFvcI+E2HnhjP2L/feifYNmWqmhbvqCopT7x0FIc/aXIHJH2nCxMIyo/302CnQ==
X-Received: by 2002:a17:90a:df08:b0:23b:3b3a:54c2 with SMTP id gp8-20020a17090adf0800b0023b3b3a54c2mr4247954pjb.48.1679515013350;
        Wed, 22 Mar 2023 12:56:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 20/80] scsi: aic94xx: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:15 -0700
Message-Id: <20230322195515.1267197-21-bvanassche@acm.org>
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
 drivers/scsi/aic94xx/aic94xx_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 954d0c5ae2e2..f7f81f6c3fbf 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -35,7 +35,7 @@ static struct scsi_transport_template *aic94xx_transport_template;
 static int asd_scan_finished(struct Scsi_Host *, unsigned long);
 static void asd_scan_start(struct Scsi_Host *);
 
-static struct scsi_host_template aic94xx_sht = {
+static const struct scsi_host_template aic94xx_sht = {
 	.module			= THIS_MODULE,
 	/* .name is initialized */
 	.name			= "aic94xx",
