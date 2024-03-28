Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C04376E1;
	Thu, 28 Mar 2024 00:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586701; cv=none; b=QzsDPBMPRz53Yr9zzE0nPehHhZBAs4a5OEdNj09cOIh1FFzfabNqJg+WiBLCivi1RnN6CfCtjfEg4k9z65j33ZD/QFIL1LhI3SkvofRMxuZoH5IL3k2pRywrt3/rDqKL5lU11byLz1r4nL1lueT6w+bgpn3MiMya5t2V3MDnBSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586701; c=relaxed/simple;
	bh=Q4BPrDA4QaofTn8F8iVQyAz1HMB+Ny9W/x+DILDkrRA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4yUao95p1a3zrVqhtZO4ReqsuGXN8+HAGMTXHMMtoQZDrHSvGuEyoNSCr+Pw2wuDjwnWls/2o1+tjRXKv4Q7QMogEyZe8yhkR+6QQ2Xvdk9gZ2TsrCanM46htxNGphhHP8+corPXGa2Z0AE3/yKXR6lQdABH6qw//ZsP3r0kX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dav9ImaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dav9ImaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1AEC433C7;
	Thu, 28 Mar 2024 00:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586701;
	bh=Q4BPrDA4QaofTn8F8iVQyAz1HMB+Ny9W/x+DILDkrRA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dav9ImaNw1dg3viuvy8SwJspix/P0G6d18kQCODqmQVYPUqF7j3VIlahEOWV7jLhn
	 obSTj1kmc+JQ+yuCeneaAfy9AujABe+sG/FHZvozasEnOnzwoagIF/iJs94eJ9ah0p
	 39ebsk/Xivo1P2CMZAFuF4d0GeygwC2p8wmCb+S4roK+Ui6XxceL923IvDdmDTQv4N
	 0Vx2LxOQ8b7boqVkEbj9dzPdsG39ON8qHiLJbQdOcSbt+cDornQXN1qrU9MRlR5WR9
	 ZaGJz9SfjR5wjkQnesMrq9oHK/f5pC7so/UAfaHagLjB4RGZ6I2IbhNfwP3riUshTe
	 5S0oKQmsiJ5yg==
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
Subject: [PATCH v3 29/30] block: Do not force select mq-deadline with CONFIG_BLK_DEV_ZONED
Date: Thu, 28 Mar 2024 09:44:08 +0900
Message-ID: <20240328004409.594888-30-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
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

