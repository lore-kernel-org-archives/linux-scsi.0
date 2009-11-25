From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
Date: Wed, 25 Nov 2009 11:10:48 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0911251052020.2879-100000@iolanthe.rowland.org>
References: <20091125084240.GA549@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44791 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753284AbZKYQKs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2009 11:10:48 -0500
In-Reply-To: <20091125084240.GA549@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: tmhikaru@gmail.com, Boaz Harrosh <bharrosh@panasas.com>, Kernel development list <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ext4@vger.kernel.org

On Wed, 25 Nov 2009, Jan Kara wrote:

> > > > > Okay, very good.  There remains the question of the disturbing error
> > > > > messages in the system log.  Should they be supressed for FAILFAST
> > > > > requests?
> > > >   I think it's useful they are there because ultimately, something really
> > > > went wrong and you should better investigate. BTW, "end_request: I/O error"
> > > > messages are in the log even for requests where we retried and succeeded...

That isn't true.  Take a look at the dmesg log accompanying Tim's 
usbmon log.  Although there were 5 read errors in the usbmon log, there 
were only 2 I/O error messages in dmesg, corresponding to the 2 reads 
that weren't retried successfully.

Personally, I think it makes little sense to print error messages in 
the system log for commands where retries are disallowed.  Unless we go 
ahead and print error messages for _all_ failures, including those 
which are retried successfully.

Perhaps a good compromise would be to set the REQ_QUIET flag in 
req->cmd_flags for readaheads.  That would suppress the error messages 
coming from the SCSI core.

>   Yeah, we might make it more obvious that read failed and whether or not
> we are going to retry. Just technically it's not so simple because a
> different layer prints messages about errors (generic block layer) and
> different (scsi disk driver) decides what to do (retry, don't retry, ...).

Actually the retry decisions (or many of them) are made by the SCSI 
core, and that's also where some of those error messages come from.

> > 	I should have asked since I'm here at the moment - do you need any
> > more information out of the buggy USB enclosure at the moment, or can I work
> > on trying to fix/replace it now?
>   No, feel free to do anything with it :). Thanks for your help with
> debugging this.

To clarify, the enclosure isn't really very buggy.  It _should_ have
carried out the failed commands, or if it had a valid reason for not
doing so then it _should_ have reported the reason.  Regardless, the
errors that occurred were harmless because they went away when the
commands were retried.  (Although if they weren't harmless, you
wouldn't be able to tell just from reading the system log...)

Alan Stern

