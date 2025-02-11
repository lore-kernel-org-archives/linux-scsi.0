Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14C71DEFFC;
	Tue, 11 Feb 2025 01:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237473; cv=none; b=Bdp/R8EvyA0jpwlkA9k4rKAeNrPWtEO02Sd0pYy+IQ2f9COwZf3gzaYJ/dIgPkivtr4QD/vel8OSzah9HzaAAqiGGMvt1cj2qoVBxJ+dyWPRCNUjyBF8XCgXq55QpX+1D2bEIY6nscdA+FTH79/wOsRkICyvFoehotrK13wpiSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237473; c=relaxed/simple;
	bh=AvpDWiT8RYU89bwyqqgYdwBmnSzet2y0wzAleiu8oeA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f8cK7tMYwA2hWvxGFQED7o1GFat+DRbWYB01UTYGJv/jAJkYZkm+A2T2b19E5zoCD4MTpFVvySAmgbJwU8GOSeiwRilRYynheZv8SNTl7b3PNhdpJo+KeIsyFGbqt9qWnhgz0qmPa1+PS5e1cMPP/Qk0+ZzIQBOdoym1CQoBAWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1Dk6b0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1Dk6b0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88906C4CED1;
	Tue, 11 Feb 2025 01:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237473;
	bh=AvpDWiT8RYU89bwyqqgYdwBmnSzet2y0wzAleiu8oeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1Dk6b0ZzXkBpcaYdu8B+tNrMzfYxLWnhjUx8U3YBHN64Vr1DSPu3LhINttzIhCIF
	 fSD6hZ6juBCi8WzdxZsfhOS0XJZbTlUbDlIKo75z0nqG2G/LpIHjmOJSmWJfJ/PcVz
	 5R10ZAdnhzbFGj5od6oFvM1EK5IYnHEJgeCeme60qWftCVSGoEdrCBFgR4DsjKuGKe
	 NINNvkJG47CXaCwOwmqO/Uwv1v/2Ju/j0T1A1DyJKXyVsov7NIDX3B3fw4/J+U8++C
	 E1CVXTaQC5FbuouQQzV4ooIEG1dUClC6NchjI0TcuXvsiaLfISwLYUf3+GmxxGO15I
	 2aJTsq13tlx3w==
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
Subject: [PATCH AUTOSEL 6.12 11/19] scsi: core: Use GFP_NOIO to avoid circular locking dependency
Date: Mon, 10 Feb 2025 20:30:39 -0500
Message-Id: <20250211013047.4096767-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013047.4096767-1-sashal@kernel.org>
References: <20250211013047.4096767-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.13
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
index 042329b74c6e6..fe08af4dcb67c 100644
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

