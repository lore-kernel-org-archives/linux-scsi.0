Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07F6CA6F
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943411; cv=none; b=u5CqqucRJgwOovrDGZ1sfvAfIFobr8g26kgDZPIVz4PcyZyfR7TyxrM4nWIgPwHeOetZTkvD1nWP+EWQBe4N2Q/09vujMgL8IKJqmtf5272KL6pu21+dMLy4r7+0hlt6F7YV8iwsVxo0D/tVwfefR0FaxLb3eu6NxXKoec14BYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943411; c=relaxed/simple;
	bh=HYTBLqLn4E3cL0gGR1WIJkrMKsXhvo7P7pFwZrO4tmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ25uoy2A/Unz+rY8k3y2/ltGiCLTX8VUuOBFTBGmaeyorHPT1sJ1z7rC+QXG5EvO4wVzIGsVWgg7pseVBvtXJwA9x7K9WtexzMgPvP4wj//vG/KuyoEYHAcaKklpHVSvG0Ttmk7Vye5+hbbIBbkL1YU/62Hp1f4gzkBdYNhGmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jGlmtzAM; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jGlmtzAM"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytH51Dljzm0pKx;
	Fri, 31 Oct 2025 20:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943407; x=1764535408; bh=hcDto
	Fpb1ltHOyX8D1sezmqY+G+tbLBna5KO9polmug=; b=jGlmtzAMF272aUkLxhmEU
	/SWshpBdE+MtCP8cNQBUoXXx/DQ0TQS1K4DKoFDeiF6wmTo3hA8fvAAqxYmJ825N
	EwuLERoCTbXIJP1IJJgIprUQhRXnAaiulNegZLDKLgVNBeRM6k8qNB2Jn0mVgVPV
	MqS5XC43ZdE+Bm8DgcWMki1kGFfJGf2ugcs4lpTyhYX0/e4TAX5afdWoUtsw2W41
	Ki3a92CnnRIQGuBnHacwb+Qg7n0I8TsnWBDcYmnx1kSInB8LLIRJiulGVP6ncAhE
	P4wEqWostxRbiL6GGq6xlT/CPsXEN9Oy9OnF2YsF3gx3pwFEfhMPGG+8/PEbkaQ+
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GHB-Wvnb_ROp; Fri, 31 Oct 2025 20:43:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytGw600yzm0jvN;
	Fri, 31 Oct 2025 20:43:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"ping.gao" <ping.gao@samsung.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>
Subject: [PATCH v8 20/28] ufs: core: Use hba->reserved_slot
Date: Fri, 31 Oct 2025 13:39:28 -0700
Message-ID: <20251031204029.2883185-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
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
index 00b043b54419..1de3360a7af1 100644
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
