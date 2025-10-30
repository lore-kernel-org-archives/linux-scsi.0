Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B971E2FD661
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853130; cv=none; b=nfk1kZ7vayBmYG1xVpZbte3NzaMmVc8JpOsoCSCAoQld0oSNRf+a2SLXsVCnulzEoVYOvh0hXj2+qYbUdz7e/Midn8l+DLmVtTOROrX1alVnVSKmgUq5nWKS1GfHFKDXNAsV0pEI+IPjcDBWIyWUT2Bc4YHTH91QXeSe6WCv9J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853130; c=relaxed/simple;
	bh=aPOLFa3x6ifB8IB65UcdtnV3QELECQpt8BdtmKnOl+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgiobU+JptysYlgqi20gyc+6sjHQHtym/wRfDBN1GoJaD6UK8K7aJUQOVkB9/kk/hh0Cjnun19LppnN1i8/pPOeKBIZ7Hy+dfcDtioPYN5x2+Dro2lZ6L4FLHKG/m/B+FThPOcTTBFKvMEUlGQvdKg84sKsbhAyw5/Y5IYtVJiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ke3uG+Vf; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ke3uG+Vf"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDtw0cvdzlpTG1;
	Thu, 30 Oct 2025 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853125; x=1764445126; bh=yROKf
	s2vdhzVnMeW7OjywStQI2KL1OLtcDajZo+cSiY=; b=ke3uG+Vf1rDWi6vSUo08b
	qnLOwuXJQzwNnYoEAQIX7gfeaILH/c8EUI0PQx9UvPzVmjajTcWFTkUi50K2jtP7
	2z7fd4mIFi/fRNo0t+1/tZ9ysiYxaO/QWMJUfHrfmWvjzHMKTTARmzE/WE6Toboc
	ho26ZzTSFK3bHsGR/SHj2nqDvn3Gpztp3RZLJXtGkTnXRBQrc4HKSE/vX1ZAxNaH
	TwjGaL/uvsElPoOnCzwvdQZyF12a5zsB9klxBcm+bWuaUvDN1L+4k9cq3QjVFRSU
	BRG0q7jkwgM0cNRXn2oz/t78dGveKRgOU3Z0is9kKFwgE9kYO/4FvYdvzbCi3BpW
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kBCyv6D9soYa; Thu, 30 Oct 2025 19:38:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDtk1ZhjzlvfGf;
	Thu, 30 Oct 2025 19:38:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v7 10/28] ufs: core: Only call ufshcd_add_command_trace() for SCSI commands
Date: Thu, 30 Oct 2025 12:36:09 -0700
Message-ID: <20251030193720.871635-11-bvanassche@acm.org>
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
index cdb8147fceb9..87892a13ef57 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -486,9 +486,6 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
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
@@ -2369,9 +2366,10 @@ void ufshcd_send_command(struct ufs_hba *hba, unsi=
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
