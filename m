From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] better discard support
Date: Thu, 17 Sep 2009 12:25:36 -0400
Message-ID: <20090917162536.815743395@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZIQQbC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 12:31:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, matthew@wil.cx, dwmw2@infradead.org
Cc: linux-scsi@vger.kernel.org

Trying to make progress on discard again.  This is mostly aimed at the
batched discard and SCSI arrays, but the ATA work should also fit in.

Since last time the first two patches got merged in mainline so the
patch series is a bit smaller now.  The first one is new and based on
a patch from Willy - we now remove the prepare_discard function, and instead
pass the discard request down as normal FS request.  To make that
actually work nicely with the block layer we have to allocate the payload
in the caller.  From the layering POV that makes a lot more sense as that
is where the payload is allocated for all other request, and in practice
it works because the single page and single sector is enough for all
implementations that we care about now.  But it could become quite
nasty if we get an implementation that doesn't fir into this scheme.

Second patch is the separate limit for the length of discard requests
as they can and should be much larger than normal I/O requests.

Patch 3 and 4 are only included for reference to show a working setup
wit hthe block bits.  The SD patch will need quite a bit of work to
look at the unmap limits that are now in SPC.
