From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Mon, 18 Sep 2006 14:10:56 -0500
Message-ID: <1158606656.6390.1.camel@mulgrave.il.steeleye.com>
References: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com>
	 <20060918184712.GA17670@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45252 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751604AbWIRTLH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 15:11:07 -0400
In-Reply-To: <20060918184712.GA17670@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ed Lin <ed.lin@promise.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Mon, 2006-09-18 at 19:47 +0100, Christoph Hellwig wrote:
> these two calls look wrong here. scsi_activate_tcq is supposed to be
> called from slave_configure.  similarly tagged_supported is probably
> going to be overwriten as part of the scanning process, but you already
> set it in slave_configure anyway.

I agree in principle.  However, the driver is doing tags as indexes into
its own internal firmware sequencer.  Thus, the first inquiry that comes
down has to go into the sequencer with a tag.  Hence this charade to
turn on tagging in slave_alloc.


> > +     if (unlikely(tag >= host->can_queue))
> >               return SCSI_MLQUEUE_HOST_BUSY;
> 
> Do we really need this check?  I'm pretty sure the block layer never
> hands out tags bigger than what you told it to with scsi_activate_tcq.

Probably not.

James


