Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E033D576;
	Mon,  8 Apr 2024 01:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540540; cv=none; b=p3+4uiY+yMnwf1Swoqj35W2dNi/AiD2D2Ubti9VFz55IlJceWPiEW/rkf1qwLovXORH9SjqMHcJLElZ1caiXek19Eq9CuAyoGOtUAn5OLLZqudu8l9fdhkNCDhTMwJFmkdOG20SREj8Oe700/olg4I1oU5QySIytnN/oNliIy9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540540; c=relaxed/simple;
	bh=Y2mdZkEnZ/DAhvusMpda3u94JlWFQ2zkygXuTzVrhEI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLpqLiNuiG1DBRQuP0hu2JkZeIq5PYN37vDL2orIZAGnsbMM5zDhKMT4otMqPP2j551yGlViQcR/rUwZR29g+OtqruQZ+7+PRwEKPV8txMgqca/qnZNqZin0vbMV9L1dh2I4d2i+b/tDcfqty9XphMavYVxoIWCBZvcrid8QhIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUm2DQ0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUm2DQ0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33AAC433F1;
	Mon,  8 Apr 2024 01:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540539;
	bh=Y2mdZkEnZ/DAhvusMpda3u94JlWFQ2zkygXuTzVrhEI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WUm2DQ0o1Wq3swKcnWyfxEQWdmqs9zon++fe9s1Z1SZygmTMMFGyg11hrjKrneYNo
	 qRt6eybt3Gvij/MbEKKOFlAExCjD9BsSxlZQicA3bqjoWf6bz0WtnVhiI7dnd1hluK
	 vlsATyvMxM1zc/TdnNn4TV9hfwdamlrBaeJElwuPsqaYB30uN9XSVCytMUiqmaC0sr
	 lpmYuIwVtYLt50ez2FC68aJN3DK6+mKitKsaC+BUmjOqz6w9XhDhgtkvx+E33TqkzG
	 nBccq+NGKPPNLEYLLybLxdsMWA/ZJ3QOj1KQHUH4YsWfUZiB3WHEC/63J79VpqsFYY
	 v5JfILRKmFp4A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 27/28] block: Do not force select mq-deadline with CONFIG_BLK_DEV_ZONED
Date: Mon,  8 Apr 2024 10:41:27 +0900
Message-ID: <20240408014128.205141-28-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408014128.205141-1-dlemoal@kernel.org>
References: <20240408014128.205141-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that zone block device write ordering control does not depend
anymore on mq-deadline and zone write locking, there is no need to force
select the mq-deadline scheduler when CONFIG_BLK_DEV_ZONED is enabled.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/Kconfig b/block/Kconfig
index 9f647149fbee..d47398ae9824 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -100,7 +100,6 @@ config BLK_DEV_WRITE_MOUNTED
 
 config BLK_DEV_ZONED
 	bool "Zoned block device support"
-	select MQ_IOSCHED_DEADLINE
 	help
 	Block layer zoned block device support. This option enables
 	support for ZAC/ZBC/ZNS host-managed and host-aware zoned block
-- 
2.44.0

