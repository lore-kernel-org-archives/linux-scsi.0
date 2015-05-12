From: Christoph Hellwig <hch@infradead.org>
Subject: Re: hosts resets in SRP and the rest of the world, was: Re: [PATCH
 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Tue, 12 May 2015 11:02:25 -0700
Message-ID: <20150512180225.GA28898@infradead.org>
References: <554204D7.9050204@dev.mellanox.co.il>
 <55420AEA.10108@sandisk.com>
 <20150430172516.GA19200@infradead.org>
 <5549E600.9050208@sandisk.com>
 <20150511075058.GA18483@infradead.org>
 <55506E46.2060103@sandisk.com>
 <20150511093130.GA30217@infradead.org>
 <55508B3B.9080806@sandisk.com>
 <20150511115029.GB32341@infradead.org>
 <5551BEAB.5080803@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbbELSCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 14:02:43 -0400
Content-Disposition: inline
In-Reply-To: <5551BEAB.5080803@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Tue, May 12, 2015 at 10:49:47AM +0200, Bart Van Assche wrote:
> Thanks for the feedback. However, I'm still wondering what will happen if
> blk_abort_request() causes e.g. blk_rq_unmap_user() or blk_update_request()
> to be called while mq_ops->queue_rq() or q->request_fn() is still in
> progress ?

We will never call the blk-mq ->timeout handler before the LLDD
called blk_mq_start_request, which the driver should only call once it's
ready to handle ->timeout.

For normal blk-mq drivers this works fine, but for SCSI we still have
the problem that we need'd really need to move this into the
->queuecommand function to be fully safe against the driver internal
data structures, the current version only helps with the SCSI level
structures.
