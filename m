Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CED0C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjCVT6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjCVT5y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:54 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F0B6A9F4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:35 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id a16so15159591pjs.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQk/3RH/O3rdmcLxCxnQwypnwRP+bkVFL+TTmjyYx3c=;
        b=jD0Ni5Ppr4nCEO8Wuu5DFXpbMZQFH0Qu+XlWyO9i2eQFQB2m+6srtyM4PKrypCYQZ+
         C97OSUMgG4ukbNYVXiuWax53cM0BvcDzY+5LZ2iJDmtuMpX2zORvVuZUBhnW5C0tqJAx
         UoiZGIl4weR4TAgFMlXSE790q1Kx81jHV6vDKxwokgtfvv82qbwAql8t2EXOtYNx56CW
         ujlN98dt7MTPN5bxn0Z4F3ovZK3UrY7IZKHfYwG0WW8ErEXxq9dhs87eGKDgdq+eYm6p
         FWo3npTtYVN00rChVFaoLIWCElUFcA9fnKN8stQt3UBYT8DTtdLhsNS8DzzCqGpX1rt7
         vh8g==
X-Gm-Message-State: AO0yUKXJqQYI4SFznTz2eqaQ5yLr1+Fggd2pLit2GRV/fM35152pP5VV
        nHSCCBOf8JOEEmB8pfB8sz0=
X-Google-Smtp-Source: AK7set+q2K9QGQ1dtR+bNYxjdQEM9iQtW2ZAMAU/sQ27t+DqffExdJwrMBMLHhYCczw5dpCfQoe4wg==
X-Received: by 2002:a17:90b:4d12:b0:23d:1948:667d with SMTP id mw18-20020a17090b4d1200b0023d1948667dmr4509844pjb.35.1679515055251;
        Wed, 22 Mar 2023 12:57:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 40/80] scsi: gvp11: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:35 -0700
Message-Id: <20230322195515.1267197-41-bvanassche@acm.org>
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
 drivers/scsi/gvp11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 7d56a236a011..d2eddad099a2 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -222,7 +222,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static struct scsi_host_template gvp11_scsi_template = {
+static const struct scsi_host_template gvp11_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "GVP Series II SCSI",
 	.show_info		= wd33c93_show_info,
