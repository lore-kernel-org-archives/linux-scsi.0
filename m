Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC043009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701663; cv=none; b=jtDyp2jEyX4JM9fSo7yVVOjQyuFh4xnSMasTAI4LlxBQB8mHLpfHZ6WQsNhoJH3I0/DmeEpOxwMfrY7g5AY4uWQ0hhUjCdddZXslKArXU0bVEUzJBJ5idQBNhIumdl403nP5HeZHvLO1qEy6Mpf6eTApojruaP0DKfsjPwVtNMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701663; c=relaxed/simple;
	bh=j/i2RgYZKh+FUq5DovA12HRgJs61Kbnnr/npzN6Tb/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6G2NAwRrtL4hVpfFggt5MTDHUc2Ff5MJN918HNni5/FGfswORTXa2SykPC1t5lOhO90E+G9WLiooDLwVNnUsuEbY/rynhHO5HX3W19HpOvEe8xJUbNIrIYtahorjJ1nn8mDD41UhG+kyoi3lKVGqJF5Jg/7U6huoSekhKuMjls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XYm9HzX4; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XYm9HzX4"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjb149rxzlgqVJ;
	Fri, 12 Sep 2025 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701659; x=1760293660; bh=bPG9y
	TImrZDmqEV1oZ4wXigJC8L4k+JPq7lizU7BkOc=; b=XYm9HzX4Has8CPaur/IQQ
	s/uG/ZgZ82bf+GZSa22A/L1sFsyHMG+oy4ixim5Rzz1zTUEgz2nBc4jg3uuBp0Lk
	I1Aj3qWma1x6VFGRsSgnxrwogJ4pgyuGy05f4YHlyDuTnhNzkqQmwUfy+DCP9B3/
	SODNm3M91DWA3xLl5EuFu/cdd3B0VV5uBfYiEIpch7yduWOjOgcxE0CN9UvyAOHO
	3Cv5swz5Iu9/0Mfsb8czyY+c5y75ZhlHKsD8BlvzOV1FtaM0ev9sCZnyOwf7uyzb
	UU902sVcVAwx5U2tBvZOg1eUplJSaaCTzlEQUsRm/nglApFgNtasvjde4jLgGooL
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tQ2vpDErEf5f; Fri, 12 Sep 2025 18:27:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjZs0dhpzlgqTs;
	Fri, 12 Sep 2025 18:27:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"ping.gao" <ping.gao@samsung.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH v4 20/29] ufs: core: Use hba->reserved_slot
Date: Fri, 12 Sep 2025 11:21:41 -0700
Message-ID: <20250912182340.3487688-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
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
