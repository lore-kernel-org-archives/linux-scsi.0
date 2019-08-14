Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7D3C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63A5F20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bYxtbHB0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfHNX5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32880 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbfHNX5d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id g2so357389pfq.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X2r6dtgA9YomhqARR1fDld/gbu41WWQ6rQDhLjveO/o=;
        b=bYxtbHB0fov/mwrspWBl+kFg6r1abwfSiiRJ5AH5AjhwEuyVgbS0W+9ZxRdmAUtqpP
         FDaV3M/GU6rTOb1XV1X+ywsXX8mDCa2XwEH/ps2uVZIK7ZgBNn0s1hQxbIlXUpJpJ6GV
         mpgRoV7VJy4FvyxByERVsA6TQD+wx669MTBbAQwncfgV7IsHwBw7WLSVMbyi4She/RGO
         y0B71v3TOoxq5jeQptvrlFrqqt/R56ydsQdHns88+tcA1Ui1M43xYHvN6E9RU7GY3dL1
         UKu3BCa+GM3r/C0mUkMr4rG6/Ok3yoS4C4oTUF+BIgRUNFYtrwMPtgWFGw08puoWiKKI
         qm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=X2r6dtgA9YomhqARR1fDld/gbu41WWQ6rQDhLjveO/o=;
        b=jQFeFLBaI2PX4ioPSo7Yqz3nee5Lg9OZjdxRBi2G7VFXdq+f22B5+bPjqmXXfdMsxa
         QQIqJh7Eztxd+tV0Fhc2AhxiZKqPMtKZ5GUP0qda6soc8X3hX6zBZ4MkX7T91q+cMsS7
         +qIIUTmzds1NANpLDfzMqYibPU4S7/Cd5T8wHtvN/WCUwPXW50vACGhzTBbrS8u/SMCU
         LtfoXihhJN8dI06KqQXLbIRedY4w+0RS2l3lanclQth5ay7BNAnpH4FFgjvhZJlWEkKN
         jGcaS3X0JtOjlOKqysJ88nzhYW4Jqc75eELfHQU+e9zu302RyBA6mh7zPELhvFyoPv5U
         5Ttw==
X-Gm-Message-State: APjAAAWArVE0ecLPBiXEAbruwjcoNT8WkqMpo6Q9S61aJipx4tB7KfoE
        lNd8zSiNkqo+quE5w5U2OUPio4d8
X-Google-Smtp-Source: APXvYqxg9tyq4m0BXmUOXq7sfGhoYmKglXzxMN9wqrJekpl/lbmSpkFujLZbj0d9eehQERRVd9TeLQ==
X-Received: by 2002:a63:d84e:: with SMTP id k14mr1384869pgj.234.1565827052214;
        Wed, 14 Aug 2019 16:57:32 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:31 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 13/42] lpfc: Fix oops when fewer hdwqs than cpus
Date:   Wed, 14 Aug 2019 16:56:43 -0700
Message-Id: <20190814235712.4487-14-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When tearing down the adapter for a reset, online/offline, or driver
unload, the queue free routine would hit a GPF oops.  This only
occurs on conditions where the number of hardware queues created is
fewer than the number of cpus in the system. In this condition cpus
share a hardware queue. And of course, it's the 2nd cpu that shares
a hardware that attempted to free it a second time and hit the oops.

Fix by reworking the cpu to hardware queue mapping such that:
Assignment of hardware queues to cpus occur in two passes:
first pass: is first time assignment of a hardware queue to a cpu.
  This will set the LPFC_CPU_FIRST_IRQ flag for the cpu.
second pass: for cpus that did not get a hardware queue they will
  be assigned one from a primary cpu (one set in first pass).

Deletion of hardware queues is driven by cpu itteration, and queues
will only be deleted if the LPFC_CPU_FIRST_IRQ flag is set.

Also contains a few small cleanup fixes and a little better logging.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 144 ++++++++++++++++++++++++++----------------
 1 file changed, 89 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 72353c9c0fa9..fcc1c45f2d35 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8878,7 +8878,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		}
 		qdesc->qe_valid = 1;
 		qdesc->hdwq = cpup->hdwq;
-		qdesc->chann = cpu; /* First CPU this EQ is affinitised to */
+		qdesc->chann = cpu; /* First CPU this EQ is affinitized to */
 		qdesc->last_cpu = qdesc->chann;
 
 		/* Save the allocated EQ in the Hardware Queue */
@@ -10725,7 +10725,7 @@ lpfc_find_hyper(struct lpfc_hba *phba, int cpu,
 static void
 lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 {
-	int i, cpu, idx, new_cpu, start_cpu, first_cpu;
+	int i, cpu, idx, next_idx, new_cpu, start_cpu, first_cpu;
 	int max_phys_id, min_phys_id;
 	int max_core_id, min_core_id;
 	struct lpfc_vector_map_info *cpup;
@@ -10767,8 +10767,8 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 #endif
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3328 CPU physid %d coreid %d\n",
-				cpup->phys_id, cpup->core_id);
+				"3328 CPU %d physid %d coreid %d flag x%x\n",
+				cpu, cpup->phys_id, cpup->core_id, cpup->flag);
 
 		if (cpup->phys_id > max_phys_id)
 			max_phys_id = cpup->phys_id;
@@ -10826,17 +10826,17 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			cpup->eq = idx;
 			cpup->irq = pci_irq_vector(phba->pcidev, idx);
 
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"3336 Set Affinity: CPU %d "
-					"irq %d eq %d\n",
-					cpu, cpup->irq, cpup->eq);
-
 			/* If this is the first CPU thats assigned to this
 			 * vector, set LPFC_CPU_FIRST_IRQ.
 			 */
 			if (!i)
 				cpup->flag |= LPFC_CPU_FIRST_IRQ;
 			i++;
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"3336 Set Affinity: CPU %d "
+					"irq %d eq %d flag x%x\n",
+					cpu, cpup->irq, cpup->eq, cpup->flag);
 		}
 	}
 
@@ -10950,69 +10950,103 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 		}
 	}
 
+	/* Assign hdwq indices that are unique across all cpus in the map
+	 * that are also FIRST_CPUs.
+	 */
+	idx = 0;
+	for_each_present_cpu(cpu) {
+		cpup = &phba->sli4_hba.cpu_map[cpu];
+
+		/* Only FIRST IRQs get a hdwq index assignment. */
+		if (!(cpup->flag & LPFC_CPU_FIRST_IRQ))
+			continue;
+
+		/* 1 to 1, the first LPFC_CPU_FIRST_IRQ cpus to a unique hdwq */
+		cpup->hdwq = idx;
+		idx++;
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3333 Set Affinity: CPU %d (phys %d core %d): "
+				"hdwq %d eq %d irq %d flg x%x\n",
+				cpu, cpup->phys_id, cpup->core_id,
+				cpup->hdwq, cpup->eq, cpup->irq, cpup->flag);
+	}
 	/* Finally we need to associate a hdwq with each cpu_map entry
 	 * This will be 1 to 1 - hdwq to cpu, unless there are less
 	 * hardware queues then CPUs. For that case we will just round-robin
 	 * the available hardware queues as they get assigned to CPUs.
+	 * The next_idx is the idx from the FIRST_CPU loop above to account
+	 * for irq_chann < hdwq.  The idx is used for round-robin assignments
+	 * and needs to start at 0.
 	 */
-	idx = 0;
+	next_idx = idx;
 	start_cpu = 0;
+	idx = 0;
 	for_each_present_cpu(cpu) {
 		cpup = &phba->sli4_hba.cpu_map[cpu];
-		if (idx >=  phba->cfg_hdw_queue) {
-			/* We need to reuse a Hardware Queue for another CPU,
-			 * so be smart about it and pick one that has its
-			 * IRQ/EQ mapped to the same phys_id (CPU package).
-			 * and core_id.
-			 */
-			new_cpu = start_cpu;
-			for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
-				new_cpup = &phba->sli4_hba.cpu_map[new_cpu];
-				if ((new_cpup->hdwq != LPFC_VECTOR_MAP_EMPTY) &&
-				    (new_cpup->phys_id == cpup->phys_id) &&
-				    (new_cpup->core_id == cpup->core_id))
-					goto found_hdwq;
-				new_cpu = cpumask_next(
-					new_cpu, cpu_present_mask);
-				if (new_cpu == nr_cpumask_bits)
-					new_cpu = first_cpu;
-			}
 
-			/* If we can't match both phys_id and core_id,
-			 * settle for just a phys_id match.
-			 */
-			new_cpu = start_cpu;
-			for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
-				new_cpup = &phba->sli4_hba.cpu_map[new_cpu];
-				if ((new_cpup->hdwq != LPFC_VECTOR_MAP_EMPTY) &&
-				    (new_cpup->phys_id == cpup->phys_id))
-					goto found_hdwq;
-				new_cpu = cpumask_next(
-					new_cpu, cpu_present_mask);
-				if (new_cpu == nr_cpumask_bits)
-					new_cpu = first_cpu;
+		/* FIRST cpus are already mapped. */
+		if (cpup->flag & LPFC_CPU_FIRST_IRQ)
+			continue;
+
+		/* If the cfg_irq_chann < cfg_hdw_queue, set the hdwq
+		 * of the unassigned cpus to the next idx so that all
+		 * hdw queues are fully utilized.
+		 */
+		if (next_idx < phba->cfg_hdw_queue) {
+			cpup->hdwq = next_idx;
+			next_idx++;
+			continue;
+		}
+
+		/* Not a First CPU and all hdw_queues are used.  Reuse a
+		 * Hardware Queue for another CPU, so be smart about it
+		 * and pick one that has its IRQ/EQ mapped to the same phys_id
+		 * (CPU package) and core_id.
+		 */
+		new_cpu = start_cpu;
+		for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+			new_cpup = &phba->sli4_hba.cpu_map[new_cpu];
+			if (new_cpup->hdwq != LPFC_VECTOR_MAP_EMPTY &&
+			    new_cpup->phys_id == cpup->phys_id &&
+			    new_cpup->core_id == cpup->core_id) {
+				goto found_hdwq;
 			}
+			new_cpu = cpumask_next(new_cpu, cpu_present_mask);
+			if (new_cpu == nr_cpumask_bits)
+				new_cpu = first_cpu;
+		}
 
-			/* Otherwise just round robin on cfg_hdw_queue */
-			cpup->hdwq = idx % phba->cfg_hdw_queue;
-			goto logit;
-found_hdwq:
-			/* We found an available entry, copy the IRQ info */
-			start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (start_cpu == nr_cpumask_bits)
-				start_cpu = first_cpu;
-			cpup->hdwq = new_cpup->hdwq;
-		} else {
-			/* 1 to 1, CPU to hdwq */
-			cpup->hdwq = idx;
+		/* If we can't match both phys_id and core_id,
+		 * settle for just a phys_id match.
+		 */
+		new_cpu = start_cpu;
+		for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+			new_cpup = &phba->sli4_hba.cpu_map[new_cpu];
+			if (new_cpup->hdwq != LPFC_VECTOR_MAP_EMPTY &&
+			    new_cpup->phys_id == cpup->phys_id)
+				goto found_hdwq;
+
+			new_cpu = cpumask_next(new_cpu, cpu_present_mask);
+			if (new_cpu == nr_cpumask_bits)
+				new_cpu = first_cpu;
 		}
-logit:
+
+		/* Otherwise just round robin on cfg_hdw_queue */
+		cpup->hdwq = idx % phba->cfg_hdw_queue;
+		idx++;
+		goto logit;
+ found_hdwq:
+		/* We found an available entry, copy the IRQ info */
+		start_cpu = cpumask_next(new_cpu, cpu_present_mask);
+		if (start_cpu == nr_cpumask_bits)
+			start_cpu = first_cpu;
+		cpup->hdwq = new_cpup->hdwq;
+ logit:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3335 Set Affinity: CPU %d (phys %d core %d): "
 				"hdwq %d eq %d irq %d flg x%x\n",
 				cpu, cpup->phys_id, cpup->core_id,
 				cpup->hdwq, cpup->eq, cpup->irq, cpup->flag);
-		idx++;
 	}
 
 	/* The cpu_map array will be used later during initialization
-- 
2.13.7

