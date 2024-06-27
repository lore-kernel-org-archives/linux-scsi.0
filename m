Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9CD60EC4
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 20:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518448; cv=none; b=jeCgJaEp6pz54NkZGKcpYslOoVfAcVn5n73BQfdLQrkfPjJ3R8XfuteVa6IXjyh0yNUI1ZPlag/33XDFmiU4CiJQV2luZ9nKgOqOSuElHguoEMvhiOb3xy/2sPEz3q4rhV6DjaNkfE+hpar98rH22EHPMAOIqZx4QA6J3MQcJf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518448; c=relaxed/simple;
	bh=OgIeVabUMDuPt0iUW7YeN3R0YtW106gGUffenvD5/bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpHn0wywTFYCdMePRQyPsjzSRAqMgdmuY6Tnmucb+a5nrbrRU+DTjCXR3Q5UpdpBZIILa3MlqZCqP56J2Hw42Y2T9jZ4ehNvTZBBI40ogh13jRs3/plWPI19qfu2bievJkhAJY+KZwNCAY9pdsttynAk18hNCy9N1QK5i1ZyutA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WLRC6zHU; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WLRC6zHU"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W98ZQ31Zzzll9bw;
	Thu, 27 Jun 2024 20:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719518443; x=1722110444; bh=nEIW5
	4z3HJ8mnYvQg/ltIEcS9Uayyo0dvbu4ds/IGUw=; b=WLRC6zHUb5C4Ja4i2T4pp
	x0GwpQXsUUQbpySXm1etZdZwjDeqQRonJVr5Pkrvh50ey9Bjy8BClo42MLV8J5Jv
	vCZt1kxx1Jh04enyZ+AskDiSV1z0uU/3z6jUf4ET3nSk+RX93MCjyCrPiei+MZ5W
	tbW6nl1pLJOmjM8BJMoO9tPwNVVgLgdO1BagwVoCzIuVp/nq29NlGDoI5RQ86csi
	fI0FIVYk4QvUFyYT151CRKRkbL5oHWwxF5hVS2U5bteUAQgkYqaUf9e1UOhXKRyB
	HaF8hEpZfMFJU6eporuMpd2eyaAXDefnAlogfnz2mYZ7cbsUIVvUeSfJwyIF/AEb
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ngheBPvyOKnt; Thu, 27 Jun 2024 20:00:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W98ZK03rxzlgMVW;
	Thu, 27 Jun 2024 20:00:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH v2 4/7] scsi: ufs: Rename the MASK_TRANSFER_REQUESTS_SLOTS constant
Date: Thu, 27 Jun 2024 12:58:30 -0700
Message-ID: <20240627195918.2709502-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240627195918.2709502-1-bvanassche@acm.org>
References: <20240627195918.2709502-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Rename this constant to prepare for the introduction of the
MASK_TRANSFER_REQUESTS_SLOTS_MCQ constant. The acronym "SDB" stands for
"single doorbell" (mode).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 include/ufs/ufshci.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9a0697556953..2cbd0f91953b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2401,7 +2401,7 @@ static inline int ufshcd_hba_capabilities(struct uf=
s_hba *hba)
 		hba->capabilities &=3D ~MASK_64_ADDRESSING_SUPPORT;
=20
 	/* nutrs and nutmrs are 0 based values */
-	hba->nutrs =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
+	hba->nutrs =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_SDB) +=
 1;
 	hba->nutmrs =3D
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
 	hba->reserved_slot =3D hba->nutrs - 1;
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index c50f92bf2e1d..8d0cc73537c6 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -67,7 +67,7 @@ enum {
=20
 /* Controller capability masks */
 enum {
-	MASK_TRANSFER_REQUESTS_SLOTS		=3D 0x0000001F,
+	MASK_TRANSFER_REQUESTS_SLOTS_SDB	=3D 0x0000001F,
 	MASK_NUMBER_OUTSTANDING_RTT		=3D 0x0000FF00,
 	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	=3D 0x00070000,
 	MASK_EHSLUTRD_SUPPORTED			=3D 0x00400000,
