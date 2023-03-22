Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE68EC6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjCVT7J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbjCVT6A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:58:00 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B646A403
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:42 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso20234850pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MFd7OEytCze0u5XL5op+H8sbsT2Mg/pBWrkNJAZR/H8=;
        b=q5xhWZD1/GN+OnA7SfNcVP3H0lrcQV9rd7itSQ5aEpbL29fZnVHzgIHCiYLG6sWaRx
         GAINmZuTquYAamF4FYcy7Fw4wdDj0Ytwba7fv+WnIT9gts98z9012pOoY0yytt5mUFhy
         NClYz0wxxyBDMLJ9sF2WUYk0hLrml4dFT9UwjCrX5vqFid/XNF6s7xjJ9KXFa7j2Tr1F
         ZiUHp2zWp6KH5dTbdUrqUkKV3YPcgP62vRa+erAHwM0jPJvDJXU7FOj95VcecaiMI7Hv
         3ix+kqpqoXPHHMoe2kLy1GD25NKjaa5m+lqCZ8OTcWQueDAlpjfpGJX+nPUnNIvI1hyB
         RjoQ==
X-Gm-Message-State: AO0yUKVCAh+k/zR2fCxr9eerCraSpj/7u8VATV6rzsACDVTHa7+EJnE6
        rOTMpf3TC/VoQYZjOkvOLcw=
X-Google-Smtp-Source: AK7set8bmVsnKssomkJxvD9ENYAb+xMqMHK88mcXJTsXyyPpvRPgMxV1UrkEwkjTtDhJ6C1KrnHEFw==
X-Received: by 2002:a17:90b:3c49:b0:23d:35d9:d03e with SMTP id pm9-20020a17090b3c4900b0023d35d9d03emr4452731pjb.48.1679515062599;
        Wed, 22 Mar 2023 12:57:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 46/80] scsi: initio: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:41 -0700
Message-Id: <20230322195515.1267197-47-bvanassche@acm.org>
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
 drivers/scsi/initio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 375261d67619..2a50fda3a628 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2788,7 +2788,7 @@ static void i91uSCBPost(u8 * host_mem, u8 * cblk_mem)
 	initio_release_scb(host, cblk);	/* Release SCB for current channel */
 }
 
-static struct scsi_host_template initio_template = {
+static const struct scsi_host_template initio_template = {
 	.proc_name		= "INI9100U",
 	.name			= "Initio INI-9X00U/UW SCSI device driver",
 	.queuecommand		= i91u_queuecommand,
