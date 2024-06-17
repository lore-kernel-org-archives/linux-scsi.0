Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA2D1B47A6;
	Mon, 17 Jun 2024 13:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630861; cv=none; b=gqH5pN+H/QiZgdFy2WW6gXLkzxuZpx3D2sLR4SyjTGq5Mjp2CQlFWyR2l/baqLGmwQmCmu8lGWir5WosRVEVCApnh2Px6EBNPs+yeO6xcUKkEIzO4KZOG4eZmZDdywlVv3csg5pBr2eQcivSx3AV5SyVxDqXj/gX6084IVkDbiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630861; c=relaxed/simple;
	bh=KPgDhhvy/qWYoIhkC4CmnQ47Y6o7/P+1R/JjJF63TEg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H0MIBIH0OoHXnUB14inPMu1r16DZQFdPdHTFW58B+9l5iKNj9GGS0eadirzcWZdy/Rhw4UluVrBSCwYzOcPYQYBhcYdrswpwuJ3s0Qdvp97qB6NzhiY5wmCHRfENfSLlHuSpWiV4AMQ9HCD8SDTdqzHanOMpKVzYu0p0vBgtyY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKVrsoHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKVrsoHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B0AC2BD10;
	Mon, 17 Jun 2024 13:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630861;
	bh=KPgDhhvy/qWYoIhkC4CmnQ47Y6o7/P+1R/JjJF63TEg=;
	h=From:To:Cc:Subject:Date:From;
	b=mKVrsoHI8WSE9y1DqBSj0os0jd9YcWCN0V+UIVq3oPaVCf0B7si3loBwfg3KQPvey
	 +AFZ9sA7oc7cl1SXFLXI5j+K06sfEXAgwBDhToB/jvSEQvgri4yZvgZnLGczUmqP4T
	 mclZ03e+SrXlK+Qq8eEcLpceKfIdE6tKw3LE6JOCrh2eXb498CB49miO2wHbidmUQg
	 WfbCpNNZ469tTs/4pW8+BjT9J0wa17bfAhLVt083H4YD8fWLa9VJNYSUvXWUa2tylZ
	 h4ttz38QZiZVxDQD2ZOpNoKbrZ/OqtYrGCByJoHnsrHlR71YEl/8niUejrsPTLrVE2
	 Y+aFz4Cz8RTtg==
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
Subject: [PATCH AUTOSEL 5.4 1/9] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Mon, 17 Jun 2024 09:27:28 -0400
Message-ID: <20240617132739.2590390-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.278
Content-Transfer-Encoding: 8bit

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 6c3bb589debd763dc4b94803ddf3c13b4fcca776 ]

Zero qed_slowpath_params before use.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240515091101.18754-4-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 858058f228191..e0601b5520b78 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3299,6 +3299,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0

