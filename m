Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF21ACA6F
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943420; cv=none; b=aa2sReaecRuuWeXN+9WyFhIH/UNyUSSmCLjaEKnTQHEBst3GZd9ytzBmo3Nuiupzt+HMbS2L0cPPMvO7RGucPUS4F4KeySmFOG0TMN1ZhRY8JE/5DB2X7oU8zinV9cjfR9XxNqI0FcJIsKYkynSRWowjTT3AZ8Rsnx/74PAz4yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943420; c=relaxed/simple;
	bh=CKah/LsJkDiCBcxFEzzNk/1lKVRPcN12nO97wVQSxNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2WRUXmgcZZCS3pgCjLTgQMvgz9Ze5/a6oH4FTSEIg7WgJj5MYXPC+KIScZHh9oLgjWHXGyuOxCSMn9bhGfz5nPh+/cp3JcSLflNAyzxfBujaa9GXy4LSq9RHLQGBLhQ63Dlp7FzogBjfo4A8FliUq+ST+Vgz9ZsQmC1Budp084=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iySqU2uV; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iySqU2uV"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytHF72M8zm0pKT;
	Fri, 31 Oct 2025 20:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943416; x=1764535417; bh=EG4Xe
	UYB2npd+CNcr5Cr5EhMXJk3GRJGhPIeIaRNYWc=; b=iySqU2uVrtjnG6lQZAb9F
	HI1ywb4A4Ns4FLWvh4vXvcWQSf7AY6ZGPyNR7O0TgBLg5ZAEAXqttb4fussEqTnK
	/JkSbIAhieBXoeNDmct7M/vv/HO6vO110wA73UVm2juDYUhoVlHdvQH3NwB1Bnzk
	OglbTl8/7QjjmfAK95KWexS1KxHnlHQFDKy2nZCJttTiVHHEUKjuiVmTpouipns1
	kAj2evu+23EY6RgdVSQMCukYhXLtkCsS78gjJgefRVwnOg2EVSQF+6v7P4q7IXCu
	sRvG1trtW2U5Ou72XghE4ElJvyh4n8F0YYOwLL24/WxjV5XYPFY3wXPnboK3JfGj
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UGLGqDiP9C4m; Fri, 31 Oct 2025 20:43:36 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytH61cZ3zm0jvL;
	Fri, 31 Oct 2025 20:43:29 +0000 (UTC)
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
Subject: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved request
Date: Fri, 31 Oct 2025 13:39:29 -0700
Message-ID: <20251031204029.2883185-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
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
