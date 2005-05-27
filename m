From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Fri, 27 May 2005 08:55:26 +0200
Message-ID: <20050527065525.GK1435@suse.de>
References: <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524075953.GY9855@suse.de> <4292E3EE.10006@pobox.com> <20050524085133.GZ9855@suse.de> <42935852.2020300@pobox.com> <20050525092952.GA7005@suse.de> <1117159298.9076.178.camel@gaston>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1117159298.9076.178.camel@gaston>
Sender: linux-ide-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 27 2005, Benjamin Herrenschmidt wrote:
> On Wed, 2005-05-25 at 11:29 +0200, Jens Axboe wrote:
> > On Tue, May 24 2005, Jeff Garzik wrote:
> > > Jens Axboe wrote:
> > > >I agree, it's a cleaner approach, with the rq being a container for
> > > >generel messages as well not just SCSI commands. The one missing piece
> > > >for that was the rq->end_io() callback so everything doesn't have to go
> > > >down sync, but that is in now as well.
> > > >
> > > >I'll try and cook something up.
> > > 
> > > Very cool ;)
> > 
> > This is the base for it. It splits request->flags into two variables:
> > 
> > - cmd_type. this is not a bitmask, but a value indicating what type of
> >   request this is.
> > 
> > - cmd_flags. various command modified flags.
> 
> I like it too. It's a long overdue cleanup :)

Indeed, it is something I wish I had done originally when moving away
from the 2.4 rq->cmd setup. Better late than never :)

> Another thing is we should/could probably move some of the other fields
> in the struct request into a union of structs. Some of them are never
> present simultaneously ...

Yes, that would be a nice way to save some space.

-- 
Jens Axboe

