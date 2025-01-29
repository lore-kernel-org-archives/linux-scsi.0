Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2CE17BB35;
	Wed, 29 Jan 2025 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159271; cv=none; b=gcly87DWU7T11V46BSbaM6xgFJRuRslRX2qQIBemYoQWK6cYDFVr7aWxxTzQYBdvE2IqxuF4SnG1b5BDEJd+TRMPHX0ujmXLSYbyjFmbE6JR3Y+0r1nYtzsA5qSM6ZYsTCxWuk8ApYpqoPJgr0WBbxQBvJ07cczoqykFyE79IAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159271; c=relaxed/simple;
	bh=tRksBt5RCuWbhAODeY1UkyyqmKlAhy6z3fFvKGEG8Fk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pd7FIJogonZzFa8G53w3NTPNhsuu0PT6gwr7YAPCTTBcUbpo2tQjFYcKyYadW+oR0Sz/fR/fWFDKwGIZaRFSLUks1p6qixfbXGyJcMULDppqrq6EtZCDWSOJ/9MyRJHJDODdpq00aJ61d/PI3Spz1P//VIkb6tyBos0xG9SeNkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pu4pzm+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pu4pzm+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1FAC4CED3;
	Wed, 29 Jan 2025 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159271;
	bh=tRksBt5RCuWbhAODeY1UkyyqmKlAhy6z3fFvKGEG8Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pu4pzm+IoH2G43LXcB/3AGo/sYu+5gX7l5IVzPrt0mB0XZbZnHF5AH4n1fZmBLUXX
	 6sQK8dhsRIUJknHc3d0nQmNFwA0z2KSuexmPEeRya5OaqHfuNAy0UpPm/CpRj68qdy
	 nc9gcYHDWnSbD2BSnQ9CTd6ifKOeW8wi/9gwWfQnydR57ZSfaFZs+BGN9vugSOWAsw
	 A4BnUfMv+3CAODPJieGbHdKRBI2idxRYSkK5AdbFfp2/oL7a4GoIA7ryQrapr98PJv
	 LvPtEJrYyCVGs9PFo01TPWIQW1CSk4z+xsbAnuKsE1M2P+ir7gq1LKCMjraE0x6ck5
	 96pcuGMGYRepw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	beanhuo@micron.com,
	dlemoal@kernel.org,
	quic_ziqichen@quicinc.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.13 2/4] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Date: Wed, 29 Jan 2025 07:57:21 -0500
Message-Id: <20250129125724.1272534-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250129125724.1272534-1-sashal@kernel.org>
References: <20250129125724.1272534-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13
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
index 6c09d97ae0065..08579c454a325 100644
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

