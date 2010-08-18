From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/2] scsi: fix kconfig dependency warnings
Date: Wed, 18 Aug 2010 09:28:46 -0500
Message-ID: <1282141726.3035.8.camel@mulgrave.site>
References: <20100817113656.c4191013.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56612 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab0HRO24 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 10:28:56 -0400
In-Reply-To: <20100817113656.c4191013.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>

On Tue, 2010-08-17 at 11:36 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig dependency warnings in scsi/Kconfig:
> 
> warning: (SCSI_SAS_LIBSAS && SCSI || SCSI_MPT2SAS && SCSI_LOWLEVEL && PCI && SCSI || FUSION_SAS && FUSION && PCI && SCSI) selects SCSI_SAS_ATTRS which has unmet direct dependencies (SCSI && BLK_DEV_BSG)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Ralf Baechle <ralf@linux-mips.org>
> ---
>  drivers/scsi/Kconfig        |    3 ++-
>  drivers/scsi/libsas/Kconfig |    1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> --- linux-next-20100810.orig/drivers/scsi/libsas/Kconfig
> +++ linux-next-20100810/drivers/scsi/libsas/Kconfig
> @@ -26,6 +26,7 @@ config SCSI_SAS_LIBSAS
>  	tristate "SAS Domain Transport Attributes"
>  	depends on SCSI
>  	select SCSI_SAS_ATTRS
> +	select BLK_DEV_BSG

This isn't right if you do the below.

Selects cascade.

>  	help
>  	  This provides transport specific helpers for SAS drivers which
>  	  use the domain device construct (like the aic94xxx).
> --- linux-next-20100810.orig/drivers/scsi/Kconfig
> +++ linux-next-20100810/drivers/scsi/Kconfig
> @@ -316,7 +316,8 @@ config SCSI_ISCSI_ATTRS
>  
>  config SCSI_SAS_ATTRS
>  	tristate "SAS Transport Attributes"
> -	depends on SCSI && BLK_DEV_BSG
> +	depends on SCSI
> +	select BLK_DEV_BSG

So this is the only part that's necessary, isn't it?  Could you resubmit
with just this?

Thanks,

James


