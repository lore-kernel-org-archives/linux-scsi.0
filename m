From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Followup on patches as571 and as572
Date: Fri, 14 Oct 2005 12:31:13 -0500
Message-ID: <1129311073.4824.21.camel@mulgrave>
References: <Pine.LNX.4.44L0.0510141239400.6253-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:28304 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750808AbVJNRbW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 13:31:22 -0400
In-Reply-To: <Pine.LNX.4.44L0.0510141239400.6253-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2005-10-14 at 12:58 -0400, Alan Stern wrote:
>     (b) The bizarre line that said
> 
> 		error_sector &= ~(block_sectors - 1);
> 
> 	is now gone.  Do you know what that was intended to do?

It's not a bizzare line ... it's rounding down to our current set block
size.  That was the difference I noticed in the reporting.  The bio
layer maintains a separate sector size from the actual device, so if the
error occurs in the middle of a block sector (because block sectors >
hard sectors) then we report as though it occurred at the beginning of
the block sector.

James


