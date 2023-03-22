Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208C7C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjCVT4w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCVT4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:43 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB60A5BC9D
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:33 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso20231531pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NNIBPT74zB8cP9y9PhKNlxYuRy1lcz2hltLytVbDwLc=;
        b=fNHxKDsVF69JOyCeEZEbCM4O5185bmUZorvD/JjO38Z8Qk6PQmUcI0gE+WWNgYFGXW
         3wKM1pw0sdGWXbgQzE5Nk9sEP+J6VWzKqSUwljw9PtUWHYQQZgSQ3coBJ10+YbLKgkXy
         AulDXv7Y3vJrFY3l8bxYtKQOPfZr1U+D0k5iX9g8+KI90vCvUhC3Laci9g1CTwmEkfV+
         IWDtKvygtNFtGCBNGIC1cqLuFJKmEfl0JK6mliV1HzTTs9tenW9LMRS/3chNGVvFkS9w
         QB2FfuxCcaRNXDbCnV/BH+2SQp+H5vFwmjcEtO8bKssR2CSKlEHKEuOfC1pJR8i56nvk
         LvLQ==
X-Gm-Message-State: AAQBX9egmH1lFjJKzEb3AVYjCIutyEohy+gya9MakUDxxrgU3vx0bXXe
        WQTzLaj/GV0URxfyZ9YYSekygbFl0fU=
X-Google-Smtp-Source: AKy350ZX1RbZe8w7dK9jfyslHl5Q15euHPi+0UcizHOTPgkuG4MapswclEyalbPwT5bYpPz5x9Yy1g==
X-Received: by 2002:a17:90a:f093:b0:23f:2486:5b53 with SMTP id cn19-20020a17090af09300b0023f24865b53mr3187923pjb.17.1679514993151;
        Wed, 22 Mar 2023 12:56:33 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 11/80] scsi: 3w-xxxx: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:06 -0700
Message-Id: <20230322195515.1267197-12-bvanassche@acm.org>
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
 drivers/scsi/3w-xxxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index ffdecb12d654..36c34ced0cc1 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2229,7 +2229,7 @@ static int tw_slave_configure(struct scsi_device *sdev)
 	return 0;
 } /* End tw_slave_configure() */
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3ware Storage Controller",
 	.queuecommand		= tw_scsi_queue,
