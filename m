From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] USB enclosures seem to require read(16) with >2TB
 drives
Date: Mon, 12 Nov 2012 09:18:14 +0100
Message-ID: <20121112091814.198f0a62@stein>
References: <1352477289-8133-1-git-send-email-hernejj@gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40294C344C61@G1W3652.americas.hpqcorp.net>
	<20121111121736.5672b762@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52377 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2KLISg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2012 03:18:36 -0500
In-Reply-To: <20121111121736.5672b762@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "Jason J. Herne" <hernejj@gmail.com>, Alan Stern <stern@rowland.harvard.edu>

On Nov 11 Stefan Richter wrote:
> On Nov 09 Elliott, Robert (Server Storage) wrote:
> > I recommend broadening this patch.  T10 is discussing making READ (10), WRITE (10), etc. obsolete in SBC-4 in favor of their 16-byte CDB counterparts.  
> > 
> > The algorithm should be:
> > 1. During discovery, determine if 16-byte CDBs are supported.  There are several ways to determine this:
> > a) REPORT SUPPORTED OPERATION CODES command succeeds and reports that READ (16) et al are supported.
> > b) READ (16) command specifying a Transfer Length of zero succeeds.
> > c) READ CAPACITY (16) command succeeds and reports that the capacity is > 2 TiB.
> > d) (future) INQUIRY command succeeds fetching the Block Device Characteristics VPD page and notices a new field added by the SBC-4 simplified SCSI feature set proposal.
> > 
> > Since REPORT SUPPORTED OPERATION CODES is optional, it won't always work. READ CAPACITY (16) used to be optional for < 2 TiB drives, so it won't always work either. READ (16) will always work, but requires the drive to be spun up beforehand (e.g., with START STOP UNIT).
> 
> This won't work.  It will crash badly written device firmwares.
> 
> Instead, try the (10) commands on the SBC-4 device and let it respond that
> it does not implement these commands.  Or have other means to be certain of
> SBC-4 compliance without issuing commands that were optional in or not
> defined by earlier revisions of the spec.  I wonder whether testing for
> INQUIRY_data.VERSION >= something is a sufficiently safe test.

Let me revise this:  Try READ CAPACITY (10) first (unless SPC-3's
INQUIRY_data.PROTECT is set, in which case I don't know what is safer;
READ CAPACITY (16) first or READ CAPACITY (10) first).

If this showed a capacity > 2 TB, then Jason's suggestion to always only
issue READ (16) to all USB attached devices makes a lot of sense to me if
it is true that Windows 7 never issues READ (10) to them.

That would be what the proposed patch does.  What about WRITE and the
various other (10)/(16) pairs of commands though?

I don't know what's best in case of transports other than USB (after
capacity > 2 TB was established).
-- 
Stefan Richter
-=====-===-- =-== -==--
http://arcgraph.de/sr/
