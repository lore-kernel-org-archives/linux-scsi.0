From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] libsas: add host SMP processing
Date: Sat, 29 Dec 2007 14:24:54 +0900
Message-ID: <200712290524.lBT5Ot2u004870@mbox.iij4u.or.jp>
References: <1198884998.3174.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:45155 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbXL2FZF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Dec 2007 00:25:05 -0500
In-Reply-To: <1198884998.3174.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] libsas: add host SMP processing
Date: Fri, 28 Dec 2007 17:36:38 -0600

> This patch allows the sas host device to accept SMP commands.  This
> brings the libsas attached hosts on to a par with the firmware based
> ones like mptsas.
> 
> James
> 
> diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
> index c01a40d..18f33cd 100644
> --- a/drivers/scsi/libsas/Kconfig
> +++ b/drivers/scsi/libsas/Kconfig
> @@ -38,6 +38,15 @@ config SCSI_SAS_ATA
>  		Builds in ATA support into libsas.  Will necessitate
>  		the loading of libata along with libsas.
>  
> +config SCSI_SAS_HOST_SMP
> +	bool "Support for SMP interpretation for SAS hosts"
> +	default y
> +	depends on SCSI_SAS_LIBSAS
> +	help
> +		Allows sas hosts to receive SMP frames.  Selecting this
> +		option builds an SMP interpreter into libsas.  Say
> +		N here if you want to save the few kb this consumes.
> +
>  config SCSI_SAS_LIBSAS_DEBUG
>  	bool "Compile the SAS Domain Transport Attributes in debug mode"
>  	default y
> diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
> index fd387b9..60d6e93 100644
> --- a/drivers/scsi/libsas/Makefile
> +++ b/drivers/scsi/libsas/Makefile
> @@ -35,3 +35,4 @@ libsas-y +=  sas_init.o     \
>  		sas_expander.o \
>  		sas_scsi_host.o
>  libsas-$(CONFIG_SCSI_SAS_ATA) +=	sas_ata.o
> +libsas-$(CONFIG_SCSI_SAS_HOST_SMP) +=	sas_host_smp.o
> \ No newline at end of file
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 27674fe..76555b1 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1896,11 +1896,9 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  	}
>  
>  	/* no rphy means no smp target support (ie aic94xx host) */
> -	if (!rphy) {
> -		printk("%s: can we send a smp request to a host?\n",
> -		       __FUNCTION__);
> -		return -EINVAL;
> -	}
> +	if (!rphy)
> +		return sas_smp_host_handler(shost, req, rsp);
> +

I have one related question.

Currently, bsg doesn't return an error to user space since I had no
idea how to convert errors such as EINVAL and ENOMEM into
driver_status, transport_status, and device_status in struct sg_io_v4.
I think that it's confusing that bsg don't return an error even if SMP
requests aren't sent (e.g. devices are offline).

Do we need to map errors to the current error code in scsi/scsi.h
(like DID_*) or define a new one for SMP?
