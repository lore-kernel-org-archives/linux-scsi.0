From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Thu, 26 May 2005 07:57:35 +0200
Message-ID: <20050526055730.GF1419@suse.de>
References: <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524075953.GY9855@suse.de> <4292E3EE.10006@pobox.com> <20050524085133.GZ9855@suse.de> <42935852.2020300@pobox.com> <20050525092952.GA7005@suse.de> <429520EF.2070501@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:4572 "EHLO
	nelson.home.kernel.dk") by vger.kernel.org with ESMTP
	id S261221AbVEZF4h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 01:56:37 -0400
Content-Disposition: inline
In-Reply-To: <429520EF.2070501@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Wed, May 25 2005, Jeff Garzik wrote:
> Jens Axboe wrote:
> >On Tue, May 24 2005, Jeff Garzik wrote:
> >
> >>Jens Axboe wrote:
> >>
> >>>I agree, it's a cleaner approach, with the rq being a container for
> >>>generel messages as well not just SCSI commands. The one missing piece
> >>>for that was the rq->end_io() callback so everything doesn't have to go
> >>>down sync, but that is in now as well.
> >>>
> >>>I'll try and cook something up.
> >>
> >>Very cool ;)
> >
> >
> >This is the base for it. It splits request->flags into two variables:
> >
> >- cmd_type. this is not a bitmask, but a value indicating what type of
> >  request this is.
> >
> >- cmd_flags. various command modified flags.
> >
> >The idea is to add a REQ_TYPE_LINUX_BLOCK request type, where we define
> >a set of command opcodes that signify an upper level defined function
> >(such as flush) that is implemented differently at the hardware/driver
> >level. Basically a way to pass down messages or commands generically.
> >
> >I like this better than using scsi opcodes always, it's a cleaner
> >abstraction. For sending generic commands to a device, we could add a
> >function ala:
> 
> cmd_type just adds a needless layer of switch{} statements in block 
> drivers, and its information that can be trivially derived from the 
> command opcode itself.
> 
> 	cmd_type = cmd_types[opcode];
> 
> HOWEVER, don't fall in love with SCSI opcodes.

Eh, I don't follow. The opcode is only valid for cmd_type
REQ_TYPE_LINUX_MSG, not for anything else. Or for REQ_TYPE_BLOCK_PC of
course, like it is right now as well.

> We want _Linux_ commands, not SCSI commands.  Just think of a 
> request_queue as having its own command protocol, one that you can 
> _change at will_.
> 
> Yes, often request_queue commands may map seamlessly to SCSI (or ATA or 
> I2O) commands.  And that's good.  But don't let yourself be locked into 
> SCSI.  SCSI is not generic enough, nor mutable enough for all our needs.
> 
> Just the other day I was thinking about the simpler approach, like the 
> attached :)  It
> * adds RQ_ to avoid namespace conflicts
> * adds RQ_FLUSH, RQ_PM_EVENT
> 
> So, overall, I would say "think Linux opcodes" as the preferred direction.

And that's exactly what I proposed, the REQ_LB_OP_xxx are the linux
specific opcodes that can be defined at will. I'm not locking myself
into SCSI at all, I'm just putting ->cmd[] to use for a new command
type.

Don't confuse/mixup fs.h and the block layer, I don't see your proposal
adding anything of use. The fs.h READ/WRITE/etc were divorced from the
block layer in 2.5.

-- 
Jens Axboe

