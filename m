From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 10:50:48 +0200
Message-ID: <20100728085048.GA8884@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:57275 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab0G1IvQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 04:51:16 -0400
Content-Disposition: inline
In-Reply-To: <4C4FECFE.9040509@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Wed, Jul 28, 2010 at 10:40:30AM +0200, Tejun Heo wrote:
> The barrier machinery can be easily changed to drop the DRAIN and
> ordering stages,

Maybe you're smarted than me, but so far I had real trouble with that.
The problem is that we actually still need the drain colouring to
keep out other "barrier" requests given that we have the state for
the pre- and post- flush requests in struct request.  This and dealing
is where I'm still struggling with my the even more relaxed barriers
I had been working on for a while.  They work perfectly on devices
supporting the FUA bit and nothing inbetween.

> so all we need to do is an interface for the
> filesystem to tell the barrier implementation that it will take care
> of ordering itself and barriers (a bit of misnomer but well it isn't
> too bad) can be handled as FUA writes which get executed after all
> previous commansd are committed to NV media.  On write-through device
> w/ FUA support, it will simply become a FUA write.

If the device is write through there is not need for the FUA bit to
start with.

> On a device w/
> write back cache and w/o FUA support, it will become flush, write,
> flush sequence.  On a device inbetween, flush, FUA write.  Would that
> be enough for filesystems?  If so, the transition would be pretty
> painless, md already splits barriers correctly and the modification is
> confined to barrier implementation itself and filesystem which want to
> use more relaxed ordering.

The above is a good start.  But at least for XFS we'll eventually
want writes without the pre flush, too.  We'll only need the pre-flush
for a specific class of log writes (when we had an extending write or
need to push the log tail), otherwise plain FUA semantics are enough.
Just going for the pre-flush / FUA semantics as a start has the
big advantage of making the transition a lot simpler, though.


