Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A456F1CF8F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 20:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719952883; cv=none; b=sCZoenljLmmPQ6oEeNGl7TPGbH4+h2Kk/qlV8SqSNdcwdJLLBDAPdSk/4jtHuyvrrJ4xXo6ny1qJqeL3iGJUavGZLb+Tz0vkkslypJTvWqeS8UGF3VmB53X7i8i8+9iRAqEFx8cAoRq7HfsSkfWc25LbJtJk/Avz/LYdNFfnjW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719952883; c=relaxed/simple;
	bh=EBiV7D4z+WEztx2RgRRU7jfIZTy/vzjL6zISW7O5fco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP5jn36HU1ULpjqNoujux16LhccJFbUUVcObthx6JOiF7J49m5cpbQ/uZZqo9ANaOLi4JAoDxsP085rze0rUUYstjKngOYRXH+qU3TuBf4ZybFILc4n6GQQLqN/Suem8pU4WmFZhcFymog7LAjjGiOMx17FG1zuHX+ZvDMtQDrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Bao10MbR; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Bao10MbR"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDFDw6r8lz6Cnk90;
	Tue,  2 Jul 2024 20:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719952876; x=1722544877; bh=4ziCu
	nqHIUeWHu7uh7TCdc2Tl6mLk+QYUQDvl0l8OwE=; b=Bao10MbRT/6qS/0CsfmKu
	KdaXlQVO71Iz4WXxCYgAoOtyEmm240l4cESl7XwDTf2qZeEy5B0ayb+oByv+/qnM
	A1Fq6Vm2S2hURoNd55ZK3vKu1ylj/I41IHDl9mp7mex52f8hGiggkSO2/UuLyH2r
	TioFSBM7+9EXkDlVKeas/lDnMGorXzJsHrqyf3GLzElQRBg8xv3Xfn1IZTmYJXS6
	S8/0JYWM2gFwhCe3ZfvCCokQxZIe9KVHy0FTkCUcH2YW3M89RcMWoieDbW2kZT6J
	XLyYNCWT7AIUprEahNy0wemkysXd2eKpiJ6MNjFjvrP7EfpRrBMSif1Qv2IFuAmS
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 68m7qmoXpt8y; Tue,  2 Jul 2024 20:41:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDFDq0nR5z6Cnv3Q;
	Tue,  2 Jul 2024 20:41:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Keoseong Park <keosung.park@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 3/9] scsi: ufs: Remove two constants
Date: Tue,  2 Jul 2024 13:39:11 -0700
Message-ID: <20240702204020.2489324-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702204020.2489324-1-bvanassche@acm.org>
References: <20240702204020.2489324-1-bvanassche@acm.org>
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
