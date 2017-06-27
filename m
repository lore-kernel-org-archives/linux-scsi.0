From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Tue, 27 Jun 2017 22:42:29 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1706272205340.25239@nippy.intranet>
References: <cover.1498461406.git.fthain@telegraphics.com.au> <201706262127.03911.linux@rainbow-software.org> <201706270828.40336.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:47240 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbdF0Mma (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 08:42:30 -0400
In-Reply-To: <201706270828.40336.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

On Tue, 27 Jun 2017, Ondrej Zary wrote:

> BTW. I've probably found the DTC write corruption. Added the following 
> check (13 is host buffer index register) -

That register is not mentioned in my 53c400 datasheet.

> and it triggers sometimes: the value is 1 instead of 0. As we use only 
> 16-bit writes, I don't see how the value could ever be odd. Looks like a 
> bug in the chip. The index register corrupts during the transfer, not 
> after IRQ or timeout. The same check at beginning of pwrite() did not 
> trigger.
> 

Are you reading this register at the right moment? Have you tried waiting 
for it to reach zero, as in,

	if (NCR5380_poll_politely(hostdata, 13, 0xff, 0, HZ / 64) < 0)
		/* printk, reset etc */;

Even if this is a reliable way to detect a short transfer, it would be 
nice to know the root cause. But I'm being unrealistic: the DTC436 vendor 
never responded to my requests for technical documentation.

> The index register is not writable so we must(?) reset the PDMA engine 
> to recover. However, this quick attempt to fix does not work, maybe we 
> should reload the block count and continue?
> 

I don't know if it is possible to recover. If the last byte never reached 
the scsi bus, then once you reset the 53c400 core, you need the driver to 
perform a single-byte PIO transfer after the short PDMA transfer. This 
would require that you set the residual appropriately (though in my 
experience that may not be sufficient).

It may be better to simply limit the transfer to 512 bytes instead of 
attempting to recover based on an undocumented (?) register, etc. Seems 
like a bit of a hack.

> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -595,7 +603,13 @@ static inline int generic_NCR5380_pwrite(struct 
> NCR5380_hostdata *hostdata,
>                                 goto out_wait;
>                         }
>                 }
> -
> +               idx = NCR5380_read(13);
> +               if (idx != 0) {
> +                       printk("host idx=%d, start=%d\n", idx, start);
> +                       NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
> +                       NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
> +                       goto out_wait;
> +               }
>                 if (hostdata->io_port && hostdata->io_width == 2)
>                         outsw(hostdata->io_port + hostdata->c400_host_buf,
>                                                         src + start, 64);
> 

I find it hard to reason about this code. For example, out_wait is to be 
removed. Let's get the preceding patches working and signed-off. Please go 
ahead and use a 512 B transfer for DTC436 testing if that will help get 
this patch series over the line.

-- 
