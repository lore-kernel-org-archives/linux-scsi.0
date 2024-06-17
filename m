Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3356E1BA89B;
	Mon, 17 Jun 2024 13:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630596; cv=none; b=JruhC5dUy+U6adyAg3y0uzUzlXh7o5CDJ1mhnBhcIavql6T6lPvIPhC622YNbObj6aF+rRRYTFO7xwIK9amOIH5mCyXP+6qSOAeDNZmRjopKl6l0vQQmNmpZOLtp9XRbd4/8J5jhGEdvxVgcurN8Yyy2yUBXIDl7wwm8el4OmFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630596; c=relaxed/simple;
	bh=CNfLHAR7cvnRetSECMAsuXP2xiqrS/PUdaTJ/tSsJqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4EGHmFcRCEoPdt6oxX3yA4qZnOvPDYNMaJa8SAzYaI/xjM38Ytz6nQaNx63wZpXjqGS7EwMM8l3Kkx/HFS5z7swRzYJmrjH3U2wozXOkGvhC9jkGkmHCI8/lz+NKGzYSiSWRX7SGbW3fBH4RNtrWlG2djT8NntXJM5Wc5SUpVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n2Jgublx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n2Jgublx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E87C2BD10;
	Mon, 17 Jun 2024 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630595;
	bh=CNfLHAR7cvnRetSECMAsuXP2xiqrS/PUdaTJ/tSsJqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2JgublxuvMJlfT3AmrELoX8R8G/GtDNq8NITXSNA0IMTR8njmHXGznIUwoIFqm5P
	 ove7/FZMYSK06+jnf0rZAx6vYyI26eYEYHC+EHMY1Z+TDvXM1+/U6K7Cdy7rENLiu/
	 4TCO0xJItFVxC1CaSUBOmFDwPhy+K0V6TRbSs+9DS0Gbcq5VwweKW5L472HQei7V17
	 tyPFss0Ld7zzD/VSOyWjhoHEZM8oqxryT54/nG95gE+KDDtZtrfsyU4Kt8M19WK+R/
	 jq5l0fauwK5pHHUpXV8xU394eSL+u2aieMAAtwlZqgbnLEo0JIcIZIOhRYC8tfxz4m
	 xGjoCy0zf01hQ==
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
Subject: [PATCH AUTOSEL 6.6 03/35] scsi: qedf: Don't process stag work during unload and recovery
Date: Mon, 17 Jun 2024 09:22:01 -0400
Message-ID: <20240617132309.2588101-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240617132309.2588101-1-sashal@kernel.org>
References: <20240617132309.2588101-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.34
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
index 91f3f1d7098eb..c27e27cff0790 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3996,6 +3996,22 @@ void qedf_stag_change_work(struct work_struct *work)
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

