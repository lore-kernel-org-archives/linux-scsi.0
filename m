From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/19] clean ups on the drivers
Date: Sat, 12 May 2007 19:05:42 +0900 (JST)
Message-ID: <20070512190534B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55716 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbXELKHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:07:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

Hi,

This patchset cleans up 9 scsi drivers, ipr, ibmvscsi, fusion,
aic7xxx, qla2xxx, lpfc, aacraid, BusLogic and aic79xxx.

- remove the now unnecessary map_single path.

- convert to new accessors for the scsi data buffer, the sg lists,
bufferlen, resid.

There are two patches for each driver, removing the non-use-sg code
and converting to use the accessors.

You can find the new accessors in the first patch. It includes
scsi_dma_map/unmap (calling dma_map/unmap_sg) that Christoph proposed
long ago and several macros (like scsi_for_each_sg, scsi_bufflen, etc)
to isolate the driver from the sg lists and the parameters.

This is in preparation for chaining sg lists and bidirectional
requests and possibly the mid-layer dma mapping, which has been
discussed. scsi_for_each_sg will be converted to use Jens' chaining sg
lists (for_each_sg) when it's ready. Jens, sorry about overlapping
with the chaining sg lists patches for the SCSI drivers.

I tested the patches lightly, booting machines and performing some
I/Os for few minutes.

This patchset can be applied cleanly to the scsi-misc or Linus' tree.

If this looks ok, I try to clean up the rest of the drivers (though I
can only do compile tests).
