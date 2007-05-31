From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: Deadlock during DV when queue is full
Date: Wed, 30 May 2007 22:19:11 -0600
Message-ID: <1180585151.6681.2.camel@grinch>
References: <1180395725.1292.43.camel@bluto.andrew>
	 <20070530180138.GQ15559@kernel.dk>
	 <1180550612.3697.39.camel@mulgrave.il.steeleye.com>
	 <20070530185526.GV15559@kernel.dk>
	 <1180551722.3697.41.camel@mulgrave.il.steeleye.com>
	 <20070530190309.GW15559@kernel.dk>
	 <1180552075.3697.44.camel@mulgrave.il.steeleye.com>
	 <20070530191110.GY15559@kernel.dk>
	 <1180552972.3697.52.camel@mulgrave.il.steeleye.com>
Reply-To: andrew.patterson@hp.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelrim01.cce.hp.com ([161.114.21.22]:6009 "EHLO
	ccerelrim01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760727AbXEaEwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2007 00:52:01 -0400
In-Reply-To: <1180552972.3697.52.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

On Wed, 2007-05-30 at 14:22 -0500, James Bottomley wrote:
> On Wed, 2007-05-30 at 21:11 +0200, Jens Axboe wrote:
> > > > > > > > There's no other solution than maintaining a cached request + command
> > > > > > > > for this. libata has a similar issue wrt error handling with ncq, we may
> > > > > > > > need a command in error handling to retrieve the log page.
> > > > > > > 
> > > > > > > Actually, there is another solution: DV is careful only to be using a
> > > > > > > single command for its processes ... if we could use the eh command for
> > > > > > > this, then I think the problem would go away ... unfortunately, that's a
> > > > > > > bit more complex to achieve than it sounds.
> > > > 
> > > > (btw this is not another solution, it's indeed the solution of keeping a
> > > > reserved request :-)
> > > > 
> > > > > > That would be fine, the key is just to have such a reserved command. Is
> > > > > > there also a reserved request?
> > > > > 
> > > > > Yes ... we clean out the failing command in error recovery and reuse it,
> > > > > so we know it has both a command and a request.
> > > > 
> > > > Sounds a bit hackish, unless the failed command never needs to be
> > > > retried.
> > > 
> > > Oh, it does.  We clean it out, save the necessary on the stack and reuse
> > > it, then restore the data and send it for a retry.  Up until a while ago
> > > it was what all the old_ fields were for in the SCSI command; now, after
> > > Christoph fixed it, we save them on the stack instead.
> > 
> > I guess the scsi command doesn't need a whole lot of saved state, but
> > the request does.
> 
> Well, we're careful never to let the block layer see it again.  We have
> a special injection point scsi_send_eh_cmnd() for this.  On the other
> hand ... supposing we were to push it back on the block queue for a
> resend, what would we need to save?  It's fully prepared and set up as
> special because of the attached command, so I'm not sure there would be
> anything, as long as we don't let it go into the normal block completion
> paths ... I'm just wondering if we can get rid of the special injection
> path.
> 
> James
> 
> 

Rather than reusing a request, can we just somehow signal the block
layer to let this command exceed the current nr_request limit and go on
through?  This would be similar to the ioc_batching mechanism currently
in use.

Andrew


