Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3328D154456
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 23:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722034808; cv=none; b=Ylmw4U0lohjVg4s/fg75hA/n0mM6bHvZTUy8SUvvobvrJlNj0+kxD9QdoUGI/u6qx5fW/RVVx8UMBobd29FX2xrbIBprXYfiLGxeRhO5V3WNqKScvhkkqQA6ono5d5ge1+U5wvuUHKdcs5IGdOucorMVTzzd8ICVOwKh2nS8Cuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722034808; c=relaxed/simple;
	bh=geS1UQbXcXnkW/yiSUsID3n7alvo9NI0iJ1i0JTVVEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bO59dAxq5go4clnZg/Q7RIEe0iEvH+8qWWo3D++9PX5lFOMYszHegW53XBNUDwlL/kL5xrrmibKCaqeTzFclDMu3jGl4UQ0G//GJcolfr01RUz0cCWG0Ok8JtYQ4oBDfhv+845oP3/B3KpvCsTEF1Z7IkryCBeSAQZxD/vIwJ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZfnHKdWr; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZfnHKdWr"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2cb5a947b7dso221857a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 16:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722034806; x=1722639606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytktVYeSc9xWuiSFp3A3dHAJ+APcHDsQuE2Mmxd6Iok=;
        b=ZfnHKdWrMvBd4n8NPmyj5rnAz6JJqVbPUoeXvf/10f5ulIaw6ZLwg4cX8Ifsd44LPf
         OQ1ziBst2nWEeXJxE4SEMMN7Cvjpfa2znpP1LSp/HB7+b28Ga+C3WVkjT/GSIiKXMIYn
         B0HxRcRJNpgX3ZFsmTDIGBEQPFAfT0P/MFf+nKzJnUJ+mb+pjFRkghkM4mT5qSUIvc7A
         975A+uzKc7FECicMKljH9jvZijnofz61SxZ9w+FggENCOdUdX/kJgD7g7inr5sveZE7N
         ymkmNIG1+d1Hw0MMm7EMI9+hxQ8H2/zn4bSAkMYuMJL7Fy7umLSk1qvxSVR7D6HCWQH+
         IK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722034806; x=1722639606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ytktVYeSc9xWuiSFp3A3dHAJ+APcHDsQuE2Mmxd6Iok=;
        b=Apd2pfpU1kqiUwvOZtlYmmn/BXtJCq+2WRLVQttXasDhJO+Mj2xKGIC5gk9vqbHVIe
         AoK9cGovXJSQ9LCOTNklIZX59i0pEXid+dK6ygkrut/FTQx0/IT5DH/dcrka6KxoxWOh
         yYf/dkuqhibvTTDxY7zsHd2idEjtdmrnhIJGuGyPwXaJTd/xfwzXaQqJf3aPxsjgocLV
         5GOuQCcXzJ1EDB+DgWxl3AplXUcHXPe72Md4ntOUVEgj5WIhPHVNl3Y+1LNybV5FX2+7
         ERc7FDjdQYqhe3p3q+5YHvkbsDP7hLmM5OeiNl9TAYDJJBOLqdI0yn4A94+eg0GGSy5L
         2P+Q==
X-Gm-Message-State: AOJu0YwCa5Kmi8UhYvKYIm+pIEegbEq0DID/okt0wF09dgEVQD8wBsaz
	kmcylJfs3o9mZRqUklzTXnddOp4Ph3ZX036slvNuGbbQt400RLZoZ+6vWA==
X-Google-Smtp-Source: AGHT+IEAJvclkMMfTl0/dfVhGQKyYsU5HYbvI/t1BRP4o9sb08Ja5g35a0CVFJ6TiVG1KU7cajgmhg==
X-Received: by 2002:a05:6a21:710a:b0:1c3:c1cf:7b98 with SMTP id adf61e73a8af0-1c477448549mr4791073637.7.1722034806235;
        Fri, 26 Jul 2024 16:00:06 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8834b1sm3308540b3a.178.2024.07.26.16.00.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2024 16:00:06 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 5/8] lpfc: Fix unsolicited FLOGI kref imbalance when in direct attached topology
Date: Fri, 26 Jul 2024 16:15:09 -0700
Message-Id: <20240726231512.92867-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240726231512.92867-1-justintee8345@gmail.com>
References: <20240726231512.92867-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In direct attached topology, certain target vendors that are quick to issue
FLOGI followed by a cable pull for more than dev_loss_tmo may result in a
kref imbalance for the remote port ndlp object.

Add an nlp_get when the defer_flogi_acc flag is set.  This is expected to
balance the nlp_put in the defer_flogi_acc clause in the
lpfc_issue_els_flogi routine.  Because we need to retain the ndlp ptr,
reorganize all of the defer_flogi_acc information into one
lpfc_defer_flogi_acc struct.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         | 12 ++++++---
 drivers/scsi/lpfc/lpfc_els.c     | 46 +++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 11 ++++++--
 3 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 7c147d6ea8a8..e5a9c5a323f8 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -306,6 +306,14 @@ struct lpfc_stats {
 
 struct lpfc_hba;
 
+/* Data structure to keep withheld FLOGI_ACC information */
+struct lpfc_defer_flogi_acc {
+	bool flag;
+	u16 rx_id;
+	u16 ox_id;
+	struct lpfc_nodelist *ndlp;
+
+};
 
 #define LPFC_VMID_TIMER   300	/* timer interval in seconds */
 
@@ -1430,9 +1438,7 @@ struct lpfc_hba {
 	uint16_t vlan_id;
 	struct list_head fcf_conn_rec_list;
 
-	bool defer_flogi_acc_flag;
-	uint16_t defer_flogi_acc_rx_id;
-	uint16_t defer_flogi_acc_ox_id;
+	struct lpfc_defer_flogi_acc defer_flogi_acc;
 
 	spinlock_t ct_ev_lock; /* synchronize access to ct_ev_waiters */
 	struct list_head ct_ev_waiters;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6d49e23f6a62..b5a8d050419a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1392,7 +1392,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
 
 	/* Check for a deferred FLOGI ACC condition */
-	if (phba->defer_flogi_acc_flag) {
+	if (phba->defer_flogi_acc.flag) {
 		/* lookup ndlp for received FLOGI */
 		ndlp = lpfc_findnode_did(vport, 0);
 		if (!ndlp)
@@ -1406,34 +1406,38 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			bf_set(wqe_ctxt_tag,
 			       &defer_flogi_acc.wqe.xmit_els_rsp.wqe_com,
-			       phba->defer_flogi_acc_rx_id);
+			       phba->defer_flogi_acc.rx_id);
 			bf_set(wqe_rcvoxid,
 			       &defer_flogi_acc.wqe.xmit_els_rsp.wqe_com,
-			       phba->defer_flogi_acc_ox_id);
+			       phba->defer_flogi_acc.ox_id);
 		} else {
 			icmd = &defer_flogi_acc.iocb;
-			icmd->ulpContext = phba->defer_flogi_acc_rx_id;
+			icmd->ulpContext = phba->defer_flogi_acc.rx_id;
 			icmd->unsli3.rcvsli3.ox_id =
-				phba->defer_flogi_acc_ox_id;
+				phba->defer_flogi_acc.ox_id;
 		}
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "3354 Xmit deferred FLOGI ACC: rx_id: x%x,"
 				 " ox_id: x%x, hba_flag x%lx\n",
-				 phba->defer_flogi_acc_rx_id,
-				 phba->defer_flogi_acc_ox_id, phba->hba_flag);
+				 phba->defer_flogi_acc.rx_id,
+				 phba->defer_flogi_acc.ox_id, phba->hba_flag);
 
 		/* Send deferred FLOGI ACC */
 		lpfc_els_rsp_acc(vport, ELS_CMD_FLOGI, &defer_flogi_acc,
 				 ndlp, NULL);
 
-		phba->defer_flogi_acc_flag = false;
-		vport->fc_myDID = did;
+		phba->defer_flogi_acc.flag = false;
 
-		/* Decrement ndlp reference count to indicate the node can be
-		 * released when other references are removed.
+		/* Decrement the held ndlp that was incremented when the
+		 * deferred flogi acc flag was set.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (phba->defer_flogi_acc.ndlp) {
+			lpfc_nlp_put(phba->defer_flogi_acc.ndlp);
+			phba->defer_flogi_acc.ndlp = NULL;
+		}
+
+		vport->fc_myDID = did;
 	}
 
 	return 0;
@@ -8456,9 +8460,9 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 	/* Defer ACC response until AFTER we issue a FLOGI */
 	if (!test_bit(HBA_FLOGI_ISSUED, &phba->hba_flag)) {
-		phba->defer_flogi_acc_rx_id = bf_get(wqe_ctxt_tag,
+		phba->defer_flogi_acc.rx_id = bf_get(wqe_ctxt_tag,
 						     &wqe->xmit_els_rsp.wqe_com);
-		phba->defer_flogi_acc_ox_id = bf_get(wqe_rcvoxid,
+		phba->defer_flogi_acc.ox_id = bf_get(wqe_rcvoxid,
 						     &wqe->xmit_els_rsp.wqe_com);
 
 		vport->fc_myDID = did;
@@ -8466,11 +8470,17 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "3344 Deferring FLOGI ACC: rx_id: x%x,"
 				 " ox_id: x%x, hba_flag x%lx\n",
-				 phba->defer_flogi_acc_rx_id,
-				 phba->defer_flogi_acc_ox_id, phba->hba_flag);
+				 phba->defer_flogi_acc.rx_id,
+				 phba->defer_flogi_acc.ox_id, phba->hba_flag);
 
-		phba->defer_flogi_acc_flag = true;
+		phba->defer_flogi_acc.flag = true;
 
+		/* This nlp_get is paired with nlp_puts that reset the
+		 * defer_flogi_acc.flag back to false.  We need to retain
+		 * a kref on the ndlp until the deferred FLOGI ACC is
+		 * processed or cancelled.
+		 */
+		phba->defer_flogi_acc.ndlp = lpfc_nlp_get(ndlp);
 		return 0;
 	}
 
@@ -10506,7 +10516,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 		lpfc_els_rcv_flogi(vport, elsiocb, ndlp);
 		/* retain node if our response is deferred */
-		if (phba->defer_flogi_acc_flag)
+		if (phba->defer_flogi_acc.flag)
 			break;
 		if (newnode)
 			lpfc_disc_state_machine(vport, ndlp, NULL,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f21c5993e8d7..35c9181c6608 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1255,7 +1255,14 @@ lpfc_linkdown(struct lpfc_hba *phba)
 	lpfc_scsi_dev_block(phba);
 	offline = pci_channel_offline(phba->pcidev);
 
-	phba->defer_flogi_acc_flag = false;
+	/* Decrement the held ndlp if there is a deferred flogi acc */
+	if (phba->defer_flogi_acc.flag) {
+		if (phba->defer_flogi_acc.ndlp) {
+			lpfc_nlp_put(phba->defer_flogi_acc.ndlp);
+			phba->defer_flogi_acc.ndlp = NULL;
+		}
+	}
+	phba->defer_flogi_acc.flag = false;
 
 	/* Clear external loopback plug detected flag */
 	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
@@ -1377,7 +1384,7 @@ lpfc_linkup_port(struct lpfc_vport *vport)
 		(vport != phba->pport))
 		return;
 
-	if (phba->defer_flogi_acc_flag) {
+	if (phba->defer_flogi_acc.flag) {
 		clear_bit(FC_ABORT_DISCOVERY, &vport->fc_flag);
 		clear_bit(FC_RSCN_MODE, &vport->fc_flag);
 		clear_bit(FC_NLP_MORE, &vport->fc_flag);
-- 
2.38.0

