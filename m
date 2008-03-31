From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/9][RESEND] mvsas : interrupt handling
Date: Mon, 31 Mar 2008 09:46:17 -0500
Message-ID: <1206974777.3192.7.camel@localhost.localdomain>
References: <47EB449F.20201@marvell.com>
	 <1206889797.4224.20.camel@localhost.localdomain>
	 <47F0BBB0.7030606@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54216 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759491AbYCaOqY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 10:46:24 -0400
In-Reply-To: <47F0BBB0.7030606@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kewei@marvell.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org

On Mon, 2008-03-31 at 18:23 +0800, Ke Wei wrote:
> James Bottomley wrote:
> > This tasklet usage doesn't quite look right.  What a tasklet does is
> > defer processing until after all interrupts have completed.  It's
> > commonly used for aggregation, which is why scsi_done simply queues for
> > the block softirq (tasklet).  However, for mvsas, I don't see any
> > benefit to defering the work to a tasklet.
> 
> OK, I understood. I will remove tasklet feature.
> 
> > 
> > Additionally, for the non MSI case, doesn't the interrupt, which is
> > level triggered, fail to deassert because we haven't cleared any
> > registers?
> > 
> I don't understood what you said. What's your meaning about non MSI case. 

A level triggered interrupt stays asserted until the condition causing
it is removed.  I've no idea what this is for mvsas, but for most SCSI
cards it's a write to an ISTAT like register to acknowledge receipt of
the interrupt.   If you don't deassert the interrupt, it reinterrupts
again as soon as you return from the interrupt routine, so you can't
defer the event that would cause the interrupt to be deasserted to a
tasklet or softirq otherwise you'll never get there.

James


