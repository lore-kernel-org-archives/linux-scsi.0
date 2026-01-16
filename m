Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2833A0B1D
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 18:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588012; cv=none; b=V8k4RbnSBQ3U+zEgXm4vBZl0J6J3mAluM2eXd+3HpAIHp4JsHpBMxvpTXk/w37zmmQVLBErT/qjRbyCQG484ocnCEUWo3yaGaHuFKQqFaATBH0OBxQ1S3OP5JN7EuEWMYrQQE0DFNfDvjGs+5x87/IFuZfh3OJCQSpw+m/94pIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588012; c=relaxed/simple;
	bh=Li6eOlTO0Z86k6hfD94XgovKt1DXoUK5Drm909dNK/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=extXdhTY+6vTuZEFYsF2iEsubk5wHzoZnuetsB93ivHL0Si7N7ZC7djuczz8ouTU4ba4AnhqLOBXQSNcoT/9DA8yoN6O+46EAetkpQ0RZhItbJD8uFwXS1yOxvxiAaXnuvo66QjjrSYC3YpEgi3RechtOoW0bmsK/5oiD5gGb7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fzG+kFAy; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fzG+kFAy"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dt7bv44bNzlh1Vw;
	Fri, 16 Jan 2026 18:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768588009; x=1771180010; bh=EJ8ML
	pfY6nkVjBj4RSCFY1swlhuNcO1vcUpY69T1cfI=; b=fzG+kFAy8pn3MaHOgEljF
	th8aobhHfdANCL4IdExi6+IvZV1pCNtGdDrmuxtMb29clzxPdGkZNA0we7J1PIdM
	VoUIlTDPRji9LgqhT7IdaA2JFMZxnBAVfNN1xhiScN2eyHQOgdhlbIGMB9pa2aqW
	BiHAvcLNw11yvTUhIPJ7eC8fZX+a3YnH3EjxRXcfu4vzTeOUImQfN3+V3+s7DCKE
	PBbFGoGeJMggAb4EX1FaXjNsWRHhrkWHoK8zmDAufOAhFiAOj0+r5XIQQP2XRgTq
	Eh4nK9AWZ2zDrF8Tsl/v0vt+zujQrDzhtMfKJTsPAgGGojw3oqKF+dXcj61ax92c
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Z8uQNqEjxT6B; Fri, 16 Jan 2026 18:26:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dt7br0PsNzlgqw4;
	Fri, 16 Jan 2026 18:26:47 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 2/7] ufs: host: mediatek: Use ufshcd_clkgate_delay_set()
Date: Fri, 16 Jan 2026 10:26:04 -0800
Message-ID: <20260116182628.3255116-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260116182628.3255116-1-bvanassche@acm.org>
References: <20260116182628.3255116-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for modifying the implementation of ufshcd_clkgate_delay_set().
No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-mediatek.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
index ecbbf52bf734..75cfa18be88b 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1109,7 +1109,6 @@ static void ufs_mtk_vreg_fix_vccqx(struct ufs_hba *=
hba)
=20
 static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 {
-	unsigned long flags;
 	u32 ah_ms =3D 10;
 	u32 ah_scale, ah_timer;
 	u32 scale_us[] =3D {1, 10, 100, 1000, 10000, 100000};
@@ -1124,9 +1123,7 @@ static void ufs_mtk_setup_clk_gating(struct ufs_hba=
 *hba)
 				ah_ms =3D ah_timer * scale_us[ah_scale] / 1000;
 		}
=20
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		hba->clk_gating.delay_ms =3D max(ah_ms, 10U);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		ufshcd_clkgate_delay_set(hba, max(ah_ms, 10U));
 	}
 }
=20
