Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529083AA4F2
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 23:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849193; cv=none; b=HMVxhoGfzepbLiSl3+UNQ+BQvDfxrM7v4kH+edJ+GEnqFmQtVVehptuNlR57VlxD+2pgKB6iPhiSNCUHjMi6Z1NEEMtq+j9hr6wtxXCpq9f9niYTLxrHB6ESbK1B9Yg4mSBVtmqki90fyv+lXKFgI5JDOhMFXNdZfZOoMgeTgkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849193; c=relaxed/simple;
	bh=u3NTW4TF2J/fqYvafkDu/Pkk2RY6Ig3tg/l2jpZlum4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QE7Belz3e02ISEUAAPhUnZ3YRPz6fIgheDcJBDm5nBy13D5XYw4l6saNFabqYnQ0l7FMv6/4F171TSWpD37mR9tXZ/ilGyYN1Hz7y/19sBUipjCjuzbosQGcnaDWXs3uj2ZYunbdXSxEfXNiKpO+FldnX+91YSkmGCwecOoEl/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l4wd9VhZ; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l4wd9VhZ"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-15ea896ddc8so3374039c88.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 16:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791849191; x=1792453991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lly4oUBlk3WeftbIfcVx/NFfRYGOA+OADKb5EF5cmn4=;
        b=l4wd9VhZHtkGsOp7TuKf9cQE6zQTfUMK+AIu1tQrxaUMk+JMLfCGteOv4k2GkKAe/r
         Ds0q/P9fKkNBDnonsKOnyRCdOQ2oew4H2yqd/VVU4QTJqLbsgVFY/n0sOThAptUOzDoV
         PeGDlUGq1gfL7BkM4GmiMTC6NPEiaOFPLZ6AfxPuytxTVYq11EhfkjMr3sndv37MaSbm
         KqyNumgRZbJefa4ivQ8KiNeyDPxc1mGnGu36tZ0MKvmZLKWWqCTQs5XLRjlPx1K0qsRE
         yq9L3NBPoFv0Kao/49vd3lZnCEaP2NFXj/0b0ahBU5tb0qXjldYzGDwV3nowA+0xJcd4
         2x3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791849191; x=1792453991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lly4oUBlk3WeftbIfcVx/NFfRYGOA+OADKb5EF5cmn4=;
        b=i2Elv6XTC2yu87Li7Hxv9eRM1LDO22bw/KuendbgDCZjjZdrfdQPzwh9zbrwJRkefA
         0rIrufK6OBPRw1kQ+baQD8COr4b68IC3Dx68RvGmqsL/BBdx0mDBwCsvBImW6X+7OjRB
         4Dtlh5UoJD5MbklZbxnPQvzhBpUoihlqbYYlVdIzeFGt+LKR75IjMlBuIpt1x0Syd2BS
         VjdN16hhqIJmUJ0IYtUTqM0TuajwrS6SY2wl8Et/siPa+WMnRvd4Xs3iLU5WDDAa+JJ7
         oIUtgz+8fPg+e0ptn9pnmx9BlbYlyeInQv4B2fOb6DScHHupAD9vB3JJTsvlaV2daBp3
         RTbg==
X-Gm-Message-State: AFq9FYICd0ae6AUwTo2bWaqMZ66v1doLnwRvOlm1bY2gc+D5S81Yq8kR
	HMF2rnazjFXWsNlkMO1MjaNvQDzATsDbGJxJfKNtItkRcDJXnhDDhqLalyloYDQ5
X-Gm-Gg: AYBFou2Sz+wLs0f0EBcc8G6kMQ2vY41FjVfyHedAirla+bCh4tIh4X6QiivMyyaSgt2
	MDo7ATnrHeyflT1I1rlTm3i7yJDkVOCMKfFSFZqgYRd8g9NpwcBO6NtKPzwjMfR2cMze673AE+O
	coHLq4+xMOVB6exfh12u17BFWrSadCVS/MUnEcRDU6H75sUey0xwIHT/46U7lGE6GsyX0ZkKBKW
	8FMPagmNH5fExlNf2RjBxDTPr48Bh52YIDMxoZxu1vv2z/I4DJfifDjijW2QJIlLfLSbw3xzu8E
	ymWqZPLrs3ijldQu56ze5gqGqjLw+ev0J7LilrX1LiDguYmJc6LeVGUeEY2LTDU9BmCfKl34MCy
	KTAKeC5HQogOSWHPzCbSfKU186Us+xAsYO8/RL0tnY42WBb/HfVzik46mc3x+mUvb2hfYX9XeDv
	ykQjGZ9P6WkKEC8irRYTvJswRBV/y08mBXR4fcs4ApY4YN3hKqO7q1CD8sMrUx15PzZrFYZs9aG
	CfVeGvEK3hp7RoC8tIuHgXsOhiVaVNyWmWyoTP7/ZStpTyE0hc6lM3F4g==
X-Received: by 2002:a05:701b:2091:10b0:143:2968:564c with SMTP id a92af1059eb24-16a6043be98mr16023733c88.26.1791849191107;
        Mon, 12 Oct 2026 16:53:11 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm15137264eec.11.2026.10.12.16.53.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 16:53:10 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: jsmart833426@gmail.com,
	paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v6 5/8] lpfc: Rework I/O flush ordering when unloading driver
Date: Mon, 12 Oct 2026 17:16:45 -0700
Message-Id: <20261013001648.62289-6-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
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

