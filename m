From: Alan Stern <stern@rowland.harvard.edu>
Subject: Unaligned scatter-gather buffers and usb-storage
Date: Tue, 18 Nov 2003 10:20:17 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311181001030.735-100000@ida.rowland.org>
References: <20031110095914.B22518@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3332 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263590AbTKRPUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 10:20:19 -0500
In-Reply-To: <20031110095914.B22518@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

Although most scatter-gather buffers are page aligned, occasionally one of 
them isn't.  This can happen when the sg and st drivers use direct I/O and 
the user's buffer doesn't start on a page boundary; the first s-g buffer 
in the list will coincide with the start of the user buffer even though 
all the later ones will start at page boundaries.

The usb-storage driver has trouble with unaligned buffers.  More 
accurately, it has trouble with s-g entries having bad lengths.  A buffer 
that occupies an entire page or is the _last_ entry in the s-g list is 
okay, but if the _first_ entry isn't aligned properly it is likely to have 
a bad length.

[For linux-scsi readers: This has to do with the way USB works.  Data
transfers are divided up into packets, and packets have a maximum size
(typically 64 or 512 bytes).  A packet can't span two s-g entries; hence
if an s-g entry's length isn't divisible by the maxpacket size then one of
the packets for that entry must be short, i.e., smaller than the maximum
size.  But USB specifies that short packets always indicate the end of a
transfer.  Thus if any s-g entry but the last has a bad length, the data
transfer will terminate prematurely.]

Alignment to a 512-byte boundary would suffice and page alignment would be
more than enough.  The cleanest way to fix the problem would be to have st
and sg refuse to do direct I/O when the user's buffer isn't page aligned.  
That's probably too draconian (but it would allow us to give the user
process an appropriate error code right away).

So instead I'm going to change the usb-storage driver to make it reject
any s-g transfer that doesn't meet the entry length requirements.  My
question is this: What's the best way to inform the SCSI midlayer about
what went wrong?  Return a DID_ABORT code?  Or would something else be
better?

Alan Stern

