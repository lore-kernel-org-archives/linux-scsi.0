Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACC92236EC;
	Tue, 11 Feb 2025 01:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237535; cv=none; b=p+qr1/JzjI5db8flQEhhgyJQUdPsbzmDd53oMSxyYXBKXLUt/CX6HLmg/sBGJBYbKgYuo9zsuBFFl6o8BprPdxm91DLNDTTrNJAccMH6Pi7CE4T3nph15BuRCvkOHKbn4BZOKwx7UAY1yRbqJpI6AikMtdt9PImVuMYVg66S0OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237535; c=relaxed/simple;
	bh=1VHiijSQilmW7pa/YP6ujaK75Y61pSc1YVCPPtkBMyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrZ1IEOkSw9Z7EBscsc5bLYu+3+fbQOnKEq1CCEiRuIghVbfCnmhN1w4ymaVVBPaEmWQ+hpKSYmBoxpRhg5LV9CVxSEpiVuJf2hDVVY45ay7b7kyH2yz9SYYQMN5SMsi8s4CmFKOFum+p0ItppaLYEJA0UkRuA/pusS4MYG+Ri0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IuxwG7O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IuxwG7O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03E0C4CEEA;
	Tue, 11 Feb 2025 01:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237535;
	bh=1VHiijSQilmW7pa/YP6ujaK75Y61pSc1YVCPPtkBMyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuxwG7O4+7R9t7yXTqT/XAMkqipvFBTKXeLWbT0DVwbir8l2m6odJdU1agdbZy2Qq
	 LY5NOVXgDNCqhdzqi+hFCsrgR0KVAXwJf7r8szn1wCOgvNnNpttZQj5MPK1xtOSE3V
	 9jV2I4O3Pj7a8mP5UCe4o0a/zzwTd90wbf1I1iXAsasHe6Um6R0aNDLhiAdWHzJNJ3
	 aoCzBwkz0aMTaZvDbRtiy69JkxSSw4ATDsKEGkxOKeLinSbQqcVDCIMzUvieQg9a7g
	 FcSCUTrlC6fkzUn35w8V6W7RB8K4G9Lmw62u/jMkIR4XQZzB+31W3iV74cUpqV6r9o
	 ezAHjPXIAyZrw==
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
Subject: [PATCH AUTOSEL 6.1 05/11] scsi: core: Use GFP_NOIO to avoid circular locking dependency
Date: Mon, 10 Feb 2025 20:32:00 -0500
Message-Id: <20250211013206.4098522-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013206.4098522-1-sashal@kernel.org>
References: <20250211013206.4098522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.128
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
index 852d509b19b2b..69288303e6004 100644
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

