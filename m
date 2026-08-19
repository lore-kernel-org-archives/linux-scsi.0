Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA3B36A34F;
	Wed, 19 Aug 2026 00:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787100716; cv=none; b=YpLRx+W7nkyO4CiVFWejY2vwiDR6s1skjXxL5NFMsUEFHLaq7oXitaLz8Rh8z7xivwmtVD78iCSm/PUTpJvzBWciVkvmhOTpWtS3Q8BCUQ8UtLrUz+FkSkd4NguPtrGe8YLlGal82QuG0t9ChnNVBNo1qbZpvGZnexwuD9w4DuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787100716; c=relaxed/simple;
	bh=oc/0KULaHoN6SnJXZv/6S58xCCc+QyBkXF8Ljgn0zQ4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fsts9CE+Q52ViU9/vIRzoHji6DolWNvUj3Eze72NVh0MA0AdA6CyBhBgZVUCdhyB6QS2oPmlumW+Ft5m7GHGbNM69T8MOgEilmC4Lw7NFhlx9DswLldqWYmtvYxjy8mZXmTDzpmpMYTUKDEG9rxrcV7Aywji2yJYsyDYP1eLyRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wDXwH4e_oRqDEumAA--.18943S3;
	Wed, 19 Aug 2026 08:51:43 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app3 (Coremail) with SMTP id zS_KCgD3MHQe_oRqBs19BA--.43316S2;
	Wed, 19 Aug 2026 08:51:42 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	megaraidlinux.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: megaraid_sas: kill tasklet after free_irq in teardown paths
Date: Wed, 19 Aug 2026 00:50:43 +0000
Message-Id: <20260819005043.439436-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgD3MHQe_oRqBs19BA--.43316S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?BO2tRAXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnZPoDCNGYdHSfuFmYJL54WMaYFv/hR4zMR5+IQtbZGQZ2QMhKutmIkYA9lCRHeVpib8H
	VZo9S4DSVA/s4W9DIsbN5RPxYw6l01w8CbPzC/8w
X-Coremail-Antispam: 1Uk129KBj93XoWxCw17WFyfAr43Cr4xJrWfXrc_yoW5AFWkpr
	ykGw4Utry8Z3WF9rWqvw48Cr1jy39xG3s8CrW8t347tr1Fvr9avrs7tr4fKFs2yr4kXanr
	Jr1jqws5uan8JwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Cr1j6rxdM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l57
	IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE
	14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2
	IYc2Ij64vIr41lF7xvr2IYc2Ij64vIr40E4x8a64kEw24lFIxGxcIEc7CjxVA2Y2ka0xkI
	wI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jbo7NUUUUU=

On MFI-series adapters the interrupt handler arms instance->isr_tasklet
for as long as the interrupt is registered, so the tasklet can be armed
again after tasklet_kill() has returned.  megasas_detach_one() and
megasas_suspend() kill the tasklet before unregistering the interrupts,
and the probe error paths skip the kill entirely, so the completion
callback can run after the teardown frees the buffers it dereferences,
or a tasklet pending across suspend is re-initialized by resume's
tasklet_init() while still queued.

Kill the tasklet after megasas_destroy_irqs(), which drains the handler
via free_irq(), and add the missing kills in the probe error paths.

This issue was found by an in-house static analysis tool.

Fixes: 5d018ad05734 ("[SCSI] megaraid_sas: adds tasklet for cmd completion")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ecd365d78ae3..627bcba720cd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6536,6 +6536,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 fail_get_ld_pd_list:
 	instance->instancet->disable_intr(instance);
 	megasas_destroy_irqs(instance);
+	tasklet_kill(&instance->isr_tasklet);
 fail_init_adapter:
 	if (instance->msix_vectors)
 		pci_free_irq_vectors(instance->pdev);
@@ -7618,6 +7619,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 
 	instance->instancet->disable_intr(instance);
 	megasas_destroy_irqs(instance);
+	tasklet_kill(&instance->isr_tasklet);
 
 	if (instance->adapter_type != MFI_SERIES)
 		megasas_release_fusion(instance);
@@ -7770,12 +7772,11 @@ megasas_suspend(struct device *dev)
 		instance->ev = NULL;
 	}
 
-	tasklet_kill(&instance->isr_tasklet);
-
 	pci_set_drvdata(instance->pdev, instance);
 	instance->instancet->disable_intr(instance);
 
 	megasas_destroy_irqs(instance);
+	tasklet_kill(&instance->isr_tasklet);
 
 	if (instance->msix_vectors)
 		pci_free_irq_vectors(instance->pdev);
@@ -8010,8 +8011,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	/* cancel all wait events */
 	wake_up_all(&instance->int_cmd_wait_q);
 
-	tasklet_kill(&instance->isr_tasklet);
-
 	/*
 	 * Take the instance off the instance array. Note that we will not
 	 * decrement the max_index. We let this array be sparse array
@@ -8028,6 +8027,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	instance->instancet->disable_intr(instance);
 
 	megasas_destroy_irqs(instance);
+	tasklet_kill(&instance->isr_tasklet);
 
 	if (instance->msix_vectors)
 		pci_free_irq_vectors(instance->pdev);

