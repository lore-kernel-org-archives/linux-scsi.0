From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 5 Aug 2010 09:32:25 -0400
Message-ID: <20100805133225.GF29846@think>
References: <4C4FE58C.8080403@kernel.org>
 <20100728082447.GA7668@lst.de>
 <4C4FECFE.9040509@kernel.org>
 <20100728085048.GA8884@lst.de>
 <4C4FF136.5000205@kernel.org>
 <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100802173930.GP16630@think>
 <4C5AB89C.5080700@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:26977 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073Ab0HENep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 09:34:45 -0400
Content-Disposition: inline
In-Reply-To: <4C5AB89C.5080700@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Thu, Aug 05, 2010 at 05:11:56PM +0400, Vladislav Bolkhovitin wrote:
> Chris Mason, on 08/02/2010 09:39 PM wrote:
> >I regret putting the ordering into the original barrier code...it
> >definitely did help reiserfs back in the day but it stinks of magic and
> >voodoo.
> 
> But if the ordering isn't in the common (block) code, how to
> implement the "hardware offload" for ordering, i.e. ORDERED
> commands, in an acceptable way?
> 
> I believe, the decision was right, but the flags and magic requests
> based interface (and, hence, implementation) was wrong. That's it
> which stinks of magic and voodoo.

The interface definitely has flaws.  We didn't expand it because James
popped up with a long list of error handling problems.  Basically how
do the hardware and the kernel deal with a failed request at the start
of the chain.  Somehow the easy way of failing them all turned out to be
extremely difficult.

Even if that part had been refined, I think trusting the ordering down
to the lower layers was a doomed idea.  The list of ways it could go
wrong is much much longer (and harder to debug) than the list of
benefits.

With all of that said, I did go ahead and benchmark real ordered tags
extensively on a scsi drive in the initial implementation.  There was
very little performance difference.

-chris

