From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 14:12:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928141228.A1815@infradead.org>
References: <4159611C.4030106@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:32019 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267804AbUI1NMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:12:31 -0400
Content-Disposition: inline
In-Reply-To: <4159611C.4030106@adaptec.com>; from luben_tuikov@adaptec.com on Tue, Sep 28, 2004 at 09:03:24AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

> config SCSI_AIC79XX
> 	tristate "Adaptec AIC79xx U320 support"
> -	depends on PCI && SCSI
> +	depends on PCI

wrong.

> config AIC79XX_BUILD_FIRMWARE
> 	bool "Build Adapter Firmware with Kernel Build"
> -	depends on SCSI_AIC79XX && !PREVENT_FIRMWARE_BUILD
> +	depends on SCSI_AIC79XX

wrong.

> -	depends on (PCI || EISA) && SCSI
> +	depends on PCI || EISA

wrong.

> 	---help---
> 	This driver supports all of Adaptec's Fast through Ultra 160 PCI
> 	based SCSI controllers as well as the aic7770 based EISA and VLB
> 	SCSI controllers (the 274x and 284x series).  For AAA and ARO based
> 	configurations, only SCSI functionality is provided.
> 
> -	To compile this driver as a module, choose M here: the
> -	module will be called aic7xxx.
> +	If you want to compile the driver as a module ( = code which can be
> +	inserted in and removed from the running kernel whenever you want),
> +	say M here and read <file:Documentation/modules.txt>.  The module
> +	will be called aic7xxx.

wrong.

> 
> config AIC7XXX_CMDS_PER_DEVICE
> 	int "Maximum number of TCQ commands per device"
> @@ -61,7 +63,7 @@
> 
> config AIC7XXX_BUILD_FIRMWARE
> 	bool "Build Adapter Firmware with Kernel Build"
> -	depends on SCSI_AIC7XXX && !PREVENT_FIRMWARE_BUILD
> +	depends on SCSI_AIC7XXX

wrong.

> -ifdef WARNINGS_BECOME_ERRORS
> -EXTRA_CFLAGS += -Werror
> -endif
> +EXTRA_CFLAGS += -Idrivers/scsi -Werror

wrong.

> ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
> -# Create a dependency chain in generated files
> -# to avoid concurrent invocations of the single
> -# rule that builds them all.
> -aic7xxx_seq.h: aic7xxx_reg.h
> -ifeq ($(CONFIG_AIC7XXX_REG_PRETTY_PRINT),y)
> -aic7xxx_reg.h: aic7xxx_reg_print.c
> -endif

wrong.

> ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
> -# Create a dependency chain in generated files
> -# to avoid concurrent invocations of the single
> -# rule that builds them all.
> -aic79xx_seq.h: aic79xx_reg.h
> -ifeq ($(CONFIG_AIC79XX_REG_PRETTY_PRINT),y)
> -aic79xx_reg.h: aic79xx_reg_print.c
> -endif

wrong.

> -static ahc_device_setup_t ahc_aic7770_EISA_setup;
> +static ahc_device_setup_t ahc_aic7770_EISA_setup;;

wrong,

> -		printf("aic7770_config: invalid irq setting %d\n", intdef);
> +		printf("aic7770_config: illegal irq setting %d\n", intdef);

wrong.

Luben, I give up on this patch.  So far this is exclusively reverting
fixes we had in mainline.
