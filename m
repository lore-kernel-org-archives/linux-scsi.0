Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2417395AC3
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681510; cv=none; b=Kq/gQuE9NfrpWx/wfRs/c7QdTIYQl6flcaAl4rX+N/dJxCzlKJkN6LTFbh7b65RsfUF5YRJHJ/irrYJAkDS2mmdkdhpZED6GuBzaoj4xqDDEKmqiKc17HkVs5N08vW5kozfPqgJYfYKl3N2ubBBuSMETMxVM3tpZYAl4UCufr0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681510; c=relaxed/simple;
	bh=UCtH4x2HS3hooZzjZNUVPly7foSBDpPatHB7jNQol2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gYfybGuZCNP8a4boWI1hgC/s01nPXgjfSvZWLUnmsrIK/XULlda2+wZY36CNlfJFUxH7hDA1QEhi9i9nm8BAbahnRgXi0hcjfcteg0TzAWNBQDvyjISpTFlv4V8hMUzACfhMW2GV2EVZt+/GptMaKuKLuLUPncHDcOjq09b+sBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pXZktPyC; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pXZktPyC"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51784eb2ba0so16744361cf.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681504; x=1781286304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wr1WOv/QbJroAJz8xOQ6n0BRN5ROPQKE78Ib+UypKlE=;
        b=pXZktPyCYDPnviV46lWe10p0MC8WcDN1VQDbZpYTqb4Bn7nk0+hIxiheQz7t4aS6jN
         0saoeSW48YONXremU4t/k+lJ3++6ZGnH/nHg9o4s9klVNSyMuPpO+2GbqENPPbGqCKf9
         IGRp7VhjmWvXJOVOtKO5ET3u2fIQTTPaEUYKVmfnmLEawDzwxtf2tihWvOV5tqztQlkF
         m5XQxn8AHs+twwa8FoHvgd/9owv28209rjSclT9hscXCEScErpyuaD+tR6FpQP1CEJYZ
         FRSuq7A5prJITRQi1z/gSIzHP2vhjawSsc4K5idrmNsIn4Kpdmag9nsXEgs5c/lKaqMj
         f8uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681504; x=1781286304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wr1WOv/QbJroAJz8xOQ6n0BRN5ROPQKE78Ib+UypKlE=;
        b=NHc4XKcPTY5KmX2EUIxPqvAxbS1pGt0irDw2w+mrW/V/dWTabn/MpBnsAvlgAu3Fk1
         9ZWXE1OLlQtDEsTP3ug5Q5Fx11l4rW8HTqWYwFeRbK4PW8Kkq/rL19EykNoXIXKj4zc0
         1M3FTpR/+UD0JjOcq1qe7KU0C4ixF9z2lyYCnLah6h0fzmM/AjIeliF85EjVg011UVN3
         JyF1D3zQeYCa1F82/Ayo+c5je8SHmxbQS/ZxDp3Ih5qIPlpR4L0ACWAMdwNKqlDoktVK
         RW3Gv1i4Z5YlElUptaqzbSUtEZQxaeaHUDakCZ4N8jn5JGefUgkBrQ9sFk6G2LMs5wT4
         qGWg==
X-Gm-Message-State: AOJu0Yx/D0jZQMvdk4Cbip3k2ZXWlFlNkOzhRRSuwYYlSejzj+A8S+YI
	SZFgmuXfUQMMpSjz0ok/N/ukaj/cZVAv46Ua8lXuIlNDh0qhQzfe70JxdYrrchkP
X-Gm-Gg: Acq92OFeUGpxT/5bIoSIF+JwKA0889332jZAGWRqIpKyUc3vrBInaC/uB0mDC5MiBgk
	8JI8427AdGzri6rFc6zLKrZWgzUw9aaE7x39TgBOZtRkYYHK5wIHrpMHQZvginCFkaU2hGimzBP
	twSdjbWWrJ6omPPW5xq28S/075w4aBuNY7fh7tPHwBUuwLLBeSkXn/MAkveAZPSs+AcEF7TWbP6
	bUDnop1CVGcouOAta6wrmAECB5YrAirt3DTfF9a4vWj6ZjQlPAyRNQIblY8IVDi8ea0JFYl5v6j
	hhAFpDALr7hkVc0+JuGbHZzkgfimyilsYZYiuU45B2ayj9CxRQkCqOwCwU16fUdkc5rLVU9/ZgE
	w1rvLJmrVw+2YjyHYdy7q2J71syERvmkauVWHaps2sl0L60t3Ki/CrYSgWadLUF9aqDv3yLj+Gb
	VXjCH8i/LLOpID9HNnv1jvEH8u2PsOZYm7pOrnstydUku9c0wYdsOgyyrDJDJt+vmi2HpLu65pm
	uab6Iy+VvTvUa9Gpf2CAuoK8iOKKGnDiICer4Dmm5Tyb3b4dn6Oiw==
X-Received: by 2002:a05:622a:1b10:b0:516:d812:c35e with SMTP id d75a77b69052e-51795ae8329mr68356811cf.21.1780681504391;
        Fri, 05 Jun 2026 10:45:04 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.45.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:45:04 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 07/14] lpfc: Rework I/O flush ordering when unloading driver
Date: Fri,  5 Jun 2026 11:23:29 -0700
Message-Id: <20260605182336.134919-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260605182336.134919-1-justintee8345@gmail.com>
References: <20260605182336.134919-1-justintee8345@gmail.com>
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

