From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: Miscellaneous fixes and improvements
Date: Mon, 17 Mar 2008 16:35:55 -0500
Message-ID: <1205789755.6767.191.camel@localhost.localdomain>
References: <20080317143909.GA7908@ubuntu.domain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60759 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbYCQVgC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 17:36:02 -0400
In-Reply-To: <20080317143909.GA7908@ubuntu.domain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, lil@marvell.com, saeed.bishara@gmail.com, kewei@marvell.com

On Mon, 2008-03-17 at 22:39 +0800, Ke Wei wrote:
> - fix default queue depth and ATAPI issue.
> - plumb in phy speeds
> - fill in error info record bits.
> - add a new tag handler to create slot num.
> - When unplug the disk, we will release all command tasks with unplugged port that have been sent.
> - if unplugged, driver's queuecommand function will return SAS_PHY_DOWN. Unfortunately, SAS and SATA's handler is different because of libsas.
> - When a slot is busy, we will not free this slot until slot reset is completed.
> - add support for 6480 chip if device id is 6440 but subsystem id is 6480.
> - when task is aborted, we will complete this task and report error if task has been already sent. On the contrary, this task will be sent if it doesn't.
> - attached SATA address makes use of port id.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Jacky Feng <jfeng@marvell.com> 
> Signed-off-by: Ke Wei <kewei@marvell.com>

I'd really rather you didn't do this.  I assume the stacked signoffs are
because this patch consists of parts from all of these people?  It's
much better to send the individual patches they sent in (modified if
need be) with your signoff so we preserve the signed off by chain.

Also, a patch of this size would be ineligible as a bug fix (although I
can skirt the rules this time because the driver is a new one, that
won't be true in future).

> diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
> index 5ec0665..6c2ac31 100644
> --- a/drivers/scsi/mvsas.c
> +++ b/drivers/scsi/mvsas.c
> @@ -37,11 +37,13 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/ctype.h>
>  #include <scsi/libsas.h>
> +#include <scsi/scsi_tcq.h>
> +#include <scsi/sas_ata.h>
>  #include <asm/io.h>
>  
>  #define DRV_NAME	"mvsas"
> -#define DRV_VERSION	"0.5.1"
> -#define _MV_DUMP 0
> +#define DRV_VERSION	"0.5.2"
> +#define _MV_DUMP	0
>  #define MVS_DISABLE_NVRAM
>  #define MVS_DISABLE_MSI
>  
> @@ -52,7 +54,7 @@
>  	readl(regs + MVS_##reg);		\
>  	} while (0)
>  
> -#define MVS_ID_NOT_MAPPED	0xff
> +#define MVS_ID_NOT_MAPPED	0x7f
>  #define MVS_CHIP_SLOT_SZ	(1U << mvi->chip->slot_width)
>  
>  /* offset for D2H FIS in the Received FIS List Structure */
> @@ -84,6 +86,7 @@ enum driver_configuration {
>  	MVS_RX_FIS_COUNT	= 17,	/* Optional rx'd FISs (max 17) */
>  
>  	MVS_QUEUE_SIZE		= 30,	/* Support Queue depth */
> +	MVS_CAN_QUEUE		= 512,	/* SCSI Queue depth */

This doesn't really look right.  Shouldn't your maximum number possible
of outstanding SCSI commands be the number of slots (minus one to allow
for abort commands from error handling) or MVS_SLOTS - 1?

>  };
>  
>  /* unchangeable hardware details */
> @@ -358,7 +361,20 @@ enum hw_register_bits {
>  
>  	/* VSR */
>  	/* PHYMODE 6 (CDB) */
> -	PHY_MODE6_DTL_SPEED	= (1U << 27),
> +	PHY_MODE6_LATECLK	= (1U << 29),	/* Lock Clock */
> +	PHY_MODE6_DTL_SPEED	= (1U << 27),	/* Digital Loop Speed */
> +	PHY_MODE6_FC_ORDER	= (1U << 26),	/* Fibre Channel Mode Order*/
> +	PHY_MODE6_MUCNT_EN	= (1U << 24),	/* u Count Enable */
> +	PHY_MODE6_SEL_MUCNT_LEN	= (1U << 22),	/* Training Length Select */
> +	PHY_MODE6_SELMUPI	= (1U << 20),	/* Phase Multi Select (init) */
> +	PHY_MODE6_SELMUPF	= (1U << 18),	/* Phase Multi Select (final) */
> +	PHY_MODE6_SELMUFF	= (1U << 16),	/* Freq Loop Multi Sel(final) */
> +	PHY_MODE6_SELMUFI	= (1U << 14),	/* Freq Loop Multi Sel(init) */
> +	PHY_MODE6_FREEZE_LOOP	= (1U << 12),	/* Freeze Rx CDR Loop */
> +	PHY_MODE6_INT_RXFOFFS	= (1U << 3),	/* Rx CDR Freq Loop Enable */
> +	PHY_MODE6_FRC_RXFOFFS	= (1U << 2),	/* Initial Rx CDR Offset */
> +	PHY_MODE6_STAU_0D8	= (1U << 1),	/* Rx CDR Freq Loop Saturate */
> +	PHY_MODE6_RXSAT_DIS	= (1U << 0),	/* Saturate Ctl */
>  };
>  
>  enum mvs_info_flags {
> @@ -511,7 +527,43 @@ enum status_buffer {
>  };
>  
>  enum error_info_rec {
> -	CMD_ISS_STPD	=  (1U << 31),	/* Cmd Issue Stopped */
> +	CMD_ISS_STPD	= (1U << 31),	/* Cmd Issue Stopped */
> +	CMD_PI_ERR	= (1U << 30),	/* Protection info error.  see flags2 */
> +	RSP_OVER	= (1U << 29),	/* rsp buffer overflow */
> +	RETRY_LIM	= (1U << 28),	/* FIS/frame retry limit exceeded */
> +	UNK_FIS 	= (1U << 27),	/* unknown FIS */
> +	DMA_TERM	= (1U << 26),	/* DMA terminate primitive rx'd */
> +	SYNC_ERR	= (1U << 25),	/* SYNC rx'd during frame xmit */
> +	TFILE_ERR	= (1U << 24),	/* SATA taskfile Error bit set */
> +	R_ERR		= (1U << 23),	/* SATA returned R_ERR prim */
> +	RD_OFS		= (1U << 20),	/* Read DATA frame invalid offset */
> +	XFER_RDY_OFS	= (1U << 19),	/* XFER_RDY offset error */
> +	UNEXP_XFER_RDY	= (1U << 18),	/* unexpected XFER_RDY error */
> +	DATA_OVER_UNDER = (1U << 16),	/* data overflow/underflow */
> +	INTERLOCK	= (1U << 15),	/* interlock error */
> +	NAK		= (1U << 14),	/* NAK rx'd */
> +	ACK_NAK_TO	= (1U << 13),	/* ACK/NAK timeout */
> +	CXN_CLOSED	= (1U << 12),	/* cxn closed w/out ack/nak */
> +	OPEN_TO 	= (1U << 11),	/* I_T nexus lost, open cxn timeout */
> +	PATH_BLOCKED	= (1U << 10),	/* I_T nexus lost, pathway blocked */
> +	NO_DEST 	= (1U << 9),	/* I_T nexus lost, no destination */
> +	STP_RES_BSY	= (1U << 8),	/* STP resources busy */
> +	BREAK		= (1U << 7),	/* break received */
> +	BAD_DEST	= (1U << 6),	/* bad destination */
> +	BAD_PROTO	= (1U << 5),	/* protocol not supported */
> +	BAD_RATE	= (1U << 4),	/* cxn rate not supported */
> +	WRONG_DEST	= (1U << 3),	/* wrong destination error */
> +	CREDIT_TO	= (1U << 2),	/* credit timeout */
> +	WDOG_TO 	= (1U << 1),	/* watchdog timeout */
> +	BUF_PAR 	= (1U << 0),	/* buffer parity error */
> +};
> +
> +enum error_info_rec_2 {
> +	SLOT_BSY_ERR	= (1U << 31),	/* Slot Busy Error */
> +	GRD_CHK_ERR	= (1U << 14),	/* Guard Check Error */
> +	APP_CHK_ERR	= (1U << 13),	/* Application Check error */
> +	REF_CHK_ERR	= (1U << 12),	/* Reference Check Error */
> +	USR_BLK_NM	= (1U << 0),	/* User Block Number */
>  };
>  
>  struct mvs_chip_info {
> @@ -543,28 +595,12 @@ struct mvs_cmd_hdr {
>  	__le32			reserved[4];
>  };
>  
> -struct mvs_slot_info {
> -	struct sas_task		*task;
> -	u32			n_elem;
> -	u32			tx;
> -
> -	/* DMA buffer for storing cmd tbl, open addr frame, status buffer,
> -	 * and PRD table
> -	 */
> -	void			*buf;
> -	dma_addr_t		buf_dma;
> -#if _MV_DUMP
> -	u32			cmd_size;
> -#endif
> -
> -	void			*response;
> -};
> -
>  struct mvs_port {
>  	struct asd_sas_port	sas_port;
>  	u8			port_attached;
>  	u8			taskfileset;
>  	u8			wide_port_phymap;
> +	struct list_head	list;
>  };
>  
>  struct mvs_phy {
> @@ -582,6 +618,27 @@ struct mvs_phy {
>  	u32		frame_rcvd_size;
>  	u8		frame_rcvd[32];
>  	u8		phy_attached;
> +	enum sas_linkrate	minimum_linkrate;
> +	enum sas_linkrate	maximum_linkrate;

It's slightly ugly to have to have this shadowed, but I suppose I see
why.

> +};
> +
> +struct mvs_slot_info {
> +	struct list_head	list;
> +	struct sas_task		*task;
> +	u32			n_elem;
> +	u32			tx;
> +
> +	/* DMA buffer for storing cmd tbl, open addr frame, status buffer,
> +	 * and PRD table
> +	 */
> +	void			*buf;
> +	dma_addr_t		buf_dma;
> +#if _MV_DUMP
> +	u32			cmd_size;
> +#endif
> +
> +	void			*response;
> +	struct mvs_port		*port;
>  };
>  
>  struct mvs_info {
> @@ -612,21 +669,11 @@ struct mvs_info {
>  
>  	const struct mvs_chip_info *chip;
>  
> -	unsigned long		tags[MVS_SLOTS];
> +	unsigned long		tags[MVS_SLOTS >> 3];

There's a DECLARE_BITMAP(name, <number of bits>) macro for this.  Your
definition above will waste half the allocation on a 64 bit machine.

>  	struct mvs_slot_info	slot_info[MVS_SLOTS];
>  				/* further per-slot information */
>  	struct mvs_phy		phy[MVS_MAX_PHYS];
>  	struct mvs_port		port[MVS_MAX_PHYS];
> -
> -	u32			can_queue;	/* per adapter */
> -	u32			tag_out;	/*Get*/
> -	u32			tag_in;		/*Give*/
> -};
> -
> -struct mvs_queue_task {
> -	struct list_head list;
> -
> -	void   *uldd_task;
>  };
>  
>  static int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
> @@ -641,10 +688,12 @@ static u32 mvs_read_port_irq_mask(struct mvs_info *mvi, u32 port);
>  static u32 mvs_is_phy_ready(struct mvs_info *mvi, int i);
>  static void mvs_detect_porttype(struct mvs_info *mvi, int i);
>  static void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
> +static void mvs_release_task(struct mvs_info *mvi, int phy_no);
>  
>  static int mvs_scan_finished(struct Scsi_Host *, unsigned long);
>  static void mvs_scan_start(struct Scsi_Host *);
>  static int mvs_sas_slave_alloc(struct scsi_device *scsi_dev);
> +static int mvs_slave_configure(struct scsi_device *sdev);
>  
>  static struct scsi_transport_template *mvs_stt;
>  
> @@ -657,9 +706,10 @@ static const struct mvs_chip_info mvs_chips[] = {
>  static struct scsi_host_template mvs_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
> +	.proc_name		= DRV_NAME,

proc_name is deprecated. For a new driver like this, we don't want
anything appearing in /proc; it should all be done under /sys

>  	.queuecommand		= sas_queuecommand,
>  	.target_alloc		= sas_target_alloc,
> -	.slave_configure	= sas_slave_configure,
> +	.slave_configure	= mvs_slave_configure,
>  	.slave_destroy		= sas_slave_destroy,
>  	.scan_finished		= mvs_scan_finished,
>  	.scan_start		= mvs_scan_start,
> @@ -709,10 +759,10 @@ static void mvs_hexdump(u32 size, u8 *data, u32 baseaddr)
>  	printk("\n");
>  }
>  
> +#if _MV_DUMP
>  static void mvs_hba_sb_dump(struct mvs_info *mvi, u32 tag,
>  				   enum sas_protocol proto)
>  {
> -#if _MV_DUMP
>  	u32 offset;
>  	struct pci_dev *pdev = mvi->pdev;
>  	struct mvs_slot_info *slot = &mvi->slot_info[tag];
> @@ -723,8 +773,8 @@ static void mvs_hba_sb_dump(struct mvs_info *mvi, u32 tag,
>  			tag);
>  	mvs_hexdump(32, (u8 *) slot->response,
>  		    (u32) slot->buf_dma + offset);
> -#endif
>  }
> +#endif
>  
>  static void mvs_hba_memory_dump(struct mvs_info *mvi, u32 tag,
>  				enum sas_protocol proto)
> @@ -779,7 +829,7 @@ static void mvs_hba_memory_dump(struct mvs_info *mvi, u32 tag,
>  
>  static void mvs_hba_cq_dump(struct mvs_info *mvi)
>  {
> -#if _MV_DUMP
> +#if (_MV_DUMP > 2)
>  	u64 addr;
>  	void __iomem *regs = mvi->regs;
>  	struct pci_dev *pdev = mvi->pdev;
> @@ -788,8 +838,8 @@ static void mvs_hba_cq_dump(struct mvs_info *mvi)
>  
>  	/*Completion Queue */
>  	addr = mr32(RX_HI) << 16 << 16 | mr32(RX_LO);
> -	dev_printk(KERN_DEBUG, &pdev->dev, "Completion Task = 0x%08X\n",
> -		   (u32) mvi->slot_info[rx_desc & RXQ_SLOT_MASK].task);
> +	dev_printk(KERN_DEBUG, &pdev->dev, "Completion Task = 0x%p\n",
> +		   mvi->slot_info[rx_desc & RXQ_SLOT_MASK].task);
>  	dev_printk(KERN_DEBUG, &pdev->dev,
>  		"Completion List Base Address=0x%llX (PA), "
>  		"CQ_Entry=%04d, CQ_WP=0x%08X\n",
> @@ -854,34 +904,54 @@ static int pci_go_64(struct pci_dev *pdev)
>  	return rc;
>  }
>  
> +static int mvs_find_tag(struct mvs_info *mvi, struct sas_task *task, u32 *tag)
> +{
> +	int i;
> +	for (i = 0; i < MVS_SLOTS; ++i) {
> +		if (mvi->slot_info[i].task == task) {
> +			*tag = i;
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}

Rather than do this lookup every time, there's a place in the task to
put the information.  If you set task->lldd_task = <mvi slot> then you
can pull it out again rather than having to do this lookup.

>  static void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
>  {
> -	mvi->tag_in = (mvi->tag_in + 1) & (MVS_SLOTS - 1);
> -	mvi->tags[mvi->tag_in] = tag;
> +	void *bitmap = (void *) &mvi->tags;
> +	clear_bit(tag, bitmap);
>  }
>  
>  static void mvs_tag_free(struct mvs_info *mvi, u32 tag)
>  {
> -	mvi->tag_out = (mvi->tag_out - 1) & (MVS_SLOTS - 1);
> +	mvs_tag_clear(mvi, tag);
> +}
> +
> +static void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
> +{
> +	void *bitmap = (void *) &mvi->tags;
> +	set_bit(tag, bitmap);
>  }
>  
>  static int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
>  {
> -	if (mvi->tag_out != mvi->tag_in) {
> -		*tag_out = mvi->tags[mvi->tag_out];
> -		mvi->tag_out = (mvi->tag_out + 1) & (MVS_SLOTS - 1);
> -		return 0;
> -	}
> -	return -EBUSY;
> +	unsigned int index, tag;
> +	void *bitmap = (void *) &mvi->tags;
> +
> +	index = find_first_zero_bit(bitmap, MVS_SLOTS);
> +	tag = index;
> +	if (tag >= MVS_SLOTS)
> +		return -SAS_QUEUE_FULL;
> +	mvs_tag_set(mvi, tag);
> +	*tag_out = tag;
> +	return 0;
>  }
>  
>  static void mvs_tag_init(struct mvs_info *mvi)
>  {
>  	int i;
>  	for (i = 0; i < MVS_SLOTS; ++i)
> -		mvi->tags[i] = i;
> -	mvi->tag_out = 0;
> -	mvi->tag_in = MVS_SLOTS - 1;
> +		mvs_tag_clear(mvi, i);
>  }
>  
>  #ifndef MVS_DISABLE_NVRAM
> @@ -1013,10 +1083,21 @@ err_out:
>  static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
>  {
>  	struct mvs_phy *phy = &mvi->phy[i];
> +	struct asd_sas_phy *sas_phy = mvi->sas.sas_phy[i];
>  
>  	if (!phy->phy_attached)
>  		return;
>  
> +	if (sas_phy->phy) {
> +		struct sas_phy *sphy = sas_phy->phy;
> +
> +		sphy->negotiated_linkrate = sas_phy->linkrate;
> +		sphy->minimum_linkrate = phy->minimum_linkrate;
> +		sphy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
> +		sphy->maximum_linkrate = phy->maximum_linkrate;
> +		sphy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
> +	}
> +
>  	if (phy->phy_type & PORT_TYPE_SAS) {
>  		struct sas_identify_frame *id;
>  
> @@ -1055,78 +1136,192 @@ static void mvs_scan_start(struct Scsi_Host *shost)
>  
>  static int mvs_sas_slave_alloc(struct scsi_device *scsi_dev)
>  {
> -	int rc;
> +	int ret;
>  
> -	rc = sas_slave_alloc(scsi_dev);
> +	ret = sas_slave_alloc(scsi_dev);
> +	if (ret)
> +		return ret;
>  
> -	return rc;
> +	return 0;
> +}

This slave_alloc routine doesn't do anything other than pass through to
sas_slave_alloc ... can't you just set

.slave_alloc = sas_slave_alloc;

in the host template?

> +
> +static int mvs_slave_configure(struct scsi_device *sdev)
> +{
> +	struct domain_device *dev = sdev_to_domain_dev(sdev);
> +	int ret = sas_slave_configure(sdev);
> +
> +	if (ret)
> +		return ret;
> +
> +	if (dev_is_sata(dev)) {
> +		/* struct ata_port *ap = dev->sata_dev.ap; */
> +		/* struct ata_device *adev = ap->link.device; */
> +
> +		/* clamp at no NCQ for the time being */
> +		/* adev->flags |= ATA_DFLAG_NCQ_OFF; */
> +		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, 1);
> +	}
> +	return 0;
>  }
>  
> -static void mvs_int_port(struct mvs_info *mvi, int port_no, u32 events)
> +static void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
>  {
>  	struct pci_dev *pdev = mvi->pdev;
>  	struct sas_ha_struct *sas_ha = &mvi->sas;
> -	struct mvs_phy *phy = &mvi->phy[port_no];
> +	struct mvs_phy *phy = &mvi->phy[phy_no];
>  	struct asd_sas_phy *sas_phy = &phy->sas_phy;
>  
> -	phy->irq_status = mvs_read_port_irq_stat(mvi, port_no);
> +	phy->irq_status = mvs_read_port_irq_stat(mvi, phy_no);
>  	/*
>  	* events is port event now ,
>  	* we need check the interrupt status which belongs to per port.
>  	*/
>  	dev_printk(KERN_DEBUG, &pdev->dev,
>  		"Port %d Event = %X\n",
> -		port_no, phy->irq_status);
> +		phy_no, phy->irq_status);
>  
>  	if (phy->irq_status & (PHYEV_POOF | PHYEV_DEC_ERR)) {
> -		if (!mvs_is_phy_ready(mvi, port_no)) {
> +		mvs_release_task(mvi, phy_no);
> +		if (!mvs_is_phy_ready(mvi, phy_no)) {
>  			sas_phy_disconnected(sas_phy);
>  			sas_ha->notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL);
> +			dev_printk(KERN_INFO, &pdev->dev,
> +				"Port %d Unplug Notice\n", phy_no);
> +
>  		} else
>  			mvs_phy_control(sas_phy, PHY_FUNC_LINK_RESET, NULL);
>  	}
>  	if (!(phy->irq_status & PHYEV_DEC_ERR)) {
>  		if (phy->irq_status & PHYEV_COMWAKE) {
> -			u32 tmp = mvs_read_port_irq_mask(mvi, port_no);
> -			mvs_write_port_irq_mask(mvi, port_no,
> +			u32 tmp = mvs_read_port_irq_mask(mvi, phy_no);
> +			mvs_write_port_irq_mask(mvi, phy_no,
>  						tmp | PHYEV_SIG_FIS);
>  		}
>  		if (phy->irq_status & (PHYEV_SIG_FIS | PHYEV_ID_DONE)) {
> -			phy->phy_status = mvs_is_phy_ready(mvi, port_no);
> +			phy->phy_status = mvs_is_phy_ready(mvi, phy_no);
>  			if (phy->phy_status) {
> -				mvs_detect_porttype(mvi, port_no);
> +				mvs_detect_porttype(mvi, phy_no);
>  
>  				if (phy->phy_type & PORT_TYPE_SATA) {
>  					u32 tmp = mvs_read_port_irq_mask(mvi,
> -								port_no);
> +								phy_no);
>  					tmp &= ~PHYEV_SIG_FIS;
>  					mvs_write_port_irq_mask(mvi,
> -								port_no, tmp);
> +								phy_no, tmp);
>  				}
>  
> -				mvs_update_phyinfo(mvi, port_no, 0);
> +				mvs_update_phyinfo(mvi, phy_no, 0);
>  				sas_ha->notify_phy_event(sas_phy,
>  							PHYE_OOB_DONE);
> -				mvs_bytes_dmaed(mvi, port_no);
> +				mvs_bytes_dmaed(mvi, phy_no);
>  			} else {
>  				dev_printk(KERN_DEBUG, &pdev->dev,
>  					"plugin interrupt but phy is gone\n");
>  				mvs_phy_control(sas_phy, PHY_FUNC_LINK_RESET,
>  							NULL);
>  			}
> -		} else if (phy->irq_status & PHYEV_BROAD_CH)
> +		} else if (phy->irq_status & PHYEV_BROAD_CH) {
> +			mvs_release_task(mvi, phy_no);
>  			sas_ha->notify_port_event(sas_phy,
>  						PORTE_BROADCAST_RCVD);
> +		}
>  	}
> -	mvs_write_port_irq_stat(mvi, port_no, phy->irq_status);
> +	mvs_write_port_irq_stat(mvi, phy_no, phy->irq_status);
>  }
>  
>  static void mvs_int_sata(struct mvs_info *mvi)
>  {
> -	/* FIXME */
> +	u32 tmp;
> +	void __iomem *regs = mvi->regs;
> +	tmp = mr32(INT_STAT_SRS);
> +	mw32(INT_STAT_SRS, tmp & 0xFFFF);
>  }
>  
> -static void mvs_slot_free(struct mvs_info *mvi, struct sas_task *task,
> +static void mvs_slot_reset(struct mvs_info *mvi, struct sas_task *task,
> +				u32 slot_idx)
> +{
> +	void __iomem *regs = mvi->regs;
> +	struct domain_device *dev = task->dev;
> +	struct asd_sas_port *sas_port = dev->port;
> +	struct mvs_port *port = &mvi->port[dev->port->id];
> +	u32 reg_set, phy_mask;
> +
> +	if (!sas_protocol_ata(task->task_proto)) {
> +		reg_set = 0;
> +		phy_mask = (port->wide_port_phymap) ? port->wide_port_phymap :
> +				sas_port->phy_mask;
> +	} else {
> +		reg_set = port->taskfileset;
> +		phy_mask = sas_port->phy_mask;
> +	}
> +	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | slot_idx |
> +					(TXQ_CMD_SLOT_RESET << TXQ_CMD_SHIFT) |
> +					(phy_mask << TXQ_PHY_SHIFT) |
> +					(reg_set << TXQ_SRS_SHIFT));
> +
> +	mw32(TX_PROD_IDX, mvi->tx_prod);
> +	mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
> +}
> +
> +static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
> +			u32 slot_idx, int err)
> +{
> +	struct domain_device *dev = task->dev;
> +	struct mvs_port *port = &mvi->port[dev->port->id];
> +	struct task_status_struct *tstat = &task->task_status;
> +	struct ata_task_resp *resp = (struct ata_task_resp *)tstat->buf;
> +	int stat = SAM_GOOD;
> +
> +	resp->frame_len = sizeof(struct dev_to_host_fis);
> +	memcpy(&resp->ending_fis[0],
> +	       SATA_RECEIVED_D2H_FIS(port->taskfileset),
> +	       sizeof(struct dev_to_host_fis));
> +	tstat->buf_valid_size = sizeof(*resp);
> +	if (unlikely(err)) {
> +		struct domain_device *dev = task->dev;
> +		enum ata_command_set command_set = dev->sata_dev.command_set;
> +		struct ata_queued_cmd *qc;
> +
> +		stat = SAM_CHECK_COND;

Actually, if we're reporting back the register D2H fis, the return
should be SAS_PROTO_RESPONSE.  That triggers sas_ata to collect the
registers and report them back to libata.

> +		if (command_set != ATAPI_COMMAND_SET) {
> +			stat = SAS_QUEUE_FULL;
> +			mvs_slot_reset(mvi, task, slot_idx);
> +			goto out_done;
> +		}
> +
> +		qc = task->uldd_task;
> +		if (qc->scsicmd) {
> +			if (qc->cdb[0] == REPORT_LUNS) {

This isn't necessary.

Firstly, a REPORT_LUNS may genuinely generate an error on MMC which is
reported back in the D2H FIS ... linux behaves properly

Secondly, a media changer may require a REPORT LUNS to be found (if it's
embedded as a function of a CD).

> +				struct scatterlist *sg = task->scatter;
> +				if (sg) {
> +					u8 *buf;
> +
> +					/* simulate */
> +					resp->ending_fis[2] &= 0xFE;
> +					buf = kmap_atomic(sg_page(sg), KM_IRQ0)
> +							+ sg->offset;
> +					memset(buf, 0, sg->length);
> +					buf[3] = 8;
> +					kunmap_atomic(buf - sg->offset,
> +							KM_IRQ0);
> +					stat = SAS_PROTO_RESPONSE;
> +				}
> +			}
> +		}
> +	}
> +out_done:
> +	return stat;
> +}
> +
> +static void mvs_slot_free(struct mvs_info *mvi, u32 rx_desc)
> +{
> +	u32 slot_idx = rx_desc & RXQ_SLOT_MASK;
> +	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
> +	slot->task = NULL;
> +	mvs_tag_clear(mvi, slot_idx);
> +}
> +
> +static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
>  			  struct mvs_slot_info *slot, u32 slot_idx)
>  {
>  	if (!sas_protocol_ata(task->task_proto))
> @@ -1149,38 +1344,57 @@ static void mvs_slot_free(struct mvs_info *mvi, struct sas_task *task,
>  		/* do nothing */
>  		break;
>  	}
> -
> -	slot->task = NULL;
> -	mvs_tag_clear(mvi, slot_idx);
> +	list_del(&slot->list);
>  }
>  
> -static void mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
> +static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
>  			 u32 slot_idx)
>  {
>  	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
> -	u64 err_dw0 = *(u32 *) slot->response;
> -	void __iomem *regs = mvi->regs;
> -	u32 tmp;
> +	u32 err_dw0 = le32_to_cpu(*(u32 *) (slot->response));
> +	u32 err_dw1 = le32_to_cpu(*(u32 *) (slot->response + 4));
> +	int stat = SAM_CHECK_COND;
>  
> -	if (err_dw0 & CMD_ISS_STPD)
> -		if (sas_protocol_ata(task->task_proto)) {
> -			tmp = mr32(INT_STAT_SRS);
> -			mw32(INT_STAT_SRS, tmp & 0xFFFF);
> -		}
> +	if (err_dw1 & SLOT_BSY_ERR) {
> +		stat = SAS_QUEUE_FULL;
> +		mvs_slot_reset(mvi, task, slot_idx);
> +	}
> +	switch (task->task_proto) {
> +	case SAS_PROTOCOL_SSP:
> +		break;
> +	case SAS_PROTOCOL_SMP:
> +		break;
> +	case SAS_PROTOCOL_SATA:
> +	case SAS_PROTOCOL_STP:
> +	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
> +		if (err_dw0 & TFILE_ERR)
> +			stat = mvs_sata_done(mvi, task, slot_idx, 1);
> +		break;
> +	default:
> +		break;
> +	}
>  
> -	mvs_hba_sb_dump(mvi, slot_idx, task->task_proto);
> +	mvs_hexdump(16, (u8 *) slot->response, 0);
> +	return stat;
>  }
>  
> -static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
> +static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
>  {
>  	u32 slot_idx = rx_desc & RXQ_SLOT_MASK;
>  	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
>  	struct sas_task *task = slot->task;
> -	struct task_status_struct *tstat = &task->task_status;
> -	struct mvs_port *port = &mvi->port[task->dev->port->id];
> +	struct task_status_struct *tstat;
> +	struct mvs_port *port;
>  	bool aborted;
>  	void *to;
>  
> +	if (!task || !task->dev || !task->dev->port)
> +		return -1;
> +	mvs_hba_cq_dump(mvi);
> +
> +	port = &mvi->port[task->dev->port->id];
> +	tstat = &task->task_status;
> +
>  	spin_lock(&task->task_state_lock);
>  	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
>  	if (!aborted) {
> @@ -1190,22 +1404,24 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
>  	}
>  	spin_unlock(&task->task_state_lock);
>  
> -	if (aborted)
> +	if (aborted) {
> +		mvs_slot_task_free(mvi, task, slot, slot_idx);
>  		return -1;
> +	}
>  
>  	memset(tstat, 0, sizeof(*tstat));
>  	tstat->resp = SAS_TASK_COMPLETE;
>  
> -
> -	if (unlikely(!port->port_attached)) {
> -		tstat->stat = SAS_PHY_DOWN;
> +	if (unlikely(!port->port_attached || flags)) {
> +		mvs_slot_err(mvi, task, slot_idx);
> +		if (!sas_protocol_ata(task->task_proto))
> +			tstat->stat = SAS_PHY_DOWN;
>  		goto out;
>  	}
>  
>  	/* error info record present */
> -	if ((rx_desc & RXQ_ERR) && (*(u64 *) slot->response)) {
> -		tstat->stat = SAM_CHECK_COND;
> -		mvs_slot_err(mvi, task, slot_idx);
> +	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
> +		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
>  		goto out;
>  	}
>  
> @@ -1242,21 +1458,7 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
>  	case SAS_PROTOCOL_SATA:
>  	case SAS_PROTOCOL_STP:
>  	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP: {
> -			struct ata_task_resp *resp =
> -			    (struct ata_task_resp *)tstat->buf;
> -
> -			if ((rx_desc & (RXQ_DONE | RXQ_ERR | RXQ_ATTN)) ==
> -			    RXQ_DONE)
> -				tstat->stat = SAM_GOOD;
> -			else
> -				tstat->stat = SAM_CHECK_COND;
> -
> -			resp->frame_len = sizeof(struct dev_to_host_fis);
> -			memcpy(&resp->ending_fis[0],
> -			       SATA_RECEIVED_D2H_FIS(port->taskfileset),
> -			       sizeof(struct dev_to_host_fis));
> -			if (resp->ending_fis[2] & ATA_ERR)
> -				mvs_hexdump(16, resp->ending_fis, 0);
> +			tstat->stat = mvs_sata_done(mvi, task, slot_idx, 0);
>  			break;
>  		}
>  
> @@ -1266,11 +1468,33 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
>  	}
>  
>  out:
> -	mvs_slot_free(mvi, task, slot, slot_idx);
> -	task->task_done(task);
> +	mvs_slot_task_free(mvi, task, slot, slot_idx);
> +	if (unlikely(tstat->stat != SAS_QUEUE_FULL))
> +		mvs_slot_free(mvi, rx_desc);
> +
> +	if (flags != 2)
> +		task->task_done(task);
>  	return tstat->stat;
>  }
>  
> +static void mvs_release_task(struct mvs_info *mvi, int phy_no)
> +{
> +	struct list_head *pos, *n;
> +	struct mvs_slot_info *slot;
> +	struct mvs_phy *phy = &mvi->phy[phy_no];
> +	struct mvs_port *port = phy->port;
> +	u32 rx_desc;
> +
> +	if (!port)
> +		return;
> +
> +	list_for_each_safe(pos, n, &port->list) {
> +		slot = container_of(pos, struct mvs_slot_info, list);
> +		rx_desc = (u32) (slot - mvi->slot_info);
> +		mvs_slot_complete(mvi, rx_desc, 1);
> +	}
> +}
> +
>  static void mvs_int_full(struct mvs_info *mvi)
>  {
>  	void __iomem *regs = mvi->regs;
> @@ -1305,40 +1529,43 @@ static int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
>  	 * we don't have to stall the CPU reading that register.
>  	 * The actual RX ring is offset by one dword, due to this.
>  	 */
> -	rx_prod_idx = mr32(RX_CONS_IDX) & RX_RING_SZ_MASK;
> -	if (rx_prod_idx == 0xfff) {	/* h/w hasn't touched RX ring yet */
> -		mvi->rx_cons = 0xfff;
> +	rx_prod_idx = mvi->rx_cons;
> +	mvi->rx_cons = le32_to_cpu(mvi->rx[0]);
> +	if (mvi->rx_cons == 0xfff)	/* h/w hasn't touched RX ring yet */
>  		return 0;
> -	}
>  
>  	/* The CMPL_Q may come late, read from register and try again
>  	* note: if coalescing is enabled,
>  	* it will need to read from register every time for sure
>  	*/
>  	if (mvi->rx_cons == rx_prod_idx)
> -		return 0;
> +		mvi->rx_cons = mr32(RX_CONS_IDX) & RX_RING_SZ_MASK;
>  
> -	if (mvi->rx_cons == 0xfff)
> -		mvi->rx_cons = MVS_RX_RING_SZ - 1;
> +	if (mvi->rx_cons == rx_prod_idx)
> +		return 0;
>  
>  	while (mvi->rx_cons != rx_prod_idx) {
>  
>  		/* increment our internal RX consumer pointer */
> -		mvi->rx_cons = (mvi->rx_cons + 1) & (MVS_RX_RING_SZ - 1);
> +		rx_prod_idx = (rx_prod_idx + 1) & (MVS_RX_RING_SZ - 1);
>  
> -		rx_desc = le32_to_cpu(mvi->rx[mvi->rx_cons + 1]);
> -
> -		mvs_hba_cq_dump(mvi);
> +		rx_desc = le32_to_cpu(mvi->rx[rx_prod_idx + 1]);
>  
>  		if (likely(rx_desc & RXQ_DONE))
> -			mvs_slot_complete(mvi, rx_desc);
> +			mvs_slot_complete(mvi, rx_desc, 0);
>  		if (rx_desc & RXQ_ATTN) {
>  			attn = true;
>  			dev_printk(KERN_DEBUG, &pdev->dev, "ATTN %X\n",
>  				rx_desc);
>  		} else if (rx_desc & RXQ_ERR) {
> +			if (!(rx_desc & RXQ_DONE))
> +				mvs_slot_complete(mvi, rx_desc, 0);
>  			dev_printk(KERN_DEBUG, &pdev->dev, "RXQ_ERR %X\n",
>  				rx_desc);
> +		} else if (rx_desc & RXQ_SLOT_RESET) {
> +			dev_printk(KERN_DEBUG, &pdev->dev, "Slot reset[%X]\n",
> +				rx_desc);
> +			mvs_slot_free(mvi, rx_desc);
>  		}
>  	}
>  
> @@ -1725,13 +1952,16 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
>  	u32 flags;
>  	u32 resp_len, req_len, i, tag = tei->tag;
>  	const u32 max_resp_len = SB_RFB_MAX;
> +	u8 phy_mask;
>  
>  	slot = &mvi->slot_info[tag];
>  
> +	phy_mask = (port->wide_port_phymap) ? port->wide_port_phymap :
> +		task->dev->port->phy_mask;
>  	slot->tx = mvi->tx_prod;
>  	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
>  				(TXQ_CMD_SSP << TXQ_CMD_SHIFT) |
> -				(port->wide_port_phymap << TXQ_PHY_SHIFT));
> +				(phy_mask << TXQ_PHY_SHIFT));
>  
>  	flags = MCH_RETRY;
>  	if (task->ssp_task.enable_first_burst) {
> @@ -1832,22 +2062,32 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
>  	void __iomem *regs = mvi->regs;
>  	struct mvs_task_exec_info tei;
>  	struct sas_task *t = task;
> +	struct mvs_slot_info *slot;
>  	u32 tag = 0xdeadbeef, rc, n_elem = 0;
>  	unsigned long flags;
>  	u32 n = num, pass = 0;
>  
>  	spin_lock_irqsave(&mvi->lock, flags);
> -
>  	do {
> +		dev = t->dev;
>  		tei.port = &mvi->port[dev->port->id];
>  
>  		if (!tei.port->port_attached) {
> -			struct task_status_struct *ts = &t->task_status;
> -			ts->stat = SAS_PHY_DOWN;
> -			t->task_done(t);
> -			rc = 0;
> -			goto exec_exit;
> +			if (sas_protocol_ata(t->task_proto)) {
> +				rc = SAS_PHY_DOWN;
> +				goto out_done;
> +			} else {
> +				struct task_status_struct *ts = &t->task_status;
> +				ts->resp = SAS_TASK_UNDELIVERED;
> +				ts->stat = SAS_PHY_DOWN;
> +				t->task_done(t);
> +				if (n > 1)
> +					t = list_entry(t->list.next,
> +							struct sas_task, list);
> +				continue;
> +			}
>  		}
> +
>  		if (!sas_protocol_ata(t->task_proto)) {
>  			if (t->num_scatter) {
>  				n_elem = pci_map_sg(mvi->pdev, t->scatter,
> @@ -1866,9 +2106,10 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
>  		if (rc)
>  			goto err_out;
>  
> -		mvi->slot_info[tag].task = t;
> -		mvi->slot_info[tag].n_elem = n_elem;
> -		memset(mvi->slot_info[tag].buf, 0, MVS_SLOT_BUF_SZ);
> +		slot = &mvi->slot_info[tag];
> +		slot->task = t;
> +		slot->n_elem = n_elem;
> +		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
>  		tei.task = t;
>  		tei.hdr = &mvi->slot[tag];
>  		tei.tag = tag;
> @@ -1897,28 +2138,24 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
>  		if (rc)
>  			goto err_out_tag;
>  
> +		slot->port = tei.port;
> +		list_add_tail(&slot->list, &slot->port->list);
>  		/* TODO: select normal or high priority */
>  
>  		spin_lock(&t->task_state_lock);
>  		t->task_state_flags |= SAS_TASK_AT_INITIATOR;
>  		spin_unlock(&t->task_state_lock);
>  
> -		if (n == 1) {
> -			spin_unlock_irqrestore(&mvi->lock, flags);
> -			mw32(TX_PROD_IDX, mvi->tx_prod);
> -		}
>  		mvs_hba_memory_dump(mvi, tag, t->task_proto);
>  
>  		++pass;
>  		mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
> -
> -		if (n == 1)
> -			break;
> -
> -		t = list_entry(t->list.next, struct sas_task, list);
> +		if (n > 1)
> +			t = list_entry(t->list.next, struct sas_task, list);
>  	} while (--n);
>  
> -	return 0;
> +	rc = 0;
> +	goto out_done;
>  
>  err_out_tag:
>  	mvs_tag_free(mvi, tag);
> @@ -1928,7 +2165,7 @@ err_out:
>  		if (n_elem)
>  			pci_unmap_sg(mvi->pdev, t->scatter, n_elem,
>  				     t->data_dir);
> -exec_exit:
> +out_done:
>  	if (pass)
>  		mw32(TX_PROD_IDX, (mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
>  	spin_unlock_irqrestore(&mvi->lock, flags);
> @@ -1937,42 +2174,64 @@ exec_exit:
>  
>  static int mvs_task_abort(struct sas_task *task)
>  {
> -	int rc = 1;
> +	int rc;
>  	unsigned long flags;
>  	struct mvs_info *mvi = task->dev->port->ha->lldd_ha;
>  	struct pci_dev *pdev = mvi->pdev;
> +	int tag;
>  
>  	spin_lock_irqsave(&task->task_state_lock, flags);
>  	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
>  		rc = TMF_RESP_FUNC_COMPLETE;
> +		spin_unlock_irqrestore(&task->task_state_lock, flags);
>  		goto out_done;
>  	}
>  	spin_unlock_irqrestore(&task->task_state_lock, flags);
>  
> -	/*FIXME*/
> -	rc = TMF_RESP_FUNC_COMPLETE;
> -
>  	switch (task->task_proto) {
>  	case SAS_PROTOCOL_SMP:
> -		dev_printk(KERN_DEBUG, &pdev->dev, "SMP Abort! ");
> +		dev_printk(KERN_DEBUG, &pdev->dev, "SMP Abort! \n");
>  		break;
>  	case SAS_PROTOCOL_SSP:
> -		dev_printk(KERN_DEBUG, &pdev->dev, "SSP Abort! ");
> +		dev_printk(KERN_DEBUG, &pdev->dev, "SSP Abort! \n");
>  		break;
>  	case SAS_PROTOCOL_SATA:
>  	case SAS_PROTOCOL_STP:
>  	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:{
> -		dev_printk(KERN_DEBUG, &pdev->dev, "STP Abort! "
> -			"Dump D2H FIS: \n");
> +		dev_printk(KERN_DEBUG, &pdev->dev, "STP Abort! \n");
> +#if _MV_DUMP
> +		dev_printk(KERN_DEBUG, &pdev->dev, "Dump D2H FIS: \n");
>  		mvs_hexdump(sizeof(struct host_to_dev_fis),
>  				(void *)&task->ata_task.fis, 0);
>  		dev_printk(KERN_DEBUG, &pdev->dev, "Dump ATAPI Cmd : \n");
>  		mvs_hexdump(16, task->ata_task.atapi_packet, 0);
> +#endif
> +		spin_lock_irqsave(&task->task_state_lock, flags);
> +		if (task->task_state_flags & SAS_TASK_NEED_DEV_RESET) {
> +			/* TODO */
> +			;
> +		}
>  		break;
>  	}
>  	default:
>  		break;
>  	}
> +
> +	spin_lock_irqsave(&task->task_state_lock, flags);
> +	task->task_state_flags &= ~SAS_TASK_STATE_ABORTED;
> +	spin_unlock_irqrestore(&task->task_state_lock, flags);

You can't do this ... that's altering internal libsas state.
Speficially, if the abort is called by the error handler (as it usually
is) you'll end up with a double free of the task.

> +	if (mvs_find_tag(mvi, task, &tag)) {
> +		spin_lock_irqsave(&mvi->lock, flags);
> +		mvs_slot_complete(mvi, tag, 2);
> +		spin_unlock_irqrestore(&mvi->lock, flags);
> +		rc = TMF_RESP_FUNC_COMPLETE;
> +	} else {
> +		if (!mvs_task_exec(task, 1, GFP_KERNEL))
> +			rc = TMF_RESP_FUNC_SUCC;
> +		else
> +			rc = TMF_RESP_FUNC_FAILED;
> +	}
>  out_done:
>  	return rc;
>  }
> @@ -2132,6 +2391,10 @@ static struct mvs_info *__devinit mvs_alloc(struct pci_dev *pdev,
>  		mvs_phy_init(mvi, i);
>  		arr_phy[i] = &mvi->phy[i].sas_phy;
>  		arr_port[i] = &mvi->port[i].sas_port;
> +		mvi->port[i].taskfileset = MVS_ID_NOT_MAPPED;
> +		mvi->port[i].wide_port_phymap = 0;
> +		mvi->port[i].port_attached = 0;
> +		INIT_LIST_HEAD(&mvi->port[i].list);
>  	}
>  
>  	SHOST_TO_SAS_HA(mvi->shost) = &mvi->sas;
> @@ -2148,9 +2411,10 @@ static struct mvs_info *__devinit mvs_alloc(struct pci_dev *pdev,
>  	mvi->sas.sas_phy = arr_phy;
>  	mvi->sas.sas_port = arr_port;
>  	mvi->sas.num_phys = chip->n_phy;
> -	mvi->sas.lldd_max_execute_num = MVS_CHIP_SLOT_SZ - 1;
> +	mvi->sas.lldd_max_execute_num = 1;
>  	mvi->sas.lldd_queue_size = MVS_QUEUE_SIZE;
> -	mvi->can_queue = (MVS_CHIP_SLOT_SZ >> 1) - 1;
> +	mvi->shost->can_queue = MVS_CAN_QUEUE;
> +	mvi->shost->cmd_per_lun = mvi->shost->can_queue / mvi->sas.num_phys;
>  	mvi->sas.lldd_ha = mvi;
>  	mvi->sas.core.shost = mvi->shost;
>  
> @@ -2357,7 +2621,7 @@ static void __devinit mvs_phy_hacks(struct mvs_info *mvi)
>  	mvs_cw32(regs, CMD_SAS_CTL0, tmp);
>  
>  	/* workaround for WDTIMEOUT , set to 550 ms */
> -	mvs_cw32(regs, CMD_WD_TIMER, 0xffffff);
> +	mvs_cw32(regs, CMD_WD_TIMER, 0x86470);
>  
>  	/* not to halt for different port op during wideport link change */
>  	mvs_cw32(regs, CMD_APP_ERR_CONFIG, 0xffefbf7d);
> @@ -2465,17 +2729,16 @@ static u32 mvs_is_phy_ready(struct mvs_info *mvi, int i)
>  {
>  	u32 tmp;
>  	struct mvs_phy *phy = &mvi->phy[i];
> -	struct mvs_port *port;
> +	struct mvs_port *port = phy->port;;
>  
>  	tmp = mvs_read_phy_ctl(mvi, i);
>  
>  	if ((tmp & PHY_READY_MASK) && !(phy->irq_status & PHYEV_POOF)) {
> -		if (!phy->port)
> +		if (!port)
>  			phy->phy_attached = 1;
>  		return tmp;
>  	}
>  
> -	port = phy->port;
>  	if (port) {
>  		if (phy->phy_type & PORT_TYPE_SAS) {
>  			port->wide_port_phymap &= ~(1U << i);
> @@ -2497,7 +2760,7 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
>  {
>  	struct mvs_phy *phy = &mvi->phy[i];
>  	struct pci_dev *pdev = mvi->pdev;
> -	u32 tmp, j;
> +	u32 tmp;
>  	u64 tmp64;
>  
>  	mvs_write_port_cfg_addr(mvi, i, PHYR_IDENTIFY);
> @@ -2524,46 +2787,20 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
>  		sas_phy->linkrate =
>  			(phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
>  				PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET;
> -
> -		/* Updated attached_sas_addr */
> -		mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_HI);
> -		phy->att_dev_sas_addr =
> -				(u64) mvs_read_port_cfg_data(mvi, i) << 32;
> -
> -		mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_LO);
> -		phy->att_dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
> -
> -		dev_printk(KERN_DEBUG, &pdev->dev,
> -			"phy[%d] Get Attached Address 0x%llX ,"
> -			" SAS Address 0x%llX\n",
> -			i, phy->att_dev_sas_addr, phy->dev_sas_addr);
> -		dev_printk(KERN_DEBUG, &pdev->dev,
> -			"Rate = %x , type = %d\n",
> -			sas_phy->linkrate, phy->phy_type);
> -
> -#if 1
> -		/*
> -		* If the device is capable of supporting a wide port
> -		* on its phys, it may configure the phys as a wide port.
> -		*/
> -		if (phy->phy_type & PORT_TYPE_SAS)
> -			for (j = 0; j < mvi->chip->n_phy && j != i; ++j) {
> -				if ((mvi->phy[j].phy_attached) &&
> -					(mvi->phy[j].phy_type & PORT_TYPE_SAS))
> -					if (phy->att_dev_sas_addr ==
> -					mvi->phy[j].att_dev_sas_addr - 1) {
> -						phy->att_dev_sas_addr =
> -						mvi->phy[j].att_dev_sas_addr;
> -						break;
> -					}
> -			}
> -
> -#endif
> -
> -		tmp64 = cpu_to_be64(phy->att_dev_sas_addr);
> -		memcpy(sas_phy->attached_sas_addr, &tmp64, SAS_ADDR_SIZE);
> +		phy->minimum_linkrate =
> +			(phy->phy_status &
> +				PHY_MIN_SPP_PHYS_LINK_RATE_MASK) >> 8;
> +		phy->maximum_linkrate =
> +			(phy->phy_status &
> +				PHY_MAX_SPP_PHYS_LINK_RATE_MASK) >> 12;
>  
>  		if (phy->phy_type & PORT_TYPE_SAS) {
> +			/* Updated attached_sas_addr */
> +			mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_HI);
> +			phy->att_dev_sas_addr =
> +				(u64) mvs_read_port_cfg_data(mvi, i) << 32;
> +			mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_LO);
> +			phy->att_dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
>  			mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_DEV_INFO);
>  			phy->att_dev_info = mvs_read_port_cfg_data(mvi, i);
>  			phy->identify.device_type =
> @@ -2582,6 +2819,7 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
>  		} else if (phy->phy_type & PORT_TYPE_SATA) {
>  			phy->identify.target_port_protocols = SAS_PROTOCOL_STP;
>  			if (mvs_is_sig_fis_received(phy->irq_status)) {
> +				phy->att_dev_sas_addr = i;	/* temp */
>  				if (phy_st & PHY_OOB_DTCTD)
>  					sas_phy->oob_mode = SATA_OOB_MODE;
>  				phy->frame_rcvd_size =
> @@ -2591,20 +2829,34 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
>  			} else {
>  				dev_printk(KERN_DEBUG, &pdev->dev,
>  					"No sig fis\n");
> +				phy->phy_type &= ~(PORT_TYPE_SATA);
> +				goto out_done;
>  			}
>  		}
> +		tmp64 = cpu_to_be64(phy->att_dev_sas_addr);
> +		memcpy(sas_phy->attached_sas_addr, &tmp64, SAS_ADDR_SIZE);
> +
> +		dev_printk(KERN_DEBUG, &pdev->dev,
> +			"phy[%d] Get Attached Address 0x%llX ,"
> +			" SAS Address 0x%llX\n",
> +			i, phy->att_dev_sas_addr, phy->dev_sas_addr);
> +		dev_printk(KERN_DEBUG, &pdev->dev,
> +			"Rate = %x , type = %d\n",
> +			sas_phy->linkrate, phy->phy_type);
> +
>  		/* workaround for HW phy decoding error on 1.5g disk drive */
>  		mvs_write_port_vsr_addr(mvi, i, VSR_PHY_MODE6);
>  		tmp = mvs_read_port_vsr_data(mvi, i);
>  		if (((phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
>  		     PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET) ==
>  			SAS_LINK_RATE_1_5_GBPS)
> -			tmp &= ~PHY_MODE6_DTL_SPEED;
> +			tmp &= ~PHY_MODE6_LATECLK;
>  		else
> -			tmp |= PHY_MODE6_DTL_SPEED;
> +			tmp |= PHY_MODE6_LATECLK;
>  		mvs_write_port_vsr_data(mvi, i, tmp);
>  
>  	}
> +out_done:
>  	if (get_st)
>  		mvs_write_port_irq_stat(mvi, i, phy->irq_status);
>  }
> @@ -2629,6 +2881,11 @@ static void mvs_port_formed(struct asd_sas_phy *sas_phy)
>  	spin_unlock_irqrestore(&mvi->lock, flags);
>  }
>  
> +static int mvs_I_T_nexus_reset(struct domain_device *dev)
> +{
> +	return TMF_RESP_FUNC_COMPLETE;
> +}

This is wrong ... it's an integral part of error handling.  If the
driver lies, libsas will think an I_T nexus reset was done, even though
nothing happened and will proceed to report the error as cleared.

>  static int __devinit mvs_hw_init(struct mvs_info *mvi)
>  {
>  	void __iomem *regs = mvi->regs;
> @@ -2790,13 +3047,12 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
>  	/* enable CMD/CMPL_Q/RESP mode */
>  	mw32(PCS, PCS_SATA_RETRY | PCS_FIS_RX_EN | PCS_CMD_EN);
>  
> -	/* re-enable interrupts globally */
> -	mvs_hba_interrupt_enable(mvi);
> -
>  	/* enable completion queue interrupt */
> -	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM);
> +	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS);
>  	mw32(INT_MASK, tmp);
>  
> +	/* Enable SRS interrupt */
> +	mw32(INT_MASK_SRS, 0xFF);
>  	return 0;
>  }
>  
> @@ -2870,6 +3126,8 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
>  
>  	mvs_print_info(mvi);
>  
> +	mvs_hba_interrupt_enable(mvi);
> +
>  	scsi_scan_host(mvi->shost);
>  
>  	return 0;
> @@ -2915,7 +3173,8 @@ static struct sas_domain_function_template mvs_transport_ops = {
>  	.lldd_execute_task	= mvs_task_exec,
>  	.lldd_control_phy	= mvs_phy_control,
>  	.lldd_abort_task	= mvs_task_abort,
> -	.lldd_port_formed	= mvs_port_formed
> +	.lldd_port_formed	= mvs_port_formed,
> +	.lldd_I_T_nexus_reset	= mvs_I_T_nexus_reset,
>  };
>  
>  static struct pci_device_id __devinitdata mvs_pci_table[] = {
> @@ -2923,6 +3182,15 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
>  	{ PCI_VDEVICE(MARVELL, 0x6340), chip_6440 },
>  	{ PCI_VDEVICE(MARVELL, 0x6440), chip_6440 },
>  	{ PCI_VDEVICE(MARVELL, 0x6480), chip_6480 },
> +	{
> +		.vendor 	= PCI_VENDOR_ID_MARVELL,
> +		.device 	= 0x6440,
> +		.subvendor	= PCI_ANY_ID,
> +		.subdevice	= 0x6480,
> +		.class		= 0,
> +		.class_mask	= 0,
> +		.driver_data	= chip_6480,
> +	},
>  
>  	{ }	/* terminate list */
>  };

James


