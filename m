From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about transfer lengths
Date: Fri, 13 Sep 2002 13:44:55 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0209131320280.1027-100000@ida.rowland.org>
References: <20020913090148.A31114@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020913090148.A31114@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: usb-storage <usb-storage@one-eyed-alien.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 13 Sep 2002, Matthew Dharm wrote:

> Since C is under our control, we use C := A.  But we don't always know A,
> since the CDB can specify size in 'blocks', the size of which varies from
> device to device.  Thus, if we see a command that uses 'blocks' (i.e.
> READ_10, etc), we choose to interpret A := D/E -- we try to enforce that
> D == E.  For those commands where we actually can determine A (i.e.
> INQUIRY, where the length is encoded in a bytecount in the CDB), we use
> that value.
>
> F should be reported back to the user.  There is a residue field in the
> request structure from the mid-layer, and we simply need to copy this data
> back to that field.

So far as I can tell this isn't done anywhere, and it hasn't seemed to
hurt anything.  (In fact, grep'ing for 'resid' in the usb-storage source
directory reveals no matches at all.)  The proper spot to fill in the
residue field is usb_stor_transfer(), but the code doesn't do it.  That
subroutine doesn't even know how much data got sent! -- the size
information is not propagated from usb_stor_transfer_partial().

Is this an error in usb-storage?  If it is, why hasn't it caused any
problems?  Or maybe it has, and nobody realized what was going on?

> Now, the good news:  After many long discussions with Linus and other on
> the linux-scsi list, we've decided that D == E should be an invariant
> established by the thing that actually originates the request.  Also, A ==
> D == E is also a requirement.  The recent discussion on my use of BUG_ON()
> is actually in relation to this -- I was trying to flag any command that
> came down the pipe with this rule violated.
>
> Any place you see that A != D or D != E is a bug, and should be fixed at
> the higher layer that sends the command.  Eventually, all that logic to
> determine the transfer length will be removed (it only works _most_, but
> not _all_ of the time) and replaced with references to D.

>From what you're saying, it sounds like the ideal thing would be to use
C := D, but instead as a defense against buggy callers we actually should
try to set C := min(A,D,E) if we can determine A, and C := min(D,E)
otherwise.  In any case we should always check and report it as a bug if
A != D or D != E.  Note that this is definitely _not_ what the code does
now.

And why does the current code only calculate A for reads and not for
writes?

Alan Stern


> > As I see it, there's about six different quantities that concern us:
> >
> > 	A = the size embedded in the scsi CDB (command data block).  We
> > are given this, although if needed we could alter it.
> >
> > 	B = the length that the device really wants to transfer.  AFAIK,
> > some devices will choke if A != B, some will choke if A > B, and some will
> > choke if A < B.
> >
> > 	C = the size that we tell the interface hardware about.  (For us,
> > the interface is a USB host controller.)  This is really the only value
> > under our direct control.  There may be additional interfaces involved,
> > such as a USB->something-else bridge; in that case we also have C' = the
> > size passed to the extra interface.  Some hardware will choke if C' has
> > the wrong value.
> >
> > 	D = the size of the request given to us by the caller.  That would
> > be the request_bufflen field of the SRB (scsi request block).
> >
> > 	E = the size of the memory buffer allocated for the transfer.
> > For scatter-gather transfers, this is the sum of the length fields of the
> > s-g descriptors in the SRB.  For non-scatter-gather, I don't think we
> > know this value -- we seem to assume that it is the same as D.
> >
> > 	F = the amount of data that ultimately gets transferred.  We ought
> > to find this out and report it back to the user.
> >
> > Clearly it is an error if D > E, and it's disastrous if F > E.  It's
> > probably also an error if F > D.  Other than that, I don't know much.
> >
> >
> > The logic used to usb_stor_transfer_length() can be described as follows:
> >
> > 	For writes (and a few assorted types of reads), calculate C =
> > 	min(D,E).  For most types of reads, calculate C = A.  Report an
> > 	error in the kernel log if C != D, and then return C.
> >
> > Also, we get F from the lower-level drivers, but we don't seem to use it
> > (beyond checking for a truncated transfer).  Certainly we don't report the
> > value back to the caller.  I presume the higher scsi routines have their
> > own ways of figuring out how much data got transferred; is that correct?
> >
> > Comments of any sort are welcome.
> >
> > Alan Stern
>
>

