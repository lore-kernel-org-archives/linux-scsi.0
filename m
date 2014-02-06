From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/15] scsi: initial blk-mq support
Date: Thu, 6 Feb 2014 08:16:15 -0800
Message-ID: <20140206161615.GA16916@infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
 <20140205124154.337539740@bombadil.infradead.org>
 <52F349F9.7090509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaBFQQ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 11:16:27 -0500
Content-Disposition: inline
In-Reply-To: <52F349F9.7090509@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Thu, Feb 06, 2014 at 10:38:17AM +0200, Sagi Grimberg wrote:
> Both you and Nic offer a single HW queue per sdev.
> I'm wandering if that should be the LLD's decision (if chooses to
> use multiple queues)?
> 
> Trying to understand how LLDs will fit in a way they exploit
> multi-queue and actually
> maintain multiple queues. SRP/iSER for example maintain a single
> queue per connection
> (or session in iSCSI). Now with multi-queue all requests of that
> shost will eventually
> boil-down to posting on a single queue which might transition the
> bottleneck to the LLDs.
> 
> I noticed virtio_scsi implementation is choosing a queue per command
> based on current
> processor id without any explicit mapping (unless I missed it).
> 
> I guess my question is where do (or should) LLDs plug-in to this mq scheme?

Just using blk-mq helps with lock contention and cacheline issues, while
being conceptually simple, that's why it's the priority.  See the
proposal I sent before the patch series for more details.

That being said if you have simple enough patches for real multiqueue
support I'd be more than happy to carry them along.
