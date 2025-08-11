Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951E1311C16
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933942; cv=none; b=b81bjF0CpjYc7qgbrMopVB7X3LH1yktfPnIIartVr4LnL/hdiu3kYcRBchqBBRrjTBdfUceB9F7CVhCv6v9CtpqfTNMzwH1P/0Ir6j7QDN/vTZzK1Ag5/78PRpxUXge0EHvm4Jl9KhjM2o2CuNPBrKJPPvQtMfXa2adbb5cZKfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933942; c=relaxed/simple;
	bh=zgZp+HdVby2fFD7AwfuJSjVHlqSWkN6QmFsuCD+h6J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNVt40rbQG0vbe1LEr/kc4tsXI/S4zPDM6vJBWXOJIcpJMj1jDc5oxfIfGFpF2s+awEei+X3m6RJVaFyyfA/Dq4lqj7q8rlP6L77wHo6RlNuCUHq02DVYQVflVnul9LS10o7oWc52cN12aQhifNHtNVNnUGBJP6i0/nKanIQDsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fmqLhynu; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fmqLhynu"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c121b55wFzlgqVH;
	Mon, 11 Aug 2025 17:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933937; x=1757525938; bh=rcb9I
	49QqKbrRiHOS0NItsJskGwH6sIOkKZu3f4qfzg=; b=fmqLhynujbgG73vsSDzpN
	E019yhc4lGioaEwMYRaVxAwFMD8KaqL1vlMHoJDzQsbQZAgQbuqmj7ipJQZ/ui94
	EgUWekYPN0U+ZzLajejaKm/oOzHZ6Y3F/mRlGxn6UksC71SOh4XKAHkTf71syv+H
	FkOW9kFWDs5fNw4ts6JUZ91Zo8AU/JnjPPW4QiFFTrtjWK13TWfBdstn2bTMV6Se
	+Vq9mKGzyaQwkrs0B85ecWc7vyOrauXngwFI9GNpMn3p1hLiHRHSFZ1hTmPYMFC6
	97XowgYvhTnSZJIu4fHziyp0Mk3d1swbtzit99jpAYXSx1BgKh+q22GMHp+GcR10
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mW265ufqQuoF; Mon, 11 Aug 2025 17:38:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c121S1rSdzlgqV4;
	Mon, 11 Aug 2025 17:38:51 +0000 (UTC)
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
Subject: [PATCH v2 12/30] ufs: core: Only call ufshcd_should_inform_monitor() for SCSI commands
Date: Mon, 11 Aug 2025 10:34:24 -0700
Message-ID: <20250811173634.514041-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
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
index c188f17a50b2..46c322c66d9e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2285,12 +2285,13 @@ static inline int ufshcd_monitor_opcode2dir(u8 op=
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
@@ -2358,9 +2359,9 @@ static inline void ufshcd_send_command(struct ufs_h=
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
