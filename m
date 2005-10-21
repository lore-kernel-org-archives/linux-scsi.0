From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 18:01:17 -0600
Message-ID: <1129852879.30258.137.camel@bluto.andrew>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>
	 <20051020170330.GA16458@lst.de>  <4357F7DE.7050004@adaptec.com>
Reply-To: andrew.patterson@hp.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel9.hp.com ([156.153.255.214]:58315 "EHLO atlrel9.hp.com")
	by vger.kernel.org with ESMTP id S932558AbVJUABd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 20:01:33 -0400
In-Reply-To: <4357F7DE.7050004@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Thu, 2005-10-20 at 16:02 -0400, Luben Tuikov wrote:
> On 10/20/05 13:03, Christoph Hellwig wrote:
> >>I'd suggest a reading of the SDI, SAS and SAM specs for an insight
> >>of how it all ties together.
> > 
> > 
> > Thanks Luben.  You might not be able to imagine it, but there are people
> > other than you who are able to read specs, and despite having read them
> > they can actually talk like a normal human without referencing them in
> > every second sentence.  That beeing said SDI is not a final
> > specification.  It's a draft that's probablt not going to make it as a
> > t10 standard because the main pushers have backed of a bit again.
> 
> The whole point is that LSI/HP/Adaptec are _using_ SDI in one form
> or another and would like to have it officially in the kernel.

I would hope that other users/vendors might find a use for this as well.

> 
> > We are not going to implement SDI in the kernel.  Long before SDI or
> 
> Who is "we"?
> 
> > it's predecessor, HP CSMI were designed we made it clear we're not going
> > to accept wide ioctl-APIs, especially when they're even bad for old
> 

CSMI is a semi-proprietary spec.  SDI is an attempt to turn this into an
open spec.  One of the reasons it has not been made into a standard is
the whole IOCTL issue.  Other OS's, Windows, HP-UX, Solaris allow them,
Linux has recently banned them (at least in the SCSI sub-system). 

> You do not have to take section 4 of SDI literally, but what everyone
> wants is the _functionality_ of section 5 of SDI. 

My guess is that what current app writers want is to use IOCTL's so they
don't have to special-case Linux.  Next best thing would be something
that closely approaches it, to avoid re-writing a lot of code.  

>  That can be implemented
> as a backend, see my next message to Arjan on this thread, and the front
> end can be anything at all (sg/sysfs/whatever1/whatever2).
> 
> > ioctl API standards.  The CSMI spec has been passed around in an early
> > phase and been totally rejected, I think even publically on linux-scsi.

The LSI driver attempted go in with CSMI. One of the reasons it was
rejected was because it used IOCTL's to implement CSMI.  I don't think
CSMI itself was rejected (other than the fact that is required IOCTL's
of course).  The SDI authors are willing to use another type of
interface, but have had no help in suggesting alternatives.

> 
> Rejected by whom?  "The community" or by you?

I believe there is a common understanding that IOCTL's are bad and
should be avoided. See:

http://lkml.org/lkml/2001/5/20/81

> 
> Let me understand this properly: LSI/HP/Adaptec are using SDI in one
> form or another and would like to see something like it in the kernel,
> but "the community", the "we" you refer to above, rejects it?
> 
> > HP decided to move ahead despite that and did a huge mis-services to
> > their customers.

Perhaps.  Given that there seems to be no alternative, we don't have
much of a choice.

> 
> Yes, because there is a _need_ for it.
> 
> > It's not my problem if big companies can't listen and do things their
> > customers have to pay for, and it's certainly not our job to work
> > around their idiocy.

Yes, CSMI should have had more Linux input when it was developed.  The
no-new IOCTL policy certainly came as a surprise to the authors. Still,
there doesn't seem to be any other usable cross-platform interface that
is acceptable to the linux community (or at least to Christoph)'s corner
of it).  My personal preference is to hide this stuff in a library, so
the kernel implementation is hidden. But even a library needs an
underlying kernel implementation.

> 
> Bold statment.
> 
> Who should "big companies" listen to?  You?  "The community?"
> Are you saying "big companies" whould listen to Linux which
> says "no to specs" among other things?
> 
> Often enough what "big companies" agree on and use and deploy is
> what Linux (you?) should _listen_ to, try to understand and maybe
> get out of the way.
> 

Big companies often want to do things in a proprietary fashion.  I
personally would prefer to see a standard's-based approach.

> It is all about customer satisfaction, which is completely
> foreign to Linux, simply because of the _nature_ of Linux.

More bold statements? ;-)

> 
> Why is there a need to _reinvent_ things?
> Aren't there engineers at those "big companies" who know
> OS design and programming?
> 
> Why do you feel the need to antiquate engineers from
> companies submitting drivers/patches/solutions to the
> Linux kernel?
> 
> Surely this isn't good for the Linux kernel in the long term.
> Or is it?
> 
> 	Luben

