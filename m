Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B65C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE7E6108B
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbhHTDIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237843AbhHTDIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 23:08:50 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFBAC061575;
        Thu, 19 Aug 2021 20:08:12 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id e3so217064qth.9;
        Thu, 19 Aug 2021 20:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+JsfzGWsf8V+ktqlcUdosLl0jyg72rZ/bLzBNSn/CbY=;
        b=CSi3aZn+1xEQ187JGQXcvYJfOUOAZe8KY6AoUqHz0JK6jBOMDPe+I0xu4Gen0wIESD
         QFWRaof6exnZDB4m616JzDftuRMnUWe2pYx4BdPg/zmJG1A/yMJXIBKBK4hB7kzvAQEf
         bRXLYAzy1cr9xB8ZXqHumy4/h7U2dWelbZR21tjrKcwogKOAG3fNfznXkRqDNY6dCM5I
         TRZNtQC6OJlSV7k8Bcsf0gNFaw33/Gu+QbCacQkhN0vdP5GdC0spwk2bnLy00zuMKIOp
         kcDRBfRanAn5mNIYQWttpA+B2Y9G/PcTsKkk/wsYjqvAtGephUdo0HfZY6RlwFh+9J6a
         em6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+JsfzGWsf8V+ktqlcUdosLl0jyg72rZ/bLzBNSn/CbY=;
        b=qpvG12oxQtECJJid7uq+0gVKWnCmFJJrsis6DkNUTzbp1ywCsJ384mosYoU6ZHBW4y
         k0LY0Mz6KQ7UFAjIjT6O3d2getPqSANuLd30EPWQgum7RRbGp9tgD71JbdKTQvIMVUMV
         9ZsgSaz1s5ZPuYpyRBb9UoUl4pghKp6r6LVvvmzJc2XCttKKWXcorB8rQKMbBoA0gACe
         H39ZYepZb1WTZaLvvrbrAQWT7TV1VM/c1TWTpVJQ3m7uU9WxtParGCNVhXxjxzrLoY0h
         NdtGkIfuWjMDqtxF0xlcAbtjUPIC0QccdmjtBJM9aDjJeeHG8hl4CAIdXP+6bErOOIkt
         OsPg==
X-Gm-Message-State: AOAM53267p2B+b+vHCQicejeMlds7CG/Qps8nOwSqhDolomE5fhJQ3bw
        OE/9EVJjNlMOmvM40JxrTOw=
X-Google-Smtp-Source: ABdhPJwRse5SxrdsSOPBCsvyCeEp9n7dbnY4O4JoOjyzFrOaIEUP1l+2lmMuUGH61ox/Y+OORfzQlw==
X-Received: by 2002:ac8:1106:: with SMTP id c6mr15974365qtj.20.1629428892242;
        Thu, 19 Aug 2021 20:08:12 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u6sm2551729qkp.49.2021.08.19.20.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 20:08:11 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <jing.yangyang@zte.com.cn>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] scsi: megaraid: fix Coccinelle warnings
Date:   Thu, 19 Aug 2021 20:08:05 -0700
Message-Id: <20210820030805.12383-1-jing.yangyang@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jing yangyang <jing.yangyang@zte.com.cn>

WARNING !A || A && B is equivalent to !A || B

This issue was detected with the help of Coccinelle.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e4298bf..17c87ac 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8773,8 +8773,7 @@ int megasas_update_device_list(struct megasas_instance *instance,
 
 		if (event_type & SCAN_VD_CHANNEL) {
 			if (!instance->requestorId ||
-			    (instance->requestorId &&
-			     megasas_get_ld_vf_affiliation(instance, 0))) {
+			megasas_get_ld_vf_affiliation(instance, 0)) {
 				dcmd_ret = megasas_ld_list_query(instance,
 						MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
 				if (dcmd_ret != DCMD_SUCCESS)
-- 
1.8.3.1


