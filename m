Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266BF1C7B6A
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845432; cv=none; b=GjJQior9oHgTMuVqjvnRfuTlh8HoVTtOEVuCSsyINM9S+ZIfbZnNndpeIECUbkbovnDWWhWbyRT+51iuXsplgcUzbejPjEOXD17EtEzcjK98ApTFENJilXVe6XOyGg7S3ASHoJArBMP5A/V+BMtpAPFFGdFrm60HtdIMQJcAkY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845432; c=relaxed/simple;
	bh=iKo12Zcm8Zbo34tPHVFkh0XZoaQw1KgD5dTmB84fqpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7w71w96jglN7bJCvgAV9EpiG+jx4F+2xpLTSfv2WS9BXT1jAVN2RLBjfw1c379vnqo0wZzqO5SPCNO7xj4MhSJ086rVXppKg86d9SytipAgBYhVb9GYhGonw/psRca2JgVYLn7S4WyVGuNmCsrPnGOd6nTeOg3DMy4Ybn16SGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ER9o1oru; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ER9o1oru"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wlwnc3yg2z6ClY9C;
	Fri, 16 Aug 2024 21:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845426; x=1726437427; bh=IE5zt
	FyDbDJQ71voVaNJt6ltQ8eIt/zzNNkiuLZwLH8=; b=ER9o1oruRq5Y8GPHy7n+C
	HQlAKgXhkN6U1RnBBL0dshYSTObiWL7HDjrC/fGdCcfKyiXFXShxSNxwvZsBGOaT
	M0GiovXntQPwHdtOakKR3JwYTzZPn4dQKGxVovfm67E8bzcIgxJQ7LfbC5z84C5d
	q7irwS+XVQSZMUc+lIHKedknSxAHowhkqtMtZopwQUfL4PAfCd8htnHl40kTMuue
	/RuMWrRu2nn4Gay2ensFVeEoqYHkEILWg0wJpHQc5NYNdEJ7TBYNSGvqvhmyjSgk
	cqnzvolGNNkNIkmzNttyWB0l/GLy9Pts6tq4FjhV9AgE0HJQ0u1EdHpG0ZjFrWd/
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BdQkq8pxxWr1; Fri, 16 Aug 2024 21:57:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WlwnX1rRNz6ClY9F;
	Fri, 16 Aug 2024 21:57:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 14/18] scsi: snic: Simplify alloc_workqueue() invocations
Date: Fri, 16 Aug 2024 14:55:37 -0700
Message-ID: <20240816215605.36240-15-bvanassche@acm.org>
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
