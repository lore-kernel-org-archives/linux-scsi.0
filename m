From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH ver4 1/5] scsi_error: code cleanup before refactoring
 of scsi_send_eh_cmnd()
Date: Mon, 08 Oct 2007 16:29:39 +0200
Message-ID: <470A3ED3.5070402@panasas.com>
References: <46E59760.9020705@panasas.com> <46E59C3E.1020703@panasas.com>	 <46E6D2ED.1060201@panasas.com> <1191426957.3340.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11930 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbXJHOab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Oct 2007 10:30:31 -0400
In-Reply-To: <1191426957.3340.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>

I will send a ver4 of these patches as reply to base patches
Meanwhile I have some comments below.

Thanks for the review.

On Wed, Oct 03 2007 at 17:55 +0200, James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> You've altered the signature and function of the routine here, this
> needs to be documented by updating the docbook description above the
> function.  (I know you do it later, but each changeset should really be
> logically complete).
> 
Done, thanks

>> +		memset(scmd->cmnd, 0, 6);
> 
> This will lead to subtle bugs: some devices (notably ATAPI) have a fixed
> command slot they will copy this into.  You have potentially trailing
> bytes of junk that this could pick up ... we have ATAPI devices known to
> fall over if they see trailing junk in the command.  Just consolidate
> the scmd->cmnd memsets to
> 
> memset(scmd->cmnd, 0, sizeof(scmd->cmnd);
> 
> outside of the ifs
> 
I wanted to have a fixture where if @cmnd and @sense_bytes are Zero than
scsi_cmnd->cmnd is not touched at all. So I fixed it by doing if (@cmnd)
only in the second arm of the if and fixed the above to what you said.
(See patch that follows)

> 
> Moving this to the sense_bytes specific piece of the if also introduces
> a subtle bug:  If the driver doesn't do auto request sense and the
> command completes with CHECK CONDITION, the sense checking routine will
> potentially pick up stale sense data here
> 
Good call thanks, done.

> 
> Other than the three comments, this looks OK.
> 
> James
> 
> 

