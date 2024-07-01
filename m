Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694EBF9DF
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 18:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719857089; cv=none; b=SiiZnZ8976DekIu4vlhBZkZhBwJXDk0PvrFBtyIjSvuY6skQuI/1zIiBDROrW4RjR7FBZn/AeDT4rpspqcOc7/2WH+2DFcuTxkEDvAWVBfPqH2Wj+wYuPtYzLmCcYKAYdz+Mgi45KzxpJeBhrNNMeiN6sahpR99JUcZHYjn17bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719857089; c=relaxed/simple;
	bh=iGzL16xIEcwP+YYTuYEXwvKikkkzv/kcvictY/r+GEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOqMIS7zZEhk0gow7qP0uJBLl69nq+laOUirqa7MtHVDrk7E0CFRNgDg4iOGBy1PwsFMNGgprW1m+/Yz/TH/FQ71uhe0/Po30Ow4Kp7Y9lzsfh4NpSizfTea3o2exp/RBNnm5xvJkaNRXvbR+yeHgUh9vd98b+2ubDsPb2o3Cqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iyCZ4Ehv; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iyCZ4Ehv"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WCYpl5BNczllCSD;
	Mon,  1 Jul 2024 18:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719857084; x=1722449085; bh=UL8Qv
	xzTY8S2zZMzG5+APzFWlOzjb5YYpFFmLeHSW3w=; b=iyCZ4EhvWKPHuH1heQBqV
	tHauHmdqRVU1E8nVsI1yCPQZC0z9OVIx2Zgza/8L/zlC0R1hooJPgYpKQuHoONUJ
	fIUP0jTAMrt8gcp4Fh1oUagyxUFM2NLr0wx7NScoqCdD0l+jxxz4CLOcSfR72O/Y
	4Q9WYmhce3fbFNxRiYORj1gZ0shjP+hZWhYQkcJH6yYHLVCW4bpwIW9QYod7XyVN
	XRtCKcnhAL+92tbV/6JnvnY6Vv2e2VcdyM4NwViM3kVyngGY52zGgGXl/szFLrBA
	Tp0DX1buz5YbNWo6nPHAirgSJjfdOHEYxknOUOWHKixvYWtGUhIr6UXmW57GSatr
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Z9iQvKnoCkL9; Mon,  1 Jul 2024 18:04:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WCYpg6k18zllCSC;
	Mon,  1 Jul 2024 18:04:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Keoseong Park <keosung.park@samsung.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 3/7] scsi: ufs: Remove two constants
Date: Mon,  1 Jul 2024 11:03:31 -0700
Message-ID: <20240701180419.1028844-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240701180419.1028844-1-bvanassche@acm.org>
References: <20240701180419.1028844-1-bvanassche@acm.org>
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b7ceedba4f93..9a0697556953 100644
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
@@ -8958,8 +8956,6 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.eh_timed_out		=3D ufshcd_eh_timed_out,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D SG_ALL,
-	.cmd_per_lun		=3D UFSHCD_CMD_PER_LUN,
-	.can_queue		=3D UFSHCD_CAN_QUEUE,
 	.max_segment_size	=3D PRDT_DATA_BYTE_COUNT_MAX,
 	.max_sectors		=3D SZ_1M / SECTOR_SIZE,
 	.max_host_blocked	=3D 1,
