Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4208C1917F9;
	Wed, 29 Jan 2025 14:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159304; cv=none; b=YeYlt7ID2FKeqSpOGfpzWlXrw9C8VDKMu+s8ADq4oZkP+GDzFVT14ErT4z84fh1G9GCTM/QtRJzZnKsZ4VqJeFJeow7C2DRv/i3YTv/5ZI51+QNRSz6HJ141VtBRP4VyZIvTjLxmYMtDS49G86fNqDgJ0jBd68wdHt2r0kpz+dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159304; c=relaxed/simple;
	bh=zW6P+qwvbWYZRyNGm/7f3BCVpnBGFUMZv7LZNMuJTis=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S+TfqFzLWkqZONWky450GwFBG/kH90HKruLRx+F4njuUSWBQT3KtEhyKJQ45EWgw5lHtdzNl0BihKhfiH/rcKkhf6cpvVy6CZ6Ya2N8UnWOl1OKLqDFNZKPmhnYFy2J2aEE7wTZBRfVZtfbDFhZzBpBsKGh3QUEaI8tWH9zUmxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8GUpTyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8GUpTyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5998BC4CED1;
	Wed, 29 Jan 2025 14:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159303;
	bh=zW6P+qwvbWYZRyNGm/7f3BCVpnBGFUMZv7LZNMuJTis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8GUpTyb/D94vBLbDPhXXQZApkpPFv7/7A1zIW4yv5pCcwK0IljgRtPuytJmUGjZt
	 qhYzcEVSV2q7MeVLLzecu0TXai03ssIF1RZu1fQFNLs8Mwbq2ik2xHluT2OnUxZsZB
	 Atx3idMC6kKCJmIqeoqUbF9hVIWFY3DRwzzmx1bgr6TQ3z2e8I8Er5iy3P8TmZAwnw
	 anRBTDMU8rxgaILgKcLHxnnPJsumumPUxRqh/Gg96z/yowXBTkRagJEdc0rGSl4DsQ
	 7lEdsusnUBgEN46id7GSG+/mb0wXc7ZCGvD4r8CZxXuN2PWZ7W26NHxh6GQVPhF1V2
	 OoAdKEAX+6Fyg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	beanhuo@micron.com,
	bvanassche@acm.org,
	quic_ziqichen@quicinc.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 2/4] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Date: Wed, 29 Jan 2025 07:57:55 -0500
Message-Id: <20250129125757.1272713-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250129125757.1272713-1-sashal@kernel.org>
References: <20250129125757.1272713-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.74
Content-Transfer-Encoding: 8bit

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 1e95c798d8a7f70965f0f88d4657b682ff0ec75f ]

Currently, this does not cause any issues, but I believe it is necessary to
set bsg_queue to NULL after removing it to prevent potential use-after-free
(UAF) access.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-3-kanie@linux.alibaba.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index fec5993c66c39..a6561e73c2fb2 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -216,6 +216,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
 		return;
 
 	bsg_remove_queue(hba->bsg_queue);
+	hba->bsg_queue = NULL;
 
 	device_del(bsg_dev);
 	put_device(bsg_dev);
-- 
2.39.5

