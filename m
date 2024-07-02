Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75E7205E26
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957221; cv=none; b=BRgqTmg39nuHS/f5xnPyKTTggGroXp/ccLUPcqJE9tjzA+++zoh8futRDaiVhu01nu79ARxYFoh3VfKzeeBfFSuQvjR+T3LziAA9iNoWMzU3QzZfZbWH0E25AkrgwxZLPT1CRtdI4sakDqWOAcs63rudEDjVKZsP2Xm2hU4GypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957221; c=relaxed/simple;
	bh=iKo12Zcm8Zbo34tPHVFkh0XZoaQw1KgD5dTmB84fqpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHlGBVoQCoKBoLXX8O4M1QCaz8vL3Ejkb2kV5Wa8spsH/ZtS1dvEnFnNz6/UAenR7iSgq+T8tu6lNGiH6qA2/h3FREeFeNkkvs9jR2uDTyuavY3Z289B5EHlPCQ4CFbwYFxoQOz2j3DC3/PgjTFXpbEfJOQWMjtQoAS07McP1TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Bcl2Y98R; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Bcl2Y98R"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGrM4YPVzlnQkm;
	Tue,  2 Jul 2024 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957217; x=1722549218; bh=IE5zt
	FyDbDJQ71voVaNJt6ltQ8eIt/zzNNkiuLZwLH8=; b=Bcl2Y98RkH67b7HY3aKnn
	BtphSVsU2h4l0tbKwaMfOF6h4jMXw9ea1HKzc1KYi5aHsh16nOVvxWalKhs+Piwm
	moslQNr+Q3aLUbGCcrlHpYMsC8TG/5/K83uR3pwJjsKgsnVJIRdYH16B+gMUhZKs
	QF6NsvaXuYp3ivLhUsYxP7Jvic1ftpFGeyD5po0+3bVj+MMJyODvkmRXXYYSlXRF
	3PNSYt6O+RpQBPhTuSv+v48/n2LRvE/q6a/opPhmqg7ra6q/DZm+0VwyWjADXqeo
	M5Y9x8liRIdzXSEuDooFkKb153x+RZ5QL76l0onz+3eITXe0Xk5lzrLcmyDcBBg8
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5Kle07fOPA1f; Tue,  2 Jul 2024 21:53:37 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGrJ1QpSzlnQkq;
	Tue,  2 Jul 2024 21:53:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 14/18] scsi: snic: Simplify alloc_workqueue() invocations
Date: Tue,  2 Jul 2024 14:52:01 -0700
Message-ID: <20240702215228.2743420-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702215228.2743420-1-bvanassche@acm.org>
References: <20240702215228.2743420-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_workqueue() format the workqueue name instead of calling
snprintf() explicitly. Not setting shost->work_q_name is safe because
there is no code that reads the value set by the removed code.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/snic/snic_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.=
c
index 2bd01eb57869..5ca8bc89dfa7 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -300,10 +300,8 @@ snic_add_host(struct Scsi_Host *shost, struct pci_de=
v *pdev)
 	}
=20
 	SNIC_BUG_ON(shost->work_q !=3D NULL);
-	snprintf(shost->work_q_name, sizeof(shost->work_q_name), "scsi_wq_%d",
-		 shost->host_no);
-	shost->work_q =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
-						shost->work_q_name);
+	shost->work_q =3D alloc_ordered_workqueue("scsi_wq_%d", WQ_MEM_RECLAIM,
+						shost->host_no);
 	if (!shost->work_q) {
 		SNIC_HOST_ERR(shost, "Failed to Create ScsiHost wq.\n");
=20
