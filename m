Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FBE1D0DE3
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356829; cv=none; b=Ee6w/fxCEgC6pRey9rYGbKC2eYf8qW+lR51dOcp+RpCCw0+uhoTq/JRWqZK5GXfZp1Rh7zpLxfOlEzcX853qtQu2T8MTbDosgkYyY5qj2DS5Mxc1CqO7VUwoW/vuIsnF/y6YQRuwR9H8nLKFEu9GsDtDhyqD6EEthgt4hvdZPeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356829; c=relaxed/simple;
	bh=R8HumJBM8ZU/AKzLjESjdXJq5h4uLvaVuxrkBFXonYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKplyiAF2kx31Fz+GdF8tG8CnxOYYjdbzXo2tj4nyzgA7l8mt0raF1XgzLNhJy7vx3NIm+l1W+odlFJXQyGMZjTssiCE8EXdYbtfy+ZTZSsSYf+qzhnKc6HUSKVONe8ZiEskQ0UnK67qUiOy455WWDKd2LGI9/VBrXkc2xbcbHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TODsb/Lq; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TODsb/Lq"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw91fM3z6ClY9K;
	Thu, 22 Aug 2024 20:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356823; x=1726948824; bh=NUMwq
	9m0NGA/JPJnvjiSkyJiugCR5QZ35pSWfTHWtKw=; b=TODsb/LqPJ+U+HWT/+Jub
	pWPM9vRTUnRTeHTiGG94sZQoeYY8ganHmqHr/Af8pjF90HHAIA0fw3mT8++piUDy
	DqooJ0aAPnmvQjAB8HWqp5Mlh2DU6XI8WaF5gqVEQc7DkFxgPVRlxYaV4dov3asw
	+zkTrZhBD0QzFJszWHT1aBb+4QyQYtZli/wiBk/04+/8uBucfqA15jxFrZEsOhPB
	YWJxOWQva/0qPhWcA5yTvdVNRU+mP0u9IrMH+95LXpxuxwhSXgUHBV64IrwDCQsN
	+zgODqIvLOCN0H1tDIAVtpzY8Io/FWrv2aaEIj/JVN4dEfeAEiRIpSH9ZCTJWMvC
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id q58s3-N3F8qI; Thu, 22 Aug 2024 20:00:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYw66Zmtz6ClY9Q;
	Thu, 22 Aug 2024 20:00:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 16/18] scsi: stex: Simplify an alloc_ordered_workqueue() invocation
Date: Thu, 22 Aug 2024 12:59:20 -0700
Message-ID: <20240822195944.654691-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org>
References: <20240822195944.654691-1-bvanassche@acm.org>
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
