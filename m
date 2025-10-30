Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA442F4A06
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853109; cv=none; b=FRQ2xj/1gmUEMqx1YHZD4mEmMD/4myc/gmcQHuH/R5QzmE7NkCs9kcOhNKEJus+03UWHrNOHYMtgGrCBE9NSk2YiatJo1hN/St9uyoIZYGH7Ip6O7+zQhoQvY9sLkP/GKWdggF6aUJ5mu3E3ddvfy88wodg2Au/GQpwVwTrtTX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853109; c=relaxed/simple;
	bh=72XM0DijgpkekbP1cPUsl4ZsnAifZ7SBAFCzQflOnZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbN6ckyMKYbhWENpyXrhvv29VI44PnSIUW+LBmm/D1X7SXuYtnblZcAW8iRl7ew/GRVh6yrAfwIuRf4LZlsnq+66AlShhT+gAuAnOD7A92hFTWOD69gydyQTnMCFazyakrVJSA+mawM4+0DaV2ZgW/UolURoVWyY/ycBFnqRGOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sWaHnowt; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sWaHnowt"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDtV5KCTzlvfn3;
	Thu, 30 Oct 2025 19:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853104; x=1764445105; bh=w43aU
	+y1tdr+5Ha9R1pCW5+yoZoqTTexTm0Z17Xjd5o=; b=sWaHnowtnr4UBsNo3aH2K
	3DsB9nVSB+EDQuriiao0Lv5eRsewjRUydwHUnLkCeEnyfbwzwV7i2V+NmIgoOba/
	VnIMvj1maoEwYecc59QK35KryuXF5ch5/h7PxCTlRaEhrcJT4RpuWbJKFw+oEv1r
	HqjRvl6ufGh8lpdsx9dzJ+01qlFJgDKmsGu8Rs4eUfUDPc5jRJP6FiLFqEMFuU8r
	fO5kPWhNkPgGLzCY+aaw8Bm57HA1eg5j+Zh7ab+YmhuHNh/TBIftYKxfwwnVHjX5
	HTvse2Zy+ZUHG/WE8infgG2o6olp40vLbcAj885Y0gztz2av95rapS5+B0Ur8jPR
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sI5TAUTgE_vE; Thu, 30 Oct 2025 19:38:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDtK3C0LzlpTG1;
	Thu, 30 Oct 2025 19:38:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH v7 08/28] ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
Date: Thu, 30 Oct 2025 12:36:07 -0700
Message-ID: <20251030193720.871635-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251030193720.871635-1-bvanassche@acm.org>
References: <20251030193720.871635-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Since 'tag' is only used inside the if-statement, move the 'tag'
assignment into the if-statement. This patch prepares for introducing a
WARN_ON_ONCE() call in ufshcd_mcq_get_tag() if the tag lookup fails.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index d04662b57cd1..bae35d0f99c5 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -307,9 +307,10 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *h=
ba,
 				   struct ufs_hw_queue *hwq)
 {
 	struct cq_entry *cqe =3D ufshcd_mcq_cur_cqe(hwq);
-	int tag =3D ufshcd_mcq_get_tag(hba, cqe);
=20
 	if (cqe->command_desc_base_addr) {
+		int tag =3D ufshcd_mcq_get_tag(hba, cqe);
+
 		ufshcd_compl_one_cqe(hba, tag, cqe);
 		/* After processed the cqe, mark it empty (invalid) entry */
 		cqe->command_desc_base_addr =3D 0;
