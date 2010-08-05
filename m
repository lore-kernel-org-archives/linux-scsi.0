From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 5 Aug 2010 19:09:33 +0200
Message-ID: <20100805170933.GB10728@lst.de>
References: <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:38305 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758854Ab0HERKA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Aug 2010 13:10:00 -0400
Content-Disposition: inline
In-Reply-To: <4C5AB89C.5080700@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Thu, Aug 05, 2010 at 05:11:56PM +0400, Vladislav Bolkhovitin wrote:
> Chris Mason, on 08/02/2010 09:39 PM wrote:
> >I regret putting the ordering into the original barrier code...it
> >definitely did help reiserfs back in the day but it stinks of magic and
> >voodoo.
> 
> But if the ordering isn't in the common (block) code, how to implement 
> the "hardware offload" for ordering, i.e. ORDERED commands, in an 
> acceptable way?

Right now we have no working implementation of actually using ordered
tags for a storage device in Linux.  There's very little need for common
code in that implementation - basically we just need flag in the bio /
request to make this one an ordered tag in addition to the existing
reordering preventing in the block queue.

