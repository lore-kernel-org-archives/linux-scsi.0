Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE87D3009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701556; cv=none; b=rBo1QCWwmGySvU6TgUU6qJVM33YpjhCqKm5NKMGNiUUm2bu9K0aFzkP1rnuBAoJXcBW9e047imVPh672V4HSZbh+rFur1vDT+JXOaGdmoMemRe3vVTUlXajgttFeQc8upfFpohzGhwJWLmOSd8H7m/nnXnrt4Q8OtLYbP6Xp8XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701556; c=relaxed/simple;
	bh=FNGXZAS5CX2lp2KH+nEYqd+j3fOQXeSd2GZ8PySdMSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETEjNH62JXiDHeURsvPs9RZbdmGgSh6ja3ruWzoC5YowjRP6Mz9xWdzySKHP+MGACrCHchrfyZnsm8YBbVoyM5mWE998UIIaKjoGKNdmJ9YSVwdzHvTO6v3c19QNTlGB4qtQ2eVuyydkYB59hZd8+GjltwdvzCDoOxt4mEUtmrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=e3TBga+i; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="e3TBga+i"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjXx5qSCzlgqyC;
	Fri, 12 Sep 2025 18:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701551; x=1760293552; bh=boWjA
	RKsgIco5vHMPI2OTyPCoGGR/+gOSZnXyg2bFAU=; b=e3TBga+ih/s/q2Yr1Imjd
	RRgBKhL5PdNOTT/yRetNR7ZTesLc0ErX0CrQ5GX5qpo8ZevIbsQUSbuLaFWOJGS8
	zpEkefGBrfceDrcpJ8yJoqKUVxd2oCdkPFHH0T6pJY/6lVeozz+ZLAruNfLHCi1Y
	71LHPa9hqwKS6mxSNmunv9ntdKH4Ak/Yoc9B51UfAVfGgy+4C2G1kqPq6Po37Xu3
	mhNIrdg3ctf0Ga6wue6CH4gwxx3ywMQblf2rFPbaP9JNP2J3sIDw7u35j53Gx4n1
	Wha2KDmnk8HM2SkrLDG90JrRqKKrS48VNV7sbemZydrBdiYDFTlRWG5P+cZ5ESdF
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EfLN8q3AUAxJ; Fri, 12 Sep 2025 18:25:51 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjXp1m0nzlgqyk;
	Fri, 12 Sep 2025 18:25:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 10/29] ufs: core: Only call ufshcd_add_command_trace() for SCSI commands
Date: Fri, 12 Sep 2025 11:21:31 -0700
Message-ID: <20250912182340.3487688-11-bvanassche@acm.org>
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

Instead of checking inside ufshcd_add_command_trace() whether 'cmd' point=
s
at a SCSI command, let the caller perform that check. This patch prepares
for removing the lrbp->cmd pointer.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9eb11bb33e85..2b14d1510d92 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -488,9 +488,6 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 	struct request *rq =3D scsi_cmd_to_rq(cmd);
 	int transfer_len =3D -1;
=20
-	if (!cmd)
-		return;
-
 	/* trace UPIU also */
 	ufshcd_add_cmd_upiu_trace(hba, lrbp, str_t);
 	if (!trace_ufshcd_command_enabled())
@@ -2365,9 +2362,10 @@ void ufshcd_send_command(struct ufs_hba *hba, unsi=
gned int task_tag,
 		lrbp->compl_time_stamp =3D ktime_set(0, 0);
 		lrbp->compl_time_stamp_local_clock =3D 0;
 	}
-	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
-	if (lrbp->cmd)
+	if (lrbp->cmd) {
+		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
+	}
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
=20
