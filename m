Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369219925B;
	Mon, 17 Jun 2024 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630781; cv=none; b=IPswAh1spHYV5E9Myf9CPpXsPV6SfLde6adFm9CbtdfQKyGGFwuZNNCesUU8fj7y+6BfgRSOVpKs7cGSMBl23z79qMssh+6rw8R8QipJCMNR2g5axqM9RZSywGVG+DT9mUZqtJqXjPYpNPqa94Z0rh63D58K8YJymoFvcHTPtgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630781; c=relaxed/simple;
	bh=+2uQ5tHZtMTt2bmW/5BElXi1TPUpOsm5QPSwJ4r75p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nz4YDHee16Fh8DRahbRGBd8ch/M0fhWdFLS2H7W6+zinvMulZzlYbaTatVqgjExU8SiYIFGagT+zu37kOWT0SflT75mzxCg5qTtJSsAM2GEB3kLFpevJ3tyw692IgE8MhrZA4hsy12Voqv3WwFMmQuP3odBafZGAU6g660nJzeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ni57Wwup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ni57Wwup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451FFC2BD10;
	Mon, 17 Jun 2024 13:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630781;
	bh=+2uQ5tHZtMTt2bmW/5BElXi1TPUpOsm5QPSwJ4r75p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ni57Wwup3GShzpm+/U0lEJagVkIXhs404z1y570eVG/C7hbZsmySqjJXwCKoR0sg5
	 1/krCPQGEW1CySDuCRb5ewGDuRpbdOewHKmOtwY4BsinPimcFxdVOwTGSfXiXqfizq
	 fBlnTe//LkSKWi9Ny0xLlk4kd7qomVLIUmZVR1JOs/NN0DtZ2SkpSQnpcxJznMOw4Q
	 YB6wk3S6FuPslpB6ZybesRqLjCnyCUK9MbDHgkiVp2Prl2HW7av0Ss0Gw3u3OBlma4
	 w3iZuDasBwKjW1HBZwQZurq4F2mkqi7hcuIeEjF37AZ7JhvqkaPxuONGAlYR65Vyvb
	 IPBJItaGf/mkQ==
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
Subject: [PATCH AUTOSEL 5.15 02/21] scsi: qedf: Don't process stag work during unload and recovery
Date: Mon, 17 Jun 2024 09:25:39 -0400
Message-ID: <20240617132617.2589631-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240617132617.2589631-1-sashal@kernel.org>
References: <20240617132617.2589631-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.161
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
index 18380a932ab61..ab43e15fa8f36 100644
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

