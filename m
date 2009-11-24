From: Jan Kara <jack@suse.cz>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
Date: Tue, 24 Nov 2009 21:39:44 +0100
Message-ID: <20091124203944.GD16662@quack.suse.cz>
References: <20091124195607.GC16662@quack.suse.cz>
 <Pine.LNX.4.44L0.0911241510590.2881-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34947 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932611AbZKXUjp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2009 15:39:45 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0911241510590.2881-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, tmhikaru@gmail.com, Kernel development list <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ext4@vger.kernel.org

On Tue 24-11-09 15:13:01, Alan Stern wrote:
> On Tue, 24 Nov 2009, Jan Kara wrote:
> 
> >   After digging in block layer code, it's as we suspected:
> > In case of host error DID_ERROR (which is our case), scsi request is
> > retried iff it is not a FAILFAST request which is set if bio is doing
> > readahead... So this is explained and everything behaves as it should.
> > Thanks everybody involved :).
> 
> Okay, very good.  There remains the question of the disturbing error
> messages in the system log.  Should they be supressed for FAILFAST
> requests?
  I think it's useful they are there because ultimately, something really
went wrong and you should better investigate. BTW, "end_request: I/O error"
messages are in the log even for requests where we retried and succeeded...

								Honza
