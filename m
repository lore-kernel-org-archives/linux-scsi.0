From: Alan Stern <stern@rowland.harvard.edu>
Subject: Questions about transfer lengths
Date: Fri, 13 Sep 2002 10:03:48 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0209130936330.735-100000@ida.rowland.org>
References: <20020912110702.A20844@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020912110702.A20844@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: usb-storage <usb-storage@one-eyed-alien.net>, linux-scsi <linux-scsi@vger.kernel.org>

Matt:

I don't really understand the logic behind the calculation used in
usb_stor_transfer_length().  Why does the code distinguish between reading
and writing?

Clearly this question opens up a can of worms.  I realize that the issue
of how to handle transfer lengths for emulated scsi devices is a difficult
one.  So I invite discussion on this topic...  For those who don't know,
this is all from the perspective of a device-driver author for
usb-storage.


As I see it, there's about six different quantities that concern us:

	A = the size embedded in the scsi CDB (command data block).  We
are given this, although if needed we could alter it.

	B = the length that the device really wants to transfer.  AFAIK,
some devices will choke if A != B, some will choke if A > B, and some will
choke if A < B.

	C = the size that we tell the interface hardware about.  (For us,
the interface is a USB host controller.)  This is really the only value
under our direct control.  There may be additional interfaces involved,
such as a USB->something-else bridge; in that case we also have C' = the
size passed to the extra interface.  Some hardware will choke if C' has
the wrong value.

	D = the size of the request given to us by the caller.  That would
be the request_bufflen field of the SRB (scsi request block).

	E = the size of the memory buffer allocated for the transfer.
For scatter-gather transfers, this is the sum of the length fields of the
s-g descriptors in the SRB.  For non-scatter-gather, I don't think we
know this value -- we seem to assume that it is the same as D.

	F = the amount of data that ultimately gets transferred.  We ought
to find this out and report it back to the user.

Clearly it is an error if D > E, and it's disastrous if F > E.  It's
probably also an error if F > D.  Other than that, I don't know much.


The logic used to usb_stor_transfer_length() can be described as follows:

	For writes (and a few assorted types of reads), calculate C =
	min(D,E).  For most types of reads, calculate C = A.  Report an
	error in the kernel log if C != D, and then return C.

Also, we get F from the lower-level drivers, but we don't seem to use it
(beyond checking for a truncated transfer).  Certainly we don't report the
value back to the caller.  I presume the higher scsi routines have their
own ways of figuring out how much data got transferred; is that correct?

Comments of any sort are welcome.

Alan Stern

