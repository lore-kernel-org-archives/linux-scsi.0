Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A269E29BDB8
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934012; cv=none; b=bM5Ntbhg1hS/0N+yJoD5Xd7uw0SmqpQ/nwWUMv6An3aD1vm0OYM5/pXD5cOIE0u2xcqCmEqUnT5I0iUSLI3XybfdbiTEqE+NXth4nvpW+h4Z+c6AeL+R4zrN+zb6vnA2frpATqR+ncuqbEreZp1TA7MaE5HloAt9G5ZCgKrpkXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934012; c=relaxed/simple;
	bh=/DBbv9aPB0AGCG5FONp05VLRV9H8qDjieblcXgs5hZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saRJO7p8vr4XQT1N0pR/GsVs8T7ypgWbofpTZOfuoGYxTQxQdvTrG4pdM7Nx0Z3jObNh1G8R36XEXKn+GCGIcl3vuRUUVncAv1cMFI8jCZneR9X3HDG7zm2/Y8JJ5RhoSxs/drap/ipKpszg7eGH68TjUxq4EpLOBgAJYbSgQRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Z7/s5Sam; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Z7/s5Sam"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c122y0578zlgqTr;
	Mon, 11 Aug 2025 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934008; x=1757526009; bh=L4kqg
	jE+MZ18GYlhx5KaBYS+YGGYoXWwlt+UBmvhrXI=; b=Z7/s5Sam4BRNICVoR+8vM
	leUKvGVayhGoHicJP53VaDGJTm5VNUdj7ZioWAQgTCDClW0ht9cMaln4J1H5d60Q
	8XKD17HIJzhR44k/UV9BlGUJOqG8Ip1BDnhOovFNkwyZRFpDIlD/SXUDf/Cqxpg2
	0s3fAnZad17MmoR6wwUJe2Ijb/X7j0mW9MKS3IYoyxzzqGZd9GkLplvv8c8xHm4i
	Z8XiRD5p/n+aCVfaESq6N6ACwj0w8IAHFWV4ww6GUI+1pag2kmEA2IGGb23/AFl+
	8E2DwcUetXJ/F/YNEt7XrGM/Y8WkEGVCD6Ac2nVsXII2ZUVnC3wuRzD5tu4rc1wc
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZCZq7KDUINed; Mon, 11 Aug 2025 17:40:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c122r1dfszlgqVP;
	Mon, 11 Aug 2025 17:40:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 18/30] ufs: core: Add an argument to ufshcd_alloc_mcq()
Date: Mon, 11 Aug 2025 10:34:30 -0700
Message-ID: <20250811173634.514041-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for allocating SCSI commands in two steps by making the UFS devic=
e
queue depth an argument of ufshcd_alloc_mcq().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bed88caea319..d63bf5b3a414 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8870,12 +8870,12 @@ static void ufshcd_memory_free(struct ufs_hba *hb=
a)
 	}
 }
=20
-static int ufshcd_alloc_mcq(struct ufs_hba *hba)
+static int ufshcd_alloc_mcq(struct ufs_hba *hba, int ufs_dev_qd)
 {
 	int ret;
 	int old_nutrs =3D hba->nutrs;
=20
-	ret =3D ufshcd_mcq_decide_queue_depth(hba, hba->dev_info.bqueuedepth);
+	ret =3D ufshcd_mcq_decide_queue_depth(hba, ufs_dev_qd);
 	if (ret < 0)
 		return ret;
=20
@@ -10569,7 +10569,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
ba)
=20
 	if (is_mcq_supported(hba)) {
 		ufshcd_mcq_enable(hba);
-		err =3D ufshcd_alloc_mcq(hba);
+		err =3D ufshcd_alloc_mcq(hba, hba->dev_info.bqueuedepth);
 		if (!err) {
 			ufshcd_config_mcq(hba);
 		} else {
