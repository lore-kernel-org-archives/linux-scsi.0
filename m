From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: don't count non-failure CHECK_CONDITION as error
Date: Fri, 15 Jan 2016 11:09:16 -0800
Message-ID: <1452884956.2356.21.camel@HansenPartnership.com>
References: <20160114214602.GC3520@mtj.duckdns.org>
	 <1452872774.2356.5.camel@HansenPartnership.com>
	 <1452873302.2356.9.camel@HansenPartnership.com>
	 <56992361.7030606@interlog.com>
	 <1452882934.2356.13.camel@HansenPartnership.com>
	 <20160115184252.GJ3520@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57806 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbcAOTJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2016 14:09:18 -0500
In-Reply-To: <20160115184252.GJ3520@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: dgilbert@interlog.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Dave Jones <dsj@fb.com>, kernel-team@fb.com

On Fri, 2016-01-15 at 13:42 -0500, Tejun Heo wrote:
> Hello, James.
> 
> On Fri, Jan 15, 2016 at 10:35:34AM -0800, James Bottomley wrote:
> > Well, I can see sense in having an error count of everything that
> > comes
> > back that's not good status because it's easy and has a well
> > defined
> > meaning (calling it the "error count" is more debatable, agreed). 
> >  It
> > appears that Dave and Tejun want the count to mean something else. 
> >  Lets treat this as a feature exercise: Dave and Tejun, what do you
> > want, then we can see if we could add an additional counter giving
> > you
> > that.
> 
> Well, currently, for libata devices, all passthrough commands bump it
> up because the result taskfile is reported via sense data, which is
> pretty misleading for something named ioerr_cnt.  Maybe we can ignore
> CHECK_CONDITION for ATA passthrough commands but special casing them
> can be confusing in other ways.

That doesn't really help me pin down what you want.  I already said
ioerr_cnt is misleading, but we're stuck with the name, becuase it's an
ABI.

Under the definition I gave, the behaviour you currently see is
correct: all commands with non good status count as errors.  That
includes a ton of stuff I wouldn't classify as real errors, like queue
full status, deferred sense codes and even auto correct, which is why I
believe the term "error count" is misleading, but, as I said, we're
stuck with it.

If we want to change what is being counted, we have to change the
definition, so what is the definition you want to see for counting
errors? and what's the reason driving this change?

James

