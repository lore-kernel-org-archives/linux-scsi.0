From: Jeremy Higdon <jeremy@sgi.com>
Subject: [PATCH] 2.6.9-rc1  drivers/scsi/libata-core.c
Date: Wed, 25 Aug 2004 21:47:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040826044751.GA125794@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:61843 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267578AbUHZEsS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 00:48:18 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jgarzik@pobox.com

We seem to have found an overflow problem in libata-core.c.
We were trying to DMA to the address range 0xffff8000-0xffffbfff.

In the original version of the code, given that address and
count (0xffff8000 and 0x4000), the variable "boundary" would be
set to 0, causing len to be set to 0x8000 (which is greater than
sg_len).  Then at the bottom of the loop, sg_len would be set
to 0xffffc000 (0x4000 - 0x8000), which would then cause the
loop never to terminate (until much of memory was scribbled
over or the kernel died).

The code below should be functionally identical, but not be
subject to the same overflow problem (boundary needs to be a
u33).

Signed-off-by: jeremy@sgi.com

===== drivers/scsi/libata-core.c 1.94 vs edited =====
--- 1.94/drivers/scsi/libata-core.c	2004-08-15 23:35:24 -07:00
+++ edited/drivers/scsi/libata-core.c	2004-08-25 21:10:45 -07:00
@@ -1836,7 +1836,7 @@
 
 	idx = 0;
 	for (nelem = qc->n_elem; nelem; nelem--,sg++) {
-		u32 addr, boundary;
+		u32 addr, offset;
 		u32 sg_len, len;
 
 		/* determine if physical DMA addr spans 64K boundary.
@@ -1847,10 +1847,10 @@
 		sg_len = sg_dma_len(sg);
 
 		while (sg_len) {
-			boundary = (addr & ~0xffff) + (0xffff + 1);
+			offset = addr & 0xffff;
 			len = sg_len;
-			if ((addr + sg_len) > boundary)
-				len = boundary - addr;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
 
 			ap->prd[idx].addr = cpu_to_le32(addr);
 			ap->prd[idx].flags_len = cpu_to_le32(len & 0xffff);
