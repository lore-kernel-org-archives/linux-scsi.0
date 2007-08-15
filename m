From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 1/4] libata: check for AN support
Date: Wed, 15 Aug 2007 03:59:10 -0400
Message-ID: <46C2B24E.1010506@garzik.org>
References: <20070808190613.616085010@localhost.localdomain> <20070808120810.5f8ed457.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070808120810.5f8ed457.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> Check to see if an ATAPI device supports Asynchronous Notification.
> If so, enable it.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> Index: 2.6-git/drivers/ata/libata-core.c
> ===================================================================
> --- 2.6-git.orig/drivers/ata/libata-core.c
> +++ 2.6-git/drivers/ata/libata-core.c
> @@ -70,6 +70,7 @@ const unsigned long sata_deb_timing_long
>  static unsigned int ata_dev_init_params(struct ata_device *dev,
>  					u16 heads, u16 sectors);
>  static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
> +static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable);
>  static void ata_dev_xfermask(struct ata_device *dev);
>  static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
>  
> @@ -1974,6 +1975,22 @@ int ata_dev_configure(struct ata_device 
>  		}
>  		dev->cdb_len = (unsigned int) rc;
>  
> +		/*
> +		 * check to see if this ATAPI device supports
> +		 * Asynchronous Notification
> +		 */
> +		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_AN(id)) {
> +			int err;
> +			/* issue SET feature command to turn this on */
> +			err = ata_dev_set_AN(dev, SETFEATURES_SATA_ENABLE);
> +			if (err)
> +				ata_dev_printk(dev, KERN_ERR,
> +						"unable to set AN, err %x\n",
> +						err);
> +			else
> +				dev->flags |= ATA_DFLAG_AN;
> +		}
> +
>  		if (ata_id_cdb_intr(dev->id)) {
>  			dev->flags |= ATA_DFLAG_CDB_INTR;
>  			cdb_intr_string = ", CDB intr";
> @@ -3948,6 +3965,42 @@ static unsigned int ata_dev_set_xfermode
>  }
>  
>  /**
> + *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
> + *	@dev: Device to which command will be sent
> + *	@enable: Whether to enable or disable the feature
> + *
> + *	Issue SET FEATURES - SATA FEATURES command to device @dev
> + *	on port @ap with sector count set to indicate Asynchronous
> + *	Notification feature
> + *
> + *	LOCKING:
> + *	PCI/etc. bus probe sem.
> + *
> + *	RETURNS:
> + *	0 on success, AC_ERR_* mask otherwise.
> + */
> +static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable)
> +{
> +	struct ata_taskfile tf;
> +	unsigned int err_mask;
> +
> +	/* set up set-features taskfile */
> +	DPRINTK("set features - SATA features\n");
> +
> +	ata_tf_init(dev, &tf);
> +	tf.command = ATA_CMD_SET_FEATURES;
> +	tf.feature = enable;
> +	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
> +	tf.protocol = ATA_PROT_NODATA;
> +	tf.nsect = SATA_AN;
> +
> +	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
> +
> +	DPRINTK("EXIT, err_mask=%x\n", err_mask);
> +	return err_mask;
> +}
> +
> +/**
>   *	ata_dev_init_params - Issue INIT DEV PARAMS command
>   *	@dev: Device to which command will be sent
>   *	@heads: Number of heads (taskfile parameter)
> Index: 2.6-git/include/linux/ata.h
> ===================================================================
> --- 2.6-git.orig/include/linux/ata.h
> +++ 2.6-git/include/linux/ata.h
> @@ -217,6 +217,12 @@ enum {
>  
>  	SETFEATURES_SPINUP	= 0x07, /* Spin-up drive */
>  
> +	SETFEATURES_SATA_ENABLE = 0x10, /* Enable use of SATA feature */
> +	SETFEATURES_SATA_DISABLE = 0x90, /* Disable use of SATA feature */
> +
> +	/* SETFEATURE Sector counts for SATA features */
> +	SATA_AN			= 0x05,  /* Asynchronous Notification */
> +
>  	/* ATAPI stuff */
>  	ATAPI_PKT_DMA		= (1 << 0),
>  	ATAPI_DMADIR		= (1 << 2),	/* ATAPI data dir:
> @@ -344,6 +350,9 @@ struct ata_taskfile {
>  #define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
>  #define ata_id_removeable(id)	((id)[0] & (1 << 7))
>  #define ata_id_has_dword_io(id)	((id)[50] & (1 << 0))
> +#define ata_id_has_AN(id)	\
> +	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
> +	  ((id)[78] & (1 << 5)) )
>  #define ata_id_iordy_disable(id) ((id)[49] & (1 << 10))
>  #define ata_id_has_iordy(id) ((id)[49] & (1 << 9))
>  #define ata_id_u32(id,n)	\
> Index: 2.6-git/include/linux/libata.h
> ===================================================================
> --- 2.6-git.orig/include/linux/libata.h
> +++ 2.6-git/include/linux/libata.h
> @@ -139,7 +139,8 @@ enum {
>  	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
>  	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
>  	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
> -	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
> +	ATA_DFLAG_AN		= (1 << 7), /* device supports AN */
> +	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
>  
>  	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
>  	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
> @@ -177,6 +178,7 @@ enum {
>  	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
>  	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
>  	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
> +	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */


I applied the above changes, in order to move AN forward


>  	/* The following flag belongs to ap->pflags but is kept in
>  	 * ap->flags because it's referenced in many LLDs and will be
> Index: 2.6-git/drivers/ata/ahci.c
> ===================================================================
> --- 2.6-git.orig/drivers/ata/ahci.c
> +++ 2.6-git/drivers/ata/ahci.c
> @@ -332,14 +332,15 @@ static const struct ata_port_operations 
>  static const struct ata_port_info ahci_port_info[] = {
>  	/* board_ahci */
>  	{
> -		.flags		= AHCI_FLAG_COMMON,
> +		.flags		= AHCI_FLAG_COMMON | ATA_FLAG_AN,
>  		.pio_mask	= 0x1f, /* pio0-4 */
>  		.udma_mask	= ATA_UDMA6,
>  		.port_ops	= &ahci_ops,
>  	},
>  	/* board_ahci_pi */
>  	{
> -		.flags		= AHCI_FLAG_COMMON | AHCI_FLAG_HONOR_PI,
> +		.flags		= AHCI_FLAG_COMMON | AHCI_FLAG_HONOR_PI |
> +				  ATA_FLAG_AN,
>  		.pio_mask	= 0x1f, /* pio0-4 */
>  		.udma_mask	= ATA_UDMA6,
>  		.port_ops	= &ahci_ops,
> 

Since I wanted to get in Tejun's ata_link changes before this, this will 
require a rediff.

But more importantly, as I was going to apply it I noticed another 
problem:  we need to verify that SiS and NVIDIA both support AN support 
turning this on, since this patch affects not only Intel but also those 
vendors' AHCI hardware as well.

It's a bit annoying but this is a cross-vendor driver after all...

	Jeff


