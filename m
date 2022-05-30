Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996E1C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 23:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242826AbiE3XPk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 19:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbiE3XPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 19:15:39 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB94712FA
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 16:15:37 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 6C739811AD;
        Mon, 30 May 2022 23:15:36 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 036D380F3B;
        Mon, 30 May 2022 23:15:36 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1653952536; a=rsa-sha256;
        cv=none;
        b=It8KsC59iNnDYcaDCFv10wEeH76+nt7+cURuYKffLQi83H7HxC21B8CO77WgellhHECNmR
        oZWD9AAJ/L2m7jCqa+eV2ZvpiZaVP9iy4XguKNo9nAgVE0rX1ofaWSfXz3FijHiE1JZWxn
        pUMhphUrlCrmmfBIAyfSFd7jrjRmfgnz+KOH4PHmZ/TuoSGhLh5gUSRd+/1YXrx18YR2Zk
        oOfkc795rauvSREg+oDaTj7VNKRxFSfkuTm8mJ6SsYQjW8X/HSNAFR2XpOjywOCio8xZ1W
        G7HEKOdD8u868v5KggHLzxTPGPXqZ87H1VfRosdFp/AGGyhlm+LHE/Tv81qC0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1653952536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=Md0UglnLrm55xoVRMWppSTa3P+8k6XDCY738goMHV5Y=;
        b=sMVE0bdUumyBTqHEqIOWLsnFbK8izFNwsrfd8WCsPxROb8jgI2e3NDhsX3XcUmO9LIDXQZ
        5xiXNZ4eXe9Bhv9EVGE+IqcZp9XuQiIiealrSpzKGbMbnBXQ0lPe/M5we9qsck3l4hXeHx
        qdBRxSHevtMbNbtV5R5WmtEpvyz56kmgi54FFY4yensfQkVfYf7Dkv+SZKxfwXmGHi8qSA
        KReC5/fWY9DFDT3XRJZgPmCTwlQ338gfGfudM63jTFQzYQFMgQ0TWaSW5x7hx3UD9NnOm0
        lbFTEAja8LR4UEu9+ASWy5dT/JjvLn7jE6Tfx+8IElGfokHluAmZg0KpwM7rTw==
ARC-Authentication-Results: i=1;
        rspamd-54ff499d4f-n6vbx;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Chief-Celery: 3fef4f62615d56c2_1653952536289_3632414120
X-MC-Loop-Signature: 1653952536289:2402954016
X-MC-Ingress-Time: 1653952536289
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.98.242.203 (trex/6.7.1);
        Mon, 30 May 2022 23:15:36 +0000
Received: from localhost.localdomain (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LBrqW2md9z2g;
        Mon, 30 May 2022 16:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1653952535;
        bh=Md0UglnLrm55xoVRMWppSTa3P+8k6XDCY738goMHV5Y=;
        h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
        b=S7ptYqF471xXf0BTVRrDs4tBPOmLlel5kWhtNEQ88mDPXXO4OXAdJBHdyly+usN6p
         a+2jiNpot8770CGXWJyDz/S+MMixx6dxZG9tpgm/xGAGQYaIsxcvyPUxKGnpKZHni2
         YmnavqgIn2NVxYhwRk1VdBvRXKX5qSJUhgjhKneEQ8e+Brpcyi7o8ZiyNGmFmiXc0I
         3uzTyUc//tLu464VMrwr+m71YKLSFgVb7W94hZ6W1OmE7M9+bo3N4MeqnpXqGqRbfq
         hE8JjXaIt/7wLvMaTXqBFTF1en1qwE0wECRWW4gzAY5HTZLbgYFRgd6ewjVsfCqDNU
         vlkhC8YOZFZuA==
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, ejb@linux.ibm.com,
        bigeasy@linutronix.de, tglx@linutronix.de, dave@stgolabs.net
Subject: [PATCH 01/10] scsi/mvsas: Kill CONFIG_SCSI_MVSAS_TASKLET
Date:   Mon, 30 May 2022 16:15:03 -0700
Message-Id: <20220530231512.9729-2-dave@stgolabs.net>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530231512.9729-1-dave@stgolabs.net>
References: <20220530231512.9729-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tasklets have long been deprecated as being too heavy on the system
by running in irq context - and this is not a performance critical
path. If a higher priority process wants to run, it must wait for
the tasklet to finish before doing so. A more suitable equivalent
is to converted to threaded irq instead.

As such remove CONFIG_SCSI_MVSAS_TASKLET (which is horrible to begin
with) and continue to do the async work, unconditionally now, just
in task context. Just as with the tasklet version, device interrupts
(MVS_IRQ_SAS_A/B) continues to be disabled from when the work was
putted until it is actually complete. Because there are no guarantees
vs ksoftirqd, if this is broken for threaded irqs, then they are
also broken for tasklets.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 drivers/scsi/mvsas/Kconfig   |  7 ------
 drivers/scsi/mvsas/mv_init.c | 44 ++++++------------------------------
 drivers/scsi/mvsas/mv_sas.h  |  1 -
 3 files changed, 7 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
index 79812b80743b..e9dd8dc84b1c 100644
--- a/drivers/scsi/mvsas/Kconfig
+++ b/drivers/scsi/mvsas/Kconfig
@@ -23,10 +23,3 @@ config SCSI_MVSAS_DEBUG
 	help
 		Compiles the 88SE64XX/88SE94XX driver in debug mode.  In debug mode,
 		the driver prints some messages to the console.
-config SCSI_MVSAS_TASKLET
-	bool "Support for interrupt tasklet"
-	default n
-	depends on SCSI_MVSAS
-	help
-		Compiles the 88SE64xx/88SE94xx driver in interrupt tasklet mode.In this mode,
-		the interrupt will schedule a tasklet.
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 2fde496fff5f..f36b270ba502 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -146,12 +146,10 @@ static void mvs_free(struct mvs_info *mvi)
 	kfree(mvi);
 }
 
-#ifdef CONFIG_SCSI_MVSAS_TASKLET
-static void mvs_tasklet(unsigned long opaque)
+static irqreturn_t mvs_async(int irq, void *opaque)
 {
 	u32 stat;
 	u16 core_nr, i = 0;
-
 	struct mvs_info *mvi;
 	struct sas_ha_struct *sha = (struct sas_ha_struct *)opaque;
 
@@ -172,46 +170,29 @@ static void mvs_tasklet(unsigned long opaque)
 out:
 	MVS_CHIP_DISP->interrupt_enable(mvi);
 
+	return IRQ_HANDLED;
 }
-#endif
 
 static irqreturn_t mvs_interrupt(int irq, void *opaque)
 {
 	u32 stat;
 	struct mvs_info *mvi;
 	struct sas_ha_struct *sha = opaque;
-#ifndef CONFIG_SCSI_MVSAS_TASKLET
-	u32 i;
-	u32 core_nr;
-
-	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
-#endif
 
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
 
 	if (unlikely(!mvi))
 		return IRQ_NONE;
-#ifdef CONFIG_SCSI_MVSAS_TASKLET
+
 	MVS_CHIP_DISP->interrupt_disable(mvi);
-#endif
 
 	stat = MVS_CHIP_DISP->isr_status(mvi, irq);
 	if (!stat) {
-	#ifdef CONFIG_SCSI_MVSAS_TASKLET
 		MVS_CHIP_DISP->interrupt_enable(mvi);
-	#endif
 		return IRQ_NONE;
 	}
 
-#ifdef CONFIG_SCSI_MVSAS_TASKLET
-	tasklet_schedule(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
-#else
-	for (i = 0; i < core_nr; i++) {
-		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
-		MVS_CHIP_DISP->isr(mvi, irq, stat);
-	}
-#endif
-	return IRQ_HANDLED;
+	return IRQ_WAKE_THREAD;
 }
 
 static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
@@ -557,14 +538,6 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 		nhost++;
 	} while (nhost < chip->n_host);
-#ifdef CONFIG_SCSI_MVSAS_TASKLET
-	{
-	struct mvs_prv_info *mpi = SHOST_TO_SAS_HA(shost)->lldd_ha;
-
-	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
-		     (unsigned long)SHOST_TO_SAS_HA(shost));
-	}
-#endif
 
 	mvs_post_sas_ha_init(shost, chip);
 
@@ -575,8 +548,9 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
 	if (rc)
 		goto err_out_shost;
-	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED,
-		DRV_NAME, SHOST_TO_SAS_HA(shost));
+	rc = request_threaded_irq(pdev->irq, irq_handler, mvs_async,
+				  IRQF_SHARED, DRV_NAME,
+				  SHOST_TO_SAS_HA(shost));
 	if (rc)
 		goto err_not_sas;
 
@@ -607,10 +581,6 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
 
-#ifdef CONFIG_SCSI_MVSAS_TASKLET
-	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
-#endif
-
 	sas_unregister_ha(sha);
 	sas_remove_host(mvi->shost);
 
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 509d8f32a04f..a0e87fdab98a 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -403,7 +403,6 @@ struct mvs_prv_info{
 	u8 scan_finished;
 	u8 reserve;
 	struct mvs_info *mvi[2];
-	struct tasklet_struct mv_tasklet;
 };
 
 struct mvs_wq {
-- 
2.36.1

