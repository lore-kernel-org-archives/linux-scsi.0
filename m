Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BA81D0498
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356823; cv=none; b=FPkWNwOStrzv1AaEednQBGtJbDmKxIJtRJB1ToR8krsKpXVEaUSCJzi5trtqkDS/VwIQzR8jiPjbyP4ma67eGNHM7aeUYlrq1NEPDXqb+YZQme0qAjBWwlQ39IJeiKSwrnUK3T/E/zP0ZC/vDNt1q0neOr2OPNx6/v7/WFOZykw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356823; c=relaxed/simple;
	bh=pKoaZ+AWdHtH3ENZvSwQNYVhA6qLwmMRi6N1YCz+V5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+EOw7WujmpQ73YjyUjeOWyhibIWW5H+IWURhOgsyrgsWnsSvVrGGCI5Y2YnAu+BJRYLcxZQgWBPiQHwvhwImQ5vcBP4dWisrBSDurK73jm0Jdr+PqfVWheFbn8/Upbu4driqEYLwTeRhEUyDq5pVpSF6nuoHJwNMlElueQM5V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TDxpJWZL; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TDxpJWZL"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw52FSWz6ClY9T;
	Thu, 22 Aug 2024 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356818; x=1726948819; bh=grUuH
	VtYtG0vOU6ssbFXaGw2TolOmql3pZyaX7x0xbQ=; b=TDxpJWZLs3J+vc/6BBQ9k
	0u6bCg7KF35H372BBUKRuGQDPfbP3aImeCn4G/t/LChz8h3ANCRIwG25me3rnEt7
	V4u6OWEHL7RetmhIufDhQh0tu+QWOBUF18F1Wc+1F8xFdDzB3aTQTx1OyHfzcuxU
	+WQ8q0EfXpp2zo2bfwRurG/0C/HZ4wyXTkluQDgsszqtZMG8KEz6KI54ffdgIxWm
	/uZaB36PbN5HX72ld6/WNbIlhNpHtVmdozTADvvH/JiDgPDUsKi2+hGzy/5eMs0X
	H7vMykiiQ8bRixmwOqbkExzJ3p2mgLR5C9IJRK/RrS1ftwsJPBKSFipYM6QsBSWM
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9bef0GZHEQxM; Thu, 22 Aug 2024 20:00:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYw20YHsz6ClY9K;
	Thu, 22 Aug 2024 20:00:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	Hannes Reinecke <hare@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 10/18] scsi: myrb: Simplify an alloc_ordered_workqueue() invocation
Date: Thu, 22 Aug 2024 12:59:14 -0700
Message-ID: <20240822195944.654691-11-bvanassche@acm.org>
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

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrb.c | 6 ++----
 drivers/scsi/myrb.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 140dc0e9cead..bfc2b835e612 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -112,10 +112,8 @@ static bool myrb_create_mempools(struct pci_dev *pde=
v, struct myrb_hba *cb)
 		return false;
 	}
=20
-	snprintf(cb->work_q_name, sizeof(cb->work_q_name),
-		 "myrb_wq_%d", cb->host->host_no);
-	cb->work_q =3D
-		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, cb->work_q_name);
+	cb->work_q =3D alloc_ordered_workqueue("myrb_wq_%d", WQ_MEM_RECLAIM,
+					     cb->host->host_no);
 	if (!cb->work_q) {
 		dma_pool_destroy(cb->dcdb_pool);
 		cb->dcdb_pool =3D NULL;
diff --git a/drivers/scsi/myrb.h b/drivers/scsi/myrb.h
index fb8eacfceee8..78dc4136fb10 100644
--- a/drivers/scsi/myrb.h
+++ b/drivers/scsi/myrb.h
@@ -712,7 +712,6 @@ struct myrb_hba {
 	struct Scsi_Host *host;
=20
 	struct workqueue_struct *work_q;
-	char work_q_name[20];
 	struct delayed_work monitor_work;
 	unsigned long primary_monitor_time;
 	unsigned long secondary_monitor_time;
