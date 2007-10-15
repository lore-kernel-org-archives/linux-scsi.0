From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Tue, 16 Oct 2007 01:08:37 +1000
Message-ID: <200710160108.38222.nickpiggin@yahoo.com.au>
References: <200710112011.22000.rob@landley.net> <200710152337.45252.nickpiggin@yahoo.com.au> <200710150452.30939.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:35768 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757528AbXJOJ6b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 05:58:31 -0400
In-Reply-To: <200710150452.30939.rob@landley.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Monday 15 October 2007 19:52, Rob Landley wrote:
> On Monday 15 October 2007 8:37:44 am Nick Piggin wrote:
> > > Virtual memory isn't perfect.  I've _always_ been able to come up with
> > > examples where it just doesn't work for me.  This doesn't mean VM
> > > overcommit should be abolished, because it's useful more often than
> > > not.
> >
> > I hate to go completely offtopic here, but disks are so incredibly
> > slow when compared to RAM that there is really nothing the kernel
> > can do about this.
>
> I know.
>
> > Presumably the job will finish, given infinite
> > time.
>
> I gave it about half an hour, then it locked solid and stopped writing to
> the disk at all.  (I gave it another 5 minutes at that point, then held
> down the power button.)

Maybe it was a bug then. Hard to say without backtraces ;)


> > You really shouldn't configure
> > so much unless you do want the kernel to actually use it all, right?
>
> Two words: "Software suspend".  I've actually been thinking of increasing
> it on the next install...

Kernel doesn't know that you want to use it for suspend but not
regular swapping, unfortunately.


> > Because if we're not really conservative about OOM killing, then the
> > user who actually really did want to use all the swap they configured
> > gets angry when we kill their jobs without using it all.
>
> I tend to lower "swappiness" and when that happens all sorts of stuff goes
> weird.  Software suspend used to say says it can't free enough memory if I
> put swappiness at 0 (dunno if it still does).  This time the OOM killer
> never triggered before hard deadlock.  (I think I had it around 20 or 40 or
> some such.)
>
> > Would an oom-kill-someone-now sysrq be of help, I wonder?
>
> *shrug* It might.  I was a letting it run hoping it would complete itself
> when it locked solid.  (The keyboard LEDs weren't flashing, so I don't
> _think_ it paniced.  I was in X so I wouldn't have seen a message...)

If you can work out where things are spinning/sleeping when that happens,
along with sysrq+M data, then it could make for a useful bug report. Not
entirely helpful, but if it is a reproducible problem for you, then you
might be able to get that data from outside X.
