From: Christoph Hellwig <hch@lst.de>
Subject: RFC: struct request cleanups
Date: Fri, 17 Apr 2015 22:37:15 +0200
Message-ID: <1429303042-12078-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbbDQUiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 16:38:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

The first 5 patches move the magic IDE request types into the old IDE
driver to keep the core block code clean of them.  Those are basically
ready to merge, just like the 6th one which is a cleanup on it's own.

The real RFC is the last one which allocates the block_pc specific
data separately in the callers instead of bloating every struct
request with it.  I always hated what we did, but with the upcoming
split of nvme into transports and command sets we'll need a NVME
equivalent of BLOCK_PC, and as NVMe was designed by crackmonkeys
dreaming of an ATA controller the "command block" for NVME is even
bigger than what we have to deal with in SCSI.

Note that the old IDE driver doesn't compile with the last patch
yet as there are major nightmares to sort out, and BLOCK_PC passthrough
with dm-multipath doesn't work yet either.  If I get some general
concensus on the approach I'll fix those of course.

