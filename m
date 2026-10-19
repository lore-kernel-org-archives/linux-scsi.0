Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DC049B44E
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 08:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792399004; cv=none; b=fHCV/bjkyVCTs7CmX1+GLM78Q6Gvh1cGhQUwBhUPhtH5YLBpM7I1TOAWswHgwXI0bUR+ZFClKTthh4ASSg1GvjMNF38G73xpdb5GARxlvJY2ROEPP7b3zaFTsVOHkNsfnQL8ExYd+i3ruGUlFp6AF54YvxCYy7ZXhFhhf2Ct6eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792399004; c=relaxed/simple;
	bh=wopnKdIWquQ/19iqJ+7yuXZ+uNue8zlPP3xAl38VlP0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PuhrUxM1RqsdWBUbc3sYrass1hmKTOG590qmfy6XP415/n1mwJpbGXROyTKeMySI0DcT3xcRAESufb+tITz8VURzee++fP/Dk3d0m7Wrxvtjp+4+AUegctDIfAyBIIgjix9q9uEbMmkEy+uh1o94S4OdQQx83f+xo0mG/w7qKpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=cbMwav/M; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="cbMwav/M"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e5fb79ce82so8940285ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 01:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792398998; x=1793003798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XHO8V/wDfiBEINRArRhvsbbx6Jsua2LG1hGVoz5r0fs=;
        b=cbMwav/MduEe4QE+8peVSBdNdzulLpla3wI2ZY4h/2+ET8qgncd8zbm9wMcuiPKy15
         CMCjqDYi47hyd8wsvbxDtEcSL23Iv7WXQpaIYhNLPNMJ7MF5MXZEqB/OcKvgUhZjc9Gy
         Va311ZGojuT4Z0Aq0Wvt2Xd0rodzNhlJCj/WbKq0vVu5e0T25dn3rW0iZDGMvmXORSQf
         9AeVc5NMosU9NpgwPpWvDmvOLTxfKqWWYWB1Obd5Tw3tw59f40vbVLhGimVMyhdlZ2AP
         STI+bhxkpcLBtnAsxVZk0ZM1WhMU69BHjI/WCqAN2cP+B8lURw8cQgjHrt4CDllDrC/a
         QuVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792398998; x=1793003798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XHO8V/wDfiBEINRArRhvsbbx6Jsua2LG1hGVoz5r0fs=;
        b=ZC7sf+0JZujzUdT78JL1z/lmkaFbCipGDNkxy3mG9Eg1aoo2suHRCNMvwJVRfgA45A
         gq9lGTGF7JQsFQt8l7LWDH87WAQZvjzbAO/pBnA5fe/xyU0jd8UBA6SuTlzJk04Dw1LU
         7G4xxvcwGHKhmhjymxWYAtGQD9aQtPEXzHZqCF4/7pA+mmHxocdDI/PZnB3Kg7bR5or9
         QDKdTn2Nudc4eCiEAK7t5Vtceh6ngbIVrIRNStFHkYoqD3OXWdcW0fVW/l+1g8LsvWFn
         TU9c69OL3JXqpCzBvHCj9eHtyW2kLmJp1dUtQfL/8pna72Srlcw8gAcMW9YH8bnbaRQA
         vEhg==
X-Forwarded-Encrypted: i=1; AKwUvBxfOT9kXOdHGKIKIQOlzGKBdZd5tAJiDvJniu0x0fdkGgXlmvqiH7hjrQzlZmUuF9WXGNQHxJyCVJf+@vger.kernel.org
X-Gm-Message-State: AFq9FYJCE/j2fwN7ro+nZpjnecx/VX0+nSknsNZijU7thkQA2n2MrPcc
	6tqBe/NPeat2tSaer/6pn+nccAemj8wQJHgwzzMN0AnMSOmmgPieiT4ChdLr9NcIuNQ=
X-Gm-Gg: AYBFou1zDIJ/hsCntoDz9HXYudU4VgLGXjqWjwqZUwpuCKiiz5iqpFh6ZSMUJKGf7O5
	U5G/HiEagqZRC3tttnQB2Bnu6+0OAIl0Rk1gwMOB+jLH0HtdtvXGxR6i1kiVNnvLbNFseFXvttx
	pMfQQsBkT7nhSMhNhbscOlw2ros+5qMkl5H/gJvBceVWuAMXyo8cBDJ0GlWODR+gOhOr0EZYQ9e
	EKmcoka5InCUpNU6lsAEjQaztehyqzQWj19Lm4MMFQfxsQrQKtSjDub2Nlnh9cX6Xp+66l05JZB
	S0cWfrItRoCKUrdGLFul7He4vgrOO07p9NqhH9WtKx1oAlvVyQYyFOUX8EUPbLPrqMFgIXXaNgd
	FBpumYTJGQ45kgv0zzOGPyTybKRYRsz5bnDvnZ5NAiNgWV9EwG5JqPbgd2+Fu05IV12XE+eB4A4
	B9LBUqWkOfEPRlCxZlp3tt0C86NAmo9jXgH9irQ9RsazwYSrQk4Qx1o7fBK1NWIhmg9Bsnz+LYI
	N9RDbhNa0QPpZ2c
X-Received: by 2002:a17:902:e84c:b0:2e9:6b5b:3db6 with SMTP id d9443c01a7336-2e9a69e93d4mr64066135ad.30.1792398998323;
        Mon, 19 Oct 2026 01:36:38 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e804c11sm35469425ad.22.2026.10.19.01.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 01:36:37 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: skashyap@marvell.com,
	jhasan@marvell.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	mrangankar@marvell.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH] scsi: qedf: bound the unsolicited frame length the firmware reports
Date: Mon, 19 Oct 2026 17:36:22 +0900
Message-ID: <20261019083622.718838-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

qedf_process_unsol_compl() takes the length of an unsolicited FCoE frame
out of the completion queue entry and copies that many bytes out of the BDQ
buffer the firmware put the frame in:

	uint16_t pktlen = cqe->cqe_info.unsolic_info.pkt_len;
	...
	bdq_addr = qedf->bdq[bdq_idx].buf_addr;
	if (!bdq_addr) {
	...
	memcpy(fh, (void *)bdq_addr, pktlen);

The BDQ index and a NULL buffer are both checked; the length is not.  A BDQ
buffer is a QEDF_BDQ_BUF_SIZE coherent DMA allocation and pkt_len is a
__le16, so a frame the firmware reports as longer than 2072 bytes reads up
to 63 KiB past the end of one.  The print_hex_dump() under qedf_dump_frames
a few lines earlier reads the same length out of the same buffer.

The destination is not where this goes wrong.  fc_frame_alloc() is handed
pktlen - sizeof(struct fc_frame_header) and sets the frame length to that
plus the header again, so there is room for exactly pktlen bytes from
fc_frame_header_get() onwards.  Only the source runs off the end.

How much room there is was the driver's decision in the first place: it
advertises QEDF_BDQ_BUF_SIZE to the firmware as rq_buffer_size while
setting up its PF parameters, and allocates every BDQ buffer at exactly
that size. A pkt_len above it contradicts the size the driver itself handed
over, so there is nothing to be gained by trying to honour it.

A lower bound belongs with the upper one, and not merely for tidiness.
payload_len underflows for any length below an FC header, and
fc_frame_alloc() then takes the fc_frame_alloc_fill() path whenever the
result is not a multiple of four.  That passes payload_len + fill on to
_fc_frame_alloc(), where alloc_skb_fclone() and skb_put() both take an
unsigned int and quietly truncate it, so the allocation succeeds at a few
dozen bytes while payload_len stays at 0xffffffff.  The

	memset((char *) fr_hdr(fp) + payload_len, 0, fill);

that follows then writes a byte roughly 4 GiB past the frame.

Drop such a frame rather than clamping it.  A truncated FC frame is not
something libfc can do anything useful with, and the out-of-range cases
this handler already has take the increment_prod exit so that the producer
index still advances and the BDQ entry goes back to the firmware.

Driving the handler with a reported length one byte past a BDQ buffer shows
the copy running off the source.  The harness is a KUnit test that is not
part of this patch; it calls the real handler with the BDQ buffer swapped
for kmalloc() of the same size, because coherent DMA allocations are page
granular and KASAN does not track them:

  BUG: KASAN: slab-out-of-bounds in qedf_process_unsol_compl+0x336/0x10b0
  Read of size 2073 at addr 00000000627ca000 by task kunit_try_catch/25
  
  CPU: 0 UID: 0 PID: 25 Comm: kunit_try_catch Tainted: G                 N  7.3.0-rc7-g58161ead29e5-dirty #3 VOLUNTARY
  Tainted: [N]=TEST
  Stack:
   6133bca2 00000000 00000000 00000000
   ffffff00 6133bca2 61343506 627ca000
   613d1680 600c3c61 62893d00 6004301e
  Call Trace:
   [<600c3c61>] ? dump_stack_lvl+0x5e/0x7a
   [<6004301e>] ? _printk+0x0/0xd7
   [<6004fc1a>] ? print_report+0x14b/0x517
   [<603b68e4>] ? __kmalloc_node_track_caller_noprof+0x1a4/0x3c0
   [<60ada41d>] ? __alloc_skb+0x1bd/0x9c0
   [<603b6740>] ? __kmalloc_node_track_caller_noprof+0x0/0x3c0
   [<6004301e>] ? _printk+0x0/0xd7
   [<609437f6>] ? qedf_process_unsol_compl+0x336/0x10b0
   [<603e0d0b>] ? kasan_report+0x11b/0x160
   [<609437f6>] ? qedf_process_unsol_compl+0x336/0x10b0
   [<60932a10>] ? qedf_test_pool_alloc+0x0/0x30
   [<603e1cc0>] ? kasan_check_range+0x0/0x1c0
   [<603e1e0e>] ? kasan_check_range+0x14e/0x1c0
   [<603e2891>] ? __asan_memcpy+0x31/0x80
   [<609437f6>] ? qedf_process_unsol_compl+0x336/0x10b0
   [<600e147d>] ? os_nsecs+0x2d/0x40
   [<60944ec1>] ? qedf_unsol_oob_2073+0xc1/0x260
   [<602453a0>] ? ktime_get_ts64+0x0/0x2c0
   [<6071e2ac>] ? kunit_try_run_case+0x1bc/0x310
   [<6071e0f0>] ? kunit_try_run_case+0x0/0x310
   [<601d9b30>] ? sched_setscheduler_nocheck+0x180/0x220
   [<600e0e70>] ? um_set_signals+0x0/0x60
   [<600e0e70>] ? um_set_signals+0x0/0x60
   [<6016021d>] ? __kthread_parkme+0xdd/0x1c0
   [<6071e0f0>] ? kunit_try_run_case+0x0/0x310
   [<60724370>] ? kunit_generic_run_threadfn_adapter+0x0/0x100
   [<607243ec>] ? kunit_generic_run_threadfn_adapter+0x7c/0x100
   [<6016649e>] ? kthread+0x36e/0x560
   [<60166130>] ? kthread+0x0/0x560
   [<600c80de>] ? new_thread_handler+0xce/0x130
  
  The buggy address belongs to the object at 00000000627ca000
   which belongs to the cache kmalloc-4k of size 4096
  The buggy address is located 0 bytes inside of
   allocated 2072-byte region [00000000627ca000, 00000000627ca818)
  
  The buggy address belongs to the physical page:
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x27c8
  head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
  flags: 0x40(head|zone=0)
  page_type: f5(slab)
  raw: 0000000000000040 0000000061802140 0000000000000122 0000000000000000
  raw: 0000000000000000 0000000000040004 00000000f5000000
  head: 0000000000000040 0000000061802140 0000000000000122 0000000000000000
  head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000003
  head: 000000009f28b3c1 00000000ffffffff 00000000ffffffff 0000000000000000
  head: 0000000000000000 00000000ffffffff
  page dumped because: kasan: bad access detected
  
  Memory state around the buggy address:
   00000000627ca700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   00000000627ca780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >00000000627ca800: 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc
                              ^
   00000000627ca880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   00000000627ca900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ==================================================================

Reported lengths of 4097 and 65535 report the same way at their own sizes.
A reported length of 23 takes the kernel down instead, with
fc_frame_alloc_fill() and qedf_process_unsol_compl() the two frames above
memset_orig in the trace and payload_len still in RBX:

  RIP: 0033:memset_orig+0x81/0xaf
  RSP: 00000000628c3d68  EFLAGS: 00010246
  RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000161a2439f
  RBP: 00000000628a2c00 R08: 0000000000000001 R09: 0000000000000007
  R10: 0000000161a2439f R11: 00000000609128c0 R12: 0000000000000001
  R13: 0000000062740608 R14: 00000000611f1d40 R15: 00000000628c8000
  Kernel panic - not syncing: Segfault with no mm

With the length checked, the three over-reads and the panic all go away,
while a frame that fills a BDQ buffer exactly and an ordinary small one are
both still handed to libfc.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index a120f0e37a644..807202f575499 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2504,6 +2504,15 @@ void qedf_process_unsol_compl(struct qedf_ctx *qedf, uint16_t que_idx,
 		  le32_to_cpu(p_bd_info->opaque.fcoe_opaque.lo),
 		  qedf->bdq_prod_idx, pktlen);
 
+	/* The firmware can only have filled the buffer it was given. */
+	if (pktlen < sizeof(struct fc_frame_header) ||
+	    pktlen > QEDF_BDQ_BUF_SIZE) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "pkt_len %u out of range, dropping unsolicited frame.\n",
+			 pktlen);
+		goto increment_prod;
+	}
+
 	bdq_idx = le32_to_cpu(p_bd_info->opaque.fcoe_opaque.lo);
 	if (bdq_idx >= QEDF_BDQ_SIZE) {
 		QEDF_ERR(&(qedf->dbg_ctx), "bdq_idx is out of range %d.\n",
