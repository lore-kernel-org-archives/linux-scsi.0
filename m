From: Pavel Machek <pavel@suse.cz>
Subject: Re: [patch] ACPI work on aic7xxx
Date: Tue, 20 Jul 2004 17:59:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040720155928.GC10921@atrey.karlin.mff.cuni.cz>
References: <40FD38A0.3000603@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:22932 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S265960AbUGTP73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2004 11:59:29 -0400
Content-Disposition: inline
In-Reply-To: <40FD38A0.3000603@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: linux-scsi@vger.kernel.org, random1@o-o.yi.org, Luben Tuikov <luben_tuikov@adaptec.com>

Hi!

> It still doesn't work. The driver complains, "scsi0: Someone reset 
> channel A" repeatedly. This message is coming from the driver's 
> interrupt handler, so either the card registers are improperly 
> reinitialized in some way, or the driver's state engine is not clearing 
> the interrupt status, or we're somehow causing the reset to occur again 
> and again. I'm not sure how much further I can take this without a data 
> book or some help figuring out the card and driver state machines. I 
> guess either the card's state machine or the driver's state machine has 
> been driven insane, but I'm not sure what direction to look in.
> 
> This patch also includes a small fix for a bad merge, as suggested by 
> Pavel Machec. See 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=108306129820558&w=2

It looks better tha what was there (modulo whitespace)

								Pavel

> diff -urN linux-2.6.7-1.492.backup/drivers/scsi/aic7xxx/aic7xxx.h linux-2.6.7-1.492/drivers/scsi/aic7xxx/aic7xxx.h
> --- linux-2.6.7-1.492.backup/drivers/scsi/aic7xxx/aic7xxx.h	2004-06-16 01:19:29.000000000 -0400
> +++ linux-2.6.7-1.492/drivers/scsi/aic7xxx/aic7xxx.h	2004-07-19 23:27:51.000000000 -0400
> @@ -1109,6 +1109,8 @@
>  
>  	uint16_t	 	  user_discenable;/* Disconnection allowed  */
>  	uint16_t		  user_tagenable;/* Tagged Queuing allowed */
> +
> +	u32                      PciState[64]; /* save PCI state to this area */
>  };
>  
>  TAILQ_HEAD(ahc_softc_tailq, ahc_softc);

Space-vs-tabs are inconsistent here.

> @@ -225,6 +233,72 @@
>  #endif
>  }
>  
> +#ifdef CONFIG_PM
> +int ahc_linux_pci_suspend(struct pci_dev *dev, u32 state)
> +{
> +	int rval;
> +	u32 device_state;
> +	struct ahc_softc *ahc =
> +		ahc_find_softc((struct ahc_softc *)pci_get_drvdata(dev));
> +
> +#if 0
> +        switch(state)
> +        {
> +                case 1: /* S1 */
> +                        device_state=1; /* D1 */;
> +                        break;
> +                case 3: /* S3 */
> +                case 4: /* S4 */
> +                        device_state=3; /* D3 */;
> +                        break;
> +                default:
> +                        return -EAGAIN /*FIXME*/;
> +                        break;
> +        }
> +#else
> +	device_state = state;
> +#endif

Can you kill #if 0 code?

> +{
> +	int rval;
> +	int device_state = dev->current_state;
> +	struct ahc_softc *ahc =
> +		ahc_find_softc((struct ahc_softc *)pci_get_drvdata(dev));
> +
> +        printk(KERN_INFO
> +        "aic7xxx: pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
> +                dev, pci_name(dev), device_state);
> +
> +        pci_set_power_state(dev, AHC_POWER_STATE_D0);
> +        pci_restore_state(dev, ahc->PciState);
> +        pci_enable_device(dev);
> +        pci_set_master(dev);
> +
> +	rval = ahc->bus_resume(ahc);

Heavy whitespace damage here, and in following hunks.

								Pavel
-- 
Horseback riding is like software...
...vgf orggre jura vgf serr.
