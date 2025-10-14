Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EE7306B0A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473175; cv=none; b=PFOsIqQKLhbzsnmXkFQp+N7YO0vCa0HxG4hvlmJOLxlTkHmpPjLqO9ZzOV6U3hnaS0LaV2eQvyYiIgFrAquLdobln0Y7F2dts+Jw53HRXtFvvIz3QyfMIiqCP/LMQeMJXM2dB2zBXDjeEyF4kG3I+m07mlXsDRbFq14nJVeaP6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473175; c=relaxed/simple;
	bh=vzbj+ZIS+a2sxfOYe8CLO49sQx/fCZl3yAQceX31BV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8wfDUYIUPfMwGTzvlfik1IMGXwdiE9L6wOAQYLh+7uprfEDyEIaJZEoRLsLClzmNSeL+aXUtKU+qztAYWmY26SbooyP1/kf2wnynXlFmsTuxfCd63cmwOePO1Jqu//Eoair5DnNnyoHChV1y59IIVZJBh35VyxPlKyb3xRCeEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iQ2h8NZy; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iQ2h8NZy"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQYJ6djgzm0yTq;
	Tue, 14 Oct 2025 20:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473170; x=1763065171; bh=QyKw5
	URcw0Q5gWgmMuig0/MYaD8F63n58BCC0a8M/QU=; b=iQ2h8NZyzJZyhFPLwFkI1
	FPCoxX+iOndazgDy3ufviXdxSOQkBhdD/oWl8V6ou48wD8OTohS6LHTXx5QyHQ7s
	ss7mb1/99apgH1ReORdP9o51zgm3gQvk6CjesE/WqmkqX/QfJiFyIjlSJ642/lTY
	bGRcW5V56q6dlr1WBrHuBUiEe0X4l+t6pwBR0cO513HycY9Q41Sc/lJzw1buCRWS
	I4WRT7zxiuK5hxGCH+MfHIAhyFMKKhMQpTgd04uftXNdsnW0VKdU1/4gDwmqfzgA
	vXlTAgOFkLnqmTra5zQdP36vS3xIKkDl7IiM84J84+SlBhPEOc2oaMPNoVq1pWoS
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GRNXcZIy6_cd; Tue, 14 Oct 2025 20:19:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQY92QyKzm0yVD;
	Tue, 14 Oct 2025 20:19:24 +0000 (UTC)
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
Subject: [PATCH v6 13/28] ufs: core: Only call ufshcd_should_inform_monitor() for SCSI commands
Date: Tue, 14 Oct 2025 13:15:55 -0700
Message-ID: <20251014201707.3396650-14-bvanassche@acm.org>
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
index 4229b03a6d57..aca87cc46290 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2292,12 +2292,13 @@ static inline int ufshcd_monitor_opcode2dir(u8 op=
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
@@ -2367,9 +2368,9 @@ static inline void ufshcd_send_command(struct ufs_h=
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
