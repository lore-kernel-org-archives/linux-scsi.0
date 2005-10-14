From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Followup on patches as571 and as572
Date: Fri, 14 Oct 2005 14:39:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0510141424370.6253-100000@iolanthe.rowland.org>
References: <1129311073.4824.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42116 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750854AbVJNSje (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 14:39:34 -0400
In-Reply-To: <1129311073.4824.21.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 14 Oct 2005, James Bottomley wrote:

> On Fri, 2005-10-14 at 12:58 -0400, Alan Stern wrote:
> >     (b) The bizarre line that said
> > 
> > 		error_sector &= ~(block_sectors - 1);
> > 
> > 	is now gone.  Do you know what that was intended to do?
> 
> It's not a bizzare line ... it's rounding down to our current set block
> size.  That was the difference I noticed in the reporting.  The bio
> layer maintains a separate sector size from the actual device, so if the
> error occurs in the middle of a block sector (because block sectors >
> hard sectors) then we report as though it occurred at the beginning of
> the block sector.

I see.  I didn't understand the relation between bio->bi_size and anything
else.  It wasn't clear that this size is always equal to a block-layer
sector size, as opposed to an arbitrary memory buffer size.

I will send a revised patch shortly.

Alan Stern

