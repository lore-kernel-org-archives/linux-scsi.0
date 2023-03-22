Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEBBC6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjCVT6k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjCVT5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:52 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44816487D
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:30 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so24656161pjt.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCDnsBDyD5KdL/cOWwSjhVPjFE5ySWXB1GfjV8JeIjI=;
        b=4sb8HeBPsjoVwI4H3P7WU0lkmymINkR4AdWeBOnrOdfhP90awaDGdra5BzZG3YCLiQ
         x9iWT7gY+ttLyz7y3pDQI+itbdJI75lAzN7GGdwLIzSJsCOaQ2gCKr7Hh2BSTAJfI9gj
         EnKD/b9eLWFjGOeF0PK+2t+MiB7230NKRyNSYLoef9sENJhI5XovH8COiODLSDftV8fL
         P8pNKX5jkoh/qkQUXSG8n+MV2Gy2aBVrXVcvww6DxwavX4up2j/nYQq2lJ4bC8wOExzg
         4OnFX9XiwCP7SrISnoT6fNI/pUXp+ke+LQm+m0qmy8rHxeXhf3SC/P3UUMViWIhwgqNW
         lqZw==
X-Gm-Message-State: AO0yUKWLdCN2kh6jjgWLk/firZxsVVhpLzHYa+D+jmT7hrwQCqM57Znt
        0wd5/eLbnErx1CZ0CkNhRrY=
X-Google-Smtp-Source: AK7set/Y/CAc+1W+LO5ST2Jeg6i+qLdYSTUTq33ULepeEdn9oJoPSWFEKHcm0uCnMY7wB/uGjW3tYA==
X-Received: by 2002:a17:90b:1bcc:b0:23d:39e0:142 with SMTP id oa12-20020a17090b1bcc00b0023d39e00142mr4780573pjb.42.1679515050064;
        Wed, 22 Mar 2023 12:57:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 36/80] scsi: fnic: Declare host template const
Date:   Wed, 22 Mar 2023 12:54:31 -0700
Message-Id: <20230322195515.1267197-37-bvanassche@acm.org>
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
 drivers/scsi/fnic/fnic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 1077110ab273..984bc5fc55e2 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -95,7 +95,7 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template fnic_host_template = {
+static const struct scsi_host_template fnic_host_template = {
 	.module = THIS_MODULE,
 	.name = DRV_NAME,
 	.queuecommand = fnic_queuecommand,
