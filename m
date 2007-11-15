From: "Igor A. Nesterov" <igor.nesterov@usa.net>
Subject: rounding dxfer_len to 512 bytes boundary in sg.c
Date: Thu, 15 Nov 2007 10:38:03 -0500
Message-ID: <1195141083.2607.203.camel@potomac.tworiverlabs.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmsout02.mbox.net ([165.212.64.32]:34382 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763407AbXKOPnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 10:43:20 -0500
Received: from cmsout02.mbox.net (cmsout02.mbox.net [165.212.64.32])
	by cmsout02.mbox.net (Postfix) with ESMTP id 5665E5BF6
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 15:38:10 +0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

dxfer_len value provided to SG_IO ioctl as a part of sg_io_hdr_t
structure is rounded up to the nearest 512 bytes boundary just before
scatterlist allocation in sg_build_indirect()

  /* round request up to next highest SG_SECTOR_SZ byte boundary */
        blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);

I do not understand why is this. From the memory handling point of view
it seems meaningless because kernel memory for scatterlist is being
allocated in pages anyway. And from the I/O point of view it results
into buggy behavior if dxfer_len is bigger then def_reserved_size and is
not multiple of 512. Roughly, there are two cases handled a little bit
different in sg.c

1) dxfer_len <= def_reserved_size (32k by default)

in this case sg_start_req() uses preallocated reserved buffer, and calls
sg_link_reserve(), which truncates the length of the last scatterlist
element to match original dxfer_len value. Everything goes fine.

2) dxfer_len > def_reserved_size || reserved buffer is in use

in this case sg_start_req() allocates new scatterlist buffer with
sg_build_indirect() and does NOT truncate the last scatterlist element
leaving it rounded up to the nearest 512k boundary. Following IO
operation is screwed up. First, operation is issued to device with a
transfer length different from what meant by SG_IO originator. Sometimes
it does not matter, sometimes it does. Even if IO operation is some sort
of read (like read from a tape) and a device responds correctly,
residual value from scsi mid-layer is calculated based on rounded up IO
transfer length, and hence incorrect. When returned back to SG_IO
originator, it creates a false impression that the actual amount of data
is less then actually read. For example, when reading a 0x8002-bytes
tape block with dxfer_len = 0x8002, the actual IO operation issued to
tape drive has a transfer length 0x8200, and residual length after the
operation is completed is 510. So the SG_IO originator has a full
impression that the actual amount of data read is 0x8002 - 510.

There are different ways to fix this problem. For example, one might
amend residual length value returned to user, or the last scatterlist
element length can be fixed. But the first question is why is that
rounding being done in the first place? I have fixed the problem by
removing it, and nothing looks broken. What do maintainers think?

diff -urp a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c 2007-07-08 19:32:17.000000000 -0400
+++ b/drivers/scsi/sg.c 2007-11-14 14:54:53.000000000 -0500
@@ -1846,8 +1846,7 @@ sg_build_indirect(Sg_scatter_hold * schp
                return -EFAULT;
        if (0 == blk_size)
                ++blk_size;     /* don't know why */
-/* round request up to next highest SG_SECTOR_SZ byte boundary */
-       blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
+
        SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d,
blk_size=%d\n",
                                   buff_size, blk_size));
 



