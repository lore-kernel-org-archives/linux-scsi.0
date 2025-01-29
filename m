Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E413C38;
	Wed, 29 Jan 2025 14:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159321; cv=none; b=HB/12/FWGgJBMYO3hfel42/DGK02bUNmqDOqjRQZI5NxywldzmM9le0ONKWOwrTixfKiwd926y1xeRbvy0jOfweD4MoHSkRmpRH74l16Oq1PSQuoADwCakybsR1uIVr6eQmks/S9mI4MpsP0GbH7ZMK/m24HDuARjA4Bnfv1m/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159321; c=relaxed/simple;
	bh=xiS2isAX8Dvh19yNo0HQmgqyGeemjTObjYJ5baRaX9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i2UZyYijT9ihyMB506Xefpls0i4HEzotbDR/w+WSyAAEARU43REetaBLEZFMPgapJrBtJsV7B++lELV1G800f0/UILXlZJqW72epRtbSFZVTZf+9pTJbx0BICHhWXgrgvEDYujx3mE4bSf2KUcq8OHuilPvlEMoAWEKZJqkXRCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M0Neg6Rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0Neg6Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46ACC4CED1;
	Wed, 29 Jan 2025 14:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159320;
	bh=xiS2isAX8Dvh19yNo0HQmgqyGeemjTObjYJ5baRaX9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0Neg6RnNZb0GJt+fdwC+sUxxCv3nYBHY1dAmG9vqVTD6yPczddcZolwLNHjSbCOS
	 ZF5SS+QQUQclruJffkNRg9RJthU9jasVMhgOLWQdSs3hlKws8somFglKgNmLIYQF3o
	 UirSnA50Iu4rcpdPXHVJ28FzbfI7MCNqJs9cxoB1avdrS4Vwqxr+ch2a9l2pmslPsQ
	 wUVDwY8GcSLGhgWfYN7Do30R9oB0aNKNXGJ+L6NlIDyiMdmX7B4hEsKt7QqYaPmCXv
	 ZxHLEDa92OBVg/Qu09S8o0aVBKCPuSOyDWBpkV7poGSidWqSZ+Vc/Bh/41XJtG++lz
	 SSJ3Hovoo6qjw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	beanhuo@micron.com,
	quic_ziqichen@quicinc.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 2/4] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Date: Wed, 29 Jan 2025 07:58:11 -0500
Message-Id: <20250129125813.1272819-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250129125813.1272819-1-sashal@kernel.org>
References: <20250129125813.1272819-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.127
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
index b99e3f3dc4efd..682b44b723eae 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -181,6 +181,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
 		return;
 
 	bsg_remove_queue(hba->bsg_queue);
+	hba->bsg_queue = NULL;
 
 	device_del(bsg_dev);
 	put_device(bsg_dev);
-- 
2.39.5

