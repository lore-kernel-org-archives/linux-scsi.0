From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 10:40:30 +0200
Message-ID: <4C4FECFE.9040509@kernel.org>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:50449 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab0G1Ik4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 04:40:56 -0400
In-Reply-To: <20100728082447.GA7668@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

Hello,

On 07/28/2010 10:24 AM, Christoph Hellwig wrote:
> In fact for XFS I'm working on doing some bit of that, too, but it's not
> actually that easy.  For one we don't actually have a non-barrier cache
> flush primitive currently, although the conversion of cache flushes
> to FS requests and the addition of REQ_FLUSH helps greatly with it.
> Second the usual primitive for log writes actually is a WRITE_FUA,
> that is a WRITE that needs to go to disk, without consequences to
> the rest of the cache.  I've stared implementing that, including
> proper emulation for devices only supporting cache flushes but got
> stuck with the barrier machinery.

The barrier machinery can be easily changed to drop the DRAIN and
ordering stages, so all we need to do is an interface for the
filesystem to tell the barrier implementation that it will take care
of ordering itself and barriers (a bit of misnomer but well it isn't
too bad) can be handled as FUA writes which get executed after all
previous commansd are committed to NV media.  On write-through device
w/ FUA support, it will simply become a FUA write.  On a device w/
write back cache and w/o FUA support, it will become flush, write,
flush sequence.  On a device inbetween, flush, FUA write.  Would that
be enough for filesystems?  If so, the transition would be pretty
painless, md already splits barriers correctly and the modification is
confined to barrier implementation itself and filesystem which want to
use more relaxed ordering.

Thanks.

-- 
tejun
