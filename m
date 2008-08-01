From: Matthew Frost <artusemrys@sbcglobal.net>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in 2.6.27-rc1
Date: Fri, 1 Aug 2008 11:46:04 -0700 (PDT)
Message-ID: <101516.95411.qm@web83205.mail.mud.yahoo.com>
References: <Pine.LNX.4.44L0.0807301656030.2322-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web83205.mail.mud.yahoo.com ([216.252.101.49]:24050 "HELO
	web83205.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751101AbYHASwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2008 14:52:45 -0400
In-Reply-To: <Pine.LNX.4.44L0.0807301656030.2322-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Matthew Frost <artusemrys@yahoo.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Matt Frost <artusemrys@sbcglobal.net>

Alan Stern wrote:
> > The patches to fix this that I have tried do not apply
> > cleanly to lk 2.6.26 (and break during compile if forced:
> > "us->fflags" is not defined).
> > 
> > Is there a lk 2.6.26 patch available?
> 
> Sorry about that; my patches are against the USB development tree and
> I tend to forget to redo them against the vanilla kernel.  Below is a
> patch against 2.6.26.  Or you can just edit the original patch and
> change the occurrences of "fflags" to "flags".
> 
> Alan Stern
> 
> 
> Index: 2.6.26/drivers/usb/storage/transport.c
> ===================================================================
> --- 2.6.26.orig/drivers/usb/storage/transport.c
> +++ 2.6.26/drivers/usb/storage/transport.c
> @@ -1034,8 +1034,21 @@ int usb_stor_Bulk_transport(struct scsi_
>  
>  	/* try to compute the actual residue, based on how much data
>  	 * was really transferred and what the device tells us */
> -	if (residue) {
> -		if (!(us->flags & US_FL_IGNORE_RESIDUE)) {
> +	if (residue && !(us->flags & US_FL_IGNORE_RESIDUE)) {
> +
> +		/* Heuristically detect devices that generate bogus residues
> +		 * by seeing what happens with INQUIRY and READ CAPACITY
> +		 * commands.
> +		 */
> +		if (bcs->Status == US_BULK_STAT_OK &&
> +				scsi_get_resid(srb) == 0 &&
> +					((srb->cmnd[0] == INQUIRY &&
> +						transfer_length == 36) ||
> +					(srb->cmnd[0] == READ_CAPACITY &&
> +						transfer_length == 8))) {
> +			us->flags |= US_FL_IGNORE_RESIDUE;
> +
> +		} else {
>  			residue = min(residue, transfer_length);
>  			scsi_set_resid(srb, max(scsi_get_resid(srb),
>  			                                       (int) residue));
> 
> 

Thanks!  I've been trying to fix it manually, and it wouldn't work.  Trying
this version now.  Let's see if this fixes my problem.

Matt Frost
