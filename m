Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7BF32BF44
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701673; cv=none; b=k39aT7f/FHPRZ/+H8FVS0qZMfn73RYK5Zm9nssZBz7lLUBMXK1kXZE55mJScYEPi8i4znvKZhAbClF34z/80fCM1mt+jdxBl+q8Jf8ppUUAGhmFPCjT2AdEinyKTR7+2VHaJDpEhUBVyjYhYnJwc7epNB6jVnzMuEJQ/9J5kYhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701673; c=relaxed/simple;
	bh=yOlLXj578zRflcSo/+nN3dJEzUJgdPyPyqTvzscVeIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjjXC0MPsmVczRlgUj1t6JJ83ClM6xKKCDZtauD7mip7RWLyiWehuS9pIpWvzrvEYAZzWoS9ln3eQWMqdkc+nrzbIY0kPRVfggngVpcJ3zEBd5WCr8OovHJPjhMcRgol1RPl5opIjdX7hXxolJarZXLKwaAvlJknUx4cf4lOW+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TFQCcJNY; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TFQCcJNY"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjbC3lRdzlgqVJ;
	Fri, 12 Sep 2025 18:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701670; x=1760293671; bh=we/g5
	u7l1BkQJaG9S+d6pGApXKbi4h3DJ6zm7kD4e10=; b=TFQCcJNYuib3hD2DerMdR
	gPEp0Geh8KFMDqsNDcHnVJuI1U12lQCy9fCRRQ3hu5TnObNj6USE+4ZNOCJelHfO
	+G0GwqqOQtgJnhMQpGBYKGG+/qB1TOn7ltoeEYWbsBoGJ7NbAN1IeCU1DlOwEC+6
	6Z6hcGvYAAwSVUBpHUln4S/wZnrtsNIYK2CA7CBCszAzZnihDtyE8r4Mk6PXNBP4
	N2RVdqgDyyJSK7alve/70wZv0DNTWWOTsFKCmNe15FQO0CD3gNg8VoTAB4uTDPPP
	uL0TwcRsyajIjqnTph6tq8Blwo5wKN6L79LzJycdH8k3fgqdk7FUjcyXL0XSv9+S
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9Kr0RQWeRJjh; Fri, 12 Sep 2025 18:27:50 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjb52nDbzlgqTs;
	Fri, 12 Sep 2025 18:27:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 21/29] ufs: core: Make the reserved slot a reserved request
Date: Fri, 12 Sep 2025 11:21:42 -0700
Message-ID: <20250912182340.3487688-22-bvanassche@acm.org>
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
index c43fd0a224f4..ce766295d4ca 100644
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
@@ -8911,7 +8911,8 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 		goto err;
=20
 	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
+	hba->host->nr_reserved_cmds =3D UFSHCD_NUM_RESERVED;
+	hba->reserved_slot =3D 0;
=20
 	return 0;
 err:
@@ -10736,6 +10737,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	 * host->cmd_per_lun to a larger value.
 	 */
 	host->cmd_per_lun =3D 1;
+	host->nr_reserved_cmds =3D UFSHCD_NUM_RESERVED;
 	host->max_id =3D UFSHCD_MAX_ID;
 	host->max_lun =3D UFS_MAX_LUNS;
 	host->max_channel =3D UFSHCD_MAX_CHANNEL;
