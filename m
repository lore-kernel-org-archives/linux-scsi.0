Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777BF1C68AC
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845433; cv=none; b=b0g93/RXwbqvpZXN1OsQFXbvCrFpx3ofvShaaOtOo9gD5YAy3ESdMbxyZjYQrr0JXxC8rEj5v56/aojGA5pOwoXZCR8ICFMGZdxYVdbuas6nGrSyxnlCDMjFA9ZNNzlo2uorVYpHrrk9kGV4qrAJVNFPzFNGsa8O40+5SBinLdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845433; c=relaxed/simple;
	bh=R8HumJBM8ZU/AKzLjESjdXJq5h4uLvaVuxrkBFXonYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lsj2UDP/1d2epc46ovz+sFgSfZQ9wy582NXnaS8EFldngaJGmBHOtAbWMh56S95YX/kenwVTPvkjLXymCGf1I0nJw8bT2TWkiaA7TrPLodLoPTlgK0H9QH7IO+sPZfIFoorMWR66HczWcoM5/aad2BTP2CuzZuRz6sASOvtrM1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FU9cxeZQ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FU9cxeZQ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wlwng5VjHz6ClY99;
	Fri, 16 Aug 2024 21:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845429; x=1726437430; bh=NUMwq
	9m0NGA/JPJnvjiSkyJiugCR5QZ35pSWfTHWtKw=; b=FU9cxeZQzOvxvG18Hjw4V
	4JKPhPUnn2h/2bJfk8a+SpFm4FezdTi3wj0wPePF3+NaMSwPq2Tagm7dRiuR2Qdd
	NILjh05jiS3Kx0bYUvJDHykKJ3jxBtTyqcjurxKnp33bVMYrsVxrQLJnh5fHsyXV
	1VBNW/kDRcfeuNqM1tFtK0qeyFr6/bNghL0/cZymZLHrKbLehqJsHBhd+ZraaUEM
	/h70e2WJunxN/dSD+6/NDgsp89a8zYsxXyf8pVUvC6VuXnwRjUNhoToN3XyeJplj
	9TMVwVp8flno2DwRCOFzSfkYyDYb48LCJK93rzX4VZ+GE15vuvWWgLvdm6cDoaN5
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WUEzk130us_X; Fri, 16 Aug 2024 21:57:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wlwnc1sW9z6ClY9D;
	Fri, 16 Aug 2024 21:57:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 16/18] scsi: stex: Simplify an alloc_ordered_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:39 -0700
Message-ID: <20240816215605.36240-17-bvanassche@acm.org>
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

Let alloc_ordered_workqueue() format the workqueue name instead of callin=
g
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/stex.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index fbee7db4a835..0e81125df8c7 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -334,7 +334,6 @@ struct st_hba {
 	struct st_ccb *wait_ccb;
 	__le32 *scratch;
=20
-	char work_q_name[20];
 	struct workqueue_struct *work_q;
 	struct work_struct reset_work;
 	wait_queue_head_t reset_waitq;
@@ -1795,10 +1794,8 @@ static int stex_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
 	hba->pdev =3D pdev;
 	init_waitqueue_head(&hba->reset_waitq);
=20
-	snprintf(hba->work_q_name, sizeof(hba->work_q_name),
-		 "stex_wq_%d", host->host_no);
-	hba->work_q =3D
-		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, hba->work_q_name);
+	hba->work_q =3D alloc_ordered_workqueue("stex_wq_%d", WQ_MEM_RECLAIM,
+					      host->host_no);
 	if (!hba->work_q) {
 		printk(KERN_ERR DRV_NAME "(%s): create workqueue failed\n",
 			pci_name(pdev));
