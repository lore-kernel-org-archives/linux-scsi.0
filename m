Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4102C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 23:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83660214DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 23:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J76pnmpW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfKKXEU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:04:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51450 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbfKKXET (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 18:04:19 -0500
Received: by mail-wm1-f68.google.com with SMTP id q70so1080387wme.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 15:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RiCOjoQ4Bk4abOc3AYp0fY+CXhVRTsgH7CIalrQnD24=;
        b=J76pnmpWVceCHO5A/9SJEgSNBEwqTzhgqcZVJhfdLgA/GWtvPmhlxx5ZdVOblKMiLB
         Dw8M2YGbf9BT6067iPjWsCqm1W4YZfknXerprOcGFRtrqwuS1BShamPOB22PmC1bbP6H
         t6uSNpyuYpxTi+o0prcPBJvW+Ye615pDQOaLKfApaURJz9R8InMMLGh2ewAmngDdNpXK
         fQZElH7ofkAxDPgVr6lxGlbe0oEDX4Vv5VhRTEmCCSr9TfJtyqrSRVA0x28Yb08tDHHP
         tIFFaqIjSn2toVOU2KxseRagVBCD1awtiMnz6iEEFwXiFqCt9MFeXjxKRvnF3rOV1f1S
         iABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RiCOjoQ4Bk4abOc3AYp0fY+CXhVRTsgH7CIalrQnD24=;
        b=tkMOMCxzjzsr89F6G8tDSsIZAIKSPFziu1SM3akmo1drFrgyto8Q3J5va/zw0exk1m
         9FQIOgjBD2GxpKbeYsv1crYabDj14p+SE4bQGkby4cmvhIvfuIhSB12oRu1mm/baeVH+
         fR58uwfEDPt80rI+itnIjz2sjGg9Jvwwz9PM82BJbOB84nM7NAC0QtDNNt88xvyBnUWO
         EfE2jYibEO+S/NC3y2acmSFuHuQaoQBlDCkpjZ5lc1x75pq+CYdzXcRvYz5NJvESn/rD
         aBN/tqFMoA/Z8f/ld45gwUbXzlwuk4+7IL/Ub2wjxVyS/wwPmQKSF4+zcYPOJWAV3Pf9
         4S3A==
X-Gm-Message-State: APjAAAXRIBpamJ89DJJFdSbd4zRTQ2qSOM8u23+AzIXPYwb3cnOAMH5w
        WwHh3UvTqtp/kPtre8lEzVJiErV9
X-Google-Smtp-Source: APXvYqySuk0i/S1LFExGOOaauBvlU7EbKU8qZoC53WgPVhX26T2zrUryJ9WBHpi9gQlQV9KlHt10dQ==
X-Received: by 2002:a7b:c08f:: with SMTP id r15mr1095178wmh.45.1573513457738;
        Mon, 11 Nov 2019 15:04:17 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m25sm655146wmi.46.2019.11.11.15.04.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 15:04:17 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 4/6] lpfc: Initialize cpu_map for not present cpus
Date:   Mon, 11 Nov 2019 15:03:59 -0800
Message-Id: <20191111230401.12958-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191111230401.12958-1-jsmart2021@gmail.com>
References: <20191111230401.12958-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, cpu_map[cpu#]->hdwq is left to equal
LPFC_VECTOR_MAP_EMPTY for not present CPUs.  If a CPU
is dynamically hot-added, it is possible we may crash due to
not assigning an allocated hdwq.

Correct by assigning a hdwq at initialization for all
not-present cpu's.

Fixes: dcaa21367938 ("scsi: lpfc: Change default IRQ model on AMD architectures")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
Issue applies as of the 12.2.0.0 patch kit, but this fix requires
the above patch set for resolution. Referenced patch is in the
5.5/scsi-queue branch
---
 drivers/scsi/lpfc/lpfc_init.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 480d5a28c4f5..2b0e1097f727 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11004,7 +11004,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 				cpu, cpup->phys_id, cpup->core_id,
 				cpup->hdwq, cpup->eq, cpup->flag);
 	}
-	/* Finally we need to associate a hdwq with each cpu_map entry
+	/* Associate a hdwq with each cpu_map entry
 	 * This will be 1 to 1 - hdwq to cpu, unless there are less
 	 * hardware queues then CPUs. For that case we will just round-robin
 	 * the available hardware queues as they get assigned to CPUs.
@@ -11083,6 +11083,23 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 				cpup->hdwq, cpup->eq, cpup->flag);
 	}
 
+	/*
+	 * Initialize the cpu_map slots for not-present cpus in case
+	 * a cpu is hot-added. Perform a simple hdwq round robin assignment.
+	 */
+	idx = 0;
+	for_each_possible_cpu(cpu) {
+		cpup = &phba->sli4_hba.cpu_map[cpu];
+		if (cpup->hdwq != LPFC_VECTOR_MAP_EMPTY)
+			continue;
+
+		cpup->hdwq = idx++ % phba->cfg_hdw_queue;
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"3340 Set Affinity: not present "
+				"CPU %d hdwq %d\n",
+				cpu, cpup->hdwq);
+	}
+
 	/* The cpu_map array will be used later during initialization
 	 * when EQ / CQ / WQs are allocated and configured.
 	 */
-- 
2.13.7

