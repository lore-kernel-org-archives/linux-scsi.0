Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E01C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 05:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4990664F3F
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 05:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhBEFbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 00:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBEFbu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 00:31:50 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C087C0613D6;
        Thu,  4 Feb 2021 21:31:10 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id r20so4253179qtm.3;
        Thu, 04 Feb 2021 21:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sTnRMsC69QVAkzEVjJQCf5UQtQTJ/iyf90Mpzti0LlA=;
        b=FB0hUz9NPzwMDYWaU786702oTioqqlDJ3tzRHJPcCbcq7Ff94njppTxArnneqGf0V4
         LbG0bZPLizxcYEx3gvVKYkfuJd/47vJ9r8X/ud8jNVIHnMivg5UDItuIj+U1XrWXq10V
         +ueNF0Z6ZpMVnqsuiKd24bvrEvSXK+H3HouxxYEoOjBzi7yObP9CAneGXtWqh0t2RymK
         EMkvUFEsdj22QQRwgV8B3NrN+OjoNLg6OTAM/9MUxgMs4gBjgt7inxO9XRlF9tuwX34n
         J9bgAkkMKCofOxee5bxlT5xyZUyZnfFRt381Ih3j4AttjHs9qmMXHIS/Ck7SIvdOG4DF
         RIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sTnRMsC69QVAkzEVjJQCf5UQtQTJ/iyf90Mpzti0LlA=;
        b=OzNPfDiro09qvth0N4rSd05hKMq5edfcN9EDAErIgmiABZ6LEUe0IdgyoEhD1Gs0SP
         Yq5zeJKOI9xGWNksE0c3sHoLS2CfuKjaGE0XT4qq5wth9O/+QYulfxmdnzJKCcV0ySVG
         l/Ho4WBoN6URR8t1OF+OKlSxXWqal+SPuEVtkBhT+rJzc09haWqxmjYY0hUpZD0nVFkw
         sYUmsPuv3uDG+i5jl7tB8lFWvl8+rbDtdQAwTs8QqZdR+GLzNswCMAjQZNx0oEAweM5C
         swJHKpgqXKjnwCdXUtg0wEIjeOBDFuDMrjpAIMPqNOT6lR7TkabMNnitHXKbM4Eg3Hn2
         eHCw==
X-Gm-Message-State: AOAM530QVTmkJIvT0jNgz1gJdYfDMI9X+qZDafigoxuYAzap7ugs3MV1
        qHMIIuV4boZhiqgE88dEe+4=
X-Google-Smtp-Source: ABdhPJyxLwlFdYLyD+oZK5KVhu7P7Dmc6LWSl9ECrQNu5kFTxxDzSiIy6RtViB9H1ZhbAOZfWLY10Q==
X-Received: by 2002:ac8:5cd0:: with SMTP id s16mr2878083qta.333.1612503069253;
        Thu, 04 Feb 2021 21:31:09 -0800 (PST)
Received: from Slackware.localdomain ([138.199.10.87])
        by smtp.gmail.com with ESMTPSA id f7sm4541588qkh.45.2021.02.04.21.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 21:31:08 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: scsi: lpfc: Mundane spelling and sentence construction fixes throughout the file
Date:   Fri,  5 Feb 2021 11:00:36 +0530
Message-Id: <20210205053036.18054-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Few spellings and sentence  construction done throughout the file.


Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ac67f420ec26..923fadb7945a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11022,7 +11022,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			/* We found a matching phys_id, so copy the IRQ info */
 			cpup->eq = new_cpup->eq;

-			/* Bump start_cpu to the next slot to minmize the
+			/* Bump start_cpu to the next slot to minimize the
 			 * chance of having multiple unassigned CPU entries
 			 * selecting the same IRQ.
 			 */
@@ -11076,7 +11076,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			/* We found an available entry, copy the IRQ info */
 			cpup->eq = new_cpup->eq;

-			/* Bump start_cpu to the next slot to minmize the
+			/* Bump start_cpu to the next slot to minimize the
 			 * chance of having multiple unassigned CPU entries
 			 * selecting the same IRQ.
 			 */
@@ -11246,14 +11246,14 @@ lpfc_cpuhp_get_eq(struct lpfc_hba *phba, unsigned int cpu,
 		if (!maskp)
 			continue;
 		/*
-		 * if irq is not affinitized to the cpu going
+		 * if irq is not affinities to the cpu going
 		 * then we don't need to poll the eq attached
 		 * to it.
 		 */
 		if (!cpumask_and(tmp, maskp, cpumask_of(cpu)))
 			continue;
-		/* get the cpus that are online and are affini-
-		 * tized to this irq vector.  If the count is
+		/* get the cpus that are online and are affinities
+		 * to this irq vector.  If the count is
 		 * more than 1 then cpuhp is not going to shut-
 		 * down this vector.  Since this cpu has not
 		 * gone offline yet, we need >1.
@@ -11367,7 +11367,7 @@ lpfc_irq_clear_aff(struct lpfc_hba_eq_hdl *eqhdl)
  * online cpu on the phba's original_mask and migrate all offlining IRQ
  * affinities.
  *
- * If cpu is coming online, reaffinitize the IRQ back to the onlining cpu.
+ * If cpu is coming online, again affinities the IRQ back to the on lining cpu.
  *
  * Note: Call only if NUMA or NHT mode is enabled, otherwise rely on
  *	 PCI_IRQ_AFFINITY to auto-manage IRQ affinity.
@@ -11401,7 +11401,7 @@ lpfc_irq_rebalance(struct lpfc_hba *phba, unsigned int cpu, bool offline)

 		/* Found a valid CPU */
 		if ((cpu_select < nr_cpu_ids) && (cpu_select != cpu)) {
-			/* Go through each eqhdl and ensure offlining
+			/* Go through each eqhdl and ensure off lining
 			 * cpu aff_mask is migrated
 			 */
 			for (idx = 0; idx < phba->cfg_irq_chann; idx++) {
@@ -11597,7 +11597,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 				 * this vector, set LPFC_CPU_FIRST_IRQ.
 				 *
 				 * With certain platforms its possible that irq
-				 * vectors are affinitized to all the cpu's.
+				 * vectors are affinities to all the cpu's.
 				 * This can result in each cpu_map.eq to be set
 				 * to the last vector, resulting in overwrite
 				 * of all the previous cpu_map.eq.  Ensure that
@@ -11635,7 +11635,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		free_irq(eqhdl->irq, eqhdl);
 	}

-	/* Unconfigure MSI-X capability structure */
+	/* Not configure MSI-X capability structure */
 	pci_free_irq_vectors(phba->pcidev);

 vec_fail_out:
@@ -11744,7 +11744,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 		}
 	}

-	/* Fallback to INTx if both MSI-X/MSI initalization failed */
+	/* Fallback to INTx if both MSI-X/MSI initialization failed */
 	if (phba->intr_type == NONE) {
 		retval = request_irq(phba->pcidev->irq, lpfc_sli4_intr_handler,
 				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
@@ -12479,7 +12479,7 @@ lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
  * lpfc_pci_remove_one_s3 - PCI func to unreg SLI-3 device from PCI subsystem.
  * @pdev: pointer to PCI device
  *
- * This routine is to be called to disattach a device with SLI-3 interface
+ * This routine is to be called to not attach a device with SLI-3 interface
  * spec from PCI subsystem. When an Emulex HBA with SLI-3 interface spec is
  * removed from PCI bus, it performs all the necessary cleanup for the HBA
  * device to be removed from the PCI subsystem properly.
@@ -12940,7 +12940,7 @@ lpfc_log_write_firmware_error(struct lpfc_hba *phba, uint32_t offset,
 	/* Three cases:  (1) FW was not supported on the detected adapter.
 	 * (2) FW update has been locked out administratively.
 	 * (3) Some other error during FW update.
-	 * In each case, an unmaskable message is written to the console
+	 * In each case, an unusable message is written to the console
 	 * for admin diagnosis.
 	 */
 	if (offset == ADD_STATUS_FW_NOT_SUPPORTED ||
--
2.30.0

