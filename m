From: tmhikaru@gmail.com
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem readonly
Date: Tue, 24 Nov 2009 17:23:34 -0500
Message-ID: <20091124222334.GB20245@roll>
References: <20091124195607.GC16662@quack.suse.cz> <Pine.LNX.4.44L0.0911241510590.2881-100000@iolanthe.rowland.org> <20091124203944.GD16662@quack.suse.cz> <20091124215044.GA20245@roll>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:64562 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798AbZKXWXb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 17:23:31 -0500
Content-Disposition: inline
In-Reply-To: <20091124215044.GA20245@roll>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tmhikaru@gmail.com
Cc: Jan Kara <jack@suse.cz>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, Kernel development list <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ext4@vger.kernel.org

On Tue, Nov 24, 2009 at 04:50:44PM -0500, tmhikaru@gmail.com wrote:
> On Tue, Nov 24, 2009 at 09:39:44PM +0100, Jan Kara wrote:
> > On Tue 24-11-09 15:13:01, Alan Stern wrote:
> > > On Tue, 24 Nov 2009, Jan Kara wrote:
> > > 
> > > >   After digging in block layer code, it's as we suspected:
> > > > In case of host error DID_ERROR (which is our case), scsi request is
> > > > retried iff it is not a FAILFAST request which is set if bio is doing
> > > > readahead... So this is explained and everything behaves as it should.
> > > > Thanks everybody involved :).
> > > 
> > > Okay, very good.  There remains the question of the disturbing error
> > > messages in the system log.  Should they be supressed for FAILFAST
> > > requests?
> >   I think it's useful they are there because ultimately, something really
> > went wrong and you should better investigate. BTW, "end_request: I/O error"
> > messages are in the log even for requests where we retried and succeeded...
> > 
> > 								Honza
> 
> While I agree it is useful information, I think that if the error messages
> are going to be printed, you should *also* print that this is a NON FATAL
> error and that it's going to be retried. It'd help diagnosing the path it's
> following through the failure code IMHO as well as not making users
> completely freak out like I did in my case. It is *not* particularly obvious
> given the message printed to syslog what is going wrong or why.
> 
> 	Just my opinion,
> 	Tim McGrath

	I should have asked since I'm here at the moment - do you need any
more information out of the buggy USB enclosure at the moment, or can I work
on trying to fix/replace it now?

Tim McGrath
