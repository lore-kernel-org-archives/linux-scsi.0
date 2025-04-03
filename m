Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3405D2E62D2
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715279; cv=none; b=RmMS86Dro9zi9XwNHhBPHsObKh65yA1ASoGd11DPF1aqdoKG2LBmgo/V0ugIzl2qPHola862U+4aayVbHiOxnMTUaU/K92ZS/58cy8jSWZib8FkftUaIHLRpElyakqD4tndgZugYB9RgH3aO6XJQozY0IDLFMDzPynJ9enMRNp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715279; c=relaxed/simple;
	bh=vS9u4bCVRVICiXOlFPvw29S4uXbEEw4ErwOjAokFggU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeMj9NIh7uKrViHe++9b1XdjBGRjLLtAIf7R+qVYSLU3Q02Ym310GPL5EUyI14BQQCLUWcOzwnO+4MQi20lRUciEJCaWok/Btvf5MVFpGPH7Zja27y3hkw6GSmGfp1I9kk6pXOP5C755mcse/5eBMKvrlegCM52FxfqDXrJkMuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KMJ2tVKQ; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KMJ2tVKQ"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF650qGPzm0yQB;
	Thu,  3 Apr 2025 21:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715275; x=1746307276; bh=EKeT0
	DzIFw4mXbh52QnrRVTDHuXPM6V1Prk90et8Skc=; b=KMJ2tVKQvNMXYjnS4Rjmr
	F4prc1gi4qlieaBmhq3vx8VSQDBf0cEopUh3+seDzZSv/m6i905I+oZlp2WGuMsV
	fzkjkmYyDE5Oc8x0Djra+SMEYvdQidfL5htkSkDB4J6tKI+U0vBLH12BCCTQsFOw
	8QlMF50+cnNIzDkTMlrOlmoidHhktS8NCCxAYme8BmzHHwjCwFwY6xhPAp1kNE1d
	9TqCk4BoqHeE4+Dl4aYgRWogObfgx8tCdYckv5Izgp8y8YPlAMTXsb5ZXntQOZat
	7jlvtk17CP4EGkQ11sdkjGYOpRodT1bEn9EbYEdYWAqPBw+FcBg+8aiYvf5iE+zp
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QuVK7hB9vAp9; Thu,  3 Apr 2025 21:21:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF5y255Kzm1Hch;
	Thu,  3 Apr 2025 21:21:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 10/24] scsi: ufs: core: Only call ufshcd_should_inform_monitor() for SCSI commands
Date: Thu,  3 Apr 2025 14:17:54 -0700
Message-ID: <20250403211937.2225615-11-bvanassche@acm.org>
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

ufshcd_should_inform_monitor() only returns 'true' for SCSI commands.
Instead of checking inside ufshcd_should_inform_monitor() whether its
second argument represents a SCSI command, only call this function for
SCSI commands. This patch prepares for removing the lrbp->cmd member.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 883551274330..f61ba94a8204 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2235,12 +2235,13 @@ static inline int ufshcd_monitor_opcode2dir(u8 op=
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
@@ -2308,9 +2309,9 @@ static inline void ufshcd_send_command(struct ufs_h=
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
