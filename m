Received: from smtp.ideco.ru (smtp.ideco.ru [51.250.56.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E7430EF7E;
	Sun, 28 Jun 2026 18:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.250.56.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782671743; cv=none; b=cfWCZpY5ppY1i4EIHW/km7v4Y4UnqGvDOzJhc550ixt372yNDA1TBJqCjpqXS6/di7LqzL215+dr8w0uMDZm+kxN/4FMwYlVIfc2CxQN9f1yWPSrXF5Vheef/ipkxLLPvF4YGmtFArIwpP6YeiC6/sDuYPtDywlHLkt7KJ6RSjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782671743; c=relaxed/simple;
	bh=lpxGphMIGEExVS5xFY9Z/dACn+nLt/m1HYP7extRHlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pVgiwFpcWXmDOfrTRPmWq5bXsaLARPwT1Lt594InK7LiwHbe2IczbpDtVDrE3JInS1qpzK1qz4iM3XPQNlar/nyoNSUKcS1gazASkR/eRsfcDQ92vqywUXEId56NqknYwJcXq7+IpxywoPr0INpAmYd5ZkFmiHUlT+H7bRL1F1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru; spf=pass smtp.mailfrom=ideco.ru; dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b=dvlbyL2W; arc=none smtp.client-ip=51.250.56.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideco.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b="dvlbyL2W"
Received: from [169.254.254.254] (localhost [127.0.0.1])
	by smtp.ideco.ru (Postfix) with ESMTP id CBC011010431;
	Sun, 28 Jun 2026 23:35:36 +0500 (+05)
Received: from fedora.. (unknown [193.168.176.213])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.ideco.ru (Postfix) with ESMTPSA id 91718103AC8A;
	Sun, 28 Jun 2026 23:35:24 +0500 (+05)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.ideco.ru 91718103AC8A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ideco.ru; s=ics;
	t=1782671734; bh=krOnNt8pZjeg83oQl+z+sL9f3IAaf/1MCw28l+HpybE=;
	h=From:To:Cc:Subject:Date;
	b=dvlbyL2WRWDEgS0GwsunU0DHmhToRdyKqKBVvpGzly188UpkcrGoAn6rHY9hrkaXR
	 c4objuk/poYyRMaz2q0ocy5DPdTaRN4/Llq2H7fFwCQJ36CCGQDndtx0qLgfmkBA4I
	 dq2L640hciptnrUhtJicQLQgMtxKuEs5Vi1OjaThfC1OWV1npcgUAbYG7JkYKP1nBu
	 fUfQ6UpMb+efL1hdce1um81ZaFZU4shlrvmQHiYeK+zydug1+2elFTZHyeSUk5CDIK
	 SVilpKO11PZXbigVcnUTeIwZvAaPigEVLLy1jjAa2JVGZ7sjdtAieepDGoThq6jjU5
	 neVvvu9mFqYdw==
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
Subject: [PATCH v4] scsi: fill in DMA padding bytes in scsi_alloc_sgtables
Date: Mon, 29 Jun 2026 01:34:55 +0700
Message-ID: <20260628183500.31970-1-p.vaganov@ideco.ru>
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

Zero the pad_len padding bytes before extending the length.  This
ensures that the DMA does not receive uninitialized data and eliminates
the KMSAN warning.

The padding bytes start at byte (last_sg->offset + last_sg->length)
within the sg entry. Since the last sg element may span multiple pages,
pfn_to_page() with page_to_pfn() arithmetic is used to locate the page
containing the start of the padding. The padding may cross a page
boundary (e.g. dma_pad_mask=511 with data ending near a page boundary),
so the zeroing is split into two memzero_page() calls when needed.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 40b01b9bbdf5 ("block: update bio according to DMA alignment padding")
Cc: stable@vger.kernel.org
Signed-off-by: Petr Vaganov <p.vaganov@ideco.ru>
---
v2: Added tag "Cc: stable@vger.kernel.org".
v3: Resending this patch as the issue is still present in the current
    kernel and the previous submission did not receive review.
v4: Use pfn_to_page()/page_to_pfn() arithmetic to locate the correct
    page when the last sg element spans multiple pages.
    Use memzero_page() instead of open-coded kmap/memset/kunmap.
    Handle the case where padding crosses a page boundary by splitting
    into two memzero_page() calls.
---
 drivers/scsi/scsi_lib.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 22e2e3223..d7111be45 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1187,6 +1187,20 @@ blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *cmd)
 	if (blk_rq_bytes(rq) & rq->q->limits.dma_pad_mask) {
 		unsigned int pad_len =
 			(rq->q->limits.dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
+		unsigned long pad_off = last_sg->offset + last_sg->length;
+		unsigned int pg_off = offset_in_page(pad_off);
+		unsigned int chunk = min_t(unsigned int, PAGE_SIZE - pg_off,
+					   pad_len);
+		struct page *pad_page =
+			pfn_to_page(page_to_pfn(sg_page(last_sg)) +
+				    (pad_off >> PAGE_SHIFT));
+
+		/* dma_pad_mask is expected to be smaller than PAGE_SIZE */
+		memzero_page(pad_page, pg_off, chunk);
+		if (chunk < pad_len)
+			/* Pages within an sg entry are physically contiguous. */
+			memzero_page(pfn_to_page(page_to_pfn(pad_page) + 1),
+				     0, pad_len - chunk);
 
 		last_sg->length += pad_len;
 		cmd->extra_len += pad_len;
-- 
2.49.0


