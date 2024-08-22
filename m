Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D101F957
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356828; cv=none; b=gu5LprPMfnJLn1z20b6TjNp5zYx92GZq1OlGEooxwNPr1g4GLd9iQDMYqX5MvqWjIo4HcS7sp3juCOO8RtM8sOBniwMg/JwZU4XCEKoIYDk5T0RCrnKg9yLAV36T/UtboMpgxrvpDRLMVB9Xv2o6UO30VMMzR4ivvrVCV65FBAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356828; c=relaxed/simple;
	bh=pA2mwES7jKXuzQMVYFJHvSelSQqGZ4r9W25lBSNyhOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0yGx53xoPpIBAdZcQ33Vkl+KMdaIxeIu6glnlU2wEnaHeL1MPDhdeGJA2Ut/sDOx3vJuazZg8qht/owK0qtE+IsgHf7bQUX/zkNh3jskcFsbCWMvJFrreWe0DtjqzgovFf5ZO1w4icSFmXLUV0lzaxUsym5mbblCA4sjBpasic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=meDipUd3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="meDipUd3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw85tyqz6ClY9S;
	Thu, 22 Aug 2024 20:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356821; x=1726948822; bh=1N94F
	XqRhqtlmPV6jIRH5+cvoqssL2AufpN0BOyUzc4=; b=meDipUd38ZNdqfMurxYCk
	NjVTS2vhIf/1rzMWjAH3qtqSvdYC8V/xl1bZa0ao/PfgDw1jLEnX9QGp3qJ1i8YN
	+Ragu96roaATSF6GSq/JJFVdojdBJ0sn+Rp43Wex5YdZuoTjtNyB0gf5GWC+eMko
	iqud32gK/VYGyEyaNlAwHasMfpvGqrOB2yRwakhWmcr6TIcPuyRtlc4sqlTGg5YR
	Fh2rs00cHgN2NGrEQAtWZ1QviAxQsug7yJW4JI046X5Cwy+aWjq7qie1/vYO40Ic
	FnbKRevdzrCyP63hXqyxCs4UxWo2g7FCCaqhoexoYRc4iVMOsHgtwBuokm0TSkyR
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xYnbK0M7J9L9; Thu, 22 Aug 2024 20:00:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYw53PgRz6ClY9K;
	Thu, 22 Aug 2024 20:00:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 14/18] scsi: snic: Simplify alloc_workqueue() invocations
Date: Thu, 22 Aug 2024 12:59:18 -0700
Message-ID: <20240822195944.654691-15-bvanassche@acm.org>
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
snprintf() explicitly. Not setting shost->work_q_name is safe because
there is no code that reads the value set by the removed code.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/snic/snic_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.=
c
index 79ffcf796b05..9be3f0193145 100644
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
