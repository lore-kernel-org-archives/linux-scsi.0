From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: OOM killer gripe (was Re: What still uses the block layer?)
Date: Mon, 15 Oct 2007 23:37:44 +1000
Message-ID: <200710152337.45252.nickpiggin@yahoo.com.au>
References: <200710112011.22000.rob@landley.net> <20071015014503.GF9715@thunk.org> <200710150304.00901.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:32248 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752915AbXJOI1e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 04:27:34 -0400
In-Reply-To: <200710150304.00901.rob@landley.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Monday 15 October 2007 18:04, Rob Landley wrote:
> On Sunday 14 October 2007 8:45:03 pm Theodore Tso wrote:

> > > excuse for conflating different categories of devices in the first
> > > place.
> >
> > See the thinkpad Ultrabay drive example above.
>
> Last week I drove my laptop so deep into swap (with a "make -j" on qemu)
> that after half an hour trying to repaint my kmail window, it locked solid.
> Again.  You'd think the oom killer would come to the rescue, but it didn't.
> Maybe Ubuntu disabled it.  I have _2_gigs_ of ram in this sucker, on a
> stock Ubuntu 7.04 install (with the "upgrade all" tab pressed a few times),
> and yet I managed to make it swap itself to death one more time.
>
> Virtual memory isn't perfect.  I've _always_ been able to come up with
> examples where it just doesn't work for me.  This doesn't mean VM
> overcommit should be abolished, because it's useful more often than not.

I hate to go completely offtopic here, but disks are so incredibly
slow when compared to RAM that there is really nothing the kernel
can do about this. Presumably the job will finish, given infinite
time.

How much swap do you have configured? You really shouldn't configure
so much unless you do want the kernel to actually use it all, right?
Because if we're not really conservative about OOM killing, then the
user who actually really did want to use all the swap they configured
gets angry when we kill their jobs without using it all.

Would an oom-kill-someone-now sysrq be of help, I wonder?
