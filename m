From: "Smart, James" <James.Smart@Emulex.Com>
Subject: [Emulex] Ready for next round...
Date: Tue, 15 Jun 2004 13:32:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:54513 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S265783AbUFORdK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 13:33:10 -0400
Received: from xbl.ad.emulex.com (xbl.ma.emulex.com [138.239.73.11])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i5FHX6W9024960
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jun 2004 10:33:07 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Christoph, et al...

I'd like to request the next round of review comments on the driver.

We believe that tonights posting on SourceForge has addressed all of the
comments to date with only a couple of exceptions (see below).

-- James S



Open items:
------------
[From 5/9] Re: typedefs in sSuDly Caps and pfoo pointer naming.
We have addressed some, but not all of this. We will remove all of it.

[From 5/9] Re: explain USE_HGP_HOST_SLIM and why only ppc64 sets it
A very valid question (thank you). This was masking several issues. Some of
which we are still testing. For now, the code has been left as is. We will
be posting the actual change shortly.

[From 5/0] Re: don't mess with eh_timeout from a LLDD please
We haven't sync'd with the IBM patch as yet. Will be doing so.


Comments:
--------------
[From 5/9] Re: lpfc_msg* stuff is not acceptable.
We've inlined the print strings and filter values. Should be acceptable now.

[From 5/9] Re: you should probably redesign your driver to use the host_lock
instead of the drvlock everywhere.
For now, we haven't changed. However, we are actively looking at this.

[From 5/9] Re: what do you need lpfcDRVR.loadtime for?
Is used for diagnostics and trouble-shooting.

[From 5/18] Re: while we're at it reorder includes alphabetically
We do not agree with alphabetical ordering. We believe in letting the header
dependencies decide the ordering, and where ordering is not dictated, let
logical grouping take place.

[From 5/31] Re: remove dead EXPORT_SYMBOLS
Based on the feedback and recommendations - we've removed the external
symbols. At a later date, we'll propose patches to reintroduce the
functionality in a manner that will be more acceptable to the group.

[From 6/1]Re: Adam Blanchard's comment on page alloc fail on ppc64, thought
on using a mempool & Re: other queuecommand problems - too many allocations,
allocs under spinlock, etc.
We made several code reorgs to move locks, and change the allocations so
that everything is GFP_NOIO under no locks. However, we're subject to an
issue with blk_run_queue() which invokes us under softirq. At this point, we
have to move things back to GFP_ATOMIC to be safe. What you will see in
tonights drop is: a) we've removed a couple of "always allocate" cases by
embedding the structures into the base scsi_buf; b) we've implemented a
mempool to hopefully help (but not solve) the failure case.



