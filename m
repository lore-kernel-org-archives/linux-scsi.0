Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084C74A64FD
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682263; cv=none; b=b8ZU9zA7DuJSuo4dBzqafa9fp9Ado0Md4wAjFGdhVIN7Ofj3e95d8JusRIVVib8nmtQ1wQXJ5lBk9uVPWefStVmMFHJhp2/X5hAYqPoPcrMuqbwWia3ayK9EqSDm6e4cCrburOY8hYLhDKeZ6YVtRDqu3UVxVg2W6vMdmJckL2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682263; c=relaxed/simple;
	bh=w+F4E854eTNICrWFb6DSFUGTG0ny47R3o5n5Sj7I8MY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YmX0uYiQN4C7oBKBjJt8pZ3hHfemLTLeKGCUPKjQNKU6+Cci/k3WWhYN/83E3FeKUlKUdkoHzCe3hK7V6aoq6Balff66eqqP8aiOBvOxDGuf2ZyjJ2g6ccLVkCFDHwiYf66h3qHWu8O8ZbIgt1YItp5dkThFG55qM65tY9m2iDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=io4AmvLl; arc=none smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="io4AmvLl"
Received: by mail-pj2-f41.google.com with SMTP id d9443c01a7336-2d91a931f66so657505ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682259; x=1790287059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nR/ntC04iP2oqglZiW4vMfWyrP2MxYkMJTBN/O/z0IQ=;
        b=io4AmvLln3IrkGP91iRc8C3TkV1mG7ARL/VXVSHc5BExkw6u70/G6pcGW7XLBTaz+x
         Xj1132DLNn+BrosMFi2nikRsWfM4YGy+LStYJiKmCQopM4HS78J8xneVWoZFoblfYUFc
         RyRifIU5Gjy5Ddfi85IHAnIe4Ofu5/pFGxHarwkHLojIorv/dsKVbQLQl2dhZX4anF7c
         foYnh86eon5eBPbFujQAgX/C7c7jt8u5M1HPVhroCAkUKFDp0uS0hgaCTtHKhS7C1fJX
         C668UolDrphAd65pwU/345Esb7YuZ8Thzp94PX6w0u50byECKwcSiCVTkTYSTPcKRRhN
         nsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682259; x=1790287059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nR/ntC04iP2oqglZiW4vMfWyrP2MxYkMJTBN/O/z0IQ=;
        b=pMn/ucg3JhK/OWWM+QmuzbaIdDlnUktV+LQTswCREPqbfju0chpPVpHS4aOJVlb87/
         EGJRKjrsUTF9m/2Kjae0nVRxeOso0x/HlaIpeVZ+qHhMotmbXrbbFM3hMbHPGDFD13fL
         5cOZqOOOLUugTtdcYh9hZlEXU6MCg2UPrXCw7sIY0gCAauN7b1HSJJep+lChhbzdOpBn
         QSMXcEt55KroHyKFDOSS+2Ltoh+NpkorwfLHedWWtPxFPKWPRM+uBxrT5xpnM8UQGOA5
         jeZhtWiTJkeNVPvOIXRqq4H725eWavhvkBcJJfcSW7D1hyN9b7cWeZjpR7Xf+huziXnF
         +DbA==
X-Gm-Message-State: AFuF++kYEkIXjXxO9IPTE/GV5y3qIeRDlAXmYo9knXxdjHrlA5CXWfvC
	BEc0o3hJrVhppRGL+KPsSEc4pZBP1x9F9fkRLc3w9aetnPCZYeb0Spmcp7HDpeja
X-Gm-Gg: AYBFou1/6etKF8fRv4Q15hzyDTn6xrNh1mZYZXqM1LA1dvsqx6Z2t7VnS7wnpmH0DLg
	NpW/dSC8Z22G0/SeIk8r/WaaRedOWG7GV+Ged4YJLdEAnaHV4b9fWadzoLEkBhiEZHYK4LaTRt4
	N2pSlQ9/mEmLXN7j2oRnR1KTP3g5msOP7gZITVHuVEWbA+UrSt/AIArmbh6dAUVFVflrUuDPxf1
	Vdg8KY0HBim+U+ECLsHmmYXKnYzDKueBATXsT+BoDI/sAntWfstkTTrieSOn5of7QGRsEmLZtnv
	uCvr7it6Pa89vdolh6wQN9FBMQOgj/x6hwHrg3TF/7gmk1iyc0kNxxzJ5o+8VChFjjNHLViaxoI
	PalNN8NPJy+5TFYnPVClb9eG9AmeKm4qjn0G6+Gkw4vfYCw0OuMka2q2eaaG6QLfKlWq4pnq1qi
	B3dPwiQm68sVIeMU8+oGVJ+QoPxdqGWk8N4fNPP6v9ogtpL2QFvy57/G+WyHIzt3K1BFBUDt7CL
	njlH+37A5yUFIpg6/WoLOFhpRiiR9NEHoShbsMmWB/u9bsZBjg90yk2vCs=
X-Received: by 2002:a17:903:2407:b0:2d9:32ee:7b83 with SMTP id d9443c01a7336-2ddb1ad9b1bmr13286865ad.8.1789682259251;
        Thu, 17 Sep 2026 14:57:39 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:38 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 07/14] lpfc: Rework I/O flush ordering when unloading driver
Date: Thu, 17 Sep 2026 15:20:08 -0700
Message-Id: <20260917222015.61053-8-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260917222015.61053-1-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
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

