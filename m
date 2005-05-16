From: Douglas Gilbert <dougg@torque.net>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Mon, 16 May 2005 13:26:54 +1000
Message-ID: <428812FE.90602@torque.net>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:28860 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261260AbVEPD05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 May 2005 23:26:57 -0400
In-Reply-To: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Al Viro wrote:
> 	a) TYPE_SDAD renamed to TYPE_RBC and taken to scsi.h
> 	b) in sbp2.c remapping of TYPE_RPB to TYPE_DISK turned off
> 	c) relevant places in midlayer and sd.c taught to accept TYPE_RBC
> 	d) sd.c::sd_read_cache_type() looks into page 6 when dealing with

Al,
Adding some information:

The name of mode page 6 is "RBC device parameters".
References for RBC:
http://www.t10.org/ftp/t10/drafts/rbc/rbc-r10a.pdf
http://www.t10.org/ftp/t10/drafts/rbc/rbc-a101.pdf

I just added mode page 6 to my sdparm beta.

> TYPE_RBC - these guys have writeback cache flag there and are not guaranteed
> to have page 8 at all.

The Write(back) Cache Disable (WCD) flag in mode page 6
is logically flipped from WCE in DASD (i.e. disk) caching
mode page (page number 8).

> 	e) sd_read_cache_type() got an extra sanity check - it checks that
> it got the page it asked for before using its contents.  And screams if
> mismatch had happened.  Rationale: there are broken devices out there that
> are "helpful" enough to go for "I don't have a page you've asked for, here,
> have another one".  For example, PL3507 had been caught doing just that...
> 	f) sbp2 sets sdev->use_10_for_rw and sdev->use_10_for_ms instead
> of bothering to remap READ6/WRITE6/MOD_SENSE, so most of the conversions
> in there are gone now.

RBC makes MODE_SENSE/SELECT (6) support mandatory but does
not support MODE_SENSE/SELECT(10).

> 	Incidentally, I wonder if USB storage devices that have no
> mode page 8 are simply RBC ones.  I haven't touched that, but it might
> be interesting to check...

I tried on a SanDisk SDDR-31 which doesn't support
any mode pages at all! Same with a SanDisk mini Cruzer.
My USB enclosure with a ATA disk inside is an
abomination wrt MODE SENSE. It doesn't respond to
MODE SENSE 6 but does to a MODE SENSE 10 but with
a mode parameter header for the 6 byte variant.
Any code that silently switches mode sense 6 to
10 (or vice versa) and doesn't fix the response is just
wrong.

Doug Gilbert
