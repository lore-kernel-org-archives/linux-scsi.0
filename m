From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Tue, 27 Jul 2010 21:43:05 +0200
Message-ID: <20100727194305.GC8973@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <1280256165.2833.238.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:50044 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab0G0Tne (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 15:43:34 -0400
Content-Disposition: inline
In-Reply-To: <1280256165.2833.238.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, tj@kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Tue, Jul 27, 2010 at 01:42:45PM -0500, James Bottomley wrote:
> I hope not ... I hope that if the drive reports write through or no
> cache that we don't enable (flush) barriers by default.

drivers/scsi/sd.c:sd_revalidate_disk()

	if (sdkp->WCE)
		ordered = sdkp->DPOFUA
			? QUEUE_ORDERED_DRAIN_FUA : QUEUE_ORDERED_DRAIN_FLUSH;
	else
		ordered = QUEUE_ORDERED_DRAIN;

	blk_queue_ordered(sdkp->disk->queue, ordered);

Documentation/block/barrier.txt:

QUEUE_ORDERED_DRAIN
        Requests are ordered by draining the request queue and cache
        flushing isn't needed.

        Sequence: drain => barrier


> The problem case is NV cache arrays (usually an array with a battery
> backed cache).  There's no consistency issue since the array will
> destage the cache on power fail but it reports a write back cache and we
> try to use barriers.  This is wrong because we don't need barriers for
> consistency and they really damage throughput.

The arrays I have access to (various Netapp, IBM and LSI) never report
write cache enabled.  I've only heard about the above issue from
historic tales.

