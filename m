Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0664EB846
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618104; cv=none; b=jcEAI2yEcMjAoE5ftwBAVklYoRoJP8gKRyLZzFKIiw6CsTrj3QFYh3HEybt6oBCXfGjfXFGTmBeWgGRWHWh4emHwuG1GEpKrNTIbyWfpq5dI6FH1rZn+0VSYvhSFW+ccRyl0xRVgRoTc9aaW+uTt8Gk90wLChBUp4sS3hYNqMCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618104; c=relaxed/simple;
	bh=w+F4E854eTNICrWFb6DSFUGTG0ny47R3o5n5Sj7I8MY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hkXA+6TctlaWmY+PwpBKUjIK46HH+nk2R0n6NTKf9FV2zRmvc8GTjWPcLEKqT+VRgjOVCEGmwEtv97vuvxfW1okUErmzQE6IsYKxijr4E07Nco1WP00AbcnyJy7AOoVOsfkbRi8DdF10QRgt1LJrO+1+g5ZOiRtxSiVFjmfIeLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mm8FfJ3F; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mm8FfJ3F"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33bfb26865fso3443559eec.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618102; x=1791222902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nR/ntC04iP2oqglZiW4vMfWyrP2MxYkMJTBN/O/z0IQ=;
        b=mm8FfJ3FObI4AwBQqIaQ7dpmxejNRg8sYLpeHvQ2saMdn9KJEFh4Rwn1TPSOLqPoBz
         +mkJN0rETwH349vZL9MpISEUGCAfCPHjUXPq7WSM7xvevEB3rJknbg6x39KNJOtQUjuq
         w7r/hFN+ZXlsa24nCXLNgvNsKFlhoWIcPw59aRYOG1dMtQJesHjLQqwq/8on8EX02k9Z
         IsmOoVrWmYm5rKON34Yq/d3fTYOKHLLrDa/cw8Mj35cEr+0WCjHDS8PXQo7YFXgAIqg5
         3lKU0ciPuoGrsRd3pAPuD+LlvJ137OruCVCHX8Hg3S7dIhGJSyPYDQTXdnBu2zBTzcI5
         E1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618102; x=1791222902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nR/ntC04iP2oqglZiW4vMfWyrP2MxYkMJTBN/O/z0IQ=;
        b=Mu4IWmUvbWU56djWCdcq/Gq6O2jabshySSYsfkN6bhqbv4Jkk85qawFUWy/hwB3SZ3
         V1na/oGHmeSAPOyGkCG4b57SHxgERdwBpFXsj4nHFchTCXH3cVIkqNJc7At8GAXZsAry
         ec6Uu+37N9Uxmnu3YktUQCAIvCVmpdlJ/5rGDPYRYRHctcwRxf1moGDrKD75+mo84eey
         RGn8OO+rw5aEpuSP2vT7uImAhegMvqDL3x1uY+N84JjvL1Cwn/d2jpmzo0EpyELCTlam
         rhwWo/VPRdDyPoK6spX6z4yHv/PV3t3M8h9pEjGFoW+2EFw69eRHWSGu7Uib2NzOM5RD
         WDcw==
X-Gm-Message-State: AFuF++mbEP7tLnVAsJNQIUgo0025n6SM95t7AWRay+cUV7e+LLxVvCgv
	MuD8WULIxJSB1p/42jlU3K28cTgYbG+FKk7aOb7KqZVzgHxdtrIy7K0L4KiPlRWm
X-Gm-Gg: AYBFou1xrQ08dKJEHPYGn4ShUEcmhzjNzB1n4xPlQxBfstSANNQUuKKQpPazUCvhHfB
	fxb/ZyiMLxp0+edLN+cUSPuuFExub9zyODZYgo9D79eaBb2tLB37LPrV7VE6eqWkPWMdSmqB/DP
	CyG4uv3aJfPc9xNtxqHapt05VqVb03HJhoq3xQPOTVombSOzkabs+XdjUN5ltt511MCME6YHeXM
	NVuwQKe2Gzoi4D15huCRpjQfC6U2cIX97LealNa8Vk5SK5rPXaDek1TtC2bQrjIcXM9BXsyr4PT
	c6CruTTrbVVNoHqYmHkc1YF51fMLMDyVTQHfTVO6W2dlCN0aF2TeRz9buyd/VJvsnzGJJGNcoBr
	NvsdUse1y/QIV9+QrQ385KS0y7cqitZJEKDGqB8rTQgeBfbwIQ4ExnKPRz0M3Illg/xFKfmS5ZK
	pfueq2B8y0qfRABu/QJVDTJlhQWNA0C4551NaE+rg/4InE8U5lmAyaSOHdJbpwJhUHCoaE8c8AI
	cmCgILzzR3JAAgGvr1up7JSyFGU1MeEKMBZCri/HBx5JLmJXGNzkZrOoQ==
X-Received: by 2002:a05:693c:258b:b0:341:dd10:c9f with SMTP id 5a478bee46e88-3427324d494mr9851983eec.35.1790618102382;
        Mon, 28 Sep 2026 10:55:02 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.55.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:55:01 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 07/10] lpfc: Rework I/O flush ordering when unloading driver
Date: Mon, 28 Sep 2026 11:17:54 -0700
Message-Id: <20260928181757.21959-8-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260928181757.21959-1-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
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

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c      | 16 ++++++++++++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c | 11 +++++++++--
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6460127bcc7b..7352cb6e584b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13514,6 +13514,9 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	/* Stop the SLI4 device port */
 	if (phba->pport)
 		phba->pport->work_port_events = 0;
+
+	/* All IO completed and queues released. Free the IOCBs. */
+	lpfc_free_iocb_list(phba);
 }
 
 /*
@@ -14948,11 +14951,20 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 
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

