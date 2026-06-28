Received: from smtp.ideco.ru (smtp.ideco.ru [51.250.56.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A3023D2A4;
	Sun, 28 Jun 2026 18:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.250.56.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782672788; cv=none; b=h2mDWKGiaBAuZQk3XS8H1hat22SVJgDiHHKE6F+TNI3hro1kG2Q7CKfx5I6jvfuQ9RQ8+0I7LpsP1b3Ybm3lvNV6nISoKU+5GbVhyMYa6PkggTnys22BpDD2bzesLXRyqTr26Yf9V2M06tPn8mc5piMmjuTqYVlQ6QxenDeLc8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782672788; c=relaxed/simple;
	bh=AQWKJNf+maNVC7jkiay3BmWJVdkgN4PjbpzB5w55+rw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FQuk7xjLakE+WtgcDuF6RB8TI/HlNUdiTGVpPHR+6K9tnAxWeg7CwlEiqQYxRK/+dnP3fvoHIusheSvyShc7/1iiFcpK/VdNiY3GHhkVf2ztV//f/gqy/u+WFhzUeGiEh0q+QdqxBxPbGygiLqZHhfwiyFr3oosNAYjm5WLY5+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru; spf=pass smtp.mailfrom=ideco.ru; dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b=iHhP5u9r; arc=none smtp.client-ip=51.250.56.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideco.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b="iHhP5u9r"
Received: from [169.254.254.254] (localhost [127.0.0.1])
	by smtp.ideco.ru (Postfix) with ESMTP id 486641010B25;
	Sun, 28 Jun 2026 23:53:03 +0500 (+05)
Received: from fedora.. (unknown [193.168.176.213])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.ideco.ru (Postfix) with ESMTPSA id B82AA1010B24;
	Sun, 28 Jun 2026 23:52:56 +0500 (+05)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.ideco.ru B82AA1010B24
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ideco.ru; s=ics;
	t=1782672780; bh=2iLlGBmIm1cTNxVRCHaw4rhbzIgUSg2y8XhQzHajMqE=;
	h=From:To:Cc:Subject:Date;
	b=iHhP5u9rVi1NJgDZTfWEvqcFk51oKWHCOFTCJIwY57sV7vVRll1Qla9JPNESN2QCH
	 9QO8ZCUEKr4yjJ3sZH0A2K7HWSp5ycb839zDyNTPHavYSb4GgIWsvQKS4u1BIH4aQE
	 4TdAd+MhPyDYIkLZV4byzMiOEwajvWdp8i0QCCvvIQh0AxFHUFFYOOVJqb75zKVHim
	 le9Yn3s47hi0vD8JLmm7HXRqzT3IJtXPwFWSxgob0iK1GzYgBNKxMYTF5CKVvHyxwA
	 k9NaWzJ7B1VLymVlMiAWQKK8HLIr+YxoWGzllSTnamxW79wxX1F9BsnFyrJ300zUiJ
	 R/22f/7hM/neg==
From: Petr Vaganov <p.vaganov@ideco.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Petr Vaganov <p.vaganov@ideco.ru>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <htejun@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH v5] scsi: fill in DMA padding bytes in scsi_alloc_sgtables
Date: Mon, 29 Jun 2026 01:52:21 +0700
Message-ID: <20260628185229.37957-1-p.vaganov@ideco.ru>
X-Mailer: git-send-email 2.49.0
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

Extend last_sg->length by pad_len first, then use sg_zero_buffer() to
zero those pad_len bytes.  sg_zero_buffer() uses sg_miter internally,
which correctly handles sg entries spanning multiple pages and padding
that crosses a page boundary.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 40b01b9bbdf5 ("block: update bio according to DMA alignment padding")
Cc: stable@vger.kernel.org
Signed-off-by: Petr Vaganov <p.vaganov@ideco.ru>
---
v2: Added tag "Cc: stable@vger.kernel.org".
v3: Resending this patch as the issue is still present in the current
    kernel and the previous submission did not receive review.
v4: Use pfn_to_page()/page_to_pfn() arithmetic to locate the correct
    page when the last sg element spans multiple pages, fixing a
    potential out-of-bounds write.
    Use memzero_page() instead of open-coded kmap/memset/kunmap.
    Handle the case where padding crosses a page boundary.
v5: Replace hand-rolled page mapping with sg_zero_buffer(), which
    handles multi-page sg entries and page boundary splits correctly
    via sg_miter.
---
 drivers/scsi/scsi_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 22e2e3223..686cef240 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1187,8 +1187,10 @@ blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *cmd)
 	if (blk_rq_bytes(rq) & rq->q->limits.dma_pad_mask) {
 		unsigned int pad_len =
 			(rq->q->limits.dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
+		unsigned int data_len = last_sg->length;
 
 		last_sg->length += pad_len;
+		sg_zero_buffer(last_sg, 1, pad_len, data_len);
 		cmd->extra_len += pad_len;
 	}
 
-- 
2.49.0


