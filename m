From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: Use module_pci_driver
Date: Thu, 9 Jul 2015 21:47:02 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1507092121210.21065@nippy.intranet>
References: <20150708043155.GA10532@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44897 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbbGILrR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2015 07:47:17 -0400
In-Reply-To: <20150708043155.GA10532@vaishali-Ideapad-Z570>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vaishali Thakkar <vthakkar1994@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Hannes Reinecke <hare@suse.de>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Michael Schmitz <schmitzmic@gmail.com>, Don Brace <don.brace@pmcs.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dc395x@twibble.org, iss_storagedev@hp.com, storagedev@pmcs.com


On Wed, 8 Jul 2015, Vaishali Thakkar wrote:

> Use module_pci_driver for drivers whose init and exit functions
> only register and unregister, respectively.
> 
> A simplified version of the Coccinelle semantic patch that performs
> this transformation is as follows:
> 
> @a@
> identifier f, x;
> @@
> -static f(...) { return pci_register_driver(&x); }
> 
> @b depends on a@
> identifier e, a.x;
> @@
> -static e(...) { pci_unregister_driver(&x); }
> 
> @c depends on a && b@
> identifier a.f;
> declarer name module_init;
> @@
> -module_init(f);
> 
> @d depends on a && b && c@
> identifier b.e, a.x;
> declarer name module_exit;
> declarer name module_pci_driver;
> @@
> -module_exit(e);
> +module_pci_driver(x);
> 
> Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>

Acked-by: Finn Thain <fthain@telegraphics.com.au>

> ---
>  drivers/scsi/a100u2w.c  | 14 +-------------
>  drivers/scsi/am53c974.c | 14 +-------------
>  drivers/scsi/dc395x.c   | 25 +------------------------
>  drivers/scsi/dmx3191d.c | 14 +-------------
>  drivers/scsi/hpsa.c     | 18 +-----------------
>  drivers/scsi/initio.c   | 14 +-------------
>  drivers/scsi/mvumi.c    | 21 +--------------------
>  drivers/scsi/wd719x.c   | 14 +-------------
>  8 files changed, 8 insertions(+), 126 deletions(-)
> 
> diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
> index cac6b37..927c1a4 100644
> --- a/drivers/scsi/a100u2w.c
> +++ b/drivers/scsi/a100u2w.c
> @@ -1222,19 +1222,7 @@ static struct pci_driver inia100_pci_driver = {
>  	.remove		= inia100_remove_one,
>  };
>  
> -static int __init inia100_init(void)
> -{
> -	return pci_register_driver(&inia100_pci_driver);
> -}
> -
> -static void __exit inia100_exit(void)
> -{
> -	pci_unregister_driver(&inia100_pci_driver);
> -}
> -
>  MODULE_DESCRIPTION("Initio A100U2W SCSI driver");
>  MODULE_AUTHOR("Initio Corporation");
>  MODULE_LICENSE("Dual BSD/GPL");
> -
> -module_init(inia100_init);
> -module_exit(inia100_exit);
> +module_pci_driver(inia100_pci_driver);
> diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
> index beea30e..0234b38 100644
> --- a/drivers/scsi/am53c974.c
> +++ b/drivers/scsi/am53c974.c
> @@ -556,16 +556,6 @@ static struct pci_driver am53c974_driver = {
>  	.remove         = pci_esp_remove_one,
>  };
>  
> -static int __init am53c974_module_init(void)
> -{
> -	return pci_register_driver(&am53c974_driver);
> -}
> -
> -static void __exit am53c974_module_exit(void)
> -{
> -	pci_unregister_driver(&am53c974_driver);
> -}
> -
>  MODULE_DESCRIPTION("AM53C974 SCSI driver");
>  MODULE_AUTHOR("Hannes Reinecke <hare@suse.de>");
>  MODULE_LICENSE("GPL");
> @@ -577,6 +567,4 @@ MODULE_PARM_DESC(am53c974_debug, "Enable debugging");
>  
>  module_param(am53c974_fenab, bool, 0444);
>  MODULE_PARM_DESC(am53c974_fenab, "Enable 24-bit DMA transfer sizes");
> -
> -module_init(am53c974_module_init);
> -module_exit(am53c974_module_exit);
> +module_pci_driver(am53c974_driver);
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index 5ee7f44..a0a6eaf 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -4870,30 +4870,7 @@ static struct pci_driver dc395x_driver = {
>  	.probe          = dc395x_init_one,
>  	.remove         = dc395x_remove_one,
>  };
> -
> -
> -/**
> - * dc395x_module_init - Module initialization function
> - *
> - * Used by both module and built-in driver to initialise this driver.
> - **/
> -static int __init dc395x_module_init(void)
> -{
> -	return pci_register_driver(&dc395x_driver);
> -}
> -
> -
> -/**
> - * dc395x_module_exit - Module cleanup function.
> - **/
> -static void __exit dc395x_module_exit(void)
> -{
> -	pci_unregister_driver(&dc395x_driver);
> -}
> -
> -
> -module_init(dc395x_module_init);
> -module_exit(dc395x_module_exit);
> +module_pci_driver(dc395x_driver);
>  
>  MODULE_AUTHOR("C.L. Huang / Erich Chen / Kurt Garloff");
>  MODULE_DESCRIPTION("SCSI host adapter driver for Tekram TRM-S1040 based adapters: Tekram DC395 and DC315 series");
> diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
> index 3e08812..2913fc7 100644
> --- a/drivers/scsi/dmx3191d.c
> +++ b/drivers/scsi/dmx3191d.c
> @@ -143,19 +143,7 @@ static struct pci_driver dmx3191d_pci_driver = {
>  	.probe		= dmx3191d_probe_one,
>  	.remove		= dmx3191d_remove_one,
>  };
> -
> -static int __init dmx3191d_init(void)
> -{
> -	return pci_register_driver(&dmx3191d_pci_driver);
> -}
> -
> -static void __exit dmx3191d_exit(void)
> -{
> -	pci_unregister_driver(&dmx3191d_pci_driver);
> -}
> -
> -module_init(dmx3191d_init);
> -module_exit(dmx3191d_exit);
> +module_pci_driver(dmx3191d_pci_driver);
>  
>  MODULE_AUTHOR("Massimo Piccioni <dafastidio@libero.it>");
>  MODULE_DESCRIPTION("Domex DMX3191D SCSI driver");
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 1dafeb4..3f04f42 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -8697,20 +8697,6 @@ static void hpsa_drain_accel_commands(struct ctlr_info *h)
>  	} while (1);
>  }
>  
> -/*
> - *  This is it.  Register the PCI driver information for the cards we control
> - *  the OS will call our registered routines when it finds one of our cards.
> - */
> -static int __init hpsa_init(void)
> -{
> -	return pci_register_driver(&hpsa_pci_driver);
> -}
> -
> -static void __exit hpsa_cleanup(void)
> -{
> -	pci_unregister_driver(&hpsa_pci_driver);
> -}
> -
>  static void __attribute__((unused)) verify_offsets(void)
>  {
>  #define VERIFY_OFFSET(member, offset) \
> @@ -8788,6 +8774,4 @@ static void __attribute__((unused)) verify_offsets(void)
>  	VERIFY_OFFSET(SG, 0x78 + 8);
>  #undef VERIFY_OFFSET
>  }
> -
> -module_init(hpsa_init);
> -module_exit(hpsa_cleanup);
> +module_pci_driver(hpsa_pci_driver);
> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 6a926ba..ea12a66 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -2994,19 +2994,7 @@ static struct pci_driver initio_pci_driver = {
>  	.remove		= initio_remove_one,
>  };
>  
> -static int __init initio_init_driver(void)
> -{
> -	return pci_register_driver(&initio_pci_driver);
> -}
> -
> -static void __exit initio_exit_driver(void)
> -{
> -	pci_unregister_driver(&initio_pci_driver);
> -}
> -
>  MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
>  MODULE_AUTHOR("Initio Corporation");
>  MODULE_LICENSE("GPL");
> -
> -module_init(initio_init_driver);
> -module_exit(initio_exit_driver);
> +module_pci_driver(initio_pci_driver);
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 3e6b866..3842cd9 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -2729,23 +2729,4 @@ static struct pci_driver mvumi_pci_driver = {
>  	.resume = mvumi_resume,
>  #endif
>  };
> -
> -/**
> - * mvumi_init - Driver load entry point
> - */
> -static int __init mvumi_init(void)
> -{
> -	return pci_register_driver(&mvumi_pci_driver);
> -}
> -
> -/**
> - * mvumi_exit - Driver unload entry point
> - */
> -static void __exit mvumi_exit(void)
> -{
> -
> -	pci_unregister_driver(&mvumi_pci_driver);
> -}
> -
> -module_init(mvumi_init);
> -module_exit(mvumi_exit);
> +module_pci_driver(mvumi_pci_driver);
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index 61346aa..a9981de 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -975,19 +975,7 @@ static struct pci_driver wd719x_pci_driver = {
>  	.probe =	wd719x_pci_probe,
>  	.remove =	wd719x_pci_remove,
>  };
> -
> -static int __init wd719x_init(void)
> -{
> -	return pci_register_driver(&wd719x_pci_driver);
> -}
> -
> -static void __exit wd719x_exit(void)
> -{
> -	pci_unregister_driver(&wd719x_pci_driver);
> -}
> -
> -module_init(wd719x_init);
> -module_exit(wd719x_exit);
> +module_pci_driver(wd719x_pci_driver);
>  
>  MODULE_DESCRIPTION("Western Digital WD7193/7197/7296 SCSI driver");
>  MODULE_AUTHOR("Ondrej Zary, Aaron Dewell, Juergen Gaertner");
> 
