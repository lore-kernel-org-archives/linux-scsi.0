From: "adam radford" <aradford@gmail.com>
Subject: Re: [patch 24/36] ioremap balanced with iounmap for drivers/scsi/3w-9xxx.c
Date: Wed, 18 Oct 2006 16:25:24 -0700
Message-ID: <b1bc6a000610181625k3d6db3bo90289baa541b2ffc@mail.gmail.com>
References: <200610102141.k9ALffof025432@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:43169 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751543AbWJRXZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 19:25:26 -0400
Received: by nf-out-0910.google.com with SMTP id c2so821485nfe
        for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 16:25:24 -0700 (PDT)
In-Reply-To: <200610102141.k9ALffof025432@shell0.pdx.osdl.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "akpm@osdl.org" <akpm@osdl.org>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, amol@verismonetworks.com

On 10/10/06, akpm@osdl.org <akpm@osdl.org> wrote:
> From: Amol Lad <amol@verismonetworks.com>
>
> ioremap must be balanced by an iounmap and failing to do so can result in a
> memory leak.
>
>  drivers/scsi/3w-9xxx.c |    5 +++++
>  1 files changed, 5 insertions(+)
>
> diff -puN drivers/scsi/3w-9xxx.c~ioremap-balanced-with-iounmap-drivers-scsi-3w-9xxxc drivers/scsi/3w-9xxx.c
> --- a/drivers/scsi/3w-9xxx.c~ioremap-balanced-with-iounmap-drivers-scsi-3w-9xxxc
> +++ a/drivers/scsi/3w-9xxx.c
> @@ -2147,6 +2147,8 @@ out_remove_host:
>         scsi_remove_host(host);
>  out_release_mem_region:
>         pci_release_regions(pdev);
> +       if (tw_dev->base_addr)
> +               iounmap(tw_dev->base_addr);
>  out_free_device_extension:
>         twa_free_device_extension(tw_dev);
>         scsi_host_put(host);
> @@ -2173,6 +2175,9 @@ static void twa_remove(struct pci_dev *p
>         /* Free up the IRQ */
>         free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
>
> +       /* Free IO mem */
> +       iounmap(tw_dev->base_addr);
> +
>         /* Shutdown the card */
>         __twa_shutdown(tw_dev);
>
> _
>

NAK...  The second iounmap() call is placed incorrectly.  __twa_shutdown()
is called after that, and it still needs to use the registers.  I'll
roll a corrected
patch into my next update.

-Adam
