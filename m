From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Infinite retries reading the partition table
Date: Thu, 7 Dec 2006 11:14:22 -0800 (PST)
Message-ID: <367656.23632.qm@web31810.mail.mud.yahoo.com>
References: <1165515378.4698.24.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1163212AbWLGTOY@vger.kernel.org>
In-Reply-To: <1165515378.4698.24.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, mdr@sgi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Wed, 2006-12-06 at 12:24 -0800, Luben Tuikov wrote:
> > NEEDS_RETRY _does_ terminate, after it exhausts the retries.  But since
> > by the ASC value we know that no amount of retries is going to work,
> > this chunk of the patch resolves it quicker, i.e. eliminates the
> > "NEEDS_RETRY" pointless retries (given the SK/ASC combination).
> 
> I agree that it's useful behaviour.  However, the change header should
> be something like "scsi_error: don't retry for unrecoverable medium
> errors" not "infinite retries .."
> 
> > > > -	if (scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
> > > > +	if (good_bytes &&
> > > > +	    scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
> > > >  		return;
> > > 
> > > What exactly is this supposed to be doing?  its result is identical to
> > > the code it's replacing (because of the way scsi_end_request() processes
> > > its second argument), so it can't have any effect on the stated problem.
> > 
> > I suppose this is true, but I'd rather it not even go in
> > scsi_end_request as (cmd, uptodate=1, good_bytes=0, retry=0) and complete
> > at the bottom as (cmd, uptodate=0, total_xfer, retry=0).
> 
> But, logically, this isn't part of the change set ... the behaviour
> you're altering is unrelated to the change set details, so this piece
> shouldn't be in.

It is.  If good_bytes=0 then nothing is up to date and uptodate should
be set to 0.

Look at my comment before the function call:
   /* A number of bytes were successfully read. ...

I repeat again: it doesn't make sense to call scsi_end_request
with uptodate=1 and good_bytes=0, since _no bytes are uptodate_.
