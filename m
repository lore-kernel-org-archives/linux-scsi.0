Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133ADC4338F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 14:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED1C361002
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 14:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbhHDOd5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 10:33:57 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59286
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238936AbhHDOdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 10:33:35 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 175843F04D;
        Wed,  4 Aug 2021 14:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628087600;
        bh=kSwB8Osy7KBFjV5y3FKjG+p2/CUjE4tMFarLYN2GUY8=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=E9ktIt4wMm8GHKM1K/bcICRkgZdDqPqbc2MR2sP5dW6X2zBreS0vM7gxxfpdHnrJh
         tPcZev0EkvOfi7lxQzu7A0nxoKYqsp39chToU7ZcQ9oB4nnEMPHayLQmz5eXz0LKQi
         koi128nIXlejQPsFPQJz1HJ66EipZFDf4+XEghFysVyjqYbNBqN/ZbeTD4uKMizUEa
         PKd8PDXwCKqS/IcVNz98rltL7h0O0wm1OrNlQN5Os0C0yeQmCg22zVOGcUpOytkl9t
         Jju0Mn4RGfO9J+LUxRZQIrnv25mmB5OdhlN9tTiv+1bgm6sBGo4wiX8XdkBR9CNvCP
         vvB85T9i5IzYA==
From:   Colin King <colin.king@canonical.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pm8001: Remove redundant initialization of variable rv
Date:   Wed,  4 Aug 2021 15:33:19 +0100
Message-Id: <20210804143319.115340-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable rv is being initialized with a value that is never
read, it is being updated later on. The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 17c0f26e683a..63690508313b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1323,7 +1323,7 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 	void *pMessage;
 	unsigned long flags;
 	int q_index = circularQ - pm8001_ha->inbnd_q_tbl;
-	int rv = -1;
+	int rv;
 
 	WARN_ON(q_index >= PM8001_MAX_INB_NUM);
 	spin_lock_irqsave(&circularQ->iq_lock, flags);
-- 
2.31.1

