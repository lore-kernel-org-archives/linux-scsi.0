From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Thu, 8 Sep 2005 12:08:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509081202170.4607-100000@iolanthe.rowland.org>
References: <1126123089.4823.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:6056 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932543AbVIHQIg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 12:08:36 -0400
In-Reply-To: <1126123089.4823.48.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 7 Sep 2005, James Bottomley wrote:

> Actually, alloc_target is properly guarded so it doesn't need the scan
> mutex.  It might be nice to update the SDEV_ state model to include a
> "scanning" state, that way we could properly guard the sdev_alloc as
> well and dump the scan mutex ... that's probably more than a slight
> change, though.

Probably not a good idea, either.  The "scanning" state applies to the 
host, not a particular device -- the idea is to prevent one thread from 
adding new devices while another thread is trying to get rid of all the 
devices because the host is going away.  (Not to mention, preventing two 
threads from adding the same target at the same time!)

And this needs to be a mutex, since host removal must wait until scanning 
finishes.  Making it a state instead won't work well.

> > Would you like me to submit an updated patch?
> 
> Yes, please.  It's been suggested that we should have a scsi_add_target
> that returns zero on success or error on failure (with no ref to the
> sdev) and keep the old behaviour of __scsi_add_target().

On Wed, 7 Sep 2005, Mike Anderson wrote:

> On as542. The first hunk of the diff is already in (declare of
> scsi_host_set_state). The second hunk looks good (SHOST_RECOVERY label).
> The third hunk I will take in combination with the other patch that
> effects the scan code. This should have probably been
> another patch.

At this point, maybe it's best for me to step back and let Mike look 
through the issues first.  There's Patrick's patch to be combined with the 
one I sent, and other things that need to be straightened out.

Alan Stern

