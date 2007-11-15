From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Thu, 15 Nov 2007 16:18:00 -0600
Message-ID: <1195165080.9519.6.camel@localhost.localdomain>
References: <664A4EBB07F29743873A87CF62C26D70B345BD@NAMAIL4.ad.lsil.com>
	 <473CC148.9050106@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55600 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933957AbXKOWSD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 17:18:03 -0500
In-Reply-To: <473CC148.9050106@nortel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Friesen <cfriesen@nortel.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "Stephens, Larry" <Larry.Stephens@lsi.com>, linux-scsi@vger.kernel.org, dgilbert@interlog.com, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

On Thu, 2007-11-15 at 15:59 -0600, Chris Friesen wrote:
> Moore, Eric wrote:
> > On Thursday, November 15, 2007 12:10 PM, Chris Friesen wrote:
> 
> >>Does this status mean that the command needs to be retried by the 
> >>userspace app, that it has already been retried by the lower 
> >>levels and 
> >>is now completed, or something else entirely?
> 
> > The midlayer is retrying the command.  I pointed you to the code in the
> > previous email.
> 
> James Smart just indicated that the midlayer was not retrying the 
> command because it's sgio.  Is he mistaken?

No.  When the command goes via SG_IO it bypasses all return status
processing (and QUEUE_FULL/BUSY is a return status).  When it's
submitted in the normal way (i.e. via a ULD) then the mid-layer
processes these returns to a retry strategy.

> If the midlayer is retrying the command, then what should the 
> application do when it receives that status?

James


