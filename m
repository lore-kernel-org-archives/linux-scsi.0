From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5] mvsas : redesign the mvsas driver architecture.
Date: Tue, 24 Feb 2009 17:15:18 +0000
Message-ID: <1235495718.3204.37.camel@localhost.localdomain>
References: <49A3C100.8040005@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59533 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756867AbZBXRPX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2009 12:15:23 -0500
In-Reply-To: <49A3C100.8040005@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kewei@marvell.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, qzhao@marvell.com, qswang@marvell.com, jfeng@marvell.com, Jason Chu <jasonchu@marvell.com>

On Tue, 2009-02-24 at 17:42 +0800, Ke Wei wrote:
> We redesign the mvsas driver architecture. Then the driver can support
> Marvell's
> 64 bit PCIE-X SAS/SATA 3Gb/s mv64xx chip and 6Gb/s mv94xx chip based
> host
> adapters. I created a directory for the driver in scsi folder and
> delete the
> original simple driver.
> 
> modify Kconfig entry for the mvsas driver, and change the driver path.
> 
> Signed-off-by: Ke Wei <kewei@marvell.com>
> ---
>  drivers/scsi/Kconfig  |   10 +-
>  drivers/scsi/Makefile |    2 +-
>  drivers/scsi/mvsas.c  | 3222
> -------------------------------------------------
>  3 files changed, 2 insertions(+), 3232 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 256c7be..b64882b 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1029,15 +1029,7 @@ config SCSI_IZIP_SLOW_CTR
> 
>           Generally, saying N is fine.
> 
> -config SCSI_MVSAS
> -       tristate "Marvell 88SE6440 SAS/SATA support"
> -       depends on PCI && SCSI
> -       select SCSI_SAS_LIBSAS
> -       help
> -         This driver supports Marvell SAS/SATA PCI devices.
> -
> -         To compiler this driver as a module, choose M here: the
> module
> -         will be called mvsas.
> +source "drivers/scsi/mvsas/Kconfig"
> 
>  config SCSI_NCR53C406A
>         tristate "NCR53c406a SCSI support"
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 7461eb0..f5bbd99 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -123,7 +123,7 @@ obj-$(CONFIG_SCSI_IBMVSCSIS)        += ibmvscsi/
>  obj-$(CONFIG_SCSI_IBMVFC)      += ibmvscsi/
>  obj-$(CONFIG_SCSI_HPTIOP)      += hptiop.o
>  obj-$(CONFIG_SCSI_STEX)                += stex.o
> -obj-$(CONFIG_SCSI_MVSAS)       += mvsas.o
> +obj-$(CONFIG_SCSI_MVSAS)       += mvsas/
>  obj-$(CONFIG_PS3_ROM)          += ps3rom.o
>  obj-$(CONFIG_SCSI_CXGB3_ISCSI) += libiscsi.o libiscsi_tcp.o cxgb3i/

Um, this isn't at all the way to split things up because it isn't
bisectable.  This patch removes the driver entirely But adds a
non-existent build directory, so we're left with one bisection point
where the driver is gone.  Your second patch adds back a Kconfig and
Makefile to the directory only, so we're left with a second point where
the build would break because you've added a Makefile but no actual
source files.

What I'd like to see in future is one patch transforming the driver to
the new layout (preferably with no functional changes) and then a series
on top of that adding the new functionality.

I can apply this by combining all five patches into a single one,
restoring bisectability, but if that's the only option and you can't do
a transformation followed by additions, could we at least see a list of
all the new stuff you've added?

Thanks,

James


