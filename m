From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] drivers/scsi/ipr.c: reorder error handling code to include
 iounmap
Date: Tue, 14 Jun 2011 11:09:32 -0500
Message-ID: <4DF787BC.8050701@linux.vnet.ibm.com>
References: <1306851409-14963-1-git-send-email-julia@diku.dk> <4DF0EC00.9020603@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42683 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1FNQJ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2011 12:09:56 -0400
In-Reply-To: <4DF0EC00.9020603@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: Julia Lawall <julia@diku.dk>, Brian King <brking@us.ibm.com>, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 06/09/2011 10:51 AM, Wayne Boyer wrote:
> On 05/31/2011 07:16 AM, Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> The out_msi_disable label should be before cleanup_nomem to additionally
>> benefit from the call to iounmap.
> 
> Yes, this is a problem.  I propose the following patch instead.

By removing the out_msi_disable label, if you fail initialization later
on and goto cleanup_nomem, you will end up leaving MSI enabled when you exit
with this patch.

-Brian



> 
> ---
> 
> In the case where ipr_test_msi returns an error that is not -EOPNOTSUPP, the
> execution jumps to the out_msi_disable label.  This misses the call to iounmap
> for ipr_regs which was initialized earlier.
> 
> The fix is to do the call to pci_disable_msi when the error case is detected
> and then goto the cleanup_nomem label if the error is not -EOPNOTSUPP.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c        2011-06-09 08:14:44.927740117 -0700
> +++ b/drivers/scsi/ipr.c        2011-06-09 08:50:10.105630466 -0700
> @@ -8763,11 +8763,11 @@ static int __devinit ipr_probe_ioa(struc
>         /* Enable MSI style interrupts if they are supported. */
>         if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSI && !pci_enable_msi(pdev)) {
>                 rc = ipr_test_msi(ioa_cfg, pdev);
> -               if (rc == -EOPNOTSUPP)
> +               if (rc) {
>                         pci_disable_msi(pdev);
> -               else if (rc)
> -                       goto out_msi_disable;
> -               else
> +                       if (rc != -EOPNOTSUPP)
> +                               goto cleanup_nomem;
> +               } else
>                         dev_info(&pdev->dev, "MSI enabled with IRQ: %d\n", pdev->irq);
>         } else if (ipr_debug)
>                 dev_info(&pdev->dev, "Cannot enable MSI.\n");
> @@ -8847,8 +8847,6 @@ cleanup_nolog:
>         ipr_free_mem(ioa_cfg);
>  cleanup_nomem:
>         iounmap(ipr_regs);
> -out_msi_disable:
> -       pci_disable_msi(pdev);
>  out_release_regions:
>         pci_release_regions(pdev);
>  out_scsi_host_put:
> 
> 


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


