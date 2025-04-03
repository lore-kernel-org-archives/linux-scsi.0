Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBC31DFF0
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715248; cv=none; b=J05gVd641VOtL4ASMPkVljpfUeijKZkx6LPcLojR/Jy3ahFpBlrUF6KzgaA+NJ9dOOrKp/BnP96XiPM4bFMYHldT5OOPULX7QXf/u/5qZyIS5b0DqUTmyPND4uurutBPlfyaJnUiXwGBLecacsS5a2Dj3vXTAHgN6sARyUFQoyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715248; c=relaxed/simple;
	bh=6n+zceZvEnVJ4oCQ0BxYsS8f70HlvSvT/WSiwq5YpcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvxwlS1qbQ+fq+wgvo2itITcGmBewLw7DMlGwJrFw+5CUezhcfoIGp1hodBLMchIlACIjkA8WHonOj5A0qb1bjZHhQm9Kby+gBVoBPr4bV6LAG8Fb1NewPBjJN77D1dC1CPIk/UpSAUifEcSdfMbpxzRhvgxIX2HpMRchR5T+6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=px5Cci4x; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="px5Cci4x"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF5V253jzm0yV3;
	Thu,  3 Apr 2025 21:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715244; x=1746307245; bh=sP+J0
	U9L3QbR71mWmwPfu3RA2IM2SpZev3MD+Nx/8/Y=; b=px5Cci4xSXVTd8lo7CBac
	qyFy0gZU7Vgotsol/wJvIhlxkAo9FAfZS4VWzlh0o5BWTi6fHsLmG33lT+9iRx8+
	L8fYEtnWmFV8M22VuKNZr5DtmEDvb2mL40V43ozu/hw82AwOgY4TBtYyW7wdtUUI
	eQ9rHPLII6OzjDo6ICOig6d9d7F298BLCP85supP7lJYSM3hkOcIKJZvbbj3u922
	YnGW498F/2LZwe490De/sTAGVOO5fr2VmamRQgZPboTW8zgFjQ6dxPhx2Bpe97j6
	tDk15brKEcxuGI1ufNI0rgJnxRAozRNt2Cg3QC3+bRhFW5GjefG4KRJ/c2O0xMwe
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GcUAChhFc3Yx; Thu,  3 Apr 2025 21:20:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF5J6jxszm0ySc;
	Thu,  3 Apr 2025 21:20:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 07/24] scsi: ufs: core: Only call ufshcd_add_command_trace() for SCSI commands
Date: Thu,  3 Apr 2025 14:17:51 -0700
Message-ID: <20250403211937.2225615-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3b470f564313..94cf864ac62b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -438,9 +438,6 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
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
@@ -2309,9 +2306,10 @@ void ufshcd_send_command(struct ufs_hba *hba, unsi=
gned int task_tag,
 	lrbp->issue_time_stamp_local_clock =3D local_clock();
 	lrbp->compl_time_stamp =3D ktime_set(0, 0);
 	lrbp->compl_time_stamp_local_clock =3D 0;
-	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
-	if (lrbp->cmd)
+	if (lrbp->cmd) {
+		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
+	}
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
=20
