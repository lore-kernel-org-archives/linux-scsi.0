Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FE4801
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253420; cv=none; b=hCvezgnP8bUaIVqc4p7TZNIg6AZGu2gL444B5JuXGRm8FzB/sR7aA2DEd70kmEVeImtpc9XUdH1Vz1lhFgY2ystqB738ciAnTup/Ew1ZYfHaY2zVZWlaIXe9kU4rLeFP2Rjp103dw6bHB25DNAtBDhUR0P8i699c9xsIfB3qnAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253420; c=relaxed/simple;
	bh=i1cMkFE5mxfpqrBydYcqB8rU4ZdiTPC4PitV/mZUa+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeOsCqnEY9ZbabR2RlD2CUneP44Fz/Tii8lwSbDO0C9on0XnKblfigjM51/L/0jarsjMoHs1hCcF6TtXUnc254A0Fr0t9JlclKDbUEbOqVSVEBXctGIjMsiMUNomtMBVeKcFG/rnQhoCKjjN2B8auzsaVrUCMAgTCsQNeepjR5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tsU+INfl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tsU+INfl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBQ094D0Rzm1742;
	Wed, 27 Aug 2025 00:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253415; x=1758845416; bh=Inu5f
	9EkOrBr6/7AALlkgRllnI4ASHicRpHM16+iqAI=; b=tsU+INflgPgOVY7hqTkpU
	eIeILaqFSI5CLSaT6R8HoowTxwtyZJtXT0H7jt9i8UUoFvwGyB1cgPddkXmUMtdL
	ndUYnH0cDsRGsNEvj51QYiZmtTWAXDlSKYWb9dNzfZPShP7zNANVFlbAsL5RTaiV
	FBwZjh+xRx6fAWqa5H52s4nBVGqjwTTXvnuHFiraP0kFb+rTMmQa00Th1xuVDjTr
	Ko4rFzrY/ktbVQQyA2qbQ6+U/nHWQ6ZzFqYXDk8uHh5GRlbxsl1A/9AOGYnCtCvn
	miMRFq0IxCVCUsYmVkrcdBodZyNL/6y5XoOsPG2t4jGUu9kwXEJL+UhwCyKppToW
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kIZ59SrlfkH2; Wed, 27 Aug 2025 00:10:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBQ011Y0Hzm0ysy;
	Wed, 27 Aug 2025 00:10:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 12/26] ufs: core: Only call ufshcd_should_inform_monitor() for SCSI commands
Date: Tue, 26 Aug 2025 17:06:16 -0700
Message-ID: <20250827000816.2370150-13-bvanassche@acm.org>
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

ufshcd_should_inform_monitor() only returns 'true' for SCSI commands.
Instead of checking inside ufshcd_should_inform_monitor() whether its
second argument represents a SCSI command, only call this function for
SCSI commands. This patch prepares for removing the lrbp->cmd member.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 02fae897a6bc..586e707bd35e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2289,12 +2289,13 @@ static inline int ufshcd_monitor_opcode2dir(u8 op=
code)
 		return -EINVAL;
 }
=20
+/* Must only be called for SCSI commands. */
 static inline bool ufshcd_should_inform_monitor(struct ufs_hba *hba,
 						struct ufshcd_lrb *lrbp)
 {
 	const struct ufs_hba_monitor *m =3D &hba->monitor;
=20
-	return (m->enabled && lrbp && lrbp->cmd &&
+	return (m->enabled &&
 		(!m->chunk_size || m->chunk_size =3D=3D lrbp->cmd->sdb.length) &&
 		ktime_before(hba->monitor.enabled_ts, lrbp->issue_time_stamp));
 }
@@ -2364,9 +2365,9 @@ static inline void ufshcd_send_command(struct ufs_h=
ba *hba,
 	if (lrbp->cmd) {
 		ufshcd_add_command_trace(hba, lrbp->cmd, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
+		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
+			ufshcd_start_monitor(hba, lrbp);
 	}
-	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
-		ufshcd_start_monitor(hba, lrbp);
=20
 	if (hba->mcq_enabled) {
 		int utrd_size =3D sizeof(struct utp_transfer_req_desc);
