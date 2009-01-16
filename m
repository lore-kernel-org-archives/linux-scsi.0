From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
Date: Fri, 16 Jan 2009 13:48:53 -0500
Message-ID: <1232131733.3224.46.camel@localhost.localdomain>
References: <1232117771.3224.21.camel@localhost.localdomain>
	 <20090116090928.e43c986e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52281 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936763AbZAPSs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 13:48:57 -0500
In-Reply-To: <20090116090928.e43c986e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, 2009-01-16 at 09:09 -0800, Andrew Morton wrote:
> On Fri, 16 Jan 2009 09:56:11 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > This is acutally four bug fixes and part of a fusion update which was a
> > bit late processing through the merge window, but which should be
> > perfectly acceptable for -rc1.
> > 
> > ...
> >
> > Full diff below.
> 
> I like full diffs.
>  
> > --- a/drivers/message/fusion/mptbase.c
> > +++ b/drivers/message/fusion/mptbase.c
> > @@ -79,9 +79,22 @@ MODULE_VERSION(my_VERSION);
> >  /*
> >   *  cmd line parameters
> >   */
> > -static int mpt_msi_enable = -1;
> > -module_param(mpt_msi_enable, int, 0);
> > -MODULE_PARM_DESC(mpt_msi_enable, " MSI Support Enable (default=0)");
> > +
> > +static int mpt_msi_enable_spi;
> > +module_param(mpt_msi_enable_spi, int, 0);
> > +MODULE_PARM_DESC(mpt_msi_enable_spi, " Enable MSI Support for SPI \
> > +		controllers (default=0)");
> > +
> > +static int mpt_msi_enable_fc;
> > +module_param(mpt_msi_enable_fc, int, 0);
> > +MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
> > +		controllers (default=0)");
> > +
> > +static int mpt_msi_enable_sas;
> > +module_param(mpt_msi_enable_sas, int, 1);
> > +MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
> > +		controllers (default=1)");
> > +
> > 
> > ...
> 
> Those MODULE_PARM_DESC strings are going to come out funny-looking,
> with extra tabs and stuff.

Yes ... the compiler complained about a few of the other updates, which
I told them to redo ... I didn't notice these.

> > +MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h \
> > +	- (default=0)");
> > +
> > +int mpt_fwfault_debug;
> > +EXPORT_SYMBOL(mpt_fwfault_debug);
> > +module_param_call(mpt_fwfault_debug, param_set_int, param_get_int,
> > +	  &mpt_fwfault_debug, 0600);
> > +MODULE_PARM_DESC(mpt_fwfault_debug, "Enable detection of Firmware fault"
> > +	" and halt Firmware on fault - (default=0)");
> 
> That one got it right.
> 
> >  
> >  #ifdef MFCNT
> >  static int mfcounter = 0;
> > @@ -1751,16 +1774,25 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
> >  		ioc->bus_type = SAS;
> >  	}
> >  
> > -	if (mpt_msi_enable == -1) {
> > -		/* Enable on SAS, disable on FC and SPI */
> > -		if (ioc->bus_type == SAS)
> > -			ioc->msi_enable = 1;
> > -		else
> > -			ioc->msi_enable = 0;
> > -	} else
> > -		/* follow flag: 0 - disable; 1 - enable */
> > -		ioc->msi_enable = mpt_msi_enable;
> >  
> > +	switch (ioc->bus_type) {
> > +
> > +	case SAS:
> > +		ioc->msi_enable = mpt_msi_enable_sas;
> > +		break;
> > +
> > +	case SPI:
> > +		ioc->msi_enable = mpt_msi_enable_spi;
> > +		break;
> > +
> > +	case FC:
> > +		ioc->msi_enable = mpt_msi_enable_fc;
> > +		break;
> > +
> > +	default:
> > +		ioc->msi_enable = 0;
> > +		break;
> > +	}
> >  	if (ioc->errata_flag_1064)
> >  		pci_disable_io_access(pdev);
> >  
> > @@ -6313,6 +6345,33 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buffer, int *size, int len, int sh
> >  	*size = y;
> >  }
> >  
> > +
> > +/**
> > + *	mpt_halt_firmware - Halts the firmware if it is operational and panic
> > + *	the kernel
> > + *	@ioc: Pointer to MPT_ADAPTER structure
> > + *
> > + **/
> > +void
> > +mpt_halt_firmware(MPT_ADAPTER *ioc)
> > +{
> > +	u32	 ioc_raw_state;
> > +
> > +	ioc_raw_state = mpt_GetIocState(ioc, 0);
> > +
> > +	if ((ioc_raw_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_FAULT) {
> > +		printk(MYIOC_s_ERR_FMT "IOC is in FAULT state (%04xh)!!!\n",
> > +			ioc->name, ioc_raw_state & MPI_DOORBELL_DATA_MASK);
> > +		panic("%s: IOC Fault (%04xh)!!!\n", ioc->name,
> > +			ioc_raw_state & MPI_DOORBELL_DATA_MASK);
> > +	} else {
> > +		CHIPREG_WRITE32(&ioc->chip->Doorbell, 0xC0FFEE00);
> > +		panic("%s: Firmware is halted due to command timeout\n",
> > +			ioc->name);
> > +	}
> > +}
> > +EXPORT_SYMBOL(mpt_halt_firmware);
> 
> Doing a panic() after we've already detected an error is plain nasty. 
> Is there no way in which we can allow the kernel to continue?

There's a long thread discussing this very point on linux-scsi.  The
short version is "no, it's only used for debugging firmware and if
you've corrupted your firmware to this point you need the machine
halting".

> 
> >  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> >  /*
> >   *	Reset Handling
> > @@ -6345,6 +6404,8 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
> >  	printk(MYIOC_s_INFO_FMT "HardResetHandler Entered!\n", ioc->name);
> >  	printk("MF count 0x%x !\n", ioc->mfcnt);
> >  #endif
> > +	if (mpt_fwfault_debug)
> > +		mpt_halt_firmware(ioc);
> >  
> >  	/* Reset the adapter. Prevent more than 1 call to
> >  	 * mpt_do_ioc_recovery at any instant in time.
> > diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
> > index dff048c..b3e981d 100644
> > --- a/drivers/message/fusion/mptbase.h
> > +++ b/drivers/message/fusion/mptbase.h
> > @@ -922,11 +922,14 @@ extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
> >  extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
> >  extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
> >  extern int	 mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num, pRaidPhysDiskPage0_t phys_disk);
> > +extern void     mpt_halt_firmware(MPT_ADAPTER *ioc);
> > +
> >  
> >  /*
> >   *  Public data decl's...
> >   */
> >  extern struct list_head	  ioc_list;
> > +extern int mpt_fwfault_debug;
> >  
> >  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> >  #endif		/* } __KERNEL__ */
> > diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> > index ee09041..e62c6bc 100644
> > --- a/drivers/message/fusion/mptscsih.c
> > +++ b/drivers/message/fusion/mptscsih.c
> > @@ -1846,6 +1846,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
> >  	if (hd->timeouts < -1)
> >  		hd->timeouts++;
> >  
> > +	if (mpt_fwfault_debug)
> > +		mpt_halt_firmware(ioc);
> 
> So one single global flag affects all controllers in the system?
> 
> I guess that's OK if it's just a debug/diag thing.

Yes, that's correct.

> >  	/* Most important!  Set TaskMsgContext to SCpnt's MsgContext!
> >  	 * (the IO to be ABORT'd)
> >  	 *
> > diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> > index a745f91..e7705d3 100644
> > --- a/drivers/scsi/libiscsi_tcp.c
> > +++ b/drivers/scsi/libiscsi_tcp.c
> > @@ -177,7 +177,6 @@ int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
> >  			   struct iscsi_segment *segment, int recv,
> >  			   unsigned copied)
> >  {
> > -	static unsigned char padbuf[ISCSI_PAD_LEN];
> >  	struct scatterlist sg;
> >  	unsigned int pad;
> >  
> > @@ -233,7 +232,7 @@ int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
> >  			debug_tcp("consume %d pad bytes\n", pad);
> >  			segment->total_size += pad;
> >  			segment->size = pad;
> > -			segment->data = padbuf;
> > +			segment->data = segment->padbuf;
> >  			return 0;
> >  		}
> >  	}
> > diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> > index 2d4f32b..9ad4d09 100644
> > --- a/drivers/scsi/qla2xxx/qla_init.c
> > +++ b/drivers/scsi/qla2xxx/qla_init.c
> > @@ -1258,35 +1258,48 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
> >  {
> >  	int	rval;
> >  	unsigned long flags = 0;
> > -	int cnt;
> > +	int cnt, que;
> >  	struct qla_hw_data *ha = vha->hw;
> > -	struct req_que *req = ha->req_q_map[0];
> > -	struct rsp_que *rsp = ha->rsp_q_map[0];
> > +	struct req_que *req;
> > +	struct rsp_que *rsp;
> > +	struct scsi_qla_host *vp;
> >  	struct mid_init_cb_24xx *mid_init_cb =
> >  	    (struct mid_init_cb_24xx *) ha->init_cb;
> 
> This cast worries me.  It's a cast between two complex data structures
> which appear to have nothing to do with each other.

Actually, it's a C++ type construct.  ha->init_cb is of type init_cb_t,
mid_init_cb actually contains this (via a second indirection) as the
first element, so what it's doing is dynamically casting out based on
the board type.

> Oh well.  It _is_ a scsi driver :(

James


