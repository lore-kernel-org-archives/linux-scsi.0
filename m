Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69822D47E2
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934060; cv=none; b=uiLo/6fk4G4+rtu0suMlgCt1J2zClG5BceJnJLs1AhnEMrS1IUfBr517hruYwrFpUneswRDDqr5vHHUkkiq+Do8AXmC9/oKteiA+hYnDNBUmj5iKCqOH2CMKSiQrqPt7Yttoo0B3OWGxzFm+P03vSxD4riFfOr7D/cZApa10bAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934060; c=relaxed/simple;
	bh=s/qIKboXXIIUS1z34FlUoJSTPErPtn+13uKBRfPzbv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dud46ozAtwFi7o0BG3TRaWuGnnctVVdoax5gb63F23e89R7q6MNpBd76MSgsNkSUY9AHeLYbC0F0j9MrylMkrMdU2CsFgUaeo8xZ0bmsN9hutz1LU+jFWSTp+IF2eFojtiei4UuMC4FAh+g7P0qOU2gXF3Uoa1EvhLVqtK8FJd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3B5oyqmL; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3B5oyqmL"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c123t1kYCzlgqTr;
	Mon, 11 Aug 2025 17:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934056; x=1757526057; bh=5l9h7
	MTaxGQ351s7hkcn3XN6G58/QJdB/j/lcgaAxp8=; b=3B5oyqmLwjxIV6DNaPPKq
	Bl3vvqSciDtBIM0QBI+VHStRTUPncC5f7OHEMJvzWjOEKjWjsVJUCKXgOuXbgQfH
	KIEWJZhr2cYKybvFXSNRyHDXPeA7f5JdkT3KP0+o4IYISNlywtA9avdKfNvxj6vQ
	XjnWYsFHFPwM4mzimTQ0FuhYhBBrj2Ws2FpddrkbqMtgj0S/MTJlIgT8Qe6lTbP5
	TEuboXkSTQ1cuaLN/6xhbhPEpiRsonOO/1QDzmIVXaWM8kFjH6GlB53wUN2Q/q2x
	A2HvOD87ruE6kYOTs4/JwFtW4YLzqoJN5fG+vb8BtB482aNjdnvaG+zyEj9tWN9Q
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k4YlqC4QLzrr; Mon, 11 Aug 2025 17:40:56 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c123l4BXZzlgqTq;
	Mon, 11 Aug 2025 17:40:50 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2 23/30] ufs: core: Use hba->reserved_slot
Date: Mon, 11 Aug 2025 10:34:35 -0700
Message-ID: <20250811173634.514041-24-bvanassche@acm.org>
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

Use hba->reserved_slot instead of open-coding it. This patch prepares
for changing the value of hba->reserved_slot.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 6a1838ced02e..da2da57130c8 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -547,7 +547,7 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int ta=
sk_tag)
 	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
 		return -ETIMEDOUT;
=20
-	if (task_tag !=3D hba->nutrs - UFSHCD_NUM_RESERVED) {
+	if (task_tag !=3D hba->reserved_slot) {
 		if (!cmd)
 			return -EINVAL;
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
