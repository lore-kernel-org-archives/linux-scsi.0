Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988BA1C57B2
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845406; cv=none; b=KyT3vB3Ba58H6zHo7wgkff6GKy8UkCz2EiRfikEb08y+JamnrMhVAIKF6R8YJjKZYszqZnabhCNx1SSG5buFjLp81XyYKnB0S6JLbcbYIwbC0OSkEoa86Yc3y6aLpeY+Bu1yldxFeE9ZDQ/HAHfk8wmSbBRZIanfFmkndgk32KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845406; c=relaxed/simple;
	bh=o10ljLmONycsnD5xQJZYaGnLPjqhRC6/yapUKzQ4TAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElaD3XNaBuS6MZ/+lvz5kkT1LVGpeM5NKifjP9c+2AWv75T3M5qcCTFDeLCTAaUNAwKWywDRG3fgJ0Iz8Wy5J+aQJ0Vy4eeV+2x85GVl+HJYJRHVVbXYz2ObRmzwtoCS8+/dIX6rbBKpX/ALnS5NSB0O5SOhoXa1vgfFikPAka8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cB3XqNEt; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cB3XqNEt"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wlwn809h3z6ClY9D;
	Fri, 16 Aug 2024 21:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845400; x=1726437401; bh=NOhjZ
	YZgYhNzxOBwIteWrZ1e+yhklFzUfYuAEEbHfWY=; b=cB3XqNEtgDQezsoB9+0vS
	sIDlWgpJ84T3/VzPHe/Y5Mlevsp7Y770PAaXRjsqQnjKdmaX1Dlp2uQGz+Uw/QJ8
	js1eCyWkUQ+a++uY3BYNoexkb4DVl7uraU6dt9n4qb9qMSAgfvk/QOZdlM7r+gSn
	bXzDalSC1s5Dkt94iMFS/13ahSCAobdVA242DLs4mMXsaOqeLkchDmlNGT9L/JYI
	R3FsVIZWyfZPtKISw/OWolDjyiGE7W6kzRLwI6ysOHCHnIuKOlkTS0XOnXJkNDW5
	4UiSBkJYasT834vh9Q24m3lyVZFXJ0sSuFdPXs963mwqGqbiz8aY8bgMIBkAM2Ir
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id f8FvBedJOKXX; Fri, 16 Aug 2024 21:56:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wlwn24z17z6ClY99;
	Fri, 16 Aug 2024 21:56:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 02/18] scsi: mptfusion: Simplify the alloc*_workqueue() invocations
Date: Fri, 16 Aug 2024 14:55:25 -0700
Message-ID: <20240816215605.36240-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240816215605.36240-1-bvanassche@acm.org>
References: <20240816215605.36240-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc*_workqueue() format the workqueue names instead of calling
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/message/fusion/mptbase.c | 10 +++-------
 drivers/message/fusion/mptbase.h |  3 ---
 drivers/message/fusion/mptfc.c   |  7 ++-----
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mp=
tbase.c
index 4bf669c55649..738bc4e60a18 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1856,10 +1856,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_=
device_id *id)
 	/* Initialize workqueue */
 	INIT_DELAYED_WORK(&ioc->fault_reset_work, mpt_fault_reset_work);
=20
-	snprintf(ioc->reset_work_q_name, MPT_KOBJ_NAME_LEN,
-		 "mpt_poll_%d", ioc->id);
-	ioc->reset_work_q =3D alloc_workqueue(ioc->reset_work_q_name,
-					    WQ_MEM_RECLAIM, 0);
+	ioc->reset_work_q =3D
+		alloc_workqueue("mpt_poll_%d", WQ_MEM_RECLAIM, 0, ioc->id);
 	if (!ioc->reset_work_q) {
 		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
 		    ioc->name);
@@ -1986,9 +1984,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_d=
evice_id *id)
=20
 	INIT_LIST_HEAD(&ioc->fw_event_list);
 	spin_lock_init(&ioc->fw_event_lock);
-	snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN, "mpt/%d", ioc->id);
-	ioc->fw_event_q =3D alloc_workqueue(ioc->fw_event_q_name,
-					  WQ_MEM_RECLAIM, 0);
+	ioc->fw_event_q =3D alloc_workqueue("mpt/%d", WQ_MEM_RECLAIM, 0, ioc->i=
d);
 	if (!ioc->fw_event_q) {
 		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
 		    ioc->name);
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mp=
tbase.h
index 8031173c3655..b406fd676da0 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -729,7 +729,6 @@ typedef struct _MPT_ADAPTER
 	struct list_head	 fw_event_list;
 	spinlock_t		 fw_event_lock;
 	u8			 fw_events_off; /* if '1', then ignore events */
-	char 			 fw_event_q_name[MPT_KOBJ_NAME_LEN];
=20
 	struct mutex		 sas_discovery_mutex;
 	u8			 sas_discovery_runtime;
@@ -764,7 +763,6 @@ typedef struct _MPT_ADAPTER
 	u8			 fc_link_speed[2];
 	spinlock_t		 fc_rescan_work_lock;
 	struct work_struct	 fc_rescan_work;
-	char			 fc_rescan_work_q_name[MPT_KOBJ_NAME_LEN];
 	struct workqueue_struct *fc_rescan_work_q;
=20
 	/* driver forced bus resets count */
@@ -778,7 +776,6 @@ typedef struct _MPT_ADAPTER
 	spinlock_t		  scsi_lookup_lock;
 	u64			dma_mask;
 	u32			  broadcast_aen_busy;
-	char			 reset_work_q_name[MPT_KOBJ_NAME_LEN];
 	struct workqueue_struct *reset_work_q;
 	struct delayed_work	 fault_reset_work;
=20
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptf=
c.c
index a3c17c4fe69c..91242f26defb 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1349,11 +1349,8 @@ mptfc_probe(struct pci_dev *pdev, const struct pci=
_device_id *id)
=20
 	/* initialize workqueue */
=20
-	snprintf(ioc->fc_rescan_work_q_name, sizeof(ioc->fc_rescan_work_q_name)=
,
-		 "mptfc_wq_%d", sh->host_no);
-	ioc->fc_rescan_work_q =3D
-		alloc_ordered_workqueue(ioc->fc_rescan_work_q_name,
-					WQ_MEM_RECLAIM);
+	ioc->fc_rescan_work_q =3D alloc_ordered_workqueue(
+		"mptfc_wq_%d", WQ_MEM_RECLAIM, sh->host_no);
 	if (!ioc->fc_rescan_work_q) {
 		error =3D -ENOMEM;
 		goto out_mptfc_host;
