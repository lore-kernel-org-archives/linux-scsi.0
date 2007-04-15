From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/4] bidi support: block layer bidirectional io.
Date: Sun, 15 Apr 2007 20:17:12 +0300
Message-ID: <46225E18.7070404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:60318 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753179AbXDORRy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Apr 2007 13:17:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux-ide <linux-ide@vger.kernel.org>, Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org, bharrosh@panasas.com

Following are 4 (large) patches for support of bidirectional
block I/O in kernel. (not including SCSI-ml or iSCSI)

The submitted work is against linux-2.6-block tree as of
2007/04/15, and will only cleanly apply in succession.

The patches are based on the RFC I sent 3 months ago. They only
cover the block layer at this point. I suggest they get included
in Morton's tree until they reach the kernel so they can get
compiled on all architectures/platforms. There is still a chance
that architectures I did not compile were not fully converted.
(FWIW, my search for use of struct request members failed to find
them). If you find such a case, please send me the file
name and I will fix it ASAP.

Patches summary:
1. [PATCH 1/4] bidi support: request dma_data_direction
	- Convert REQ_RW bit flag to a dma_data_direction member like in SCSI-ml use.
	- removed rq_data_dir() and added other APIs for querying request's direction.
	- fix usage of rq_data_dir() and peeking at req->cmd_flags & REQ_RW to using
	  new api.
	- clean-up bad usage of DMA_BIDIRECTIONAL and bzero of none-queue requests,
	  to use the new blk_rq_init_unqueued_req()

2. [PATCH 2/4] bidi support: fix req->cmd == INT cases
	- Digging into all these old drivers, I have found traces of past life
	  where request->cmd was the command type. This patch fixes some of these
	  places. All drivers touched by this patch are clear indication of drivers
	  that were not used for a while. Should we removed them from Kernel? 
	  These Are:
		drivers/acorn/block/fd1772.c, drivers/acorn/block/mfmhd.c,
		drivers/block/nbd.c, drivers/cdrom/aztcd.c, drivers/cdrom/cm206.c
		drivers/cdrom/gscd.c, drivers/cdrom/mcdx.c, drivers/cdrom/optcd.c
		drivers/cdrom/sjcd.c, drivers/ide/legacy/hd.c, drivers/block/amiflop.c

2. [PATCH 3/4] bidi support: request_io_part
	- extract io related fields in struct request into struct request_io_part
	  in preparation to full bidi support.
	- new rq_uni() API to access the sub-structure. (Please read below comment
	  on why an API and not open code the access)
	- Convert All users to new API.

3. [PATCH 4/4] bidi support: bidirectional block layer
	- add one more request_io_part member for bidi support in struct request.
	- add block layer API functions for mapping and accessing bidi data buffers
	  and for ending a block request as a whole (end_that_request_block())

--------------------------------------------------------------------------------------------
Developer comments:

patch 1/4: Borrow from struct scsi_cmnd use of enum dma_data_direction. Further work (in
progress) is the removal of the corresponding member from struct scsi_cmnd and converting
all users to directly access rq_dma_dir(sc->req).

patch 3/4: The reasons for introducing the rq_uni(req) API rather than directly accessing
req->uni are:

* WARN(!bidi_dir(req)) is life saving when developing bidi enabled paths.  Once we, bidi
  users, start to push bidi requests down the kernel paths, we immediately get warned of
  paths we did not anticipate. Otherwise, they will be very hard to find, and will hurt
  kernel stability.

* A cleaner and saner future implementation could be in/out members rather than
  uni/bidi_read.  This way the dma_direction member can deprecated and the uni sub-
  structure can be maintained using a pointer in struct req.
  With this API we are free to change the implementation in the future without
  touching any users of the API. We can also experiment with what's best. Also, with the
  API it is much easier to convert uni-directional drivers for bidi (look in
  ll_rw_block.c in patch 4/4).

* Note, that internal uses inside the block layer access req->uni directly, as they will
  need to be changed if the implementation of req->{uni, bidi_read} changes.




