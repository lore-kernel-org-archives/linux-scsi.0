From: David Miller <davem@davemloft.net>
Subject: Re: Sparc ESP problem with blk-mq
Date: Sat, 18 Oct 2014 13:31:32 -0400 (EDT)
Message-ID: <20141018.133132.1505060820853861420.davem@davemloft.net>
References: <20141015.165324.1768019967735260346.davem@davemloft.net>
	<alpine.LRH.2.11.1410160942150.13273@adalberg.ut.ee>
	<20141017.155612.266274322805506383.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20141017.155612.266274322805506383.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: mroos@linux.ee
Cc: hch@infradead.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph, I don't see how the new tagging code with blk-mq can
be providing compatible behavior for existing SCSI drivers.

Do you know that scsi_populate_tag_msg() is always going to provide a
tag?  Unconditionally, every time, when using blk-mq?

This is because the test:

	if (blk_rq_tagged(req))

is always true if a blk-mq context is attached to the request.

And every scsi request will have a blk-mq context.

scsi_execute() {
	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
	blk_get_request() {
		if (q->mq_ops)
			return blk_mq_alloc_request(q, rw, gfp_mask, false);
		blk_mq_alloc_request() {
			rq = __blk_mq_alloc_request(&alloc_data, rw);
			__blk_mq_alloc_request() {
				blk_mq_rq_ctx_init() {
					rq->mq_ctx = ctx;

and therefore:

#define blk_rq_tagged(rq) \
	((rq)->mq_ctx || ((rq)->cmd_flags & REQ_QUEUED))

will always evaluate to true.

This cannot work, because we can't put a TAG into the initial SCSI bus
scanning messages for example.

It is a common pattern in SCSI drivers to see if scsi_populate_tag_msg()
succeeds and gives us a non-zero tag, to determine whether to enable
DISCONNECT, whether to send the TAG in the initial MESSAGE_OUT phase
after selection, etc.

It has to be conditional upon the SCSI tcq state, perhaps a test on
whether the queue_depth has been set to a non-zero value.

scsi_populate_tag_msg() is giving out tags even when
sdev->tagged_supported is false, which is bogus.
