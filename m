From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bugme-new] [Bug 16058] New: [BUG] Cannot boot any kernel from
 2.6.27 on if a 256 byte sector SCSI disk is attached
Date: Fri, 28 May 2010 10:58:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1005281050030.1939-100000@iolanthe.rowland.org>
References: <4BFFAE25.4010007@cfl.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33855 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750929Ab0E1O6R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 10:58:17 -0400
In-Reply-To: <4BFFAE25.4010007@cfl.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Hounschell <dmarkh@cfl.rr.com>
Cc: markh@compro.net, SCSI development list <linux-scsi@vger.kernel.org>, bugzilla-daemon@bugzilla.kernel.org

On Fri, 28 May 2010, Mark Hounschell wrote:

> First READ(10):
> 
>  sde:
> ahc_calc_residual: Entered
> ahc_calc_residual: return Case 5-1 resid = 0x800
> ahc_calc_residual: return Case 5-2 resid = 0x800
> 
> scsi_finish_command: Entered for cmd(10):0x28 0x00 0x00 0x00 0x00 0x00
> 0x00 0x00 0x08 0x00
> cmd->result = 0x00000000
> good_bytes == old_good_bytes = 0x800  scsi_get_resid(cmd) = 0x800
> New good_bytes = 0x0
> scsi_finish_command: Complete
> 
> From here it just keeps repeating this read of 8 blocks. (2048 bytes) so
> it looks like the machine is hung.

Probably not hung, just doing a lot of retries.  It should time out 
eventually, but it might take a long time (perhaps as long as 15 
minutes).  The combination of the block layer and the SCSI layer isn't 
very good at knowing when to give up.

> Now, I know for a fact that _if_ this read CDB is actually being sent to
> the drive, it's actual residual count will be zero. These are working
> disks and that read CDB is valid.
> 
> Why is ahc_calc_residual saying that the residual count is as though the
> read never took place? I noticed that the first read on all the SATA
> drives was for 4096 bytes, why is this one only 2048? Should it have
> been 4096 and ahc_calc_residual assume that?

I don't know the answer to any of these questions.  They could well be
due to bugs in the driver, and I know nothing about how the aic7xxx
driver works.  You should talk to someone who does.

In the meantime, you can track this down a little farther by adding
printk's to the appropriate places in drivers/scsi/sd.c.  Look at
sd_prep_fn() to see why there's 2048 bytes instead of 4096.

Alan Stern


