Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA481991DF;
	Mon, 17 Jun 2024 13:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630453; cv=none; b=E0PwVDY54hpULdK+ch3LIeUwPphZ6nXNwrjfKcTEhojqWCZDPbWHXX2Z3q21TUvOYKQbP4y0luKbCBDx5i8axkeTOwphsb7aokALoF9B6gQS+YfBBZ6J82E6bYveRwkO+PZN/GF93+fEwreNxx8Y/H/sW+utxZAjm8y/B+a4H4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630453; c=relaxed/simple;
	bh=JS3Tk0dGhxxBkvLZHmEFeCnlSbasAMo3S+9Su7Ecuhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koj192YyBufLq+WIipr/soal8TQmV2GN8wsUj5hCIlM/m8w3GIvEZYZRa4GaG5i8ftUmR9CHA8isRYdswkA464lHrqfvXv4G95hFx0C/Jb/zwJS2vCCYpVpUtQA8Eb+6tVsGVdszbrsG4DQRRqB6C+MrV3/lbEmWbLR4O9zAb38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrCKBgUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrCKBgUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8B9C2BD10;
	Mon, 17 Jun 2024 13:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630453;
	bh=JS3Tk0dGhxxBkvLZHmEFeCnlSbasAMo3S+9Su7Ecuhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrCKBgUgCwXktBD2N+3P6KAi1Ykqz7W8Mqv/SeapKmOm6TiiU+6jkeARsIWVUu7fS
	 DYfrwM/tjUhrraF6nwaAK3PTWUxBCDQKvhtFf4gbyw+K4716F+72E3UraWTad2nbGa
	 eHQbvRKG+iFN5dDrBPiJ0qaFEY25XlOyBSEzLthq8MsS9VWAXLzM03e2KfHt7bgEb9
	 Vkf288M7vQrswzQs3RI0y7sE55MPFgE8xSjpsrkP3OrTyM6u45BPyFvoHULUUQ2xPP
	 WIOGyECFQGGMuoikF6jAnXt6WMl/qiw7lcE1+A6ddNUUSxJbEbT8gN1tARfo1uXWJ8
	 LzXXotdJ3YHdA==
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
Subject: [PATCH AUTOSEL 6.9 03/44] scsi: qedf: Don't process stag work during unload and recovery
Date: Mon, 17 Jun 2024 09:19:16 -0400
Message-ID: <20240617132046.2587008-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240617132046.2587008-1-sashal@kernel.org>
References: <20240617132046.2587008-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.9.5
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
index a58353b7b4e8b..e882aec867653 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3997,6 +3997,22 @@ void qedf_stag_change_work(struct work_struct *work)
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

