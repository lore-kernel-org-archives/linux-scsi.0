From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about transfer lengths
Date: Sun, 15 Sep 2002 15:57:50 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0209151547190.11901-100000@netrider.rowland.org>
References: <20020913172656.B3611@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020913172656.B3611@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: usb-storage <usb-storage@one-eyed-alien.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 13 Sep 2002, Matthew Dharm wrote:

> > From what you're saying, it sounds like the ideal thing would be to use
> > C := D, but instead as a defense against buggy callers we actually should
> > try to set C := min(A,D,E) if we can determine A, and C := min(D,E)
> > otherwise.  In any case we should always check and report it as a bug if
> > A != D or D != E.  Note that this is definitely _not_ what the code does
> > now.
>
> Um... we do check that C != D or E -- we used to BUG_ON() if they were
> different, but Linus didn't like that.  Eventually, we will be removing the
> entire usb_stor_transfer_length() mess, tho.

That's not quite true.  If we look at E at all (which we only do
sometimes), we only make sure that C = min(D,E).  And we don't log an
error message if D != E.

> > And why does the current code only calculate A for reads and not for
> > writes?
>
> The asymmetry of USB.  If we're writing and we write too much, the device
> can tell us.  If we're reading and we read too much, all we get is a CSW
> block loaded into our user buffer.

Okay, that explains that.  But consider this:  For now, the only reasons
we have for going through all these shenanigans are:

	1.  We don't trust the caller to get it right; and

	2.  If the caller gets it wrong, we want to make sure that it
	doesn't look as though things worked okay when in fact they didn't
	(reading CSW bytes into a data buffer for example).

Given these reasons, I think the best course is always to take the time to
compute A and E whenever possible, for writes as well as reads, and always
log an error (and maybe a stack trace) if they disagree.  After all, if
the whole point is to catch our callers' errors, then let's look for them!
(Also, it would help simplify part of the isd200 driver, where apparently
the length embedded in the CDB needs to be decoded for both reads and
writes.)

Alan Stern

