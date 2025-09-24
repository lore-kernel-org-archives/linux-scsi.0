Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E461329F0F
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746002; cv=none; b=ib4/u7bgKxfdWAhpDZH2Nnn6yIb20HwxA9eqCxqqtEaqzBMITn3W/rs6zj9jyGrLEV/4h6smk+6212VNvdVKeGEnFzWEeaWN0k4nkqwFLnmxgAurM4STxKV1i2iGuXbz/g4Xn34e66ri21utmCBm404cMKdKxlc9oyVH7nDukg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746002; c=relaxed/simple;
	bh=luYcrdhShSsccAQrFYFtYZICbGkSxQiGnxXbZHAD+eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLRxld1HZl4CmhVKMn73IObHtgzpG41SrurgFsiUEWm5NmjaBw9LU6M5Whu+Ht5aOZW91qEUe+DTO3D9M3TPNCiJY/b0g1Hbj8yDVGnkCkC0ZNrn9upF6BdM7hsiUn8wFIe6NXlE9pKBeYm67Ic0AkmuF05yKAS8ZVy4weZ0HKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DbB3LUKl; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DbB3LUKl"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7pR5Z2czlfnCg;
	Wed, 24 Sep 2025 20:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758745997; x=1761337998; bh=mhRk1
	qMtIGZc45Pm9TVD5WC+c0CpaezViljaPzuAFNY=; b=DbB3LUKln49cN4/8nPPZs
	er7hvwm0dHPiSjkyjH+cd+2d3qy92+q0egw1gI/A2HKx6CkE1cPaTmpRkqmOLxXZ
	KoDGTa2HyeW52HBT4O0FtDVkdJblXy17EMbGp8FFiN6iGhBM0f6nopH7Jhm5R4BZ
	aVi3kopl341fppBCl5+55TLT/uN0eTFdfwM/IkIBlRW64OWjP2lWKsMLpeL7hfrh
	ng+dC4blEZFp73dlxtH9uuIpf+HGC6qphV02FYruxfYVq9clH9u/bgdpw1I3+rp9
	3CtQ8VxsrcUaCoByRTn2aibmFAQrVBnK3Z/hZiXhOfPcnXTLahcODytZVOBAmwf2
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s9crvzoqJMyk; Wed, 24 Sep 2025 20:33:17 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7pJ2tzxzlgqyg;
	Wed, 24 Sep 2025 20:33:11 +0000 (UTC)
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
Subject: [PATCH v5 13/28] ufs: core: Only call ufshcd_should_inform_monitor() for SCSI commands
Date: Wed, 24 Sep 2025 13:30:32 -0700
Message-ID: <20250924203142.4073403-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
References: <20250924203142.4073403-1-bvanassche@acm.org>
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
index abc843fdbbc4..be8fd3b15d5f 100644
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
