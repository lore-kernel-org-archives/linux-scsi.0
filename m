From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Tue, 27 Jul 2010 21:37:00 +0200
Message-ID: <20100727193700.GA8973@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:56342 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0G0Thc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 15:37:32 -0400
Content-Disposition: inline
In-Reply-To: <20100727175418.GF6820@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, tj@kernel.org, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Tue, Jul 27, 2010 at 07:54:19PM +0200, Jan Kara wrote:
>   OK, let me understand one thing. So the storage arrays have some caches
> and queues of requests and QUEUE_ORDERED_DRAIN forces them flush all this
> to the platter, right?

Not quite.  QUEUE_ORDERED_DRAIN does not interact with the target at
all, it's entirely initiator (Linux) side.  What it does it to make
sure we drain the whole queue in the I/O scheduler (elevator) and in
flight to the device (command queueing) by waiting for all I/O before
the barrier to finish, the issue the barrier command and only then
allow any newly arriving requests to proceed.

>   So can it happen that they somehow lose the requests that were already
> issued to them (e.g. because of power failure)?

We can lose the requests already on the wire, but not completed yet.
That's why log write wait for all preceding log writes (or things like
the I/Os required to push the tail) and fsync waits for all I/O
completions manually.

