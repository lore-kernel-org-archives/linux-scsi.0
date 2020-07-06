Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E902C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 20:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6806320723
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 20:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bdvHTqIz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgGFUmj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 16:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgGFUmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 16:42:39 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DBEC061794
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 13:42:39 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so43467899wml.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2020 13:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VyLMoYjdK1T5oytHD6dpgbIQeFyeCvTbY1R9synIJeM=;
        b=bdvHTqIzlcpmofEznfPmzSmERdwlNV5ZGX56NTqMU6PNV3wDVjJ9duxiqHk3Dw1Snm
         JU+gvSbtov1E/jPSlsvx/QmyJwgoMm0zv9yHsVQ3Ire2EK2JFV7NT3D2HqauG4le2vNZ
         t7DgBISVfG5qYDoIeYVqmJyiG39xR6Rk/S8bQMxJx523zdzg5GY8nlMHxo/vp3a20QEA
         9XgsZe7pI4nPffMEbWN+99KqGipfINu+gKTTObJAtp4lquFPs8NfvUwGsE9+v6nVhBJF
         c22ygDeAq+0m1EtuyKX/RWV3yJjKVk/H/B+0AR3rwxA57EmBAX+4O1M/s2Ie17za63CK
         gHAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VyLMoYjdK1T5oytHD6dpgbIQeFyeCvTbY1R9synIJeM=;
        b=RZEJ5ahFJbDhzVjhNz9tNHDPmaa4R03OYRIa/93+4vJepqNvvYcvYU4ZUG0keNw88v
         kZUI1ddViQAOQ64J1LU9w7eDF3k8zRKAg81qpKdm3K6kgkQAZ969s4u5oELWtHhaLmm2
         L+un2kuUAAviuCBQUWwz8dZi1QPAzCBnYL7+LH8cqbDZAJ9cWelSBFw0eQhV1zKwEvMU
         v4cwvH9hY1PekiyPZ7EfPwSLAX3ESLUngdc6XLvMgB5k2mh4I9sCxGQ7VXYq0FcEG6QX
         s56EuXX2jMG8S8a93VTwTMhizIPXr6oKbUMRdsqDNOmcdkvt1IftJbi10C8OjujIM2R0
         NVlg==
X-Gm-Message-State: AOAM533PtRPKWOKlywXBnuLgz+y/N/9qIF7Y1Gj8Qa08ztu/nYM0Uvwc
        hMw228Wwcb/K5x/xzJ4KNq/EwAWu
X-Google-Smtp-Source: ABdhPJy/NCT8B0ruA8t5ZtSK7iYmfoe5iXTnCHvW8SqFw6RH26uGVm9CnH0Rj/zKNeqPBbJ3Q4nDHQ==
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr872153wmm.156.1594068157739;
        Mon, 06 Jul 2020 13:42:37 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-85-189.oc.oc.cox.net. [68.5.85.189])
        by smtp.gmail.com with ESMTPSA id m4sm646877wmi.48.2020.07.06.13.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:42:37 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] lpfc: Fix interrupt assignments when multiple vectors are supported on same cpu
Date:   Mon,  6 Jul 2020 13:42:30 -0700
Message-Id: <20200706204230.130363-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With certain platforms its possible pci_alloc_irq_vectors() may
affinitize irq vectors to multiple (all?) cpus. The driver is currently
assuming exclusivity and vectors being doled out to different cpus and
is assigning primary ownership of each vector to the first cpu in the
mask.  The code doesn't bother to check if the cpu already owns a vector
and will unconditionally overwrite the cpu to vector mapping. This causes
the relationships between eq's and cq's to get confused and gets worse
when cpus start to offline. The net results are interrupts are skipped
resulting in mailbox timeouts and there are oops's in cpu offling flows.

Fix this changing up the primary vector assignment. Now assign the eq to
a cpu only if it is the cpu in the mask that does not have a prior
assignment. And once the primary ownership is assigned, break from the
loop. For cpu's that may have been set before but not the primary owner,
the lpfc_cpu_affinity_check() routine will balance the cpu to eq
assignment.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 33d334ac8d20..4ba8202d391b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11522,9 +11522,9 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	char *name;
 	const struct cpumask *aff_mask = NULL;
 	unsigned int cpu = 0, cpu_cnt = 0, cpu_select = nr_cpu_ids;
+	struct lpfc_vector_map_info *cpup;
 	struct lpfc_hba_eq_hdl *eqhdl;
 	const struct cpumask *maskp;
-	bool first;
 	unsigned int flags = PCI_IRQ_MSIX;
 
 	/* Set up MSI-X multi-message vectors */
@@ -11597,18 +11597,28 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		} else {
 			maskp = pci_irq_get_affinity(phba->pcidev, index);
 
-			first = true;
 			/* Loop through all CPUs associated with vector index */
 			for_each_cpu_and(cpu, maskp, cpu_present_mask) {
+				cpup = &phba->sli4_hba.cpu_map[cpu];
+
 				/* If this is the first CPU thats assigned to
 				 * this vector, set LPFC_CPU_FIRST_IRQ.
+				 *
+				 * With certain platforms its possible that irq
+				 * vectors are affinitized to all the cpu's.
+				 * This can result in each cpu_map.eq to be set
+				 * to the last vector, resulting in overwrite
+				 * of all the previous cpu_map.eq.  Ensure that
+				 * each vector receives a place in cpu_map.
+				 * Later call to lpfc_cpu_affinity_check will
+				 * ensure we are nicely balanced out.
 				 */
+				if (cpup->eq != LPFC_VECTOR_MAP_EMPTY)
+					continue;
 				lpfc_assign_eq_map_info(phba, index,
-							first ?
-							LPFC_CPU_FIRST_IRQ : 0,
+							LPFC_CPU_FIRST_IRQ,
 							cpu);
-				if (first)
-					first = false;
+				break;
 			}
 		}
 	}
-- 
2.25.0

