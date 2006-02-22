From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Fw: [Bugme-new] [Bug 6114] New: Initio sbp2 causes: "slab error in cache_free_debugcheck(): cache `size-512(DMA)': double free, or memory outside" object was overwritten
Date: Wed, 22 Feb 2006 01:20:58 +0000
Message-ID: <20060222012057.GX27946@ftp.linux.org.uk>
References: <43FBB608.5060202@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:43228 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S932324AbWBVBVC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 20:21:02 -0500
Content-Disposition: inline
In-Reply-To: <43FBB608.5060202@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Tue, Feb 21, 2006 at 07:53:28PM -0500, Douglas Gilbert wrote:
> Stefan Richter wrote:
> 
> > What I don't understand is why mode page 8 is still accessed in your
> > log: http://bugzilla.kernel.org/attachment.cgi?id=7432&action=view
> > (Log lines "command: Mode Sense (10): 5a 00 08 00 00 00 00 00 d9 00",
> > "SCSI transfer size = 17d9" --- yeah, into a 512 Bytes big buffer, "sda:
> > got wrong page".)
> 
> Stefan,
> That sounds familiar. My guess is that a MODE SENSE (6)
> response is being returned for a MODE SENSE (10) cdb.
> "sdparm -f" can decode that in some contexts.

No.  It's a broken bridge that replies to _everything_ with page 6 and
doesn't return a header at all - not 4 bytes for MODE SENSE(6), not
8 bytes for MODE SENSE(10), *zero* bytes.  Just the page 6 contents.

So in place of block descriptor length (offsets 6 and 7) you get the
part of page 6 body.  Which is going to be bits 31..16 of size in blocks.
And that's going to be 0x17bd in his case (203928MB/0.5KB/65536).
