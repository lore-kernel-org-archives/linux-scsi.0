Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83301591FC
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 22:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107916; cv=none; b=UnkRa0u6UGS1Rd6CVZr5LzyOkNRYy9DFZtF6708NJVVezYvNXMHuflgdOb3kgBdxiPspgTWQYH5oj53iRReRDrUdiBjJAsDO1VjzKWyIrSvU4aC8xbacwEjD/fawLgpqXGg0+0BFy6aKRslLkjSeJovQAXRZ5u1swonH6n55cEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107916; c=relaxed/simple;
	bh=pbzzAUA5mjDwOpaQ3E68cbtHi3IBNTaGsEPVQHUSU7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvY+xuylJqiEf8W9blGgNch7XaitP1YaeAGCsJoSWLMpvxMgSYPjdhjo8VMk37FJC21aygSGJnCcBW7qvSJnrxt97GDZr8CpzXUdMk7F2zTSyCwtNRwEq+3k3739+K8hrWn5RWnBznWvaPXPuvbM71mls8dIyU4bKcDxfQIiZhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Kt+fqW9W; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Kt+fqW9W"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WnnsQ0YMnz6ClY8q;
	Mon, 19 Aug 2024 22:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724107910; x=1726699911; bh=wbJk8
	lO+Vcd8A1zWrOKa9Jx+gILaiMBuKg/Of8iBn+w=; b=Kt+fqW9WtLTuZldJlRnVP
	IfMF3e7XhzQ9b5P1AS+7M3nmTCywz03MmDMczLGMUYT2WDo8o2lLmAo6R5cU/Bey
	9XTg1w9dQhbQC09eljADPqDwRsOAbYjw65L/nKbzxd517GzcXo+r2JM/WlJCsT+C
	RqvgJoM5xjW2+zQ5gu+ZGMnYdqJLd8Hv7ai5PPXXzKnyd0HqVJzrmK+8qH76QWfe
	r3QzlwoVnv9vH90Z9hiJquTeDfqd0Oy5d7wOjx0mteGK08DzfkdeTXjdzCyvMdEy
	LzCiUexroUw1iAXKceidOlP6cMHxNk0jmNffrDNRf3kp+LUWFzFg9TTXNwb+8wfJ
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id e_qbA7wk7PgD; Mon, 19 Aug 2024 22:51:50 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WnnsK2sLsz6Cnk9X;
	Mon, 19 Aug 2024 22:51:49 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH 6/9] ufs: core: Move the ufshcd_device_init(hba, true) call
Date: Mon, 19 Aug 2024 15:50:23 -0700
Message-ID: <20240819225102.2437307-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240819225102.2437307-1-bvanassche@acm.org>
References: <20240819225102.2437307-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the ufshcd_device_init(hba, true) call from ufshcd_async_scan()
into ufshcd_init(). This patch prepares for moving both scsi_add_host()
calls into ufshcd_add_scsi_host().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 86deea546b44..2754f496d10e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8931,10 +8931,7 @@ static void ufshcd_async_scan(void *data, async_co=
okie_t cookie)
 	int ret;
=20
 	down(&hba->host_sem);
-	/* Initialize hba, detect and initialize UFS device */
-	ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
-	if (ret =3D=3D 0)
-		ret =3D ufshcd_probe_hba(hba);
+	ret =3D ufshcd_probe_hba(hba);
 	up(&hba->host_sem);
 	if (ret)
 		goto out;
@@ -10630,6 +10627,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
+	/* Initialize hba, detect and initialize UFS device */
+	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	if (err)
+		goto out_disable;
+
 	err =3D ufshcd_add_scsi_host(hba);
 	if (err)
 		goto out_disable;
