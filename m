Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF003BADB6
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599058; cv=none; b=FQswE16pp50g/WNUSKVJ76fLWHRWkKyFMuB1hk0eVSbB6sfqjz6H6WADkzd+POzBXLvc3LlnEn81DRvdFUQV+rEAXg9igTo7c2hKl/iKk9umsB43EmJtuBuoahszTVaRsfMnsBbYUOZ9sKHPM/PmJ4xZJgxLnmSkdF9TWIQJBvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599058; c=relaxed/simple;
	bh=UCtH4x2HS3hooZzjZNUVPly7foSBDpPatHB7jNQol2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rFmacmeMrbqAPTDlL9RskTrUTIPN45M2ff8WTiBYkgcP4q7lwaeawHnf6plKXxJpBl+4asXqFI/ztAA27wseVitpU2zEaaen3+itaEZPG4Fc+/EJq13cuifkVEjyn/gPXeElRjP7KmtkAmvO9m5k7x57JSVlAXJELopz4VvFp+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LiCKuhl1; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LiCKuhl1"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9157b895c57so104944885a.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599056; x=1781203856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wr1WOv/QbJroAJz8xOQ6n0BRN5ROPQKE78Ib+UypKlE=;
        b=LiCKuhl1ua9q0fsvE58lxlyIFx0JhQs26jgGTBqR11obteeBKmC2fy0vyX3RTRr+uJ
         zJ5cuI5oYvm9+tyc4p/1Uu6oeYz1eJ1uwKkEc2kv9PFpRPKjAkGc71k9p42Yvs5Tlfp9
         EIzXN89R31hM60lbcC0wwbk/ni9jgY4HnwxkmItdoC+TiwRLL3MUG+hfuF0lPvLxYE6U
         7b4DEz5lFACbN6NmiZMpm91jw5jj/TFplRNsEDUa7tj83FDmhTLQWugdn0IdglS2h++2
         9b3ffAVN+EGNIbENOzNQiIxhJCcGG4em65mhGdlmbgfiTTzDNKhCv4dKt9rtxtbT5+rc
         nIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599056; x=1781203856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wr1WOv/QbJroAJz8xOQ6n0BRN5ROPQKE78Ib+UypKlE=;
        b=XS+JSyhFOT53pzLc/yV58Uu3IH8RInLX4aSZ4UdkFHWevC1fG2upqEKVfyB2iZTKNc
         dub5AiSeUjrsrpjH8++00onjoe/uDiV2qOPND4Up8cYxceZ1fEMHUGlpmCcd3PGJEbbG
         punS8/vA0T6vI+OU54hUYi4LCCevCuS/dNLEkgmRunnicQCXwkVyD6bUF/1nBHbZRuuX
         IMfW9RZRlSPNs708lS1vU2zWcbeRUHNU9a9kVZ6snQBKDbPxALj6FQ5EZWoASwDgAbig
         At9fj72jEFIre9zyY9k3jBlEhkw4jQ2AhRMaiYf27uTnXwdYX7Ekqf/ArCO1xlvDNckb
         oCog==
X-Gm-Message-State: AOJu0YxEhfMT2SXYMGHwBUoPA64VMbjoWlaMLfcZxJabVAKgIRfCnT0z
	0SPq/aBh3ZWVsgpsEAK4J/vEY+dwT3+BdXAxWySwKi2nF/+JtsvhaowXPYPKiad/
X-Gm-Gg: Acq92OGw6aHm1uBqN8E4oEVbGmDmkkIsELMfpYeI9Af4kUgU1+vq0aCDYZp2Jvip/IG
	7Jnb88L4i9+QnXwgHLNEeoXcd1eZbV1ImUvqstSXBiEbnh/EwYwmVARCQY2Z1cwi9VmXy80zHZK
	n397Ub3aVJz948weGtyMr+HVP0Gv6bFyCy7AjmXIm77U9yisExsPZI2Cx4zRmAY0TyM9nmc/7Rz
	8qO/k3IgYosQeeqD95vpLtTDQ8+mnVzdpu3s3k1vIT/BJcCIcNIXmKaTqHB5cL78xVaD3cAic9T
	TGaK8mqhKgnkkoiEjrsKVEWobGRKcQUcg3FAqmO7zsunhf15jXvrQQ6Uu6nQ1aHkccf7E+RpZdY
	raja+gPatTL/xMpYEyrIR0r0A9/Qa5bvTcPIUwgjpxIyt1U/c0vqvvz+TsU74drXMHchOU6v/yX
	4yOcll+IodHcCkPbC8sfvVu940siOz8QTST0BXMHLuH9LD4cRj7nZSXHpr3Io24UjSMWuOhowyF
	nClObIfwHEZDQQXKIrSqCtOZUhWgDBqwiM2v9tMaWF7l4M+aD0Zdw==
X-Received: by 2002:a05:620a:410f:b0:915:8502:f7fd with SMTP id af79cd13be357-915a9c9afc5mr70596985a.17.1780599056120;
        Thu, 04 Jun 2026 11:50:56 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.50.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:50:55 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/14] lpfc: Rework I/O flush ordering when unloading driver
Date: Thu,  4 Jun 2026 12:29:30 -0700
Message-Id: <20260604192937.65605-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260604192937.65605-1-justintee8345@gmail.com>
References: <20260604192937.65605-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The lpfc_els_abort routine has a code path that cancels outstanding
I/Os on the ELS ring when attempted aborts fail.  The failed aborts are
queued to a drv_cmpl_list and then cancelled after the ELS pring->txcmplq
is fully traversed.  However if the abort failure returns IOCB_ABORTING,
then the driver should not have cancelled it.  Doing so starts two threads
working on the same iocb and ndlp, leading to unintended race conditions.

Fix by capturing the IOCB_ABORTING return value in lpfc_els_abort and not
adding it to the list of iocbs for cancelling.  We should allow the iocb
scheduled for abort to complete naturally.  This avoids simultaneous
threads acting on the same iocb and ndlp objects.

The lpfc_free_iocb_list is moved to execute after lpfc_sli4_hba_unset
allowing the routine to flush I/O before freeing it.  And, in
lpfc_pci_remove_one_s4 a call to flush the phba->wq is added.  This makes
the unload logic consistent with offline handling logic.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c      | 16 ++++++++++++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c | 11 +++++++++--
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 968a25235a2d..44f213f42347 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13515,6 +13515,9 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	/* Stop the SLI4 device port */
 	if (phba->pport)
 		phba->pport->work_port_events = 0;
+
+	/* All IO completed and queues released. Free the IOCBs. */
+	lpfc_free_iocb_list(phba);
 }
 
 /*
@@ -14949,11 +14952,20 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 
 	/* Perform scsi free before driver resource_unset since scsi
 	 * buffers are released to their corresponding pools here.
+	 * lpfc_sli4_hba_unset() issues aborts via lpfc_sli_hba_iocb_abort(),
+	 * which allocates abort IOCBs from phba->lpfc_iocb_list; the pool
+	 * must still exist, so lpfc_free_iocb_list() runs only after unset.
 	 */
 	lpfc_io_free(phba);
-	lpfc_free_iocb_list(phba);
-	lpfc_sli4_hba_unset(phba);
 
+	/* Flush the PHBA WQ - there could be a race with ELS IOs while lpfc
+	 * is unloading.  This stops a race between completions, aborts and
+	 * resource recovery.
+	 */
+	if (phba->wq)
+		flush_workqueue(phba->wq);
+
+	lpfc_sli4_hba_unset(phba);
 	lpfc_unset_driver_resource_phase2(phba);
 	lpfc_sli4_driver_resource_unset(phba);
 
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 2c8d995a45bf..f917a5bcfd02 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -255,8 +255,9 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	spin_lock_irq(&phba->hbalock);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
+
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
-	/* Add to abort_list on on NDLP match. */
+		/* Add to abort_list on NDLP match. */
 		if (lpfc_check_sli_ndlp(phba, pring, iocb, ndlp))
 			list_add_tail(&iocb->dlist, &abort_list);
 	}
@@ -271,7 +272,13 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 		retval = lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
 		spin_unlock_irq(&phba->hbalock);
 
-		if (retval && test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
+		/* An abort that fails here is just cancelled when the driver is
+		 * going offline.  However, if the abort failure is because the
+		 * IOCB is already getting aborted, don't cancel.  Just let it
+		 * complete.
+		 */
+		if (test_bit(FC_UNLOADING, &phba->pport->load_flag) &&
+		    retval && retval != IOCB_ABORTING) {
 			list_del_init(&iocb->list);
 			list_add_tail(&iocb->list, &drv_cmpl_list);
 		}
-- 
2.38.0

