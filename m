From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Followup on patches as571 and as572
Date: Fri, 14 Oct 2005 12:58:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0510141239400.6253-100000@iolanthe.rowland.org>
References: <1129305716.4824.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:64908 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750797AbVJNQ6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 12:58:48 -0400
In-Reply-To: <1129305716.4824.15.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 14 Oct 2005, James Bottomley wrote:

> On Fri, 2005-10-14 at 11:09 -0400, Alan Stern wrote:
> > I haven't heard anything back about these two patches:
> > 
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=112801815229091&w=2
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=112801965207763&w=2
> > 
> > They were submitted a couple of weeks ago, and they don't appear in your 
> > scsi-misc git repository.
> 
> I was waiting for Jens to comment since he's supposed to be the sr
> maintainer.
> 
> To me, the first looks fine.  The second alters the behaviour of error
> completion.  Previously we report the number of good bytes up to the
> first bad block in linux filesystem terms.  Now we report it up to the
> first bad block in hardsect terms.  I'm not sure if anything actually
> cares, but I don't really see a reason to change it.

Thanks for responding so quickly.

I'm not sure I understand your comment on the second patch.  The patch 
doesn't affect the value of good_bytes except in two respects:

    (a) When the device does not provide valid information in
	the Information field, the code will now realize it and
	fall back on the Residue.

    (b) The bizarre line that said

		error_sector &= ~(block_sectors - 1);

	is now gone.  Do you know what that was intended to do?

Otherwise the value should be exactly the same as before.  The new 
calc_good_bytes routine does most of its work using 2048-byte hardware 
blocks instead of 512-byte sectors, but the end result is unchanged.

When the Information value is used, the good region must end on a hardware
block boundary because the value is given in units of blocks.  When using
the Residue, in principle the region could end at any byte.  Would you
like me to change the patch so that the Residue-based calculation goes up
to a 512-byte sector boundary instead of a block boundary?

Or were you referring to something else entirely?

Alan Stern

