Received: from smtp.ideco.ru (smtp.ideco.ru [51.250.56.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D36A3101B0;
	Thu, 21 Aug 2025 12:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.250.56.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755779765; cv=none; b=fCKEwACc13u5QoAVZBcKiSi6bsDUu8yfhVv77mbu4OovcadW3VgjtTjWoa6ntL3QedhnRyqXWx4XSI2LN14bBDziIaCM27adeBdIai85hxkjWw6jQ9p2FFw8YVrmULgF9Kr3rRtpghG5m5P6iKeZroFLCrXQEYDhOVrpq3rYRsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755779765; c=relaxed/simple;
	bh=4a6bZoV/RMqu+QzfmcSRUTUmQHPGzIv7BXnA36PO3qg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k+Kn9Et5WC60pBzlUYOSrsK1RgnKBA8cYhBnZGj8jc4yi0mkDEphx539URMm/ddPGPkA5XtAt5s5A1oiA1CzY860+hvdOtD5cExRBzWqO/Dg5WmOTrKEeMcJ9QhpVuO0QFPLjpF9hrH2lqqqQpu45pP4iHX4k+3zDc8tOQ+hRww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru; spf=pass smtp.mailfrom=ideco.ru; dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b=BhYmGwRQ; arc=none smtp.client-ip=51.250.56.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideco.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b="BhYmGwRQ"
Received: from [169.254.254.254] (localhost [127.0.0.1])
	by smtp.ideco.ru (Postfix) with ESMTP id 4A63E17A37;
	Thu, 21 Aug 2025 17:26:37 +0500 (+05)
Received: from fedora (unknown [94.159.101.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.ideco.ru (Postfix) with ESMTPSA id 9DB519B88;
	Thu, 21 Aug 2025 17:26:35 +0500 (+05)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.ideco.ru 9DB519B88
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ideco.ru; s=ics;
	t=1755779196; bh=ZBCriu/wRttPNQbAeXyQFRyR28wr2U4BJOvkqPdM3pY=;
	h=From:To:Cc:Subject:Date;
	b=BhYmGwRQakTHTi/Yg8Opjhkn2TdRyw3IR5uH/sk1s9djSQs13t1LqqxDXJFZe8j7Z
	 hxG/sm3WbJTIFs+0EmCJwooyyB8hrEn7vEKY8HqraavgPsJl0P1aP1dVGI4RLnzIGZ
	 ZhfDDsVlxCrfTKiL8X/UOdxbPB8f6nN9k/kDcc1LLBAwVg7RlKRXAmG5+oeqTW87Cv
	 YwHEL/xqRF78iaIEAur7qXIR8mGAzG9S2JIZTbpNlV8hq993tiiS07gBA+68n8NOgV
	 N0NUpssrtw6pEJbKBsT+j38kN0v2Rk1vYJAWNFcW/6mqw4h+6FzDz87M6G8Ih/R9Jh
	 QdLMUzk1W5Muw==
From: Petr Vaganov <p.vaganov@ideco.ru>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Petr Vaganov <p.vaganov@ideco.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <htejun@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fill in DMA padding bytes in scsi_alloc_sgtables
Date: Thu, 21 Aug 2025 17:25:53 +0500
Message-ID: <20250821122559.1559736-1-p.vaganov@ideco.ru>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During fuzz testing, the following issue was discovered:

BUG: KMSAN: uninit-value in __dma_map_sg_attrs+0x217/0x310
 __dma_map_sg_attrs+0x217/0x310
 dma_map_sg_attrs+0x4a/0x70
 ata_qc_issue+0x9f8/0x1420
 __ata_scsi_queuecmd+0x1657/0x1740
 ata_scsi_queuecmd+0x79a/0x920
 scsi_queue_rq+0x4472/0x4f40
 blk_mq_dispatch_rq_list+0x1cca/0x3ee0
 __blk_mq_sched_dispatch_requests+0x458/0x630
 blk_mq_sched_dispatch_requests+0x15b/0x340
 __blk_mq_run_hw_queue+0xe5/0x250
 __blk_mq_delay_run_hw_queue+0x138/0x780
 blk_mq_run_hw_queue+0x4bb/0x7e0
 blk_mq_sched_insert_request+0x2a7/0x4c0
 blk_execute_rq+0x497/0x8a0
 sg_io+0xbe0/0xe20
 scsi_ioctl+0x2b36/0x3c60
 sr_block_ioctl+0x319/0x440
 blkdev_ioctl+0x80f/0xd70
 __se_sys_ioctl+0x219/0x420
 __x64_sys_ioctl+0x93/0xe0
 x64_sys_call+0x1d6c/0x3ad0
 do_syscall_64+0x4c/0xa0
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Uninit was created at:
 __alloc_pages+0x5c0/0xc80
 alloc_pages+0xe0e/0x1050
 blk_rq_map_user_iov+0x2b77/0x6100
 blk_rq_map_user_io+0x2fa/0x4d0
 sg_io+0xad6/0xe20
 scsi_ioctl+0x2b36/0x3c60
 sr_block_ioctl+0x319/0x440
 blkdev_ioctl+0x80f/0xd70
 __se_sys_ioctl+0x219/0x420
 __x64_sys_ioctl+0x93/0xe0
 x64_sys_call+0x1d6c/0x3ad0
 do_syscall_64+0x4c/0xa0
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Bytes 14-15 of 16 are uninitialized
Memory access of size 16 starts at ffff88800cbdb000

When processing the last unaligned element of the scatterlist,
it is supplemented with missing bytes in the amount of pad_len.
These bytes remain uninitialized, which leads to a problem.

Add zeroing pad_len bytes of padding by pad_offset offset before
increasing its length. This ensures that the DMA does not receive
uninitialized data and eliminates the KMSAN warning.

In this case, the pages are not located in highmem, but in the
general case they might be, so kmap_local_page() is used for mapping.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 40b01b9bbdf5 ("block: update bio according to DMA alignment padding")
Signed-off-by: Petr Vaganov <p.vaganov@ideco.ru>
---
 drivers/scsi/scsi_lib.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 144c72f0737a..d287e24b6013 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1153,6 +1153,11 @@ blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *cmd)
 	if (blk_rq_bytes(rq) & rq->q->limits.dma_pad_mask) {
 		unsigned int pad_len =
 			(rq->q->limits.dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
+		unsigned int pad_offset = last_sg->offset + last_sg->length;
+		void *vaddr = kmap_local_page(sg_page(last_sg));
+
+		memset(vaddr + pad_offset, 0, pad_len);
+		kunmap_local(vaddr);
 
 		last_sg->length += pad_len;
 		cmd->extra_len += pad_len;
-- 
2.50.1

