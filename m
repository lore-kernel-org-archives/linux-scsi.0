Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885A318028
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356817; cv=none; b=f5CIlvj4JDAGVtoa8WEqz8a+Y5BFr6ROoXjwymeYw78cN5wt22s45IPIIeYzFkKEZd+TvXnGXW2bYT0pBnhy8DpB8MQ3Ve/tO0H6WddJAWrLmTme/27XK+jkgJ9roS0hkOGp1DfraN9rmdjjNo3V15rtrsaIhQ1p7leeiupACyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356817; c=relaxed/simple;
	bh=cgtOvADPeSF14nGQHjloqhw+5tHnH3QyTV7vyu1OuiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6SG602Sh/aZGv4fzUkRJw3NeU5RTy8oC+R8llhrKRWS/yBMU5SjV6z3ehlI+aVS0mq/pH7qwYIDnPnqvuIeBkaZFYWmcYmNkgIcqU08Y3rVD5o1tqirIJsDcuVpk59Gtva34BFp7PF5RJlBLVg2LjeXvGbyUKXbkXZHGMxUUjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TxYfhW6J; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TxYfhW6J"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYvy75NTz6ClY9Q;
	Thu, 22 Aug 2024 20:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356812; x=1726948813; bh=fqvIk
	ghVilRYJVAJ2j3innOMRcrBOb5gndIaWzePiOA=; b=TxYfhW6JHPz9JqjCcLHLc
	Vzu6GdS4BU5Jbn1KlYgDAoKNMhA4gDFG8hcjmOdY6p1Fge/fb1zmO23MzpBBDBO1
	/D5cAYPsdfWh91nNmOIn8mBAzVCyeGXWTgcjorTB3OOF9mcIBkbWDpBLiN5M2MkF
	EPkt0XMW+0prR66q1OPpbXY+fyV2r+DALABSzwET0lD32UCQ699b1UFKU/yQxPD9
	j8aCmoDC2dxLNUeMY4wukJTs4yCB+CGZmUsiu9b7aLzsudezSJn7x+/hP4C/ivXN
	jNGlCzwoj0Cj3fC4B9Vhgg7TnHI8NBRJd6DL62VpkYXDgCoC0/Egc8A1w1csIQFw
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ADPqwe1h_g8z; Thu, 22 Aug 2024 20:00:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYvw2Sr3z6ClY9M;
	Thu, 22 Aug 2024 20:00:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 03/18] scsi: be2iscsi: Simplify an alloc_workqueue() invocation
Date: Thu, 22 Aug 2024 12:59:07 -0700
Message-ID: <20240822195944.654691-4-bvanassche@acm.org>
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

Let alloc_workqueue() format the workqueue name instead of calling
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/be2iscsi/be_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_m=
ain.c
index 06acb5ff609e..76a1e373386e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5528,7 +5528,6 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev=
,
 	struct beiscsi_hba *phba =3D NULL;
 	struct be_eq_obj *pbe_eq;
 	unsigned int s_handle;
-	char wq_name[20];
 	int ret, i;
=20
 	ret =3D beiscsi_enable_pci(pcidev);
@@ -5634,9 +5633,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev=
,
=20
 	phba->ctrl.mcc_alloc_index =3D phba->ctrl.mcc_free_index =3D 0;
=20
-	snprintf(wq_name, sizeof(wq_name), "beiscsi_%02x_wq",
-		 phba->shost->host_no);
-	phba->wq =3D alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, wq_name);
+	phba->wq =3D alloc_workqueue("beiscsi_%02x_wq", WQ_MEM_RECLAIM, 1,
+				   phba->shost->host_no);
 	if (!phba->wq) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : beiscsi_dev_probe-"
