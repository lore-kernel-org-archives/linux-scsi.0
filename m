From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BusLogic cleanup
Date: Wed, 7 Jan 2004 15:31:49 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040107153149.A29756@infradead.org>
References: <3FF513FE.17A1C2FD@primenet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:18694 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266219AbUAGPbv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2004 10:31:51 -0500
Content-Disposition: inline
In-Reply-To: <3FF513FE.17A1C2FD@primenet.com>; from doyle@primenet.com on Thu, Jan 01, 2004 at 11:47:26PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Bob Doyle <doyle@primenet.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 01, 2004 at 11:47:26PM -0700, Bob Doyle wrote:
> I'm starting to do some cleanup to the BusLogic SCSI driver.
> Since I'm a rank-newbie at anything SCSI, I thought I'd post a snap-shot
> of where I am, and solicity direction and comments from the experts...
> 
> Please review and comment.

Patch looks okay so far.

> - I'd really really like to run the code through 'indent' to match the
>   kernel coding standards but for now I don't want to confuse formatting
>   changes with code changes.  It is very difficult to read as it is
>   currently formatted.

Indeed.  But it's not only a problem of indentation, but also of horrible
naming of datatypes, structure members & variable names.  You'll have to
to some major work on these first otherwise a driver that is run through
Lindent might be even more unreadable due to gazillions of linebreaks.

A good start would be to kill the silly typedefs for kernel / scsi datatypes..

> So - now the questions...
> 
> How do I test the eh_* handler functions?  I've tried everything
> I can think of to provoke them but haven't managed to.  For now,
> I don't know if they work or not.

The best testcase would be a faulty disk.  You could also try to get
into EH szenarios by wrong termination / cabling - but who wants to do
that to his system?

> Also I clearly don't understand the command completion in the
> context the error handlers.  Do the eh_* functions need to
> do command completion?

They shouldn't in theory, but for that you need to make sure the
driver leaves all queuing to the midlayer.  If you queue command
internaally to the driver the midlayer obviously doesn't know
about them.  One more reason not to do that.

