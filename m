Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985BE2BE02A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473236; cv=none; b=pCgXhGRaJU4GXeg0E0hAz0gvvHdLTuobrvrvrPJwrYq566bhy0TOQE4FX7fLpc7d9RJFFJij5SaRLqVDL6LvVRT+rZB/yh7tEI7Rtz4lmpTxXm/kEH9vO6CnE/T+eHBMsvF44NjtFRFR8XRBHILnqxEdop1PbxkGN2wVeIX7eC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473236; c=relaxed/simple;
	bh=05auVugi9fsRoK6yxB89A/EgR6qztnsDXnM5MAJw+To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YotdRIyULNDuBvlbGMAPEmJQ3drvv4HIStwpSPEkeHyIA5bUexq8CeXStHuDEu21CHRQcQTOxdkk8yILEZ0dU9yMOLAPCyn7XXwanFfMr6Dg9Vsu3Kr4kOHGKa70VuYIELnJAH0SzzwbAUOAXAPeFa7EzLdRrpopIybhpPp3lto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mnXiAFDQ; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mnXiAFDQ"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQZT5YbVzm0yVM;
	Tue, 14 Oct 2025 20:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473231; x=1763065232; bh=YUyai
	aoy/zR7TJnrtVdyf43U0MrigqqiJHfpS31/nHY=; b=mnXiAFDQFiy7c7eluWXpS
	hb3AwZIiAaO7imSVXP9TQMlzlOPG5wDXNuwHDiohrCGCteSDqyy+1w4yI4mmFXb4
	k3iqFvdJZCxB1zhj4+pJRQ+xbY4VMMMpBNrJnlVP/hH8f2yrhskgeucMOCcVZZat
	YdfgyseokmjIShTzwn8JeiC29b0EF+SJviZBq/B0cM5z24IT8fmdiCkC4ASbV5d/
	xWZq9p4Uu08nPOu3ptu3pzO6fxYYk4QbJ3MZ2Cw9k/YK9eBWdA6zCTO1BbZrJoLY
	4Drf30zVMmK9Cgo+geXAj0G7NCMSxsJiP+5lpnH5/xrMAmiCNn7ZtWW7bkRu2bO5
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Bq2ebDx0kHVl; Tue, 14 Oct 2025 20:20:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQZK42Gnzm0yVJ;
	Tue, 14 Oct 2025 20:20:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"ping.gao" <ping.gao@samsung.com>
Subject: [PATCH v6 20/28] ufs: core: Use hba->reserved_slot
Date: Tue, 14 Oct 2025 13:16:02 -0700
Message-ID: <20251014201707.3396650-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
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
index 36b755f6d7d0..3e4260084e34 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -544,7 +544,7 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int ta=
sk_tag)
 	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
 		return -ETIMEDOUT;
=20
-	if (task_tag !=3D hba->nutrs - UFSHCD_NUM_RESERVED) {
+	if (task_tag !=3D hba->reserved_slot) {
 		if (!cmd)
 			return -EINVAL;
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
