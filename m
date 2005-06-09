From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [RFC] convert fusion to SPI transport class and use generic D
	V
Date: Thu, 9 Jun 2005 17:27:02 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C02A96495@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [147.145.40.20] ([147.145.40.20]:62355 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262417AbVFIX1U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2005 19:27:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "Wade, Roy" <Roy.Wade@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>

Are you considering this for inclusion into the kernel?

(1)We need to hold off on that till we sort out supporting 
integrated raid first in the spi transport.  Also, can the transport
support receiving asyn event form scsi lld for triggering dv on disk that
was just added to degraded volume(raid 1)?  Also queising IO to
the volume, is that supported; I believe that is, but just asking.

(2) Does this patch dependent on the previous patch to work; e.g.
"update spi transport class so that u320 Domain Validation works"
Just wondering if there were any backward compatibility for this patch this
to work.

(3) I need to review our source to confirm what work arounds in our code are
going to be
backed out by using your generic dv.  I know of sep devices known to freeze
the bus 
when too large inquiry data is requested.  Wondering if generic dv will
freeze the bus.
Also known are mixed mode devices on the bus getting starved when qas is
enabled, 
e.g. u320 and non-u320 disk devices on same bus. 
I'm not sure whether generic dv is disabling qas in that case.  
I think there are other concerns, I will have to check and post them later.

Eric Moore



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Thursday, June 09, 2005 7:35 AM
> To: SCSI Mailing List
> Subject: [RFC] convert fusion to SPI transport class and use 
> generic DV
> 
> 
> This code is more posted as an illustration of how to do 
> things than an
> actual patch for submission.  However, I've tested this and it does
> actually work:
> 
> ioc1: 53C1030: Capabilities={Initiator,Target}
> scsi5 : ioc1: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=56
>   Vendor: HP 36.4G  Model: ST336607LW        Rev: HPC3
>   Type:   Direct-Access                      ANSI SCSI revision: 03
>  target5:0:1: Beginning Domain Validation
>  target5:0:1: Ending Domain Validation
>  target5:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS (6.25 
> ns, offset 127)
> 
> jejb@titanic> ls /sys/class/spi_transport/target5\:0\:1/
> device@  iu          max_width   offset    period  rd_strm    
>  rti    wr_flow
> dt       max_offset  min_period  pcomp_en  qas     revalidate  width
> 
> James
> 
> --- a/drivers/message/fusion/Kconfig
> +++ b/drivers/message/fusion/Kconfig
> @@ -9,6 +9,7 @@ config FUSION_SPI
>  	tristate "Fusion MPT ScsiHost drivers for SPI"
>  	depends on PCI && SCSI
>  	select FUSION
> +	select SCSI_SPI_ATTRS
>  	---help---
>  	  SCSI HOST support for a parallel SCSI host adapters.
>  
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -2507,7 +2507,7 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
>  		/* 4. Renegotiate to all devices, if SCSI
>  		 */
>  		if (ioc->bus_type == SCSI) {
> -			dnegoprintk(("writeSDP1: ALL_IDS USE_NVRAM\n"));
> +			printk("writeSDP1: ALL_IDS USE_NVRAM\n");
>  			mptscsih_writeSDP1(hd, 0, 0, 
> MPT_SCSICFG_ALL_IDS | MPT_SCSICFG_USE_NVRAM);
>  		}
>  
> @@ -2766,7 +2766,7 @@ mptscsih_initTarget(MPT_SCSI_HOST *hd, i
>  					vdev->tflags |= 
> MPT_TARGET_FLAGS_VALID_56;
>  				}
>  			}
> -			mptscsih_setTargetNegoParms(hd, vdev, data_56);
> +			//mptscsih_setTargetNegoParms(hd, vdev, 
> data_56);
>  		} else {
>  			/* Initial Inquiry may not request 
> enough data bytes to
>  			 * obtain byte 57.  DV will; if target 
> doesn't return
> @@ -2777,7 +2777,7 @@ mptscsih_initTarget(MPT_SCSI_HOST *hd, i
>  				 */
>  					data_56 = data[56];
>  					vdev->tflags |= 
> MPT_TARGET_FLAGS_VALID_56;
> -					
> mptscsih_setTargetNegoParms(hd, vdev, data_56);
> +					
> //mptscsih_setTargetNegoParms(hd, vdev, data_56);
>  				}
>  			}
>  		}
> @@ -2806,6 +2806,8 @@ mptscsih_setTargetNegoParms(MPT_SCSI_HOS
>  
>  	target->negoFlags = pspi_data->noQas;
>  
> +	printk("HERE\n");
> +
>  	/* noQas == 0 => device supports QAS. Need byte 56 of 
> Inq to determine
>  	 * support. If available, default QAS to off and allow enabling.
>  	 * If not available, default QAS to on, turn off for non-disks.
> @@ -3105,6 +3107,8 @@ mptscsih_writeSDP1(MPT_SCSI_HOST *hd, in
>  	u8			 negoFlags;
>  	u8			 maxwidth, maxoffset, maxfactor;
>  
> +	printk("HERE2\n");
> +
>  	if (ioc->spi_data.sdp1length == 0)
>  		return 0;
>  
> @@ -3204,8 +3208,8 @@ mptscsih_writeSDP1(MPT_SCSI_HOST *hd, in
>  			return -EAGAIN;
>  		}
>  
> -		ddvprintk((MYIOC_s_INFO_FMT "WriteSDP1 (mf=%p, 
> id=%d, req=0x%x, cfg=0x%x)\n",
> -			hd->ioc->name, mf, id, requested, 
> configuration));
> +		printk(MYIOC_s_INFO_FMT "WriteSDP1 (mf=%p, 
> id=%d, req=0x%x, cfg=0x%x)\n",
> +			hd->ioc->name, mf, id, requested, 
> configuration);
>  
>  
>  		/* Set the request and the data pointers.
> @@ -4228,12 +4232,12 @@ mptscsih_qas_check(MPT_SCSI_HOST *hd, in
>  		if ((pTarget != NULL) && (!pTarget->raidVolume)) {
>  			if ((pTarget->negoFlags & 
> hd->ioc->spi_data.noQas) == 0) {
>  				pTarget->negoFlags |= 
> hd->ioc->spi_data.noQas;
> -				dnegoprintk(("writeSDP1: id=%d 
> flags=0\n", id));
> +				printk("writeSDP1: id=%d 
> flags=0\n", id);
>  				mptscsih_writeSDP1(hd, 0, ii, 0);
>  			}
>  		} else {
>  			if (mptscsih_is_phys_disk(hd->ioc, ii) == 1) {
> -				dnegoprintk(("writeSDP1: id=%d 
> SCSICFG_USE_NVRAM\n", id));
> +				printk("writeSDP1: id=%d 
> SCSICFG_USE_NVRAM\n", id);
>  				mptscsih_writeSDP1(hd, 0, ii, 
> MPT_SCSICFG_USE_NVRAM);
>  			}
>  		}
> --- a/drivers/message/fusion/mptscsih.h
> +++ b/drivers/message/fusion/mptscsih.h
> @@ -67,7 +67,7 @@
>   * capabilities.
>   */
>  
> -#define MPTSCSIH_ENABLE_DOMAIN_VALIDATION
> +#undef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
>  
>  
>  /* SCSI driver setup structure. Settings can be overridden
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -62,6 +62,8 @@
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_tcq.h>
> +#include <scsi/scsi_transport.h>
> +#include <scsi/scsi_transport_spi.h>
>  
>  #include "mptbase.h"
>  #include "mptscsih.h"
> @@ -98,6 +100,8 @@ static int mpt_pq_filter = 0;
>  module_param(mpt_pq_filter, int, 0);
>  MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral 
> qualifier filter: enable=1  (default=0)");
>  
> +static struct scsi_transport_template 
> *mptspi_transport_template = NULL;
> +
>  static int	mptspiDoneCtx = -1;
>  static int	mptspiTaskCtx = -1;
>  static int	mptspiInternalCtx = -1; /* Used only for 
> internal commands */
> @@ -115,6 +119,48 @@ static struct device_attribute *mptspi_d
>  	NULL,
>  };
>  
> +static int mptspi_target_alloc(struct scsi_target *starget)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST 
> *)shost->hostdata;
> +	static void mptspi_write_offset(struct scsi_target *, int);
> +	static void mptspi_write_width(struct scsi_target *, int);
> +
> +	if (hd == NULL)
> +		return -ENODEV;
> +
> +	if (hd->ioc->spi_data.nvram &&
> +	    hd->ioc->spi_data.nvram[starget->id] != 
> MPT_HOST_NVRAM_INVALID) {
> +		u32 nvram = hd->ioc->spi_data.nvram[starget->id];
> +		spi_min_period(starget) = (nvram & 
> MPT_NVRAM_SYNC_MASK) >> MPT_NVRAM_SYNC_SHIFT;
> +		spi_max_width(starget) = nvram & 
> MPT_NVRAM_WIDE_DISABLE ? 0 : 1;
> +	} else {
> +		spi_min_period(starget) = 
> hd->ioc->spi_data.minSyncFactor;
> +		spi_max_width(starget) = hd->ioc->spi_data.maxBusWidth;
> +	}
> +	spi_max_offset(starget) = hd->ioc->spi_data.maxSyncOffset;
> +
> +	spi_offset(starget) = 0;
> +	mptspi_write_width(starget, 0);
> +
> +	return 0;
> +}
> +
> +static int mptspi_slave_configure(struct scsi_device *sdev)
> +{
> +	int ret = mptscsih_slave_configure(sdev);
> +
> +	if (ret)
> +		return ret;
> +
> +	if (!spi_initial_dv(sdev->sdev_target)) {
> +		spi_dv_device(sdev);
> +		spi_display_xfer_agreement(sdev->sdev_target);
> +	}
> +
> +	return 0;
> +}
> +
>  static struct scsi_host_template mptspi_driver_template = {
>  	.proc_name			= "mptspi",
>  	.proc_info			= mptscsih_proc_info,
> @@ -122,8 +168,9 @@ static struct scsi_host_template mptspi_
>  	.info				= mptscsih_info,
>  	.queuecommand			= mptscsih_qcmd,
>  	.slave_alloc			= mptscsih_slave_alloc,
> -	.slave_configure		= mptscsih_slave_configure,
> +	.slave_configure		= mptspi_slave_configure,
>  	.slave_destroy			= mptscsih_slave_destroy,
> +	.target_alloc			= mptspi_target_alloc,
>  	.eh_abort_handler		= mptscsih_abort,
>  	.eh_device_reset_handler	= mptscsih_dev_reset,
>  	.eh_bus_reset_handler		= mptscsih_bus_reset,
> @@ -138,6 +185,325 @@ static struct scsi_host_template mptspi_
>  	.sdev_attrs			= mptspi_dev_attrs,
>  };
>  
> +static int mptspi_read_page0(struct scsi_target *starget,
> +			     struct _CONFIG_PAGE_SCSI_DEVICE_0 
> *pass_pg0)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST 
> *)shost->hostdata;
> +	struct _MPT_ADAPTER *ioc = hd->ioc;
> +	struct _CONFIG_PAGE_SCSI_DEVICE_0 *pg0;
> +	dma_addr_t pg0_dma;
> +	int size;
> +	struct _x_config_parms cfg;
> +	struct _CONFIG_PAGE_HEADER hdr;
> +	int err = -EBUSY;
> +
> +	size = ioc->spi_data.sdp0length * 4;
> +	/*
> +	if (ioc->spi_data.sdp0length & 1)
> +		size += size + 4;
> +	size += 2048;
> +	*/
> +
> +	pg0 = dma_alloc_coherent(&ioc->pcidev->dev, size, 
> &pg0_dma, GFP_KERNEL);
> +	if (pg0 == NULL) {
> +		dev_printk(KERN_ERR, &starget->dev, 
> "dma_alloc_coherent for parameters failed\n");
> +		return -EINVAL;
> +	}
> +
> +	memset(&hdr, 0, sizeof(hdr));
> +
> +	hdr.PageVersion = ioc->spi_data.sdp0version;
> +	hdr.PageLength = ioc->spi_data.sdp0length;
> +	hdr.PageNumber = 0;
> +	hdr.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
> +
> +	memset(&cfg, 0, sizeof(cfg));
> +
> +	cfg.hdr = &hdr;
> +	cfg.physAddr = pg0_dma;
> +	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
> +	cfg.dir = 0;
> +	cfg.pageAddr = (starget->channel << 8) | starget->id;
> +
> +	if (mpt_config(ioc, &cfg)) {
> +		dev_printk(KERN_ERR, &starget->dev, "mpt_config 
> failed\n");
> +		goto out_free;
> +	}
> +	err = 0;
> +	memcpy(pass_pg0, pg0, size);
> +
> + out_free:
> +	dma_free_coherent(&ioc->pcidev->dev, size, pg0, pg0_dma);
> +	return err;
> +}
> +
> +static void mptspi_read_parameters(struct scsi_target *starget)
> +{
> +	int nego;
> +	struct _CONFIG_PAGE_SCSI_DEVICE_0 pg0;
> +
> +	mptspi_read_page0(starget, &pg0);
> +
> +	nego = le32_to_cpu(pg0.NegotiatedParameters);
> +
> +	spi_iu(starget) = (nego & MPI_SCSIDEVPAGE0_NP_IU) ? 1 : 0;
> +	spi_dt(starget) = (nego & MPI_SCSIDEVPAGE0_NP_DT) ? 1 : 0;
> +	spi_qas(starget) = (nego & MPI_SCSIDEVPAGE0_NP_QAS) ? 1 : 0;
> +	//spi_hold_mcs(starget) = (nego & 
> MPI_SCSIDEVPAGE0_NP_HOLD_MCS) ? 1 : 0;
> +	spi_wr_flow(starget) = (nego & 
> MPI_SCSIDEVPAGE0_NP_WR_FLOW) ? 1 : 0;
> +	spi_rd_strm(starget) = (nego & 
> MPI_SCSIDEVPAGE0_NP_RD_STRM) ? 1 : 0;
> +	spi_rti(starget) = (nego & MPI_SCSIDEVPAGE0_NP_RTI) ? 1 : 0;
> +	spi_pcomp_en(starget) = (nego & 
> MPI_SCSIDEVPAGE0_NP_PCOMP_EN) ? 1 : 0;
> +	spi_period(starget) = (nego & 
> MPI_SCSIDEVPAGE0_NP_NEG_SYNC_PERIOD_MASK) >> 
> MPI_SCSIDEVPAGE0_NP_SHIFT_SYNC_PERIOD;
> +	spi_offset(starget) = (nego & 
> MPI_SCSIDEVPAGE0_NP_NEG_SYNC_OFFSET_MASK) >> 
> MPI_SCSIDEVPAGE0_NP_SHIFT_SYNC_OFFSET;
> +	spi_width(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WIDE) ? 1 : 0;
> +}
> +
> +static int mptspi_write_page1(struct scsi_target *starget,
> +			       struct 
> _CONFIG_PAGE_SCSI_DEVICE_1 *pass_pg1)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST 
> *)shost->hostdata;
> +	struct _MPT_ADAPTER *ioc = hd->ioc;
> +	struct _CONFIG_PAGE_SCSI_DEVICE_1 *pg1;
> +	dma_addr_t pg1_dma;
> +	int size;
> +	struct _x_config_parms cfg;
> +	struct _CONFIG_PAGE_HEADER hdr;
> +	int err = -EBUSY;
> +
> +	size = ioc->spi_data.sdp1length * 4;
> +
> +	pg1 = dma_alloc_coherent(&ioc->pcidev->dev, size, 
> &pg1_dma, GFP_KERNEL);
> +	if (pg1 == NULL) {
> +		dev_printk(KERN_ERR, &starget->dev, 
> "dma_alloc_coherent for parameters failed\n");
> +		return -EINVAL;
> +	}
> +
> +	memset(&hdr, 0, sizeof(hdr));
> +
> +	hdr.PageVersion = ioc->spi_data.sdp1version;
> +	hdr.PageLength = ioc->spi_data.sdp1length;
> +	hdr.PageNumber = 1;
> +	hdr.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
> +
> +	memset(&cfg, 0, sizeof(cfg));
> +
> +	cfg.hdr = &hdr;
> +	cfg.physAddr = pg1_dma;
> +	cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
> +	cfg.dir = 1;
> +	cfg.pageAddr = (starget->channel << 8) | starget->id;
> +
> +	memcpy(pg1, pass_pg1, size);
> +
> +	pg1->Header.PageVersion = hdr.PageVersion;
> +	pg1->Header.PageLength = hdr.PageLength;
> +	pg1->Header.PageNumber = hdr.PageNumber;
> +	pg1->Header.PageType = hdr.PageType;
> +
> +	if (mpt_config(ioc, &cfg)) {
> +		dev_printk(KERN_ERR, &starget->dev, "mpt_config 
> failed\n");
> +		goto out_free;
> +	}
> +	err = 0;
> +
> + out_free:
> +	dma_free_coherent(&ioc->pcidev->dev, size, pg1, pg1_dma);
> +	return err;
> +}
> +
> +static u32 mptspi_getRP(struct scsi_target *starget)
> +{
> +	u32 nego = 0;
> +
> +	nego |= spi_iu(starget) ? MPI_SCSIDEVPAGE1_RP_IU : 0;
> +	nego |= spi_dt(starget) ? MPI_SCSIDEVPAGE1_RP_DT : 0;
> +	nego |= spi_qas(starget) ? MPI_SCSIDEVPAGE1_RP_QAS : 0;
> +	//nego |= spi_hold_mcs(starget) ? 
> MPI_SCSIDEVPAGE1_RP_HOLD_MCS : 0;
> +	nego |= spi_wr_flow(starget) ? MPI_SCSIDEVPAGE1_RP_WR_FLOW : 0;
> +	nego |= spi_rd_strm(starget) ? MPI_SCSIDEVPAGE1_RP_RD_STRM : 0;
> +	nego |= spi_rti(starget) ? MPI_SCSIDEVPAGE1_RP_RTI : 0;
> +	nego |= spi_pcomp_en(starget) ? 
> MPI_SCSIDEVPAGE1_RP_PCOMP_EN : 0;
> +
> +	nego |= (spi_period(starget) <<  
> MPI_SCSIDEVPAGE1_RP_SHIFT_MIN_SYNC_PERIOD) & 
> MPI_SCSIDEVPAGE1_RP_MIN_SYNC_PERIOD_MASK;
> +	nego |= (spi_offset(starget) << 
> MPI_SCSIDEVPAGE1_RP_SHIFT_MAX_SYNC_OFFSET) & 
> MPI_SCSIDEVPAGE1_RP_MAX_SYNC_OFFSET_MASK;
> +	nego |= spi_width(starget) ?  MPI_SCSIDEVPAGE1_RP_WIDE : 0;
> +
> +	return nego;
> +}
> +
> +static void mptspi_write_offset(struct scsi_target *starget, 
> int offset)
> +{
> +	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
> +	u32 nego;
> +
> +	if (offset < 0)
> +		offset = 0;
> +
> +	if (offset > 255)
> +		offset = 255;
> +
> +	if (spi_offset(starget) == -1)
> +		mptspi_read_parameters(starget);
> +
> +	spi_offset(starget) = offset;
> +
> +	nego = mptspi_getRP(starget);
> +
> +	pg1.RequestedParameters = cpu_to_le32(nego);
> +	pg1.Reserved = 0;
> +	pg1.Configuration = 0;
> +
> +	mptspi_write_page1(starget, &pg1);
> +}
> +
> +static void mptspi_write_period(struct scsi_target *starget, 
> int period)
> +{
> +	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
> +	u32 nego;
> +
> +	if (period < 8)
> +		period = 8;
> +
> +	if (period > 255)
> +		period = 255;
> +
> +	if (spi_period(starget) == -1)
> +		mptspi_read_parameters(starget);
> +
> +	if (period == 8) {
> +		spi_iu(starget) = 1;
> +		spi_dt(starget) = 1;
> +	} else if (period == 9) {
> +		spi_dt(starget) = 1;
> +	}
> +
> +	spi_period(starget) = period;
> +
> +	nego = mptspi_getRP(starget);
> +
> +	pg1.RequestedParameters = cpu_to_le32(nego);
> +	pg1.Reserved = 0;
> +	pg1.Configuration = 0;
> +
> +	mptspi_write_page1(starget, &pg1);
> +}
> +
> +static void mptspi_write_dt(struct scsi_target *starget, int dt)
> +{
> +	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
> +	u32 nego;
> +
> +	if (spi_period(starget) == -1)
> +		mptspi_read_parameters(starget);
> +
> +	if (!dt && spi_period(starget) < 10)
> +		spi_period(starget) = 10;
> +
> +	spi_dt(starget) = dt;
> +
> +	nego = mptspi_getRP(starget);
> +
> +	
> +	pg1.RequestedParameters = cpu_to_le32(nego);
> +	pg1.Reserved = 0;
> +	pg1.Configuration = 0;
> +
> +	mptspi_write_page1(starget, &pg1);
> +}
> +
> +static void mptspi_write_iu(struct scsi_target *starget, int iu)
> +{
> +	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
> +	u32 nego;
> +
> +	if (spi_period(starget) == -1)
> +		mptspi_read_parameters(starget);
> +
> +	if (!iu && spi_period(starget) < 9)
> +		spi_period(starget) = 9;
> +
> +	spi_iu(starget) = iu;
> +
> +	nego = mptspi_getRP(starget);
> +
> +	
> +	pg1.RequestedParameters = cpu_to_le32(nego);
> +	pg1.Reserved = 0;
> +	pg1.Configuration = 0;
> +
> +	mptspi_write_page1(starget, &pg1);
> +}
> +
> +static void mptspi_write_qas(struct scsi_target *starget, int qas)
> +{
> +	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
> +	u32 nego;
> +
> +	spi_qas(starget) = qas;
> +
> +	nego = mptspi_getRP(starget);
> +	
> +	pg1.RequestedParameters = cpu_to_le32(nego);
> +	pg1.Reserved = 0;
> +	pg1.Configuration = 0;
> +
> +	mptspi_write_page1(starget, &pg1);
> +}
> +
> +static void mptspi_write_width(struct scsi_target *starget, 
> int width)
> +{
> +	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
> +	u32 nego;
> +
> +	if (!width) {
> +		spi_dt(starget) = 0;
> +		if (spi_period(starget) < 10)
> +			spi_period(starget) = 10;
> +	}
> +
> +	spi_width(starget) = width;
> +
> +	nego = mptspi_getRP(starget);
> +	
> +	pg1.RequestedParameters = cpu_to_le32(nego);
> +	pg1.Reserved = 0;
> +	pg1.Configuration = 0;
> +
> +	mptspi_write_page1(starget, &pg1);
> +}
> +
> +static struct spi_function_template mptspi_transport_functions = {
> +	.get_offset	= mptspi_read_parameters,
> +	.set_offset	= mptspi_write_offset,
> +	.show_offset	= 1,
> +	.get_period	= mptspi_read_parameters,
> +	.set_period	= mptspi_write_period,
> +	.show_period	= 1,
> +	.get_width	= mptspi_read_parameters,
> +	.set_width	= mptspi_write_width,
> +	.show_width	= 1,
> +	.get_iu		= mptspi_read_parameters,
> +	.set_iu		= mptspi_write_iu,
> +	.show_iu	= 1,
> +	.get_dt		= mptspi_read_parameters,
> +	.set_dt		= mptspi_write_dt,
> +	.show_dt	= 1,
> +	.get_qas	= mptspi_read_parameters,
> +	.set_qas	= mptspi_write_qas,
> +	.show_qas	= 1,
> +	.get_wr_flow	= mptspi_read_parameters,
> +	.show_wr_flow	= 1,
> +	.get_rd_strm	= mptspi_read_parameters,
> +	.show_rd_strm	= 1,
> +	.get_rti	= mptspi_read_parameters,
> +	.show_rti	= 1,
> +	.get_pcomp_en	= mptspi_read_parameters,
> +	.show_pcomp_en	= 1,
> +};
> +
>  
>  
> /*************************************************************
> ***************
>   * Supported hardware
> @@ -382,7 +748,6 @@ mptspi_probe(struct pci_dev *pdev, const
>  		mpt_saf_te,
>  		mpt_pq_filter));
>  #endif
> -
>  	ioc->spi_data.forceDv = 0;
>  	ioc->spi_data.noQas = 0;
>  
> @@ -398,6 +763,11 @@ mptspi_probe(struct pci_dev *pdev, const
>  	hd->scandv_wait_done = 0;
>  	hd->last_queue_full = 0;
>  
> +	/* Some versions of the firmware don't support page 0; without
> +	 * that we can't get the parameters */
> +	if (hd->ioc->spi_data.sdp0length != 0)
> +		sh->transportt = mptspi_transport_template;
> +
>  	error = scsi_add_host (sh, &ioc->pcidev->dev);
>  	if(error) {
>  		dprintk((KERN_ERR MYNAM
> @@ -441,6 +811,10 @@ mptspi_init(void)
>  
>  	show_mptmod_ver(my_NAME, my_VERSION);
>  
> +	mptspi_transport_template = 
> spi_attach_transport(&mptspi_transport_functions);
> +	if (!mptspi_transport_template)
> +		return -ENODEV;
> +
>  	mptspiDoneCtx = mpt_register(mptscsih_io_done, MPTSPI_DRIVER);
>  	mptspiTaskCtx = 
> mpt_register(mptscsih_taskmgmt_complete, MPTSPI_DRIVER);
>  	mptspiInternalCtx = 
> mpt_register(mptscsih_scandv_complete, MPTSPI_DRIVER);
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
