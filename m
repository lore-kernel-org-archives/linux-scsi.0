Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3149C3128BC
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853241; cv=none; b=YSKi6uYZHhjxIM0ixz4sph5x+Kon36jReLfrAMUAJK5+U1w6uU91XqtQNIMiMwvZ4Syo/pC081PlC8/HOFxEKwX1E3BvpLKVPRifFbapzG5QtFl6P6oaulTjCg5CPNe5z3npUEUJhCu6NFllmxyQm750lLut6x7eEkLIajbcEXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853241; c=relaxed/simple;
	bh=CKah/LsJkDiCBcxFEzzNk/1lKVRPcN12nO97wVQSxNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sN/JFqIWWR8zcs6JJFtdlLVpkoyy9rSK4RIvtW01NxwfPmnw6OwmZgXVqRuaQOfBzv7cJ7b5YR0QoOg/Ig7UsUsP/DdxMRJf5LWl5QYj0pRmRjeiaX8+lunAp5PjrVO+4JL1fQBbqCUt5qyRIGpbBbmj1eQu0+w+EdvrEmqSfhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=V0AkgpGO; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="V0AkgpGO"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDx33vvCzltNPs;
	Thu, 30 Oct 2025 19:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853237; x=1764445238; bh=EG4Xe
	UYB2npd+CNcr5Cr5EhMXJk3GRJGhPIeIaRNYWc=; b=V0AkgpGO4vJOTRqLVzHyx
	cE1/61kQj0WzoTf8zMo1UWLvdBYQDHEdNTucKJgjSlbXuGT3A2IR3KYgqpLZjBTz
	ZpLXYyG3cm3wUtVwVdcw8M2l2iSlhagPLSd952urTsBUFLe7CsQvI1VHlbHDDPG/
	5rmQqyrs1oWR678DdvLgxE1c2bMxxdhUvP1B/T8WaXvvRyYGK55NvyvB0yvl3ngv
	tdMpWQWoEgQsT0Xgfn7/I1j5LirSZ2EPsrBnOziCQrZWh0ulhT3ylWYIIUAe6C+q
	5Yc/9WfWO2xY6gtwEVTiq4lhfEQEdO/osbRK3obax5ojIeFeg4HqkqZlymnYpnTL
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4GOT3Iy0BqUK; Thu, 30 Oct 2025 19:40:37 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDwv4HFyzlvfnJ;
	Thu, 30 Oct 2025 19:40:30 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v7 21/28] ufs: core: Make the reserved slot a reserved request
Date: Thu, 30 Oct 2025 12:36:20 -0700
Message-ID: <20251030193720.871635-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251030193720.871635-1-bvanassche@acm.org>
References: <20251030193720.871635-1-bvanassche@acm.org>
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
index f6eecc03282a..20eae5d9487b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2476,7 +2476,7 @@ static inline int ufshcd_hba_capabilities(struct uf=
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
@@ -8945,7 +8945,6 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 		goto err;
=20
 	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
=20
 	return 0;
 err:
@@ -9184,6 +9183,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.proc_name		=3D UFSHCD,
 	.map_queues		=3D ufshcd_map_queues,
 	.queuecommand		=3D ufshcd_queuecommand,
+	.nr_reserved_cmds	=3D UFSHCD_NUM_RESERVED,
 	.mq_poll		=3D ufshcd_poll,
 	.sdev_init		=3D ufshcd_sdev_init,
 	.sdev_configure		=3D ufshcd_sdev_configure,
