From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI TMF processing; tag allocation
Date: Mon, 15 Nov 2010 08:52:10 -0600
Message-ID: <1289832730.2233.7.camel@mulgrave.site>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com>
	 <20101113123750.GF18258@parisc-linux.org> <4CE0FD24.4030000@fusionio.com>
	 <1289831595.2233.5.camel@mulgrave.site>
	 <20101115144612.GA6178@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54038 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435Ab0KOOwM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2010 09:52:12 -0500
In-Reply-To: <20101115144612.GA6178@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jens Axboe <jaxboe@fusionio.com>, Luben Tuikov <ltuikov@yahoo.com>, Greg KH <greg@kroah.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>

On Mon, 2010-11-15 at 07:46 -0700, Matthew Wilcox wrote:
> On Mon, Nov 15, 2010 at 08:33:15AM -0600, James Bottomley wrote:
> > Right, it's the clock algorithm to prevent tag starvation.  If you have
> > hands representing the first and last tag and they're never allowed to
> > cross, the device can't starve any tag for too long because eventually
> > it will be the only outstanding command.
> > 
> > It's not the only algorithm however.  Banging down an ordered tag every
> > 200 or so commands has exactly the same effect.  In fact the clock
> > algorithm was what the 53c700 driver used (before it was converted to
> > generic tags) and the ordered tag what aic7xxx uses.
> > 
> > Realistically, tag starvation isn't really a problem.  It was a known
> > issue for 80s era hardware.  I've got some of the oldest drives on the
> > planet and I didn't see a problem when the clock algorithm was removed
> > from 53c700.
> 
> The problem is that each driver is solving the problem in its own way
> right now, which is clearly daft.  And no drive manufactured in the past
> fifteen years supports ordered tags anyway, so they're only a placebo
> at this point.

Actually, most drivers ignore the issue ... which is why I don't think
there's much of a problem.  The aic7xxx is the only one I know doing
something about this.  Like I said, I removed the clock algorithm from
53c700 and haven't had a problem (yet, I suppose).

James


