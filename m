Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2ED7C47254
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AB88208DB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tRp1XGph"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgEAVn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 17:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgEAVnZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 17:43:25 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E454C061A0C
        for <linux-scsi@vger.kernel.org>; Fri,  1 May 2020 14:43:25 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l18so2442944wrn.6
        for <linux-scsi@vger.kernel.org>; Fri, 01 May 2020 14:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=65kWVGa9kl8uAn4jfM7Y1jGC934v1JVqxU+ajpy5d3k=;
        b=tRp1XGphPJuBLOsOqD4rCfHsyoOpxjqTdontn9QJTxDUW8h0cvrzqbQypz5pLpU4TM
         EqDhLqFIvp4CFIv6xVLf5EjnP1mQmOQTYsVsXZoj7D1yWZYAoiXhxL6H3u31VeQBFOI1
         RRwl/XtyfRl7EdscV46pJzifjupoBm2aVfim5q9ChNVkoLJ1HUm1f7PO/BI4BLHOXt8o
         wyqzUS6ix9G9QhX25xyo7/dAekvFc9hLlXNzHiECM9m83a3W/sYaXh3+8l2AKNEmS9bZ
         q8K2Kw9XQhg8u+pQXkwvEsmfLji3VBq7ssKQM+CB6REeegHwV7XSrCY/RrurzD3sM1zZ
         MBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=65kWVGa9kl8uAn4jfM7Y1jGC934v1JVqxU+ajpy5d3k=;
        b=JsrjWR49c2IR0F2K1X09EeQEculti9/iDwVCbhSxGgHM7zhZBUYuWnHzK9efZNMHWx
         CZBxVLmbgsRpFwW1apwI4RNITPom+SRHok8Bf69ac96DUcwfQnqfX/Ca1dzDEmYf3McO
         xmvuR0H2GFQyl4ho2Olow1xPyxwmvPA1p5vl07BDFyBlKf5U/yNyWkCxTdnrwrQT5WQQ
         3OKN6BFsDo2pNbbOh99bzOjNtzY1k4V6c4+WsTLftlQtQKjcxITLR7ar5ktG0c7vZpm2
         fwvOeY9ykrqjXM1lNLXAo4a4ywaYDfjQiXJBRie11HnRkrQ4SKmvDcNo5YMRTbP/MLeX
         FjNg==
X-Gm-Message-State: AGi0PubSKtgOA7Byhzb57WTEj4/iBvAoFf+WxYh0kazxltStsY2KZi0r
        FKl6GzIBQ8r+JZNadr5KxV1UTxL2
X-Google-Smtp-Source: APiQypK3kjwRlZ8lwSUbsEr3H3Hl6ZlwGqT1vmdMQJHbYPzZKSewIaKrQDSaVz2AsmbR6Qb4UJZ/6w==
X-Received: by 2002:a05:6000:1008:: with SMTP id a8mr6326641wrx.189.1588369403598;
        Fri, 01 May 2020 14:43:23 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t2sm1207734wmt.15.2020.05.01.14.43.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 14:43:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 2/9] lpfc: Maintain atomic consistency of queue_claimed flag
Date:   Fri,  1 May 2020 14:43:03 -0700
Message-Id: <20200501214310.91713-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200501214310.91713-1-jsmart2021@gmail.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A previous change introduced the atomic use of queue_claimed flag for
eq's and cq's.  The code works fine, but the clearing of the
queue_claimed flag is not atomic.

Change queue_claimed = 0 into xchg(&queue_claimed, 0) to be consistent
for change under atomicity.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b6fb665e6ec4..9ce37560f4c0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -538,7 +538,7 @@ lpfc_sli4_process_eq(struct lpfc_hba *phba, struct lpfc_queue *eq,
 	if (count > eq->EQ_max_eqe)
 		eq->EQ_max_eqe = count;
 
-	eq->queue_claimed = 0;
+	xchg(&eq->queue_claimed, 0);
 
 rearm_and_exit:
 	/* Always clear the EQ. */
@@ -13694,7 +13694,7 @@ __lpfc_sli4_process_cq(struct lpfc_hba *phba, struct lpfc_queue *cq,
 				"0369 No entry from completion queue "
 				"qid=%d\n", cq->queue_id);
 
-	cq->queue_claimed = 0;
+	xchg(&cq->queue_claimed, 0);
 
 rearm_and_exit:
 	phba->sli4_hba.sli4_write_cq_db(phba, cq, consumed,
-- 
2.26.1

