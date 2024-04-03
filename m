Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F2784D13;
	Wed,  3 Apr 2024 08:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133813; cv=none; b=c50WnJypfjogWexDCMG6rwss+BW08QtgYBVkFztOxZLI2CNSPwRm4Ybn3ZMYhyifdgFSdCSMF7Yx0rXYu6auMLj064nIBY1Hre8ROiOOIIYtBKgZ/z4YNlpKaKnFmmODt09rW3gybUaPjYKWso7+bVH1krw4d+rTAjGZWaQYqVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133813; c=relaxed/simple;
	bh=zJg2W4YZSVDbkVyvzcyKxS2XcZn+CTU4gufBXBk7TGE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvBt5H4Vrzrob7Q8dK39YsNGyWNlU2qWfpf2sQWnHT5n1+QZg49PF/6lqXQWpTmjdyBRJPq0X2LCPpiw/rhTVfcQO6B8X+KZjcTRepyAgagKwC5aguBMuv9+TEnGmK8tucBw3HdZnrT97dW6t9W3O7fqw8BsyShP9s9PauXdP5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2NzCmrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2NzCmrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ED2C433C7;
	Wed,  3 Apr 2024 08:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133813;
	bh=zJg2W4YZSVDbkVyvzcyKxS2XcZn+CTU4gufBXBk7TGE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=f2NzCmrnluP4faK+qiofhB3B8jqJo0iuekt8ofhgENDnxZETJNAu4yvhtorNbJM5e
	 4eS0PN8QKwmHgUTgPoU6e3SZWCFp37gd3vWOn/2W3K4MGgJdh9/pxuLm4GNESf6AqS
	 mp4y4AOnfvJMp5H9dMzHaTZzg4kjyuKcMTcA7EyVXGPp4CI3/SkVVHTNe9IdZJy70e
	 qbypqL1vkaOgYaJ0Svg7odi5+NzlRriDg0lPvH3NmkzzR4WMh+Mrn1E+YgkQlc60UK
	 9SjOsl3LlhMTUL7gczAQUFnU89lIrF1tYnhc8t1zJOPq1gvjL19YFFWyP8v2TeeWmI
	 IeGM2KHvro73w==
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
Subject: [PATCH v5 27/28] block: Do not force select mq-deadline with CONFIG_BLK_DEV_ZONED
Date: Wed,  3 Apr 2024 17:42:46 +0900
Message-ID: <20240403084247.856481-28-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403084247.856481-1-dlemoal@kernel.org>
References: <20240403084247.856481-1-dlemoal@kernel.org>
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

