Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1718D4503B
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473478; cv=none; b=iJYA6rVPnZUTQMB5S+ZdonapYLF1rXyizeVAEtMWM1YDpyE1Eby40u9kKHcixZgWK3r5UCAtTcSvMpHBLfncymBSc0tk+YmoYd3Wkp14YImVg9+NKtIgLkl02gt4yGn78z9HRXE9/X2gykyKtVUXdM2Eg/ZDd5aUwJh9US4SaHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473478; c=relaxed/simple;
	bh=bog69wK+u3MJRMP5GkrTiQEfg3DlANbSlM5Tbw4Sz1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYm9e1ynXDO5qG8jJ6l5RBiAxG9reEOA5EQT1c12rDjx+JH526uWm9AAzb2gF6tqp9BuwrVpyhZasGhq7OrDfrSjuT85LKSVdZzSSfDR14ByJbHMcoATktZtSEdih1hbzeg9mqaKd6mqUX0mdhsvmW7ECzP1mkL7PIMqMNJB4lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gZeeJj0b; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gZeeJj0b"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WHxmN3rmbz6CmM6L;
	Mon,  8 Jul 2024 21:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1720473472; x=1723065473; bh=7zR3X
	MkbbD1SWPzGr1k7aZOsIkLMqYr2141aP0Wn/qU=; b=gZeeJj0bP9AigoUflvaEZ
	hDq7S7j12cMCXrxew6zZlmPFs+a5zec4KIf6XP/PWZcT65JK2IH6rMgyoDHql9Uz
	k9tTbQzPypMk11uUardV+/4c80nlWCMnEGv4JUVBhmWcsKZ/AKhjX2b9cTGABZO0
	f7nzrB74HEWG2HSjxUsmelUEoDZxkfn1SrKYk+UGDIWNUwmchwgVHvC8FziPQQdW
	OpgWqR5r2nwWj6JMSX2rGA7pWxSB9MCPaf9pLG7dvTe9naJ7FAhi55mL4cCXzISM
	W0xnesnQcCSeNcKb7VZfswaPEy/O3eup0CSvCmrD1hC8DaWXBj0JAOlwNjKs13b+
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7JakenHeNeXW; Mon,  8 Jul 2024 21:17:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WHxmF3Qbzz6Cnk9T;
	Mon,  8 Jul 2024 21:17:49 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	Bart Van Assche <bvanassche@acm.org>,
	Keoseong Park <keosung.park@samsung.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 03/10] scsi: ufs: Remove two constants
Date: Mon,  8 Jul 2024 14:15:58 -0700
Message-ID: <20240708211716.2827751-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240708211716.2827751-1-bvanassche@acm.org>
References: <20240708211716.2827751-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The SCSI host template members .cmd_per_lun and .can_queue are copied
into the SCSI host data structure. Before these are used, these are
overwritten by ufshcd_init(). Hence, this patch does not change any
functionality.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Keoseong Park <keosung.park@samsung.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 13c57bbcdad7..1b0445bb5b7a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -164,8 +164,6 @@ EXPORT_SYMBOL_GPL(ufshcd_dump_regs);
 enum {
 	UFSHCD_MAX_CHANNEL	=3D 0,
 	UFSHCD_MAX_ID		=3D 1,
-	UFSHCD_CMD_PER_LUN	=3D 32 - UFSHCD_NUM_RESERVED,
-	UFSHCD_CAN_QUEUE	=3D 32 - UFSHCD_NUM_RESERVED,
 };
=20
 static const char *const ufshcd_state_name[] =3D {
@@ -8959,8 +8957,6 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.eh_timed_out		=3D ufshcd_eh_timed_out,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D SG_ALL,
-	.cmd_per_lun		=3D UFSHCD_CMD_PER_LUN,
-	.can_queue		=3D UFSHCD_CAN_QUEUE,
 	.max_segment_size	=3D PRDT_DATA_BYTE_COUNT_MAX,
 	.max_sectors		=3D SZ_1M / SECTOR_SIZE,
 	.max_host_blocked	=3D 1,
