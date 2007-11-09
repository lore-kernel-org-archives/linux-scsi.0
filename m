From: "adam radford" <aradford@gmail.com>
Subject: Re: [PATCH] 3w-9xxx: fix abysmal write performance on some motherboards
Date: Fri, 9 Nov 2007 10:10:17 -0800
Message-ID: <b1bc6a000711091010j1d0e1a1q2a50f927fca8e1ea@mail.gmail.com>
References: <4734A133.8090207@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:36775 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbXKISKS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2007 13:10:18 -0500
Received: by rv-out-0910.google.com with SMTP id k20so536813rvb
        for <linux-scsi@vger.kernel.org>; Fri, 09 Nov 2007 10:10:18 -0800 (PST)
In-Reply-To: <4734A133.8090207@cybernetics.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linuxraid@amcc.com, linux-scsi@vger.kernel.org

On Nov 9, 2007 10:04 AM, Tony Battersby <tonyb@cybernetics.com> wrote:
> The 3ware 9500S-8 SATA RAID controller exhibits terrible write
> performance when PCI memory-write-and-invalidate is disabled.  This is
> easy to demonstrate by replacing pci_try_set_mwi() in the patch below
> with pci_clear_mwi().  My benchmarks show the following:
>
> MWI disabled: 15 MB/s write, 330 MB/s read
> MWI enabled:  240 MB/s write, 330 MB/s read
>
> Most motherboards will enable MWI without the driver having to set it
> explicitly, so most people probably wouldn't encounter this problem.
> For the few motherboards that don't enable it, this patch could give a
> 16x performance improvement for writing.
>
> This issue does not seem to affect the 9550SX controller, but the patch
> doesn't hurt it either.  I haven't tested any of the other 3ware
> controllers.
>
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> --- linux-2.6.24-rc2/drivers/scsi/3w-9xxx.c.orig        2007-11-09 12:32:32.000000000 -0500
> +++ linux-2.6.24-rc2/drivers/scsi/3w-9xxx.c     2007-11-09 12:33:20.000000000 -0500
> @@ -2010,6 +2010,7 @@ static int __devinit twa_probe(struct pc
>        }
>
>        pci_set_master(pdev);
> +       pci_try_set_mwi(pdev);
>
>        if (pci_set_dma_mask(pdev, DMA_64BIT_MASK)
>            || pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

ACK...

-Adam
