Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF693054DE
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472187; cv=none; b=el0wDEIZ/0UH0wGGRuN+AdrpuCOl5+woNu/RSgwbYBLmW/N7jH7NWVlYQ5qE95gB4L1hD1Rytkq5ihVnaxfGn0L3+klTd/rJv7M3so+QYFVyAtF+b7AwvLEeTvfhXH8AcDp/uNHwvKk6sLb3YlKaRgFu1W34bP3jNrS692hY0x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472187; c=relaxed/simple;
	bh=8zsxDLcWj3kELaFNE8pgx7OLH84ZzMIaT8Oye9J3xKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giY2D6A62iXtawFvi0Qkbd4pPmzJqZpBgrAjC9RtGw92BUt5S7NrhageUg5TGdUbmNat+x+mtTYxfi/DEK5lI8QkkzGYt441azbL4o+5UZolg0dULJi2b2Ecv5Ez3kdOgDpFHeL+ATxrSSA/7U/EISsqcyyQHyYTwqMcoPMwoRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hlaiGL80; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hlaiGL80"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmQBG2wPkzlgqTt;
	Tue, 14 Oct 2025 20:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760472180; x=1763064181; bh=oJRJS
	eJTmm3I85XbBp/z5KjpultfzdHLkUUQjf2KaQk=; b=hlaiGL80Gdj8ZhxvNF7vc
	G6p6iimHcRjpTS2LPNigQQVrcGtoir5JzZ2lreuIsoigLJG2uCUWaeqpTDg5MycV
	yUzGVZUuZifTqFXQ0qHnI6q3mn/mpVgkWxOK24x1yDioTRRdVuoKFY6zsDh1579U
	21phQE+zvQmr5V3ZtcSjiP2u+LQvoQpxLHCuyi56EV20ZdTXxri21DY3BRNXqEfG
	7h2PBXMYFg0OkETwKN1EkKxcgqFwCBWD2PD9RTCCgzWJ0ueD8MIiKH4MakvJXEIs
	JoyJA4JCOER2yCu4ZuzEtKX1LOeTaNbJUWhgZBYLyOfSAOKS017Xa/eUBvAGaPWq
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zmkiKxkdBgPj; Tue, 14 Oct 2025 20:03:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQ9z3F6fzlgqVb;
	Tue, 14 Oct 2025 20:02:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Avri Altman <avri.altman@wdc.com>,
	Eric Biggers <ebiggers@google.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6/8] ufs: core: Move the ufshcd_enable_intr() declaration
Date: Tue, 14 Oct 2025 13:00:58 -0700
Message-ID: <20251014200118.3390839-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014200118.3390839-1-bvanassche@acm.org>
References: <20251014200118.3390839-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

ufshcd_enable_intr() is not exported and hence should not be declared in
include/ufs/ufshcd.h.

Fixes: 253757797973 ("scsi: ufs: core: Change MCQ interrupt enable flow")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd-priv.h | 2 ++
 include/ufs/ufshcd.h           | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index d0a2c963a27d..1f0d38aa37f9 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -6,6 +6,8 @@
 #include <linux/pm_runtime.h>
 #include <ufs/ufshcd.h>
=20
+void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs);
+
 static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
 {
 	return !hba->shutting_down;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 4d215a18522c..edfbc3a216be 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1295,7 +1295,6 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba,=
 u32 mask, u32 val, u32 reg)
=20
 void ufshcd_enable_irq(struct ufs_hba *hba);
 void ufshcd_disable_irq(struct ufs_hba *hba);
-void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs);
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
 int ufshcd_hba_enable(struct ufs_hba *hba);
 int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);
