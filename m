Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CD81F7910;
	Tue, 11 Feb 2025 01:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237509; cv=none; b=r4V8kLo4nS1cHBzdLLdYt0wOMTCouJjro9m3gc0c0dGDZtwrMkxoNd5eNK7u3cdMltXC8u0/E7S8J/nhc/JKbCLEhOKmr+MQlLQ4H/zZpUg31qOvotvwbXYOSBA/rbGaYCI0QD5rWTdMnDKH2E96b5un4dFoPa93nC4HYUcGPpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237509; c=relaxed/simple;
	bh=XmFhPgocvk5M8n3X6b6Z/pyIVE09pHfdrlXGz9mvK7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hzBcq/AHgKYu2gmW2Gu8x8W8S8LfW06D1Z0O92hm4jZYwf1OykkhkQEa+VdDCQcBmJpzxmDZLvi59IV4BH/MriH5uUO+yPDC7KLAaRgj4dCoklqO9fAdET0QpB6EEbwZU5iiR7kYvPLltvJRIzTE/jhLT04C/O02MZD2Fcb80yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aX/g1c7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aX/g1c7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B93BC4CEE5;
	Tue, 11 Feb 2025 01:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237508;
	bh=XmFhPgocvk5M8n3X6b6Z/pyIVE09pHfdrlXGz9mvK7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aX/g1c7ssEXIz3QaDAlWCksh8vGqZjDD5PvePX4eiYA0oDN/A3YH3bpS9UKNNioYb
	 au5XxrLkGKAEDo8HQrRdEeRnwRg76K7C0kgEJwAorbeU3s3GIzkUzjbNNO5T5vYw4H
	 AAbfdzHVYDm3adKmxGJ1bX79dAeF49X3jdoHhtgXtbA+6IT3T6OSTmQQaMvPvE526C
	 Ybjr1CAravNExYrZxQAPjuH/KbId8dGsu1o3NR2YbMZQ/XawhrImsrW3tzDXlqogDh
	 3e3VpqZXJb1JMF1HFyHFUOZEdr5gjUGwB5WNV865zQQSOFaEzRG1gBnyWSbuUWTr6l
	 VJT6pmJw6MLUw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	=?UTF-8?q?Marc=20Aur=C3=A8le=20La=20France?= <tsi@tuyoix.net>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 08/15] scsi: core: Use GFP_NOIO to avoid circular locking dependency
Date: Mon, 10 Feb 2025 20:31:28 -0500
Message-Id: <20250211013136.4098219-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013136.4098219-1-sashal@kernel.org>
References: <20250211013136.4098219-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.76
Content-Transfer-Encoding: 8bit

From: Rik van Riel <riel@surriel.com>

[ Upstream commit 5363ee9d110e139584c2d92a0b640bc210588506 ]

Filesystems can write to disk from page reclaim with __GFP_FS
set. Marc found a case where scsi_realloc_sdev_budget_map() ends up in
page reclaim with GFP_KERNEL, where it could try to take filesystem
locks again, leading to a deadlock.

WARNING: possible circular locking dependency detected
6.13.0 #1 Not tainted
------------------------------------------------------
kswapd0/70 is trying to acquire lock:
ffff8881025d5d78 (&q->q_usage_counter(io)){++++}-{0:0}, at: blk_mq_submit_bio+0x461/0x6e0

but task is already holding lock:
ffffffff81ef5f40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x9f/0x760

The full lockdep splat can be found in Marc's report:

https://lkml.org/lkml/2025/1/24/1101

Avoid the potential deadlock by doing the allocation with GFP_NOIO, which
prevents both filesystem and block layer recursion.

Reported-by: Marc Aurèle La France <tsi@tuyoix.net>
Signed-off-by: Rik van Riel <riel@surriel.com>
Link: https://lore.kernel.org/r/20250129104525.0ae8421e@fangorn
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ca99be7341d9b..cead0fbbe5dbd 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -245,7 +245,7 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 	}
 	ret = sbitmap_init_node(&sdev->budget_map,
 				scsi_device_max_queue_depth(sdev),
-				new_shift, GFP_KERNEL,
+				new_shift, GFP_NOIO,
 				sdev->request_queue->node, false, true);
 	if (!ret)
 		sbitmap_resize(&sdev->budget_map, depth);
-- 
2.39.5

