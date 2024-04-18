Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D7A29A1
	for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2024 07:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713423621; cv=none; b=GXcpbc+UAmabxrmQH6sN+8PtIjHRbGbCESI4YUeNK6nwxWEkTvAvOc2QhW9Dr/IX0QFIOGnftSGS1qwQi28iNHAfPiUORRmdS01FfpUJbtakBGqYaMHFJjy5EDC4KOKxEpokMCmtT/y92YE3snEyB13YoVeEg8LHKjlY7lQ6QuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713423621; c=relaxed/simple;
	bh=84k7VsFvtuTgJs2a3KUPj9K7wBwzlNjJTQnhuPraELc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fCbeKL4YZ8EecEsbae0EHsk8omWyEcezDoGmUBqAEHgjTQx4f/sqZurd2posjRH9IsXA3Mcr4qcX5Z1+clzGe6RtGadd0IC4AZh5t921vmkUavgbYwedq971ygFINH6gS4iNiOm/pp2BZ0xXu599oNRKoOUtfueb4++PzFQWJ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yl3rxLPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yl3rxLPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796C1C113CE;
	Thu, 18 Apr 2024 07:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713423620;
	bh=84k7VsFvtuTgJs2a3KUPj9K7wBwzlNjJTQnhuPraELc=;
	h=From:To:Cc:Subject:Date:From;
	b=Yl3rxLPpLdFkxm5ZanxtS9yxfmqMuE327I6Bm9d3JbwIEZFsNkuKWcheOxVedcdZv
	 d/CJIyZdHsrQv9ziy8jiXS58wMJAqpDbBd3J7Jyve7K+dY3q+ew4KV+T4zldBdsG8P
	 FWK70tEB33Veozf/bJ+qz2Kms2T2av5TRdSlvzHZAvVphISZjowM7bot/7smDoOYRF
	 xjIf2L6KDBZLQADblrNN6xnRLoC7cMxmz87+0igzbjKceo1B20wzEZHFNo07zSAQDM
	 88qHSQere1yUbWQQ3qLCHzJTeQtLbGTXRsNeH/6tluYbXfSFi9i4QVV5Zij0UdS7Fe
	 vMsZgJ4L0TS7w==
From: Hannes Reinecke <hare@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>,
	Martin Wilck <martin.wilck@suse.com>
Subject: [PATCH] scsi_lib: Align max_sectors to kb
Date: Thu, 18 Apr 2024 09:00:15 +0200
Message-Id: <20240418070015.27781-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

max_sectors can be modified via sysfs, but only in kb units.
Which leads to a misalignment on stacked devices if the original
max_sector size is an odd number. So align the max_sectors setting
to kb to avoid this issue.

Reported-by: Martin Wilck <martin.wilck@suse.com>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/scsi_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2e28e2360c85..aad2ac1353d1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1983,7 +1983,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 		blk_queue_max_integrity_segments(q, shost->sg_prot_tablesize);
 	}
 
-	blk_queue_max_hw_sectors(q, shost->max_sectors);
+	/* Align to kb to avoid conflicts with Sysfs settings */
+	blk_queue_max_hw_sectors(q, shost->max_sectors & ~0x1);
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 	dma_set_seg_boundary(dev, shost->dma_boundary);
 
-- 
2.35.3

