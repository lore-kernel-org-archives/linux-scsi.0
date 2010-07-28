From: Steven Whitehouse <steve@chygwyn.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 10:28:55 +0100
Message-ID: <1280309335.2502.14.camel@localhost>
References: <20100727165627.GA474@lst.de>
	 <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com>
	 <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de>
	 <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de>
	 <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de>
	 <4C4FF42C.1050701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from c.painless.aaisp.net.uk ([81.187.30.53]:44840 "EHLO
	c.painless.aaisp.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0G1Jpz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 05:45:55 -0400
In-Reply-To: <4C4FF42C.1050701@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp

Hi,

On Wed, 2010-07-28 at 11:11 +0200, Hannes Reinecke wrote:
> Christoph Hellwig wrote:
> > On Wed, Jul 28, 2010 at 10:58:30AM +0200, Tejun Heo wrote:
> >> I see.  It probably would be good to have ordering requirements
> >> carried in the bio / request, so that filesystems can mix and match
> >> barriers of different strengths as necesasry.  As you seem to be
> >> already working on it, are you interested in pursuing that direction?
> > 
> > I've been working on that for a while, but it got a lot more urgent
> > as there's been an application hit particularly hard by the barrier
> > semantics on cache less devices and people started getting angry
> > about it.  That's why fixing this for cache less devices has become
> > a higher priority than solving the big picture.
> > 
> My idea here is to use the 'META' request tag to emulate FUA.
> From what I've seen, the META request tag is only ever used on gfs2,
> and even that is using is for tagging journal requests on write.
> 
> Once you've tagged all bios/requests with correctly it trivial to
> set the FUA bit.
> 
> Cheers,
> 
> Hannes

The META tag is used in GFS2 for tagging all metadata whether to the
journal or otherwise. Is there some reason why this isn't correct? My
understanding was that it was more or less an informational hint to
those watching blktrace,

Steve.


