Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478392FCC09
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 15:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755273589; cv=none; b=YodMRBCroVConzt4hU+CE4Kc7cOL+jM+q8G+lr8OkDtDmXqNVZJl/4mtQwZV8HZjtG2OpJ97zdAQojsk2oHwPanV3ZKo3smtOCUpfET+2SwVpX25uxgEWcxiAfVxNag3J8JMZHyMg+cXSWjiSBbO1jiVBUM4sTy+U6AK4BshB0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755273589; c=relaxed/simple;
	bh=GGj68Ye2IjXsbvh7nUvFqIYNbv632xCfgU0jIQlxnyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQt2BEMLbX/x81itTZOmJY8IaJ/f4Vp+iLxgu/g7kS+voB9q16bRaSmRuDq7u28HanJqaznUgt5beBx1E91tZCVzZi7sf8d4UQEMd0CDbhM0cNXBLFvMuBFlGCga82t9DNJTdBCU2Y7N9b0gOl1AdWltHvOo/tk0GySLIfm0dUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v7VF4CsS; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v7VF4CsS"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c3RdH2MvPzlgrtT;
	Fri, 15 Aug 2025 15:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1755273585; x=1757865586; bh=JKKR2
	aQ52tA41pN5w8YX1g63Rzn2nDEp3Ud3Use+v4E=; b=v7VF4CsS/ue/UEvViqusm
	fFhQ+9W9qROZfbH/qXj4z+OLRyTSTWOnAyhKe7LLanfm2v3ht5prCe3yMSeJH9ID
	jsrVF9yn9eXZwPmnR3C/uvJuHbyPOLAZKHKGUIdt0hYWC5rn7dcymFZWzpLjIbES
	XF+6mrFwC4TIv2mCdTrTZReJkmgvAarmU48n9dt7V0+t6gzU18aEUsiKE72eZo8p
	T/3v7vhVpKFruAkmjA3E0NzVTp6p4qq+E0QjICTQBG+4MFQ4+3GLRIuJsaWeS51b
	iToXHb9CxNtqPniOfPoedFh+tGA436WyiIY2rgTnx9UvpCPoQoKM4f2kNUG0TaZL
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yTLAhWVTmt_2; Fri, 15 Aug 2025 15:59:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c3Rd60KPszlgqW2;
	Fri, 15 Aug 2025 15:59:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v3 4/4] ufs: core: Rename ufshcd_wait_for_doorbell_clr()
Date: Fri, 15 Aug 2025 08:58:26 -0700
Message-ID: <20250815155842.472867-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
In-Reply-To: <20250815155842.472867-1-bvanassche@acm.org>
References: <20250815155842.472867-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The name ufshcd_wait_for_doorbell_clr() refers to legacy mode. Commit
8d077ede48c1 ("scsi: ufs: Optimize the command queueing code") added
support for MCQ mode in this function. Since then the name of this
function is misleading. Hence change the name of this function into
something that is appropriate for both legacy and MCQ mode.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e6c2daba2772..405380aaa408 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1303,7 +1303,7 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
  *
  * Return: 0 upon success; -EBUSY upon timeout.
  */
-static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
+static int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba,
 					u64 wait_timeout_us)
 {
 	int ret =3D 0;
@@ -1431,7 +1431,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_=
hba *hba, u64 timeout_us)
 	down_write(&hba->clk_scaling_lock);
=20
 	if (!hba->clk_scaling.is_allowed ||
-	    ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
+	    ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
 		ret =3D -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
