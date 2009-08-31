From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Mon, 31 Aug 2009 18:00:24 +0000
Message-ID: <1251741624.18828.83.camel@mulgrave.site>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <1251739735.16169.20.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753884AbZHaSAk@vger.kernel.org>
In-Reply-To: <1251739735.16169.20.camel@ank32.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akataria@vmware.com
Cc: Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2009-08-31 at 10:28 -0700, Alok Kataria wrote:
> VMware PVSCSI driver - v2.

OK, so the first thing that springs to mind is that we already have one
of these things: the ibmvscsi ... is there no way we can share code
between this and the other PV drivers?

> Changelog (v2-v1)
> - use PCI_VDEVICE instead of PCI_DEVICE.
> - use list_first_entry
> - use parenthesis for every sizeof usage
> - get rid of all #ifdef for CONFIG_PCI_MSI
> - use PVSCSI_MEM_SPACE_SIZE while checking for MMIO resource len.
> - use kcalloc instead of kmalloc.
> - replaced a couple of scmd_printk usage with dev_dbg
> - use dev_info and pr_info at couple of places.
> - add a comment to pvscsi_map_context
> - Add entry in MAINTAINERS.
> 
> Patch applies on top of 2.6.31-rc8.
> --
> 
> SCSI driver for VMware's virtual HBA.
> 
> From: Alok N Kataria <akataria@vmware.com>
> 
> This is a driver for VMware's paravirtualized SCSI device,
> which should improve disk performance for guests running
> under control of VMware hypervisors that support such devices.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> ---
> 
>  MAINTAINERS           |    7 
>  drivers/scsi/Kconfig  |    8 
>  drivers/scsi/Makefile |    1 
>  drivers/scsi/pvscsi.c | 1391 +++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/pvscsi.h |  395 ++++++++++++++
>  5 files changed, 1802 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/pvscsi.c
>  create mode 100644 drivers/scsi/pvscsi.h
> 
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 60299a9..952fe93 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5491,6 +5491,13 @@ S:	Maintained
>  F:	drivers/vlynq/vlynq.c
>  F:	include/linux/vlynq.h
>  
> +VMware PVSCSI driver
> +M:	Alok Kataria <akataria@vmware.com>
> +L:	linux-scsi@vger.kernel.org
> +S:	Maintained
> +F:	drivers/scsi/pvscsi.c
> +F:	drivers/scsi/pvscsi.h
> +
>  VOLTAGE AND CURRENT REGULATOR FRAMEWORK
>  M:	Liam Girdwood <lrg@slimlogic.co.uk>
>  M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 9c23122..8a47981 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -620,6 +620,14 @@ config SCSI_FLASHPOINT
>  	  substantial, so users of MultiMaster Host Adapters may not
>  	  wish to include it.
>  
> +config VMWARE_PVSCSI
> +	tristate "VMware PVSCSI driver support"
> +	depends on PCI && SCSI && X86

This is a PCI emulation driver ... it shouldn't be x86 only.

> +	help
> +	  This driver supports VMware's para virtualized SCSI HBA.
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called pvscsi.
> +
>  config LIBFC
>  	tristate "LibFC module"
>  	select SCSI_FC_ATTRS
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 25429ea..27fd013 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -130,6 +130,7 @@ obj-$(CONFIG_SCSI_MVSAS)	+= mvsas/
>  obj-$(CONFIG_PS3_ROM)		+= ps3rom.o
>  obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgb3i/
>  obj-$(CONFIG_SCSI_BNX2_ISCSI)	+= libiscsi.o bnx2i/
> +obj-$(CONFIG_VMWARE_PVSCSI)	+= pvscsi.o
>  
>  obj-$(CONFIG_ARM)		+= arm/
>  
> diff --git a/drivers/scsi/pvscsi.c b/drivers/scsi/pvscsi.c
> new file mode 100644
> index 0000000..fc85a3a
> --- /dev/null
> +++ b/drivers/scsi/pvscsi.c
[...]
> +static int __devinit pvscsi_allocate_sg(struct pvscsi_adapter *adapter)
> +{
> +	struct pvscsi_ctx *ctx;
> +	int i;
> +
> +	ctx = adapter->cmd_map;
> +	BUILD_BUG_ON(sizeof(struct pvscsi_sg_list) > PAGE_SIZE);
> +
> +	for (i = 0; i < adapter->req_depth; ++i, ++ctx) {
> +		ctx->sgl = pci_alloc_consistent(adapter->dev, PAGE_SIZE,
> +						&ctx->sglPA);

Why do you need coherent memory for the sg list?  Surely the use pattern
of an SG list is that it follows a predefined ownership model between
the driver and the virtual device, thus not really requiring coherent
memory?

> +		BUG_ON(ctx->sglPA & ~PAGE_MASK);
> +		if (!ctx->sgl) {
> +			for (; i >= 0; --i, --ctx) {
> +				pci_free_consistent(adapter->dev, PAGE_SIZE,
> +						    ctx->sgl, ctx->sglPA);
> +				ctx->sgl = NULL;
> +				ctx->sglPA = 0;
> +			}
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	return 0;
> +}

James
