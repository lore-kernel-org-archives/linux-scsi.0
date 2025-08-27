Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E345FDF59
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253499; cv=none; b=hOUl9pG3knkfTJG3AAK0UvbzhrxlDtoJSatxwO5mtzeg74WN+10NrvFNHZAdBGUK+Gt4f2Q+iaMSiYQOIeZVVwYx4sWwhkU5H+5D+MqwApvy4Lpf2TeCqy47hYFIHRR3QFbhUj4TVwL45q6N8jr/o4sq+s2FPKDo9OSbF91YhUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253499; c=relaxed/simple;
	bh=j/i2RgYZKh+FUq5DovA12HRgJs61Kbnnr/npzN6Tb/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ad1VgFaxghRAWioZRjczlhHpgnL8M498ZKhYJAaK1OzaTRPwh5lTvtgV0coXQrPOPbFpjlVWmosbQbCPG4ux0RFuY4Mf+owy01n11ZW4O2W5LDqvEzcRp9jXYHxQ7XqPuP/LIniU8kDLIuU0nt1MC080CQ4Gp/pVgnz1IuyWDDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=diiAUVd/; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="diiAUVd/"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBQ1d1wsJzm1742;
	Wed, 27 Aug 2025 00:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253491; x=1758845492; bh=bPG9y
	TImrZDmqEV1oZ4wXigJC8L4k+JPq7lizU7BkOc=; b=diiAUVd/1KcMq96lc2Ic9
	TdvV1Xq4A//YuKp/gGzjRtsLuaStrtV3jKHb0NRC3d2mvGnmQepwKgu8g54JYZHm
	HTTXkVGggNEyjEZ9yoN5HXTfjTIQnZwTVE0/Rb+6mgiMrxeTZ+mC48oiUZ0pRON3
	AVsF5Y39ywE9stP/maHrTu3ORLhXNELM99xO4p2KdoAvuLKugjbiCYTTcGAaAuRq
	HWAKwmFw7L4EJkR0zSGVFTUcgXYN6aC5w9mk/KNca6LNzQnSZ+JJcMniE2WgfxgE
	X9NWvBGhmmHkUZ0IE4VrfLQ90Ww58IR/ZceRpI208qfrkQv6I4Thqd+afWQ0KPgn
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Pa0eGoZA8jyP; Wed, 27 Aug 2025 00:11:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBQ1S41Ltzm0yVM;
	Wed, 27 Aug 2025 00:11:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"ping.gao" <ping.gao@samsung.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v3 19/26] ufs: core: Use hba->reserved_slot
Date: Tue, 26 Aug 2025 17:06:23 -0700
Message-ID: <20250827000816.2370150-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
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
