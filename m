Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C2C186A
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253504; cv=none; b=fzmR0hB3pFjxS9Sh2kAu4VuQtR+eAKCBf6n+O77devLxIbtAbj3yAVcLtHP22xOeeBwuWnI8nWAaZsUFyYzOp5rRjITsjAka7cnpaKyxvsvH8/G2pRCPtA6ap+6WFpXo92Jr/959P+MjUT7tp9o7SOrR0B4anICilRI1AghQ04M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253504; c=relaxed/simple;
	bh=T6rLk1yKOfvNJ1kw2ZMrxoLL1gbT8Z+MbdawY66/C0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGLjLUkfZi//l6dVviZmXf/bI9bqkZP3Od+dTNtJPTIhXSL8zzYB0AGVA2AUNaGNdvgrmUYKM3/+RxRqF45jEdnmgdmamf5OfT2wN+wfxkiAHZG9SJ63AD+bAPU6QqZbcPgd9fUeydVV7xm03vb43Nia9YLkvVyh3+0ikwv/HDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yqOAqnTA; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yqOAqnTA"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBQ1p1BJFzm1742;
	Wed, 27 Aug 2025 00:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253500; x=1758845501; bh=3EU8h
	IKx7BTSHIEboWfIvSLrMOrhubNIJM0LZys5aEk=; b=yqOAqnTAp14mKQUBujB+w
	KwYGG/IbPtV7UD/BNAOJdYZ5THKOv7ym2pSmKopQk1ia18Bm4nhULCjt9qNCxOqn
	iMKQcEJTQYnKLbUhJ/poj2tsy7tuIjlBzD464nTYSjTcO0i7Onf2uGCNRK/PauvD
	niajE1G/sthv5fQjPvRf1/EK7NWtnHPnp0PoWeehOodMUWEn0tBo1ErYiyKgOXr7
	WU431vqdoQF8ezY6TP5JMrv2IE0EZQEc3fsEYaX+vN7WINBeeBZfd6em28wb6qFn
	uot7BsDU6zblmA7hPNRoQjHq7O+J8MMHBPSagpLPenwlRJmu4ST+m8vJJN5vpKPb
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id abmA7upB9gVu; Wed, 27 Aug 2025 00:11:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBQ1g5FsSzm174D;
	Wed, 27 Aug 2025 00:11:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 20/26] ufs: core: Make the reserved slot a reserved request
Date: Tue, 26 Aug 2025 17:06:24 -0700
Message-ID: <20250827000816.2370150-21-bvanassche@acm.org>
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

Instead of letting the SCSI core allocate hba->nutrs - 1 commands, let
the SCSI core allocate hba->nutrs commands, set the number of reserved
tags to 1 and use the reserved tag for device management commands. This
patch changes the 'reserved slot' from hba->nutrs - 1 into 0 because
the block layer reserves the smallest tags for reserved commands.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 766ea5c5c460..a0a555a86403 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2472,7 +2472,7 @@ static inline int ufshcd_hba_capabilities(struct uf=
s_hba *hba)
 	hba->nutrs =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_SDB) +=
 1;
 	hba->nutmrs =3D
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
-	hba->reserved_slot =3D hba->nutrs - 1;
+	hba->reserved_slot =3D 0;
=20
 	hba->nortt =3D FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT, hba->capabilities=
) + 1;
=20
@@ -8910,7 +8910,8 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 		goto err;
=20
 	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+	hba->host->nr_reserved_cmds =3D UFSHCD_NUM_RESERVED;
+	hba->reserved_slot =3D 0;
=20
 	return 0;
 err:
@@ -10735,6 +10736,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	 * host->cmd_per_lun to a larger value.
 	 */
 	host->cmd_per_lun =3D 1;
+	host->nr_reserved_cmds =3D UFSHCD_NUM_RESERVED;
 	host->max_id =3D UFSHCD_MAX_ID;
 	host->max_lun =3D UFS_MAX_LUNS;
 	host->max_channel =3D UFSHCD_MAX_CHANNEL;
