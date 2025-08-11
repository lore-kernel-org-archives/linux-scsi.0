Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E0F311C16
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934068; cv=none; b=ohGRIl0JKhOVszDQITfA6wknTkIdyUE6WtKnBMIoOYe8aUQ4yLw3/fWbTWqodCNg36aonKgN280nEmlEd4mZ7yLL5mS4wz43LFBwAyB+soWG7h6GLhKL1PwWgqoPUV7/xlB4mtnSEYXgS7JrV21krcqj6t1V4QyOinTrhyA4R78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934068; c=relaxed/simple;
	bh=7OUG1Bij2BI/1BIBGgD755On3SiY8hoUY3TAkbUpmbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Za+g3uPWuijjg5RzfIlObcjdVZfCpR2ty+BSNJNMprXM3PzYAmh8yUJ+jOBG+MNKMnQ3e4ZH25j/ofrtnti7UDN41v+H0Q+CwurherHgY3dZ2wWp5kDEtb3KHZD7NVOoPZj8nsoqSV5Zzi4itpAj9hjeR42EU4WgbNSE4DjnjCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rw/sBeSL; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rw/sBeSL"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c12423gmszlgqTr;
	Mon, 11 Aug 2025 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934065; x=1757526066; bh=6ULWe
	PwbImgpb6WAbSrl7hgeYLgCqBTYaHFHNWRGkLQ=; b=rw/sBeSLmLJ0kP6/4Xgvh
	ZcHRKF+T8AScVAV9+sEfAAllouuypEESJfUsZvAPtcRirEtUSv+rjrETuymsts1B
	lvHO/kWGfRxVZBEPYRriHhmACeGWfzf5Nmht1XpIikG3ubNHfoTo2QWTS7bXkEpw
	BEHbpewpNrGKB6s74kgTP1CnDhcwNEdhLuST6V4xbjSV8nAgQTG39DeKvf9EUAun
	vH5C5lkFr6ry1x2K0maIXirrKxy7W8+28aIl5lEWjpwgmTrTMwIfM2c8ut+uyZlB
	JlIntU34SiKqi3SZXK2kAkKqTPUbpzi5JCw1XgW2s1yj//uc7q6w/5MhY7hXomef
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JvPJMgqrjNBY; Mon, 11 Aug 2025 17:41:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c123w5KcvzlgqTq;
	Mon, 11 Aug 2025 17:40:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 24/30] ufs: core: Make the reserved slot a reserved request
Date: Mon, 11 Aug 2025 10:34:36 -0700
Message-ID: <20250811173634.514041-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
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
index a932f62c5c2c..8014b6ec0e42 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2466,7 +2466,7 @@ static inline int ufshcd_hba_capabilities(struct uf=
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
@@ -8912,7 +8912,8 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba, in=
t ufs_dev_qd)
 		goto err;
=20
 	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+	hba->host->nr_reserved_cmds =3D UFSHCD_NUM_RESERVED;
+	hba->reserved_slot =3D 0;
=20
 	return 0;
 err:
@@ -10757,6 +10758,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
=20
 	host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
 	host->cmd_per_lun =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+	host->nr_reserved_cmds =3D UFSHCD_NUM_RESERVED;
 	host->max_id =3D UFSHCD_MAX_ID;
 	host->max_lun =3D UFS_MAX_LUNS;
 	host->max_channel =3D UFSHCD_MAX_CHANNEL;
