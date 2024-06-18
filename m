Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB5019E839;
	Tue, 18 Jun 2024 12:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714425; cv=none; b=exdgop6w0te+vgtJ5t+khXOqnfiyaxzvNI1hA3hVNoEZQru3LCZgKBn4Nn8GXwbCmDggJcCNkAJMZf8zx4Nx+zjlnOzb53sxGCi822VLqNIicl1Qma22ZLUyU/dzMt01Knr1qc7uSCbaXxIMRUhKYEKIpZL20ojj2cmurS3vqik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714425; c=relaxed/simple;
	bh=fV7RJv41JYFv1mqiIVbqc1Q37tlxIkIelFZiReJ/YD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzhAeay84A3jNW1I5dmXCM3C85gAQ4WiEECox4ujdukZR5lLtC0uERPjqvwylAgQCE0FEYbAE1S/fXhO2xOAW8Rwx+mgu/wxBH+55uPEVNUFD7Y+MPW2IumTwPY1rN159YlNoU9HvQALHV0nrOesJlqjr7J8OrW8YawYQ2vy0Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QY33XBeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QY33XBeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5699DC3277B;
	Tue, 18 Jun 2024 12:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714424;
	bh=fV7RJv41JYFv1mqiIVbqc1Q37tlxIkIelFZiReJ/YD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QY33XBegonXjP8qpXMAYZRUlcvgKdqbIhxBKOMfeQ3d1bCK/LMypvhfz1jtvlcev2
	 IL1wbmhFWHDZ5iQnUitAjN8w7FlWQEoR+NQnSvjB0EI4kN9YHBlP0U3VrnODfegu6q
	 7MNPUeb2ix5MAdhVeLUxVS0cewUELN5RCWW9L2I3qn+mnzdQtnuWLzpdDLAzeJakyw
	 y7f4n3Lv0GBvzsvZQOeNI2VR4yEx8Hl6TwzEuXSkXsF6OCX+kHk4FG1RQKf+tHmNBV
	 vi0Mj5nLXOVvBlgKNmeGfOifVTQRful2I1bD41YttfBqP32p4kyXMS8ZfxXr0/Ajdb
	 tZxgZNj9mPV7Q==
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
Date: Tue, 18 Jun 2024 08:39:29 -0400
Message-ID: <20240618124018.3303162-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618124018.3303162-1-sashal@kernel.org>
References: <20240618124018.3303162-1-sashal@kernel.org>
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

