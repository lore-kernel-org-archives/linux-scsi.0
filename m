From: Christer Weinigel <christer@weinigel.se>
Subject: Re: cd burning with plextor drives.
Date: 29 Jul 2006 17:39:29 +0200
Message-ID: <m3vepgzaha.fsf@zoo.weinigel.se>
References: <20060729045249.GA23398@redhat.com>
	<20060729111240.GG13095@suse.de>
	<1154180419.9447.61.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:38017 "EHLO
	zoo.weinigel.se") by vger.kernel.org with ESMTP id S1751008AbWG2Pja
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 11:39:30 -0400
In-Reply-To: <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org, torvalds@osdl.org


James Bottomley <James.Bottomley@SteelEye.com> writes:

> On Sat, 2006-07-29 at 13:12 +0200, Jens Axboe wrote:
> > > I'm not that familiar with this code, but would adding exceptions
> > > on a per-vendor basis in sg_allow_access() be the way forward here?
> > > 
> > > If not, what is the right answer ?
> > 
> > I'd greatly prefer just ripping the entire command access table out, it
> > was a mistake to begin with and still just a horrible solution.
> > 
> > In fact, I think we should decide soon what to do about it. At the
> > storage summit, there was general consensus on just killing it as well.
> 
> I concur.  If we're going to allow users access to burn CDs, it's
> impossible to police them with certainty as this case indicates.  If we
> allow vendor specific commands down, there are bound to be some that
> format the drive or destroy the firmware ...
> 
> So I think ripping the table out and acknowledging we have no security
> is better than giving the illusion of having it.

How about making cmd_type a per device variable and adding an ioctl to
set cmd_type?  Let cmd_type default to letting everything through.
That way a distribution can add filters if it wants to.

 /Christer

-- 
"Just how much can I get away with and still go to heaven?"

Freelance consultant specializing in device driver programming for Linux 
Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
