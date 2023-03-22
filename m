Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99067C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjCVUBI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjCVUAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:00:17 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E395BC85
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:26 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id le6so20268465plb.12
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8ne1LFtZC0aI46uW+Rpyylv80/ucvjDGf+JX18Z6oo=;
        b=MSDCR5iPyWAu6oQE9E5MiT7+wpFPBL6SvHDr4IqkFxapefQz+9/EbBhZG5hRzdh1/Q
         0y78VG+QKYXU5fXJn8qX4pGiQxDgLaczCk9kgPHpCuOJKZqgCPfZNV4Bq+0PE41VJdIS
         WZSxmH7a+ARGZvC+jnRg+H4AWswIS8oXRUk1Qw2hekeDNCXmUQwgJ0Iy7859KJF9HIrK
         KeTAJ+MczomLcH3DROt1TI0W3WqxB4jNVWdHG8xAX+8wIIlq49bSEqTSkzBE2UrdJiJY
         jG3cgb5/fK3zwGs/4TN4JudKODCPis9SDl/j0wDhR3q8elxyumNdr6CaZT4ZvRzHIT5J
         u1BQ==
X-Gm-Message-State: AO0yUKWqIMVu0+Tlczz+nDjmolIBNJbFd8+/8kWFgz3w0Jy5y29yaZAU
        9OmSx82tOQFN3RT5qP6+FO8=
X-Google-Smtp-Source: AK7set+E07fGre84XL4RxZEBaqqqA8o1fbKPXZBrjNfnaQY3C423gBsVNwgxOFKKIXLiGxyxfYCI9Q==
X-Received: by 2002:a17:90a:3:b0:237:b64c:6bb3 with SMTP id 3-20020a17090a000300b00237b64c6bb3mr5357259pja.11.1679515104352;
        Wed, 22 Mar 2023 12:58:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        GOTO Masanori <gotom@debian.or.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 60/80] scsi: nsp32: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:55 -0700
Message-Id: <20230322195515.1267197-61-bvanassche@acm.org>
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
 drivers/scsi/nsp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 75bb0028ed74..b7987019686e 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -259,7 +259,7 @@ static void nsp32_dmessage(const char *, int, int,    char *, ...);
 /*
  * max_sectors is currently limited up to 128.
  */
-static struct scsi_host_template nsp32_template = {
+static const struct scsi_host_template nsp32_template = {
 	.proc_name			= "nsp32",
 	.name				= "Workbit NinjaSCSI-32Bi/UDE",
 	.show_info			= nsp32_show_info,
