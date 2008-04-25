From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH scsi-rc-fixes-2.6] mvsas: fix error handling.
Date: Fri, 25 Apr 2008 11:07:17 -0500
Message-ID: <1209139637.3087.12.camel@localhost.localdomain>
References: <47FB498A.2010107@marvell.com>  <4811FE09.10209@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41340 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755752AbYDYQHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 12:07:22 -0400
In-Reply-To: <4811FE09.10209@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: kewei@marvell.com, linux-scsi@vger.kernel.org

On Fri, 2008-04-25 at 11:51 -0400, Jeff Garzik wrote:
> Ke Wei wrote:
> >  Changed error handling: Add a internal queue to send command in mvs_task_abort function.
> >  Set max_id and max_lun to a valid value. It's good for 64xx chip.
> >  BTW, DVD-ROM compatibility needs to test carefully.
> > 
> > 
> > Signed-off-by: Ke Wei <kewei@marvell.com>
> 
> James, ping?
> 
> Did this get missed?  Are we waiting on Marvell to update this patch?

Actually, the patch contains a red flag:

> -       mvi->shost->max_id = 21;
> -       mvi->shost->max_lun = ~0;
> +       mvi->shost->max_id = 128;
> +       mvi->shost->max_lun = 1;

Setting max_lun to 1 can't be right.  My suspicion is that it's done to
turn off the REPORT_LUN scan that I've already said twice is necessary.

The DVD that's showing the problems needs to be blacklisted.

So, it's on my list to check carefully to see what else might have been
quietly slipped in there ... unfortunately, I haven't had much time
recently (and probably won't until the merge window closes) to give this
patch the thorough scrutiny it needs.

James


