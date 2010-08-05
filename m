From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 5 Aug 2010 19:07:55 +0200
Message-ID: <20100805170755.GA10728@lst.de>
References: <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net> <20100805133225.GF29846@think> <4C5AD01F.2060602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:38294 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab0HERI2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Aug 2010 13:08:28 -0400
Content-Disposition: inline
In-Reply-To: <4C5AD01F.2060602@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Thu, Aug 05, 2010 at 04:52:15PM +0200, Hannes Reinecke wrote:
> I still think that implementing ordered tags is the correct way of
> doing things, implementation details notwithstanding.
> 
> It looks better conceptually than using FUA, and would be easier
> from the request-queue side of things.

Sorry, but ordered tags are in no way a replacement for the FUA bit.
Admittedly the current barrier semantics are confusing because they
mix up to only minimally related things:

 a) cache flushing
 b) ordering

a) is what we really need from the filesystems point of view.  b) is
something all our filesystems can do ourself.  We could use ordered
tags to offload it, and I'd be happy if someone could prove that
we're getting speedups from it, but it certainly does not replace a).

With enough outstanding tags, be that using ordered tags or software
managed ordering we could fill the disk enough that we don't need to
write cache, but again that'll need a lot of benchmarking.
