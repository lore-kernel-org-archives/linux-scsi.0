Received: from smtp.ideco.ru (smtp.ideco.ru [51.250.56.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4E72E7F34;
	Fri, 25 Jul 2025 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.250.56.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753446539; cv=none; b=tkHqb/NoOeC/o+HA++yCmeiTyMPRxVCcmtnkOjX9jrJf2Bq0slKpzNA1yfnaG8zSYB2sAfjW8yFdv9sb/bS5xDlcFh9nJYmwJ2ATd9mcTmzwU6dg1YWQKBw64jiExFnIcdrUiVQPGvrySBuVjIIF6gGqSI/UKBc544X03wkEC40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753446539; c=relaxed/simple;
	bh=x+b3x2AvTB4xVeTuWWrwabGOIoHBfzemRqb2/v57SAY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GPuc+kNKdx+pGVUa4kEmt7/63oEm+Wpx3OrMtDGAXAWTCf4xp+FmdyTYu57mrkMe5aUuM2Wn2lEkHc6s+JRB96x9wV6mzsYBMC3VTAtUQRsUsjzMMqx1cnt9Z7Mr3T3y1SygfT6LiZoWNa2pfHxbg3X09Oo3r+fKkE8HvbnH1NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru; spf=pass smtp.mailfrom=ideco.ru; dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b=SLpbuS1c; arc=none smtp.client-ip=51.250.56.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideco.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b="SLpbuS1c"
Received: from [169.254.254.254] (localhost [127.0.0.1])
	by smtp.ideco.ru (Postfix) with ESMTP id 14F8B102AA20;
	Fri, 25 Jul 2025 17:23:10 +0500 (+05)
Received: from fedora (unknown [94.159.101.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.ideco.ru (Postfix) with ESMTPSA id C0706102AA1D;
	Fri, 25 Jul 2025 17:23:06 +0500 (+05)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.ideco.ru C0706102AA1D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ideco.ru; s=ics;
	t=1753446189; bh=trP0XJpooGTDkJ3CKgo2EF7+uta1JC7E8Yz2rzhwif0=;
	h=From:To:Cc:Subject:Date;
	b=SLpbuS1cB/S+wAKgJURID3eIyiM4BwrTN3EsWju5g7oo6kRGIkFzZn51pyCjgNiyb
	 5Ek/4WguWCEIDoL6KCMaOdZOtz2toNtFqMWHQXJWjBtX3OaPnS7szcv5b89aSc97A5
	 NCcuSYK8fnWG9iaoStgvRJaMCXuq3H8svsimkUDJ0i1tBCrzcDhpLPSM4hycOlyPl2
	 kxa+h6/UZOjsq4icZfhUrT+Fgi2UxuetxdOzUgvnR7CWE5npEzDBHBduCmkkzn5RAH
	 Nnv0dlcUIBYJG+MHPxX8K/qypX4X7j325sCPfehG/tttUmph9O0rj6KhJvpVAkl8NO
	 8U8fl5w6c0KPQ==
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
	lvc-project@linuxtesting.org,
	Boris Tonofa <b.tonofa@ideco.ru>
Subject: [PATCH] scsi: fill in DMA padding bytes in scsi_alloc_sgtables
Date: Fri, 25 Jul 2025 17:21:59 +0500
Message-ID: <20250725122202.77199-1-p.vaganov@ideco.ru>
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
Co-developed-by: Boris Tonofa <b.tonofa@ideco.ru>
Signed-off-by: Boris Tonofa <b.tonofa@ideco.ru>
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

