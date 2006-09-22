From: Luca <kronos.it@gmail.com>
Subject: Re: [PATCH]: PCI Error Recovery: Symbios SCSI device driver
Date: Sat, 23 Sep 2006 00:06:29 +0200
Message-ID: <20060922220629.GA4600@dreamland.darkstar.lan>
References: <20060921231314.GW29167@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:47531 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S965210AbWIVWGR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 18:06:17 -0400
Received: by nf-out-0910.google.com with SMTP id o25so1124844nfa
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 15:06:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20060921231314.GW29167@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org


Hi Linas,

Linas Vepstas <linas@austin.ibm.com> ha scritto:
> Index: linux-2.6.18-rc7-git1/drivers/scsi/sym53c8xx_2/sym_glue.c
> ===================================================================
> --- linux-2.6.18-rc7-git1.orig/drivers/scsi/sym53c8xx_2/sym_glue.c      2006-09-21 17:32:54.000000000 -0500
> +++ linux-2.6.18-rc7-git1/drivers/scsi/sym53c8xx_2/sym_glue.c   2006-09-21 17:35:37.000000000 -0500
> +/**
> + * sym2_io_slot_reset() -- called when the pci bus has been reset.
> + * @pdev: pointer to PCI device
> + *
> + * Restart the card from scratch.
> + */
> +static pci_ers_result_t sym2_io_slot_reset (struct pci_dev *pdev)
> +{
> +       struct sym_hcb *np = pci_get_drvdata(pdev);
> +
> +       printk (KERN_INFO "%s: recovering from a PCI slot reset\n",

Space after function name? You put in other places too, it's not
consistent with the rest of the patch.

> +           sym_name(np));
> +
> +       if (pci_enable_device(pdev))
> +               printk (KERN_ERR "%s: device setup failed most egregiously\n",
> +                           sym_name(np));

Is the failure of pci_enable_device ignored on purpose?
(plus extra space)

> +
> +       pci_set_master(pdev);
> +       enable_irq (pdev->irq);

Spurious space.

> +
> +       /* Perform host reset only on one instance of the card */
> +       if (0 == PCI_FUNC (pdev->devfn)) {

Ditto.

> +               if (sym_reset_scsi_bus(np, 0)) {
> +                  printk(KERN_ERR "%s: Unable to reset scsi host controller\n",
> +                                                 sym_name(np));
> +                       return PCI_ERS_RESULT_DISCONNECT;
> +               }
> +               sym_start_up (np, 1);

Ditto.

> +       }
> +
> +       return PCI_ERS_RESULT_RECOVERED;
> +}


Luca
-- 
"L'abilita` politica e` l'abilita` di prevedere quello che
 accadra` domani, la prossima settimana, il prossimo mese e
 l'anno prossimo. E di essere cosi` abili, piu` tardi,
 da spiegare  perche' non e` accaduto."
