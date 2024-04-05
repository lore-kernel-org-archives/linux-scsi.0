Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BE84E1C1;
	Fri,  5 Apr 2024 04:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292169; cv=none; b=BO4I+5mEH5Y81163PbiwDkjd5WVxTB3L1Cf4fJjk9LAEFFXmWNaZmHpo0CtbF6O8H5NeeDpV4bFBMgSPV6Qo+lKd10aFGsb023fu+Kq5mzS4TVvSMOhNHPUK6d2/iGVIvbhBuEw+qh/cABn8e8OOt4UXu+5+d35b0UkqMDSuwag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292169; c=relaxed/simple;
	bh=Xc+57Y8lhUKrfxnA8kI7YV8+a6Tg3KWZjsI74h+yUyE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZdFPnhtuMH0cQeOb5Y9TNSqYlA2aSVWDgC6u6gbtV+5HtKj8ueHp+HL5+USuTuR+waBRw4mTlBlr9zK2Um6KD+W/sOV5oFIa95DKJyNHntM72WMHDirl5blnIhqfZ4PqByrTCTytCnaDdeawGLX0d6nC4Pc2z2eV4TbX0A2p1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGUyynG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGUyynG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4B8C43394;
	Fri,  5 Apr 2024 04:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292169;
	bh=Xc+57Y8lhUKrfxnA8kI7YV8+a6Tg3KWZjsI74h+yUyE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mGUyynG9Mo3HkZ9XmAgQqZhz83//ZBydmHrnyxkUagSWojfZkODGyEju2rWatBHRw
	 jvB56KCnBY4GezSGy1SGzOPlt9+XHbBl2i87ARFogqSJ5Om9A4FWTwCBUM7+f4um/D
	 qfyzHjmSDIzaZkkK+SX9/XjNX9xCpIsuf0jj6MNJU8NyoeQM1owS7kO+Cmv7IS9DT2
	 isqLqAcT+hkzJwZC06Jbxhnl2hjfRDr3M4+4mbhA6cYzwi/KCIqYW8irKN2OCjRzyo
	 XTwVCeJzoMBokTu7RFiBHKy1OMuJTOQJGMx0zb5vDA5lHJVxUY7PW2BEiM2gsdtZ9p
	 5DACRfU7nSwtg==
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
Subject: [PATCH v6 27/28] block: Do not force select mq-deadline with CONFIG_BLK_DEV_ZONED
Date: Fri,  5 Apr 2024 13:42:06 +0900
Message-ID: <20240405044207.1123462-28-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
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

