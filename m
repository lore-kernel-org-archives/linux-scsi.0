Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB25C7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjCVT55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjCVT53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:29 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCBB5C9C0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:06 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so20262533pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kH268M7KVsr02fjw5NLBwrnT+cyJ3HjwvjHBuiPtPhM=;
        b=0rLh5xoRoU4v99HCgKSAvN1kl6fK5Dk+SE37huT0k4eMDEHGLvWqnK3LU9oibSHrU1
         QY2JD4o662AqkhiOnYaKCxLoTS/FApyO8vOtOSYaZJbZNR9WMKEfNCfOh8Wl701i7yPu
         QDc08v+C8+5cRUy2vkE2pFylq2GMgdgKeHYE0aNa3dJ2dXhnubaofZ7uVQgAfA7IZwBF
         ALZMb0smzvNGXpwc2VlmuD/fndLwJWpCXZqZ1DqvPgPzkAYmWXK15Ss6ku/8gOZCC1C8
         YkpTX17VXu4PoIDx4WKW/hnPK6QmR6g+GffgjVSXIDzg05NF8hPKrRUrtfytm24Cb5pz
         lO0w==
X-Gm-Message-State: AO0yUKUZ1BF0QhGPr3lF36xcvSgXYZdW0iOdplZ2TiHbrGFySnfWHpdi
        vZ/eOva8IxWSMeTAQvtvCEI=
X-Google-Smtp-Source: AK7set8d9K3ud3IxXZXJA1CM2rgHa0iF+0PWnKIizvhzzTwPr1Kf3WVORPdJXxIv2MjzlUIS5dD8vA==
X-Received: by 2002:a17:90a:309:b0:23e:f855:79ed with SMTP id 9-20020a17090a030900b0023ef85579edmr5106341pje.28.1679515026290;
        Wed, 22 Mar 2023 12:57:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 24/80] scsi: aha1740: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:19 -0700
Message-Id: <20230322195515.1267197-25-bvanassche@acm.org>
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
 drivers/scsi/aha1740.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 134255751819..3d18945abaf7 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -543,7 +543,7 @@ static int aha1740_eh_abort_handler (struct scsi_cmnd *dummy)
 	return SUCCESS;
 }
 
-static struct scsi_host_template aha1740_template = {
+static const struct scsi_host_template aha1740_template = {
 	.module           = THIS_MODULE,
 	.proc_name        = "aha1740",
 	.show_info        = aha1740_show_info,
