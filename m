Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62F021C18A;
	Mon, 17 Jun 2024 13:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630702; cv=none; b=QKY42rqEPcEdOdHCBxH6BQbgYVIYRBnVC6rJtBz4PTizJ2CaxevQmrPSbk8kbb0pfYdVVvoOfnodUBbRaviePwdnVIuZe3Qyy40ofiHGq+1Nsqlin0B6Tf1iOB/76sruAVbZyy3JDKqOXraxTq+JFiOtsMftpu7xXKwYAfpBAcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630702; c=relaxed/simple;
	bh=fV7RJv41JYFv1mqiIVbqc1Q37tlxIkIelFZiReJ/YD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXL0WEe4URzNdLRdnPcRhzBQ8tzggTAK/79BOX19mK+4m7a82kkfFrYHCSy+oMmxkzFhqc4NgYzeQlbSvNmM18jhV+iDnECbDNwuP9y1s+EULa0J8sGwiryaaPZQ6akW4kwfuD1/OVytuMUIWxSxPjHNwsZ8H5m3akrzeSnZkF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOm8tkw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOm8tkw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DF0C2BD10;
	Mon, 17 Jun 2024 13:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630702;
	bh=fV7RJv41JYFv1mqiIVbqc1Q37tlxIkIelFZiReJ/YD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOm8tkw4p9FtSfQHoU778/3CQZSRu6VeBewDi2RbPRsC52Gn/dcHeL/i+HIg8Rs6U
	 mgLTKTc3u8ht/tJle3t2etAXsbsREBBNs17Xrsx7gL64I9S1GCYoP1dtRjwWRhqKdD
	 g2Z6eLkOuTD+/daRieO7kpeLiyuC58eDFc39C7rAa32aRQWohJBesHHSCZy/1S1ViT
	 NHQBSicTO2+K9/hnBR5nOyczGfLX6QJNXC9Y2mI88Nye9ApTz7l00HZP5L48LkxwG0
	 Vzm6F6f17B8A0ODdJVxyO8/Md2eU9QUHAU53iZlsyS2zU4qduuh3oUWxRvPz2VFrMx
	 x4e7PK/snBBww==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jhasan@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 03/29] scsi: qedf: Don't process stag work during unload and recovery
Date: Mon, 17 Jun 2024 09:24:07 -0400
Message-ID: <20240617132456.2588952-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240617132456.2588952-1-sashal@kernel.org>
References: <20240617132456.2588952-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.94
Content-Transfer-Encoding: 8bit

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 51071f0831ea975fc045526dd7e17efe669dc6e1 ]

Stag work can cause issues during unload and recovery, hence don't process
it.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240515091101.18754-2-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index d969b0dc97326..27f4028bff3bf 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -4001,6 +4001,22 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
+	if (!qedf) {
+		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		return;
+	}
+
+	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Already is in recovery, hence not calling software context reset.\n");
+		return;
+	}
+
+	if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Driver unloading\n");
+		return;
+	}
+
 	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
 			dev_name(&qedf->pdev->dev), __func__, __LINE__,
 			qedf->dbg_ctx.host_no);
-- 
2.43.0

