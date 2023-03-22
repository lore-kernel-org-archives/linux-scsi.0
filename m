Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302ADC6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjCVUCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjCVUBu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:01:50 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC4D6B970
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:57 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id w4so12218960plg.9
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z98/9n8VZg3wxBNz3Lr/vj7ZAQifDxFL83R6BG2/4ng=;
        b=8PipaPb79ds1c0PQT9QmHXHPvogiNw6LB0AvJnvMPNVz+pot8EKUL5gYn4xtWOxxLx
         BjURFPFn1j5vWOfO8IvlPuHne1XRMVwGIDKemNbBLFy89DaJr2v9wHO7oQDtnqzpVyt9
         dr2Jk6vtLi2ani3iujr4RrFOrwIvoPnzjn7XtRN/4hrMSAjEbli8xpThqOCs0jyKbilY
         GxTqGbqqdA8Iyfz00BVOXC0ZOkFuvax7nc2pacd2r8eFAz4nDXAPfgCi1hh7Bmu0nq39
         5we0i4yUx4jgW4jU2QdnH0ovOwpmDEjNx7oJbZPWSrYy5+nReBMhwvVdgE3hzEwgIbHM
         MTJw==
X-Gm-Message-State: AO0yUKX8smyASUkFICurRnJdCNYdnqfEmKg178dk7Y5WEm++cQaC0TPt
        aBH173yfTf3qlfW1v+AUPeoe+u7TVl8eqw==
X-Google-Smtp-Source: AK7set+iM1kzjoid6RhK0aLfXY75A9d7jhxpMRcpWvXelH13S7hqK2su6u8jU9XkZ+tWEr6ynvt2Zg==
X-Received: by 2002:a17:90b:3149:b0:23f:7dfb:7dc1 with SMTP id ip9-20020a17090b314900b0023f7dfb7dc1mr5011569pjb.33.1679515121824;
        Wed, 22 Mar 2023 12:58:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 68/80] scsi: qlogicpti: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:03 -0700
Message-Id: <20230322195515.1267197-69-bvanassche@acm.org>
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
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index bf08c7cd10ef..1e8fbd457248 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1287,7 +1287,7 @@ static int qlogicpti_reset(struct scsi_cmnd *Cmnd)
 	return return_status;
 }
 
-static struct scsi_host_template qpti_template = {
+static const struct scsi_host_template qpti_template = {
 	.module			= THIS_MODULE,
 	.name			= "qlogicpti",
 	.info			= qlogicpti_info,
