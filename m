From: Bob Doyle <doyle@primenet.com>
Subject: Re: BusLogic cleanup
Date: Wed, 07 Jan 2004 22:12:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFCE6D8.9E57769B@primenet.com>
References: <3FF513FE.17A1C2FD@primenet.com> <20040107153149.A29756@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.roc2.gblx.net ([64.215.96.101]:25592 "EHLO
	smtp2.roc2.gblx.net") by vger.kernel.org with ESMTP id S263734AbUAHFNE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 00:13:04 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> 
> On Thu, Jan 01, 2004 at 11:47:26PM -0700, Bob Doyle wrote:
> > I'm starting to do some cleanup to the BusLogic SCSI driver.
> > Since I'm a rank-newbie at anything SCSI, I thought I'd post a snap-shot
> > of where I am, and solicity direction and comments from the experts...
> >
> > Please review and comment.
> 
> Patch looks okay so far.

Good.  I don't feel like a dummy now...

> > - I'd really really like to run the code through 'indent' to match the
> >   kernel coding standards but for now I don't want to confuse formatting
> >   changes with code changes.  It is very difficult to read as it is
> >   currently formatted.
> 
> Indeed.  But it's not only a problem of indentation, but also of horrible
> naming of datatypes, structure members & variable names.  You'll have to
> to some major work on these first otherwise a driver that is run through
> Lindent might be even more unreadable due to gazillions of linebreaks.

I know.  I ran it though lindent and it was unreadable in less than 200
columns.  I want to get the EH fixed and accepted then I start submitting
the 'beautification' changes.  Those changes affect virtually every line
of code.  I'll choke it down for now.

> A good start would be to kill the silly typedefs for kernel / scsi datatypes..

Already done in my tree.  I was afraid that it would not be accepted.
For now, removing the typedefs just makes the linebreak issue worse.
 
> > So - now the questions...
> >
> > How do I test the eh_* handler functions?  I've tried everything
> > I can think of to provoke them but haven't managed to.  For now,
> > I don't know if they work or not.
> 
> The best testcase would be a faulty disk.  You could also try to get
> into EH szenarios by wrong termination / cabling - but who wants to do
> that to his system?

I saw that there was a scsi ramdisk driver to check the midlayer EH.
I was just wondering if there was some magic sysfs mechanism (or something)
excercise the driver EH.  Anyway I have a junk disk that I might
be able to wound.

> > Also I clearly don't understand the command completion in the
> > context the error handlers.  Do the eh_* functions need to
> > do command completion?
> 
> They shouldn't in theory, but for that you need to make sure the
> driver leaves all queuing to the midlayer.  If you queue command
> internaally to the driver the midlayer obviously doesn't know
> about them.  One more reason not to do that.

Hmm.  I haven't spent much time reading the midlayer code.  I didn't know
that midlayer did command queuing.   Are you recommending that the
driver-level queuing be removed?  

Are the BusLogic docs anywhere anymore?  The mylex page re-directs
to LSI Logic.

Sorry for all the questions...

Regards,
Bob.
