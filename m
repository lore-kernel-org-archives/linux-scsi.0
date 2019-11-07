Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06613C5DF61
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAE1E2178F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfKGFWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 00:22:15 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41783 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfKGFWP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 00:22:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id p26so1544159pfq.8
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 21:22:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DTaOhDgtEZZE6eTIW6R/dFyHM3FvEb3jzqyn/t/MQfg=;
        b=FhAfWFZd1XIL0TXztN1Mm3Hg4KFQzdcoLmruoCwcmhC3BPmcBwkj4pyv83rSlzOhcn
         d4yGK34k/CP/kzpENAGRaTPr1fJrS4LBBR2E+izg3G82nFh8mS488mCgrvSUaRo5A/w5
         GGaHKVckQ0h3UK5UE59UtPm8vq0uHUyMzuyHtrKHCCVHeVh614Pu38x+NSYwcEJF5vXq
         ok3rue3i+eJBf0vEOuEztTKZSf2fOHgnuFPYwhQcg4nI9FlzCrt8Ka9PCZJI7qiwWpcM
         uQDjLyI9unVAVNMt6yvt6hdJWGyyx4RtbE1CSTJk8lJN/bpmjEHYaNXECyouSQjfWfu3
         0dsg==
X-Gm-Message-State: APjAAAUEjckUwqDCQya+5SwJSAlkaVmgRkFZZXYDH9EFSbJhE+lMnPVH
        SidUhBxtkAwauF5kmEbgOgo=
X-Google-Smtp-Source: APXvYqy4XTD2Nt6kKswyM7xzJvyIxstz6CHEFNBWafXd1qdK0Lc9Ik677fdbn8DmEoRi1V9xHi8gYw==
X-Received: by 2002:a63:c445:: with SMTP id m5mr2135913pgg.211.1573104134426;
        Wed, 06 Nov 2019 21:22:14 -0800 (PST)
Received: from localhost.net ([2601:647:4000:1075:7917:b099:7983:671c])
        by smtp.gmail.com with ESMTPSA id m13sm719961pga.70.2019.11.06.21.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 21:22:13 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/3] lpfc: Fix lpfc_cpumask_of_node_init()
Date:   Wed,  6 Nov 2019 21:21:58 -0800
Message-Id: <20191107052158.25788-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107052158.25788-1-bvanassche@acm.org>
References: <20191107052158.25788-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel warning:

cpumask_of_node(-1): (unsigned)node >= nr_node_ids(1)

Fixes: dcaa21367938 ("scsi: lpfc: Change default IRQ model on AMD architectures")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 37e57fd9ba5d..f2051e2f5f56 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6005,21 +6005,14 @@ static void
 lpfc_cpumask_of_node_init(struct lpfc_hba *phba)
 {
 	unsigned int cpu, numa_node;
-	struct cpumask *numa_mask = NULL;
+	struct cpumask *numa_mask = &phba->sli4_hba.numa_mask;
 
-#ifdef CONFIG_NUMA
-	numa_node = phba->pcidev->dev.numa_node;
-#else
-	numa_node = NUMA_NO_NODE;
-#endif
-	numa_mask = &phba->sli4_hba.numa_mask;
+	numa_node = dev_to_node(&phba->pcidev->dev);
+	if (numa_node == NUMA_NO_NODE)
+		return;
 
 	cpumask_clear(numa_mask);
 
-	/* Check if we're a NUMA architecture */
-	if (!cpumask_of_node(numa_node))
-		return;
-
 	for_each_possible_cpu(cpu)
 		if (cpu_to_node(cpu) == numa_node)
 			cpumask_set_cpu(cpu, numa_mask);
-- 
2.23.0

