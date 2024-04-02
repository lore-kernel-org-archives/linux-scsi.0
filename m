Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAC17A151;
	Tue,  2 Apr 2024 12:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061588; cv=none; b=eq2qiIUbdxxY3hjUm9hWT2VTCUkrbAj2ncPVxG1ckC+0FwvjZCRYlDw+x9+3doorDRbsnDnRvolATf7H9ALI5jxDkP0NPllK7Sb+gqYDAakwJlAT0P0fSEWO3Wp50txw0O9X1pgvYyXZc8yqMN7UBXhqLyhQGrdRkogHzZxlYCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061588; c=relaxed/simple;
	bh=zJg2W4YZSVDbkVyvzcyKxS2XcZn+CTU4gufBXBk7TGE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4JAvAXqUd2n+1O42zJ6oR+Qh5GKkZZptTgsYMNzNoKJI7eLMlWVBUq/8lkNoREbSlor5u6Srx4mOfTWwOO0p3493vjyb6GtTPeDdxXH9zbDhKhwxjg2OJQqtpAXDnniugXOOQP1OTblrNO+IbHcQ/IjwkGqw0R4R9dmJ0Yz/MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=htWgIJ+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="htWgIJ+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D4FC433C7;
	Tue,  2 Apr 2024 12:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061588;
	bh=zJg2W4YZSVDbkVyvzcyKxS2XcZn+CTU4gufBXBk7TGE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=htWgIJ+JnqgK4cHlu11qGHY7T0xl7GDqsm8tBL+bB5Q+UlgIRGISjVqSFOY9Hnz79
	 1ga9wnbMKCWsuHOW9decuefz8yqniDP3nKEMmsp1mHDK476+nmERvhMgzl5jj4Htfp
	 +59i5Onqb0i4oMNBDN8Yrwt6KEom/csqBCy4CpcRfsDFRdXH+QkmckpJ2poTsuAzla
	 gQ992AJfloMoJooDyDC1LjM+ouGpUxmRtKBdwC30yrBuiggX4BuPmg3Aagli0cn5Zt
	 gh169kTBBCI3qruSiwdeZbT79u7dY3gA0U4Z+AN9KeN4OBoGxC0VMwbr0PML1Lve/u
	 W247doYrfy4fg==
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
Subject: [PATCH v4 27/28] block: Do not force select mq-deadline with CONFIG_BLK_DEV_ZONED
Date: Tue,  2 Apr 2024 21:39:06 +0900
Message-ID: <20240402123907.512027-28-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402123907.512027-1-dlemoal@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
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

