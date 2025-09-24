Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1055632BF48
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746059; cv=none; b=AaihNnKDQ/63vXjnaOzt3mOHwdKBwYTCPwHYGfmGLS86SeR+YtYjujqHLtnBk7sHVDGPeUNwLFB65ydS7nt47e8yMT6mV6/INB/gp8vKUN1GTkC4BRgCCPgDoCWE7Cd9yaX3+864m5+7omYSQLM1ImA5l3YHCTl3ymwNpBF9XA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746059; c=relaxed/simple;
	bh=j/i2RgYZKh+FUq5DovA12HRgJs61Kbnnr/npzN6Tb/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8sdv2ieurCR7RbH3gvWm8S3zVOn/kW5cM9uCkqYF/d5uBpvzjpUl6ODFMChuzxkeaxGRxqfmyWpT2couEeb7Tlp7GqdQ1HOmb/b2PSTOcT5gonERHAIqP7pDe3nwphyZIjyd3Zl2Xxs/jXRWsOMUB4lMvCP4bXGw1DTOX8a6h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=5KG9pAX8; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="5KG9pAX8"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7qY2mQWzlgqVP;
	Wed, 24 Sep 2025 20:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758746055; x=1761338056; bh=bPG9y
	TImrZDmqEV1oZ4wXigJC8L4k+JPq7lizU7BkOc=; b=5KG9pAX8Z/5mvRZganbwI
	DeP2KJ8ehDRvQcss0p5zmwUGX0B6PFEA6EAM9jtpVVAsO3zcuLnOIn4lriTA0lbV
	TcE/O+IBgObw431WDYxkQlX9jLilm/AKBk2RLi6XZjMJ7d0PLap/2ecV/g5K8Nh3
	1MsU3Xf7WbN1EaGY8uQxB8C1LSDfwCNkUGqzODA9YDXjIK/sWDrmZii5j0AB6EjH
	VWXUvcu5LL1uXU+U9ytrFqKwQqbFzbUuT53W4fqYB6I39LBZWdi/hvZZBoLnwXBs
	rfU+mDKKW9Gld0H2PV0RRyKWHZIBH62rUW/rikxMi5ND1dX6A/IVL3Nhrj0X3nS4
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N83ANnQml5rD; Wed, 24 Sep 2025 20:34:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7qQ1Z6Zzlgqxk;
	Wed, 24 Sep 2025 20:34:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v5 20/28] ufs: core: Use hba->reserved_slot
Date: Wed, 24 Sep 2025 13:30:39 -0700
Message-ID: <20250924203142.4073403-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
References: <20250924203142.4073403-1-bvanassche@acm.org>
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
index b99e482ad8da..9b6674d6f21c 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -536,7 +536,7 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int ta=
sk_tag)
 	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
 		return -ETIMEDOUT;
=20
-	if (task_tag !=3D hba->nutrs - UFSHCD_NUM_RESERVED) {
+	if (task_tag !=3D hba->reserved_slot) {
 		if (!cmd)
 			return -EINVAL;
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
