Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226F2C17441
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 23:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A75215EA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 22:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fVhQvmmO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKHW77 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 17:59:59 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34017 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfKHW77 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 17:59:59 -0500
Received: by mail-pf1-f196.google.com with SMTP id n13so5836076pff.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2019 14:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wqJ/YvB2lvq9OiKAIzylZEQcsEuEhwj6T+76hhYV194=;
        b=fVhQvmmOUXuBpAs8zDPp/KkjpvJMux8O/xe+9fOUUQoZrTr1OdHONHYeQzdbdT7A8B
         iHBRbBTlH4uUn8Fh1MMgL5uChQPgHoO94jUQfefpmvCBdqlBPwYXuW62Ia/9igfj7lzG
         LSvy06dLGES/EhXMlk75a8NAp8aYezXObnj/wsZyth2CwkI/6z/TmRndD4EBUuptbBuz
         UBw2hXAaGf7oK50L2Q2SxD5XH9uNiiA12+Cq68zQxUFuyXwpD0yWqd0uJEKMtHPpLVCB
         2rZUPkQ3PYrHDfkwy+0hgAhmybws1grNRSpCRoU6jnds/HwZ2aLRIgzWXzpQgLAbeldI
         PEnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wqJ/YvB2lvq9OiKAIzylZEQcsEuEhwj6T+76hhYV194=;
        b=HvCDm8mmTpizWqgk/5o7T1yF9lWBPx8x+Po4ablQOhU8g7+hUI+maiNLyy6vo0bfKj
         CJkBikl01RcGWGKUXUH1pmxlT4kuurw7EPT/uZNY8/mGBns8dzOZ+rmzvWIze8SNiDtb
         wZQLB0vm2FIZWdj8VHts6FDxKSin6FeE2NUv+jZcIi7fAcA1/k5E78FRK6gYWI5YV49J
         zrWdZn5GowHmTnLK3idqsHsayzwWmcNkXK6sVAqcDT8e2CBYnNoV9d8Am4rjnCR05EMq
         tu+bc418bJzqf9BqRJY3pLSVdAGM7BC74VFLJF2S9WxOk3sdrxwGn4VCZTXfRQhsyN5x
         6Y8A==
X-Gm-Message-State: APjAAAXZ84P6ysr785gk0l+8vKKZTGmzoBCALr8Uxqpy+d/Yo+q7clPD
        r4Nr8t90yv1R1ecsrghR8B8=
X-Google-Smtp-Source: APXvYqyTxaN+j/j48OJE2lPgMbubCPWJG00O9FP+UhM6o/7qzxAKT53NSx5mV1DZNTPYpYBRkI/i4g==
X-Received: by 2002:a17:90a:353:: with SMTP id 19mr18100822pjf.128.1573253998846;
        Fri, 08 Nov 2019 14:59:58 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l62sm7068499pgl.24.2019.11.08.14.59.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Nov 2019 14:59:58 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2] lpfc: Fix lpfc_cpumask_of_node_init()
Date:   Fri,  8 Nov 2019 14:59:47 -0800
Message-Id: <20191108225947.1395-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Fix the following kernel warning:

cpumask_of_node(-1): (unsigned)node >= nr_node_ids(1)

Fixes: dcaa21367938 ("scsi: lpfc: Change default IRQ model on AMD architectures")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
Barts patch slightly reorged to clear the mask before exiting
---
 drivers/scsi/lpfc/lpfc_init.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 28e6a763f106..480d5a28c4f5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6005,19 +6005,13 @@ static void
 lpfc_cpumask_of_node_init(struct lpfc_hba *phba)
 {
 	unsigned int cpu, numa_node;
-	struct cpumask *numa_mask = NULL;
-
-#ifdef CONFIG_NUMA
-	numa_node = phba->pcidev->dev.numa_node;
-#else
-	numa_node = NUMA_NO_NODE;
-#endif
-	numa_mask = &phba->sli4_hba.numa_mask;
+	struct cpumask *numa_mask = &phba->sli4_hba.numa_mask;
 
 	cpumask_clear(numa_mask);
 
 	/* Check if we're a NUMA architecture */
-	if (!cpumask_of_node(numa_node))
+	numa_node = dev_to_node(&phba->pcidev->dev);
+	if (numa_node == NUMA_NO_NODE)
 		return;
 
 	for_each_possible_cpu(cpu)
-- 
2.13.7

