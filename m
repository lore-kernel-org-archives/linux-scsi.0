Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DDB2FF676
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853232; cv=none; b=arFkK5eTjaz1HQ/GcMmRmXHhIymU+yulwvgIUEKQnM+FsD3X3ovCSsAXsY8A7D31sm6KzgUe8fOJQGo1QlMj6QttUNZUvzmbZJfIPaqO/44hMEaLpJUMe+fwLSFv3561pcySPFTiSP93ygL4tFfAprKea+f8dV97ADV1HY2udbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853232; c=relaxed/simple;
	bh=HYTBLqLn4E3cL0gGR1WIJkrMKsXhvo7P7pFwZrO4tmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iL9bkw/cHBiPS8am5U+S0QFAIHDv0MmcK0lzwZQ3VoLYQsUbT41sHGV83SzO2pSH0yjnRkiGGMW6zZU0ymIJJ+gWoFO78wckury0GpB0dPIauYkUCMEnV+FdNvNCefc5siDK5x5cRt07FTKJT0g4PmrM9Qa8tKsnjOb71oMX9us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sYkDjPVA; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sYkDjPVA"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDwt4wy0zlrvsx;
	Thu, 30 Oct 2025 19:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853228; x=1764445229; bh=hcDto
	Fpb1ltHOyX8D1sezmqY+G+tbLBna5KO9polmug=; b=sYkDjPVAWKHZ/aqncAJoU
	Dy15dJPpCmedYN1fjOCvGDW+nj0LXxFUUiadAnYPPIOcLWZ3lK33UYZbgVOyJ9WP
	kPrXwJbGdeg0akYqzkeAUQlTWMnsEf4psGnVuaxZ+7DoWvv0U/gGnsiP0fvxJb3D
	n1dhKnnCv8r0qE35TPEooi50im1DKglt0UPGs8BAp7BjMbljR/GJnmUTd47bA9I1
	p9G1tGDRDymqScjxIThKcuV/VcgI4G9/n/WTiJQ6LJyCV1LEt9w3iYbOnSF4EogV
	E/2gYwQqoMz4jEvTMh6r6ANZ8/XWsa1nDAgsbsrGSal5v+RR47y2Tmd/jthAyhKZ
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c1yj5KUNdP4u; Thu, 30 Oct 2025 19:40:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDwk5C2gzltPtH;
	Thu, 30 Oct 2025 19:40:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"ping.gao" <ping.gao@samsung.com>
Subject: [PATCH v7 20/28] ufs: core: Use hba->reserved_slot
Date: Thu, 30 Oct 2025 12:36:19 -0700
Message-ID: <20251030193720.871635-21-bvanassche@acm.org>
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
