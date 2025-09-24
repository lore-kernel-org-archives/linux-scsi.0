Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E22632BF48
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746066; cv=none; b=ZvBETqmyid9vUNRHuw8wa5SvlKf+YqF8Qo0qns+kidfSs2i2mKT462vB4ez8jXjhAso/aZi3aRLNun3jVJ1CSsyjMB7/yEXIcMGuiT32gErJTP5j4Buqn1sYRkFKnUS8IhV5qlEOpSYe/Tkl/ioc3cOkVlM3MguBkKbahLJDbSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746066; c=relaxed/simple;
	bh=jDu2bMJAaL/pwh3gGucswsfdh6dUQ97bNFuHHIZwtSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5GjevYnld20Hf66tN3D/6PAftRD0bKAM/Zd6xarkWfJvsPhsyxnePiJzD1+QfXIzL27uI8sRnejGpMov5/6wAwflJ1muKE1FDN9enUWDVreDR0yPPuSEB6jfgDQuc9pJh7/DMpX/+c9dGVrx2mBBiDmwP/j6GF8ZpmCK0GfkTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WHjE4XwT; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WHjE4XwT"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7qh2CCvzlgqVB;
	Wed, 24 Sep 2025 20:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758746062; x=1761338063; bh=KB5F2
	8S2UVaUWifYpBS08F0qRMkT7vq65NaXUtTLZcM=; b=WHjE4XwTN4PELMfZlhYM2
	u/xXxgVTYoko04jBu0X4ZwbJsEeYu1V9Y8/oDKpe8Xfe5eo+xO/ymp9z7JvnYSGb
	MIEic1/5IdbuGcn2gT/gCcnfHfqXIdCJ/TFbwhOcSw93EBuJ1b/sjTmQ53afjnE+
	MeD7SnSYDFgUj6hM9Z4Yv86/K1Q8yDhcWoSU9BnvYikgriQi7a33u1fBsvLE44d7
	jwav7zKRvmC8RNXixHu2jhrfuVJuxJU6PG6FNcvlTgNV/yXBNxNWETu65HK99j5G
	xp3hb8k1IytFmB7G5U4+ecvCfkeS81SHfeQY6RR/pOmGW1ooGjGhaP8+vW9qZmzR
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UX-hJ878xkSO; Wed, 24 Sep 2025 20:34:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7qZ3fDHzlgqxk;
	Wed, 24 Sep 2025 20:34:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 21/28] ufs: core: Make the reserved slot a reserved request
Date: Wed, 24 Sep 2025 13:30:40 -0700
Message-ID: <20250924203142.4073403-22-bvanassche@acm.org>
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

Instead of letting the SCSI core allocate hba->nutrs - 1 commands, let
the SCSI core allocate hba->nutrs commands, set the number of reserved
tags to 1 and use the reserved tag for device management commands. This
patch changes the 'reserved slot' from hba->nutrs - 1 into 0 because
the block layer reserves the smallest tags for reserved commands.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bb14af688e98..1dbb5bdf84f2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2475,7 +2475,7 @@ static inline int ufshcd_hba_capabilities(struct uf=
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
@@ -8915,7 +8915,6 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 		goto err;
=20
 	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
=20
 	return 0;
 err:
@@ -10740,6 +10739,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	 * host->cmd_per_lun to a larger value.
 	 */
 	host->cmd_per_lun =3D 1;
+	host->nr_reserved_cmds =3D UFSHCD_NUM_RESERVED;
 	host->max_id =3D UFSHCD_MAX_ID;
 	host->max_lun =3D UFS_MAX_LUNS;
 	host->max_channel =3D UFSHCD_MAX_CHANNEL;
