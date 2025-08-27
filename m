Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1498D28695
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253355; cv=none; b=NkOrFLENPDAsp3RIHWB9/42jljj+Or/I2gn4NaH020zz7OUZxm2vw6fwiaQL75j82QeWO3VXKe3acLTD6Ks2a/IBIXUbM6t47peW3oapWTuRaHwB4x5J0sSM5dX6TWiToIn1Y4nscd7EIx5xikSRj5U0Mch/eDqB8JUsjJz1gdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253355; c=relaxed/simple;
	bh=NNopB7HsCw5hHHmASnR7hShJanHtgx8YYzdYd7VsIZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpX1re98IeoLCSYPFZ68KC/NjnuXK0fiwSpiooq/bMQoOnuCF1KwfaLJqulO/LpKB3fjDx5zwbkhM8iwGOYLF2QnXS9OPDuLfK3MQ12ypJdsqk9pWKmBeUBXmbM490ZWv/AyCYak45L1fddXDvV/Kig+82nBGsH5BV29IVo673s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sHPmu1Qc; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sHPmu1Qc"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPyx0rrWzm174B;
	Wed, 27 Aug 2025 00:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253351; x=1758845352; bh=yDfGy
	WS/uTQKnUHYuHZXSD3qnaDGCdN1IM8f2ZiCM90=; b=sHPmu1QcrkavyOcSG2CnC
	JztKf6c00lpiDRrq8eU8m84hkabsuq3J8VX1J76tAAsXMeQymDYY9rYaNQU+O5gK
	ou7ekycg9p2vfm6RY9/kfeJp1nwszjcc8X5kSoWN3/8VRMDFNibPAmdAocnXQFd5
	4fgTrcp6TN3M55uNUQHRQ5uIZZp91Lxc0HPGuFGeiRR5RPdJKGHg6G30qBjnoDTp
	7f2UD+Zkidfi5sj9wxu/22Kw7nF6u7pVUmB22OOALuKEWxber0OWl2piiq/4GYVr
	kcYCBBq1YzPUhaPKzppTyHjYSTIK27jdKTCoUcgnJH+c3UO4TnnNZYEGFegb03FM
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id F50pOVCj_Xj0; Wed, 27 Aug 2025 00:09:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPys0Dfgzm1742;
	Wed, 27 Aug 2025 00:09:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 06/26] scsi_debug: Set .alloc_pseudo_sdev
Date: Tue, 26 Aug 2025 17:06:10 -0700
Message-ID: <20250827000816.2370150-7-bvanassche@acm.org>
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

Make sure that the code for allocating a pseudo SCSI device gets triggere=
d
while running blktests.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 90943857243c..83bb84ea2ea4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9438,6 +9438,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.module =3D		THIS_MODULE,
 	.skip_settle_delay =3D	1,
 	.track_queue_depth =3D	1,
+	.alloc_pseudo_sdev =3D	1,
 	.cmd_size =3D sizeof(struct sdebug_scsi_cmd),
 	.init_cmd_priv =3D sdebug_init_cmd_priv,
 	.target_alloc =3D		sdebug_target_alloc,
