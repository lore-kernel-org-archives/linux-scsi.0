From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi/arcmsr: Add timeout module parameter
Date: Tue, 19 Aug 2014 11:07:54 -0700
Message-ID: <20140819180754.GB16742@infradead.org>
References: <alpine.GSO.2.00.1408022058560.609@hutcs>
 <20140804111552.GA2494@infradead.org>
 <alpine.GSO.2.00.1408051559160.13057@hutcs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaHSSH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 14:07:56 -0400
Content-Disposition: inline
In-Reply-To: <alpine.GSO.2.00.1408051559160.13057@hutcs>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ari Sundholm <asundhol@cs.hut.fi>
Cc: linux-scsi@vger.kernel.org, Ching Huang <ching2048@areca.com.tw>

On Tue, Aug 05, 2014 at 04:10:08PM +0300, Ari Sundholm wrote:
> 
> On Mon, 4 Aug 2014, Christoph Hellwig wrote:
> 
> > To modify the timeout on a queue please use blk_queue_rq_timeout in
> > the slave_configure method instead of poking directly into the block
> > timer, which won't work e.g. for the blk-mq path.
> 
> I see. It seems the way the driver Areca offers on its download page does 
> this is wrong, then, as all I did was I ported the feature from there.
>  
> > But this really needs an explanation on why you'd need a configurable
> > timeout to start with.
> 
> A colleague of mine has experienced problems with disks not supporting 
> TLER performing lengthy error recovery, hitting a timeout. He has 
> mitigated this problem by configuring the timeout to be long enough to 
> allow for the error recovery to finish. And again, the driver offered by 
> Areca supports this feature, so it seems they have their reasons as well.

Can you test this patch:

http://git.infradead.org/users/hch/scsi-queue.git/commitdiff/3a7fcf9e5f57469fab78d6b6db81fbef6fa48a0d

which is part of the latest Areca code drop?  I don't really like the
timeout parameter, but if there's no better work around for you we'll
probablyneed to merge something.  In that case I'd love a patch ontop of
the branch that the above patches is in, which used the timeout
manipulation method I mentioned in my previous mail.

