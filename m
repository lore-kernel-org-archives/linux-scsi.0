From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v4 0/5] g_NCR5380: PDMA fixes and cleanup
Date: Thu, 29 Jun 2017 15:27:01 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1706290827440.19937@nippy.intranet>
References: <cover.1498622056.git.fthain@telegraphics.com.au> <201706282328.06806.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:42502 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdF2F07 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 01:26:59 -0400
In-Reply-To: <201706282328.06806.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

On Wed, 28 Jun 2017, Ondrej Zary wrote:

> 
> Now read seems to work on non-DTC chips. Writes continue in PDMA after 
> disconnect but there's a corruption - one 128 B block missing on 
> disconnect.
> 
> On DTC, the log is spammed with errors like this:
> sd 2:0:1:0: [sdb] tag#0 generic_NCR5380_pread: End of DMA timeout (0)
> 
> They're cause by read corruption on DTC: pread() is breaking at 
> start=3968 because of an end-of-DMA IRQ (BASR=0x98) but pdma_residual is 
> set to zero (block counter is zero because the data was read into the 
> buffer but we did not read it from there). So we lose one buffer of data 
> on each 4 KB read.
>

But the algorithm in the datasheet never reads from the buffer after the 
block counter reaches zero. (Of course, the only datasheet we have is for 
a 53c400 device not a DTC436 so all bets are off.)

Anyway, the corrupted data that you describe is telling. I think you're 
right, we have to drain the buffer even when Gated IRQ has been asserted 
(or find a better way to calculate the residual).

I can see a theoretical problem with the code I sent. If the 53c80 raises 
IRQ during the outsb() or insb(), we could still end up with start == end, 
which could mess up both the residual and the handling for an incomplete 
transfer.

> The PDMA is then reset which probably means BASR_END_DMA_TRANSFER will 
> not be asserted.
> 

But the BASR_END_DMA_TRANSFER flag is latched, and resetting the 53c400 
logic should not affect 53c80 registers (assuming they are accessible). So 
the reset does not explain the log messages.

Maybe your BASR=0x98 observations do not co-incide with the log messages. 
Or maybe we need to wait for registers to become accessible after the 
reset.

I've attempted to address all these issues in v5.

Thanks.

-- 
