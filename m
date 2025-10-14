Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540882BE02A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473242; cv=none; b=UkxizJ+OaMPtoj0bcqKUnlSzDVJGbnkYO4Qhz0oSdnqw+RVfY6GpVlh21SPFmLuL2gC0VXYHEg04PajQb7IQA/pTvEz+HyfgGUaIHSyo+5YC3l4cQObxdwOS16Z0NFXWbmWFKQhrHaFTKxQphU1Z4nn/BT2cT6+Oa2WYwPdz6qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473242; c=relaxed/simple;
	bh=rf7k+P1UjR512jBtu+aMh0rcDD/g9nzQD1JNdL/no2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kc8sZJ5TdsjJRE0LRcMgfVF14CnNRMQi5aMED4pCoOx+0zynQDmgCtiW/turx/HdmPxHXC7EcfE+kVfWWRbQE+tJdnar7Lu5W52Yf+0wR5Tn1hEUnU2Dtw3fuR1DYkA+nc78M7BcjFWsGJ9ULmEv9Oj/wmWc9lilW6kjljhQWv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NxG4zl1/; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NxG4zl1/"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQZc2r6Bzm0yVZ;
	Tue, 14 Oct 2025 20:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473238; x=1763065239; bh=Q8lan
	e/1Vt4YV4p0CvvjFG7DtYJ0qpM+Gk6+oM+M2+k=; b=NxG4zl1/1K3X40zdupNHX
	zoWJjANCaoH8bUJKq7gE8J4KKr2wNjM/dlgksn1tXiGrZceOcLp6y4LMbfnNaLUb
	XgoSTczL/zd7TLqTlVxQx7VsshHKFy348S2Knae+web0QDZdan9FfXdiW5BnNj5f
	hsfVTC6wHXtl1iv34DpgfOTCH9oUyA1d+fqKLcas3X0NqRBzZTbF6qLJ+sEBJWJV
	wqw8nHqHQg98W61xPtq044tZwrF5Wod5xkCtUeYr9a0pxTpP30YvTv1FAthpa8+p
	iyWMswoqun8CJw0KVocBMw1JTqTrHjxcuh3oPgOjTG2U0V/ZOoHE/t1SnuTngp4v
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UFuVsht_Qe-D; Tue, 14 Oct 2025 20:20:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQZV4r4Lzm0ysd;
	Tue, 14 Oct 2025 20:20:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v6 21/28] ufs: core: Make the reserved slot a reserved request
Date: Tue, 14 Oct 2025 13:16:03 -0700
Message-ID: <20251014201707.3396650-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
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
index bd87a7953551..dd280a85ebb5 100644
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
@@ -8942,7 +8942,6 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 		goto err;
=20
 	hba->host->can_queue =3D hba->nutrs - UFSHCD_NUM_RESERVED;
-	hba->reserved_slot =3D hba->nutrs - UFSHCD_NUM_RESERVED;
=20
 	return 0;
 err:
@@ -9181,6 +9180,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.proc_name		=3D UFSHCD,
 	.map_queues		=3D ufshcd_map_queues,
 	.queuecommand		=3D ufshcd_queuecommand,
+	.nr_reserved_cmds	=3D UFSHCD_NUM_RESERVED,
 	.mq_poll		=3D ufshcd_poll,
 	.sdev_init		=3D ufshcd_sdev_init,
 	.sdev_configure		=3D ufshcd_sdev_configure,
