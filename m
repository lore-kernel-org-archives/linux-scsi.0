From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] hpsa: refine the pci enble/disable handling]
Date: Wed, 13 Aug 2014 15:24:45 -0500
Message-ID: <20140813202445.GE19666@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:20266 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaHMUZi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Aug 2014 16:25:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, tomas.henzl@redhat.com, michael.miller@canonical.com, joseph.t.handzik@hp.com


Let me try again, this time not from gmail.

On Thu, Jun 12, 2014 at 10:29 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> When a second(kdump) kernel starts and the hard reset method is used
> the driver calls pci_disable_device without previously enabling it,
> so the kernel shows a warning -
> [   16.876248] WARNING: at drivers/pci/pci.c:1431
> pci_disable_device+0x84/0x90()
> [   16.882686] Device hpsa
> disabling already-disabled device
> ...
> This patch fixes it, in addition to this I tried to balance also some
> other pairs
> of enable/disable device in the driver.
> Unfortunately I wasn't able to verify the functionality for the case of a
> sw reset,
> because of a lack of proper hw.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 5858600..67c41b9 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -5983,7 +5983,6 @@ static int hpsa_kdump_hard_reset_controller(struct
> pci_dev *pdev)
>         /* Turn the board off.  This is so that later pci_restore_state()
>          * won't turn the board on before the rest of config space is
> ready.
>          */
> -       pci_disable_device(pdev);
>         pci_save_state(pdev);
>
>         /* find the first memory BAR, so we can find the cfg table */
> @@ -6031,11 +6030,6 @@ static int hpsa_kdump_hard_reset_controller(struct
> pci_dev *pdev)
>                 goto unmap_cfgtable;
>
>         pci_restore_state(pdev);
> -       rc = pci_enable_device(pdev);
> -       if (rc) {
> -               dev_warn(&pdev->dev, "failed to enable device.\n");
> -               goto unmap_cfgtable;
> -       }
>         pci_write_config_word(pdev, 4, command_register);
>
>         /* Some devices (notably the HP Smart Array 5i Controller)
> @@ -6548,6 +6542,12 @@ static int hpsa_init_reset_devices(struct pci_dev
> *pdev)
>         if (!reset_devices)
>                 return 0;
>
> +       rc = pci_enable_device(pdev);
> +       if (rc) {
> +               dev_warn(&pdev->dev, "failed to enable device.\n");
> +               return -ENODEV;
> +       }
> +
>         /* Reset the controller with a PCI power-cycle or via doorbell */
>         rc = hpsa_kdump_hard_reset_controller(pdev);
>
> @@ -6556,10 +6556,11 @@ static int hpsa_init_reset_devices(struct pci_dev
> *pdev)
>          * "performant mode".  Or, it might be 640x, which can't reset
>          * due to concerns about shared bbwc between 6402/6404 pair.
>          */
> -       if (rc == -ENOTSUPP)
> -               return rc; /* just try to do the kdump anyhow. */
> -       if (rc)
> -               return -ENODEV;
> +       if (rc) {
> +               if (rc != -ENOTSUPP) /* just try to do the kdump anyhow. */
> +                       rc = -ENODEV;
> +               goto out_disable;
>


Checkpatch complained of trailing whitespace here. ^^^

Other than that, looks good.

-- steve


> +       }
>
>         /* Now try to get the controller to respond to a no-op */
>         dev_warn(&pdev->dev, "Waiting for controller to respond to
> no-op\n");
> @@ -6570,7 +6571,11 @@ static int hpsa_init_reset_devices(struct pci_dev
> *pdev)
>                         dev_warn(&pdev->dev, "no-op failed%s\n",
>                                         (i < 11 ? "; re-trying" : ""));
>         }
> -       return 0;
> +
> +out_disable:
> +
> +       pci_disable_device(pdev);
> +       return rc;
>  }
>
>  static int hpsa_allocate_cmd_pool(struct ctlr_info *h)
> @@ -6722,6 +6727,7 @@ static void
> hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
>                 iounmap(h->transtable);
>         if (h->cfgtable)
>                 iounmap(h->cfgtable);
> +       pci_disable_device(h->pdev);
>         pci_release_regions(h->pdev);
>         kfree(h);
>  }
> --
> 1.8.3.1
>
>

----- End forwarded message -----
