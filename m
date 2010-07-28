From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 10:24:47 +0200
Message-ID: <20100728082447.GA7668@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:43479 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0G1IZR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 04:25:17 -0400
Content-Disposition: inline
In-Reply-To: <4C4FE58C.8080403@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Wed, Jul 28, 2010 at 10:08:44AM +0200, Tejun Heo wrote:
> What I don't get here is if filesystems order requests already by
> waiting for completions why do they use barriers at all?  All they
> need is flush request after all the preceding requests are known to be
> complete.

In fact for XFS I'm working on doing some bit of that, too, but it's not
actually that easy.  For one we don't actually have a non-barrier cache
flush primitive currently, although the conversion of cache flushes
to FS requests and the addition of REQ_FLUSH helps greatly with it.
Second the usual primitive for log writes actually is a WRITE_FUA,
that is a WRITE that needs to go to disk, without consequences to
the rest of the cache.  I've stared implementing that, including
proper emulation for devices only supporting cache flushes but got
stuck with the barrier machinery.
