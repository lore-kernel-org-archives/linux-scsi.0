Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CB51779B8;
	Wed, 29 Jan 2025 14:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159288; cv=none; b=GGA3HTOivirjJ+ABOhTWPTaRQA1ZepimQe4IZxj8f1/V3Ocubedc3qyhm/LOh+K5EjJxO9eRGWT9fqO27gFJ3ka+8jMSsk78i6sGO+POACS8TGVKPrytrdmtyTxVD9X/QkoE3NK28tsi9R8J3QBn2iDmx9YPlOviEA7idLIlwAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159288; c=relaxed/simple;
	bh=tRksBt5RCuWbhAODeY1UkyyqmKlAhy6z3fFvKGEG8Fk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JiTZybyebK3uHNPwDVo2dOVWPRe0+q6kfQWH9aNcIKmqPkidjVhTUOvj1EFZ7p0kLCBSuplFzolOmSysTdzabvRPUSv4CxQKq3kRcJLlKL9UYq+tI9ZbHf2A8fVb+31T0QmgjRoF7vlP9UqhgG251/dTZQKpsjN0BN9L0RK6djk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rl0wdOQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rl0wdOQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C64FC4CED1;
	Wed, 29 Jan 2025 14:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159287;
	bh=tRksBt5RCuWbhAODeY1UkyyqmKlAhy6z3fFvKGEG8Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rl0wdOQBzrOkqqCuH7vaGuz8GgYy2omnClmGxc/NPiYwvRpWKOS5tMmYCQNHVkf1+
	 Vdddpn1RFcNKqiQwrjQ4cX6ipqWPlxd5jxQSG6npL7ns/Llf1z2egg8WuhL4XLhgE6
	 zTiVVtcXUb549rkygTa4F7Aq4E6wpQVBEOxzhkg3Ih2Dm1sF9miq0OfqLYAR66KUu8
	 dkdc2TYHacZDu3VQQ08e9fnsmy7N1ICFNPZdTZfTXdYatbwpkkUNNEOBAYcKyjcZ/S
	 DQ+9k5Zt1FagbgdnauNkh/UA1FI35VErSCm1HCxrxlDKRIvY7lifx9vuMZK6ntQhmV
	 2fVSXJ03evqLg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	quic_cang@quicinc.com,
	hare@suse.de,
	quic_ziqichen@quicinc.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 2/4] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Date: Wed, 29 Jan 2025 07:57:39 -0500
Message-Id: <20250129125741.1272609-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250129125741.1272609-1-sashal@kernel.org>
References: <20250129125741.1272609-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.11
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

