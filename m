Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B600C13C675;
	Tue, 18 Jun 2024 12:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714178; cv=none; b=XC4fZmpHB8IaS7UokyrVGusyb8MPbu5O55R/Bcw1kPc72bvokqztpO1jnIOFMXdZjMtyv/csONowhatHpKgqpuHUpZdWG4i4Zhl8UfHfeHrWpqsRmhU5tTFv1o6O7guIvZMO4oYnZlQxDXHgBYpb+ABbdcx2kPnf5cmjq5nVmn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714178; c=relaxed/simple;
	bh=JS3Tk0dGhxxBkvLZHmEFeCnlSbasAMo3S+9Su7Ecuhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyRztuj80gW0XneROjCNrAT0dP8b84JOAXHxs/SUigd89mGzxG/iMrACe86HUjwDmMtLaZjCMFiizFBAmhWX3ZISZ2NwxL3EmKsDrVMUGESSp5bi5dErVrtmLhWH3Uij/pLB5XT7vDC/QhYMO95UcdhGw+5a4ya23Fy8RKH0ymQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ixo4WEKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixo4WEKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1B4C3277B;
	Tue, 18 Jun 2024 12:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714178;
	bh=JS3Tk0dGhxxBkvLZHmEFeCnlSbasAMo3S+9Su7Ecuhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixo4WEKjYDt6ZccAh5BhefPe+EJ7nVYwi44F0kUUDOyIUA0iLex5lsd5jGcz25MnT
	 j6RKaVGgLFOhbXiywNwsgfjCM+dVFdbWjM43ro0Il2PYa4tPD2q7g5AzuuXWpmTCpK
	 IujpinzXwi9kcD9M7FL2gsqRyL0T0NjUMMAukpNq7n8VrcicUo44dOMZs96gZPCPiF
	 Wzg88hiqFfV5g5QZ4rF7E7fMtBV/4s81NLUZLJo8+MzbxJzYVDbx0H0JZKCZzWosIT
	 9i7A5Ixd/PiGP4wxoDr3evRhVgG6VETwGR4Eul1nsFyWic6Gic3WTorMe7p+zub3D+
	 Ue3diH+am8EjQ==
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
Date: Tue, 18 Jun 2024 08:34:44 -0400
Message-ID: <20240618123611.3301370-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618123611.3301370-1-sashal@kernel.org>
References: <20240618123611.3301370-1-sashal@kernel.org>
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

