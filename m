Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664FE1D130E
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989472; cv=none; b=uWsjR6+Oksuatf+J9lRyH3/HbAgZyL58qYnYndoyE5nOCZikqtswvgCXEe5nemZPD0j078znpSToVL1xKDC+ayJx7TUg9QkOG77Y9mI48HetM1dS2AUgQSqduWxGRTNhSjMwIJfmzGGoni1UFOX8oiyVe3CgEalY/pPX05V+Flw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989472; c=relaxed/simple;
	bh=KPHVTRqlTvf2o6R7XecLA84QRmkEZ0mDOH8BtUQFzc4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YJSrJyCv5oXocRVHw9Vbhs8bjlkC20SCrMy1mum2dBiuX5PNgbXT6AnGeNuVkz6+RoniOQGPxGEiJpjGmUp9kT6KkgHdR/YdT3DmgkIz1czVdha9JLDAOkg0+IFoNLywLVoQ3MeMvi5gE2oYoN9iuXbSm+a5AYEO/ziMy9AVodE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YKCofnh7; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKCofnh7"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e7632b193so42786285a.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989470; x=1784594270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rMlKI7yTa3lsviY9xSr5oPnv/QtyBnjCJWpwMrqBumE=;
        b=YKCofnh72M3flLRvg5/qgCZIqwdEaULcL9xkWFgezdMQysbQ73fYrCsc2L5/+pAoHK
         /U0O11GLb94wGuhB7F/G/bE4dRuhud0Y7MIK6zj1Nhh5uTsQgZmAVxJAR1ucx1WUc7Us
         wvTEmMlx/ijbLE1uKkDhskBiVQwpnMjHQ+tTLZFaCstYbh7LhSfQeOvlZ1xg/wjERTF5
         UlaNaJ3NseGIWaFuRLQpFwn6ncg5vJZ8RCaobneNYH7aMwdMZMgNNAiQXwUdHSeEFNhM
         sLfqnMsnYJv+yXhBg8bXVXMhca7hxfu6hR/FV2FKTRyPbFE1HUw9J/fVkiL5hi3zw+Jn
         Vuow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989470; x=1784594270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rMlKI7yTa3lsviY9xSr5oPnv/QtyBnjCJWpwMrqBumE=;
        b=AfRXUqba4LxnnP+Y7SZQ6PH3R/h29EKCZ3UTRNWInz4fTwEVAf47Kwm8YoEYh3U3WT
         0P0A+oREg3xjMCIUS45PJbhAf096568yue38ZJ889sx/GoNSVJoCIYmz8cRSOUsWp9oy
         r2pedsmpLhgNB8F0tq1mDBauiXDU7DT7+66qeJi/V1HlgDaoTwjJfqD9V8qUFQOp1uGM
         XK8ZmC3q/dZgSdVb800vM5i8rCFkjsE0urb6B3glyAbd2oLXiOcW9hUJaC0CRjMQfSG8
         pFpmfjeL+IOdf+QLODmMHhH5W3Qm/Xi8t9EsFyBelGx7zIdw/aBL3l9f3rgXLj+XskcM
         iK/Q==
X-Gm-Message-State: AOJu0YwR1Fn3jqixUE2ov96MbhPmyEKR/dbacXL+EpVaC4cI67VA4NZw
	Fp81lgoHQBYkklrYEVGoZp3HZXc9LCiRaVBVeSUIA3vA4gs/Q92P6bhMTM0kcySc4VI=
X-Gm-Gg: AfdE7cnRnVKLV+vyez2c/LjeQtHasC9dVoQDyz2vbzoxx8QwnQjzvb5q/Yg/sraA1s0
	FEZXmSUPXxYdb2RoT5T8qD6PR2NlB9P0aA0rffSd2VK7ni3QTYre7h4eM6/rjgrRmqaKTtsKo3K
	HPHaUlEEW+qjIUKDNsWytMK0Xy+uuu26ftaLl1esG8c2l3x23l+awDCDpT+KxPN05BtWfRMZnz3
	P6duGqntRQf+7s3o7b2HAm9YLVs9CVgUoGhq2/Yy6AnRGuE8r3ufH4Bcok00GZsydoUmC0dqvzG
	jst/v5/NysXL/RJL55IES55omIhrqtfQqwQU9ayQDqSIQc7OphBaGrTffOj40a6lexEgF7YXLwE
	1TR2AfMKnEjoV4iCU85pCG/1j/5lx7f4NgjGO91ChAlBL5pAYyFmAmq2Hs1hfOAnGIYB0xtYHt5
	NZCohnZovD5dz6t2PFkF/tda1yItJ5F7bMpln/5UzPjRG/XfcBry2VvrwaeasL9/6PxstQ+8Yhl
	4vvnjU3BQ4n6D3Su66cAlJ2SHyR/O1L
X-Received: by 2002:a05:620a:271b:b0:92e:44eb:1e7a with SMTP id af79cd13be357-92ef2b7187bmr1094205485a.29.1783989470096;
        Mon, 13 Jul 2026 17:37:50 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:49 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 07/14] lpfc: Rework I/O flush ordering when unloading driver
Date: Mon, 13 Jul 2026 18:18:05 -0700
Message-Id: <20260714011812.106753-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260714011812.106753-1-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
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
index 82af59c913e9..c23bc3d059a1 100644
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

