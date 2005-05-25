From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Thu, 26 May 2005 01:40:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0505252201270.6612@poirot.grange>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave>
 <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave>
 <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com>
 <20050524075953.GY9855@suse.de> <4292E3EE.10006@pobox.com>
 <20050524085133.GZ9855@suse.de> <42935852.2020300@pobox.com>
 <20050525092952.GA7005@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050525092952.GA7005@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 25 May 2005, Jens Axboe wrote:

> On Tue, May 24 2005, Jeff Garzik wrote:
> > Jens Axboe wrote:
> > >I agree, it's a cleaner approach, with the rq being a container for
> > >generel messages as well not just SCSI commands. The one missing piece
> > >for that was the rq->end_io() callback so everything doesn't have to go
> > >down sync, but that is in now as well.
> > >
> > >I'll try and cook something up.
> > 
> > Very cool ;)
> 
> This is the base for it. It splits request->flags into two variables:
> 
> - cmd_type. this is not a bitmask, but a value indicating what type of
>   request this is.
> 
> - cmd_flags. various command modified flags.
> 
> The idea is to add a REQ_TYPE_LINUX_BLOCK request type, where we define
> a set of command opcodes that signify an upper level defined function
> (such as flush) that is implemented differently at the hardware/driver
> level. Basically a way to pass down messages or commands generically.
> 
> I like this better than using scsi opcodes always, it's a cleaner
> abstraction. For sending generic commands to a device, we could add a
> function ala:
> 
> blk_send_message(queue, unsigned char cmd, completion_callback);
> 
> that would allocate the request, set it up, add to block layer queue,
> and call the completion_callback when it is done. So for a flush, a
> driver could do
> 
>         blk_send_message(q, REQ_LB_OP_FLUSH, flush_done);
> 
> to a target queue.
> 
> What do you think?

Heh, very nice! Just what's needed for nbd!:-) NBD has several "threads":

1. the one running in the original nbd-client context, receiving answers 
from the server and completing requests,

2. the block queue

3. (my addition) block-device operations open, close, ioctl...

1. and 2. are already working in the block queue context, to simplify 3. I 
also faked those operations with block requests. I didn't go as far as 
really submitting them to the block layer and completing them 
respectively, I just used the same request object and inserted it directly 
into the internal list to process replies in 1. With the current patch 
from Jens (with some minor extensions) this could be done even nicer.

(see also my another post today to linux-scsi)

Thanks
Guennadi
---
Guennadi Liakhovetski

