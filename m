Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4CB32573D
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943313; cv=none; b=Pj6t///ZWGpNnMwAvAbQzcr+ny5IYZ3v5yEbA+tYetVGVFCbDUpuFg615Pr8p/WiJt3icvPd1axr9EZKA+5hwXhSwv7LWoqAwuUYvav5qY9oKUAydECiv5q6kdtURJ2NXrJoCrefLD7dKoSw7rrmbzGmA0USaqVxcoDAB2rFVIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943313; c=relaxed/simple;
	bh=aPOLFa3x6ifB8IB65UcdtnV3QELECQpt8BdtmKnOl+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/HQVfZXHlrAs7dI5EX3rfGlZnDOyHWLIk9GI+/ob28+sbq5TcKLti1nbDcjEQKoIpSOPDL1Ck7N0ZVXdU0BK4wjqz2fuGG7SSi+zv1MtF5tdfdyZdQFY1Lva15Rt86Ub9cwCvU2sI1jLEkDXiEOwGk9pTI6g4Vxmfmpo9E87/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BdmP0sns; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BdmP0sns"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytFC1ycHzm0pKl;
	Fri, 31 Oct 2025 20:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943309; x=1764535310; bh=yROKf
	s2vdhzVnMeW7OjywStQI2KL1OLtcDajZo+cSiY=; b=BdmP0snsLjXwc3cGhhB25
	dQqAsezlqH2G4VoYUdrw0KrRp66Muz663oWeBSatgfuFH8mXXzPi4fzzPNUc07jB
	ZISGT6JtEj6++SbXwENetNj2Q7bXbRfV4zy4xhjrgR1Li7Vfj2PFU4vuHhjjTiTd
	HyDjXThBjANZriIw0AkzFWwsRytscCdXezbqZe9LHhJ+zK4WvI2YXZW7UYT/ihj5
	nnh5zZfbZoZrj5+KShD10jThA7EuVLflq+MOcYgqa9IhwgbtJnZG5cjPuggnQFo2
	RAJLE3KhP//6CDUklt5YdZd03Uj7YjkkSdlLXzsGwF4YL2um18Nkai9QcypV704T
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dj7nZN1G6bYO; Fri, 31 Oct 2025 20:41:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytF158Xnzm0pJx;
	Fri, 31 Oct 2025 20:41:40 +0000 (UTC)
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
Subject: [PATCH v8 10/28] ufs: core: Only call ufshcd_add_command_trace() for SCSI commands
Date: Fri, 31 Oct 2025 13:39:18 -0700
Message-ID: <20251031204029.2883185-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
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
