From: Jan Kara <jack@suse.cz>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
Date: Tue, 24 Nov 2009 20:56:08 +0100
Message-ID: <20091124195607.GC16662@quack.suse.cz>
References: <4B0C1C20.2080901@panasas.com>
 <Pine.LNX.4.44L0.0911241418440.2881-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:32972 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361AbZKXT4H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2009 14:56:07 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0911241418440.2881-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, tmhikaru@gmail.com, Kernel development list <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ext4@vger.kernel.org

On Tue 24-11-09 14:28:35, Alan Stern wrote:
> On Tue, 24 Nov 2009, Jan Kara wrote:
> 
> >   My naive guess would be that those non-retried reads were actually
> > readahead. That's not retried if I remember correctly. Later, when we
> > really needed the data, we sent another read request...
> 
> That would be my guess too.  I don't know how to verify it, though.
> 
> If you're interested in pursuing this farther, I can show you how to 
> generate equivalent errors on demand using an emulated USB drive.  
> At this point it's not clear how much more one could learn by doing 
> this, however.
  After digging in block layer code, it's as we suspected:
In case of host error DID_ERROR (which is our case), scsi request is
retried iff it is not a FAILFAST request which is set if bio is doing
readahead... So this is explained and everything behaves as it should.
Thanks everybody involved :).

								Honza
