Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2739C7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCVT4u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCVT4k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:40 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089A55BCA4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:31 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso24686152pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMZZSzHNKzDNL64pOw/gqMY4JB5yYVuh2s/FZomE/a4=;
        b=wpb2rLWOXDmtAkgcpamPMhgk+CRsYn4fWuvBYccDHM9Ic8EU0bRW2kOqLVOKJZgZCS
         fzHzzwB23j++lSAue1ezErKlq8fmwkUKQzY2blZGeO/UZKUjK2JgeLBZGKa7DWVrYpga
         WqIP61kNrmw8L7cDdVoRga16M8m82c+I0qNK+gPrXQvFRJIHmfQqeACenbn+hKHAs2kY
         ouOCB9CuKEWhE0AivZ1BbK/QMcHUiS7+6w5lwIgefnWTDpXguxbsMob8bGqnxR+PH5db
         ZOBCs65iQA10ERem5CvdjLxdNZiFsa4Er0PWqaG+LXJoVOdbLyaoJrvDc10GklDb2naR
         TU9g==
X-Gm-Message-State: AO0yUKXNpe7d4hZHQFTpvhUyhywI9VT33+g6W3n3/Chpg97btV9fwIlC
        tysdiQeMmZ2Aoz9Pss7q01g=
X-Google-Smtp-Source: AK7set9Hpr0Jm2dXhg6mJO+SHaZReYA3JHmZIUvo3nc2gTKE/U1JI/EXGiF6KxUo7rLLM6VCyxk5CA==
X-Received: by 2002:a17:90a:1918:b0:23a:8d71:99d with SMTP id 24-20020a17090a191800b0023a8d71099dmr4800136pjg.22.1679514990479;
        Wed, 22 Mar 2023 12:56:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 09/80] scsi: 3w-9xxx: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:04 -0700
Message-Id: <20230322195515.1267197-10-bvanassche@acm.org>
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
 drivers/scsi/3w-9xxx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 6cb9cca9565b..38d20a69ee12 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1976,8 +1976,7 @@ static int twa_slave_configure(struct scsi_device *sdev)
 	return 0;
 } /* End twa_slave_configure() */
 
-/* scsi_host_template initializer */
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3ware 9000 Storage Controller",
 	.queuecommand		= twa_scsi_queue,
