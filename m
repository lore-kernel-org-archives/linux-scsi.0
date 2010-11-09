From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC PATCH] SCSI host lock push-down
Date: Mon, 08 Nov 2010 17:28:29 -0800
Message-ID: <1289266109.27226.154.camel@haakon2.linux-iscsi.org>
References: <20101105002409.GA21714@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20101105002409.GA21714@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <openosd@gmail.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-11-04 at 20:24 -0400, Jeff Garzik wrote:
> There were some previous attempts to push the SCSI host lock down
> into each driver.  In both cases, authors working independently of
> each other managed to both (a) skip some drivers that need updates, and,
> (b) get the locking wrong in some cases and/or rewrite the locking.
> 
> The patch below presents a simple SCSI host lock push-down as an
> equivalent transformation.  No locking or other behavior should change
> with this patch.  All existing bugs and locking orders are preserved.
> 
> Minimal code disturbance was attempted with this change.  Most drivers
> needed only two one-line modifications for their host lock push-down.
> 
> An alternate arrangement, not presented by this patch, might
> be preferred:  in order to make it clear that queuecommand
> locking has changed, one could s/queuecommand/queuecommand_nl/ in
> Scsi_Host_Template, in order to guarantee that drivers are either
> (a) upgraded or (b) broken at compile time.  Compile-time detection of
> new locking may be desirable, and I'll volunteer to change my patch to
> do that, if community members prefer that route instead of below.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Hi Jeff,

Many thanks for jumping on this one and being the first to produce a
functionally correct 'push-down' series.  ;)  I started in on this on
this conversion last week, but unfortuately did not make it all the way
through as the seasonal flu cut my efforts short.

In any event, I will start rebasing my lock-less efforts upon your patch
and add the extras currently existing in
lio-4.0.git/host_lock-less-for-37-v10 on top of this patch.  This
includes the atomic_t for per host serial counter patch and to enable
those LLDs that have gotten maintainer ACKs, or that we think should be
OK (and has had some testing) to function in lockless mode by default.

As I still have my hands full w/ TCM items atm, this is going to take a
few days to respin a patch nut I will aim to get my own lock-less
development VMs converted to running this code by the end of the week /
as the remaining TODO items for TCM v4.0 are addressed.

Thank you!

--nab

> ---
>  arch/ia64/hp/sim/simscsi.c            |    4 +++-
>  drivers/ata/libata-scsi.c             |    4 +++-
>  drivers/block/cciss_scsi.c            |    4 +++-
>  drivers/firewire/sbp2.c               |    4 +++-
>  drivers/infiniband/ulp/srp/ib_srp.c   |    4 +++-
>  drivers/message/fusion/mptfc.c        |    4 +++-
>  drivers/message/fusion/mptsas.c       |    4 +++-
>  drivers/message/fusion/mptspi.c       |    4 +++-
>  drivers/message/i2o/i2o_scsi.c        |    6 ++++--
>  drivers/s390/scsi/zfcp_scsi.c         |    4 +++-
>  drivers/scsi/3w-9xxx.c                |    4 +++-
>  drivers/scsi/3w-sas.c                 |    4 +++-
>  drivers/scsi/3w-xxxx.c                |    4 +++-
>  drivers/scsi/53c700.c                 |    6 ++++--
>  drivers/scsi/BusLogic.c               |    3 ++-
>  drivers/scsi/NCR5380.c                |    3 ++-
>  drivers/scsi/NCR53c406a.c             |    4 +++-
>  drivers/scsi/a100u2w.c                |    4 +++-
>  drivers/scsi/aacraid/linit.c          |    4 +++-
>  drivers/scsi/advansys.c               |    4 +++-
>  drivers/scsi/aha152x.c                |    4 +++-
>  drivers/scsi/aha1542.c                |    4 +++-
>  drivers/scsi/aha1740.c                |    4 +++-
>  drivers/scsi/aic7xxx/aic79xx_osm.c    |    4 +++-
>  drivers/scsi/aic7xxx/aic7xxx_osm.c    |    4 +++-
>  drivers/scsi/aic7xxx_old.c            |    4 +++-
>  drivers/scsi/arcmsr/arcmsr_hba.c      |    4 +++-
>  drivers/scsi/arm/acornscsi.c          |    4 +++-
>  drivers/scsi/arm/fas216.c             |    8 ++++++--
>  drivers/scsi/atari_NCR5380.c          |    4 +++-
>  drivers/scsi/atp870u.c                |    4 +++-
>  drivers/scsi/bfa/bfad_im.c            |    4 +++-
>  drivers/scsi/dc395x.c                 |    3 ++-
>  drivers/scsi/dpt_i2o.c                |    4 +++-
>  drivers/scsi/eata.c                   |    4 +++-
>  drivers/scsi/eata_pio.c               |    4 +++-
>  drivers/scsi/esp_scsi.c               |    4 +++-
>  drivers/scsi/fd_mcs.c                 |    4 +++-
>  drivers/scsi/fdomain.c                |    4 +++-
>  drivers/scsi/fnic/fnic_scsi.c         |    4 +++-
>  drivers/scsi/gdth.c                   |    4 +++-
>  drivers/scsi/hpsa.c                   |    4 +++-
>  drivers/scsi/hptiop.c                 |    4 +++-
>  drivers/scsi/ibmmca.c                 |    4 +++-
>  drivers/scsi/ibmvscsi/ibmvfc.c        |    4 +++-
>  drivers/scsi/ibmvscsi/ibmvscsi.c      |    4 +++-
>  drivers/scsi/imm.c                    |    4 +++-
>  drivers/scsi/in2000.c                 |    4 +++-
>  drivers/scsi/initio.c                 |    4 +++-
>  drivers/scsi/ipr.c                    |    4 +++-
>  drivers/scsi/ips.c                    |    4 +++-
>  drivers/scsi/libfc/fc_fcp.c           |    4 +++-
>  drivers/scsi/libiscsi.c               |    4 +++-
>  drivers/scsi/libsas/sas_scsi_host.c   |    4 +++-
>  drivers/scsi/lpfc/lpfc_scsi.c         |    4 +++-
>  drivers/scsi/mac53c94.c               |    4 +++-
>  drivers/scsi/megaraid.c               |    4 +++-
>  drivers/scsi/megaraid/megaraid_mbox.c |    4 +++-
>  drivers/scsi/megaraid/megaraid_sas.c  |    4 +++-
>  drivers/scsi/mesh.c                   |    4 +++-
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c  |    4 +++-
>  drivers/scsi/ncr53c8xx.c              |    4 +++-
>  drivers/scsi/nsp32.c                  |    4 +++-
>  drivers/scsi/pcmcia/nsp_cs.c          |    4 +++-
>  drivers/scsi/pcmcia/sym53c500_cs.c    |    4 +++-
>  drivers/scsi/pmcraid.c                |    4 +++-
>  drivers/scsi/ppa.c                    |    4 +++-
>  drivers/scsi/ps3rom.c                 |    4 +++-
>  drivers/scsi/qla1280.c                |    4 +++-
>  drivers/scsi/qla2xxx/qla_os.c         |    4 +++-
>  drivers/scsi/qla4xxx/ql4_os.c         |    4 +++-
>  drivers/scsi/qlogicfas408.c           |    4 +++-
>  drivers/scsi/qlogicpti.c              |    4 +++-
>  drivers/scsi/scsi.c                   |   15 +++------------
>  drivers/scsi/scsi_debug.c             |    4 +++-
>  drivers/scsi/scsi_error.c             |    3 ---
>  drivers/scsi/stex.c                   |    4 +++-
>  drivers/scsi/sun3_NCR5380.c           |    4 +++-
>  drivers/scsi/sym53c416.c              |    4 +++-
>  drivers/scsi/sym53c8xx_2/sym_glue.c   |    4 +++-
>  drivers/scsi/tmscsim.c                |    4 +++-
>  drivers/scsi/u14-34f.c                |    4 +++-
>  drivers/scsi/ultrastor.c              |    4 +++-
>  drivers/scsi/vmw_pvscsi.c             |    4 +++-
>  drivers/scsi/wd33c93.c                |    6 ++++--
>  drivers/scsi/wd7000.c                 |    4 +++-
>  drivers/staging/hv/storvsc_drv.c      |    4 +++-
>  drivers/staging/keucr/scsiglue.c      |    4 +++-
>  drivers/usb/image/microtek.c          |    4 +++-
>  drivers/usb/storage/scsiglue.c        |    4 +++-
>  drivers/usb/storage/uas.c             |    4 +++-
>  include/scsi/scsi_host.h              |   16 ++++++++++++++++
>  92 files changed, 289 insertions(+), 108 deletions(-)
> 
> diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
> index 3a078ad..331de72 100644
> --- a/arch/ia64/hp/sim/simscsi.c
> +++ b/arch/ia64/hp/sim/simscsi.c
> @@ -202,7 +202,7 @@ simscsi_readwrite10 (struct scsi_cmnd *sc, int mode)
>  }
>  
>  static int
> -simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
> +simscsi_queuecommand_lck (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
>  {
>  	unsigned int target_id = sc->device->id;
>  	char fname[MAX_ROOT_LEN+16];
> @@ -326,6 +326,8 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(simscsi_queuecommand)
> +
>  static int
>  simscsi_host_reset (struct scsi_cmnd *sc)
>  {
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index d050e07..a007c36 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3180,7 +3180,7 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
>   *	Return value from __ata_scsi_queuecmd() if @cmd can be queued,
>   *	0 otherwise.
>   */
> -int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +static int ata_scsi_queuecmd_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct ata_port *ap;
>  	struct ata_device *dev;
> @@ -3208,6 +3208,8 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  	return rc;
>  }
>  
> +DEF_SCSI_QCMD(ata_scsi_queuecmd)
> +
>  /**
>   *	ata_scsi_simulate - simulate SCSI command on ATA device
>   *	@dev: the target device
> diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> index 575495f..4bfec0a 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -1406,7 +1406,7 @@ static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *c,
>  
> 
>  static int
> -cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
> +cciss_scsi_queue_command_lck (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
>  {
>  	ctlr_info_t *h;
>  	int rc;
> @@ -1504,6 +1504,8 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(cciss_scsi_queue_command)
> +
>  static void cciss_unregister_scsi(ctlr_info_t *h)
>  {
>  	struct cciss_scsi_adapter_data_t *sa;
> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
> index bfae4b3..afa576a 100644
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -1468,7 +1468,7 @@ static int sbp2_map_scatterlist(struct sbp2_command_orb *orb,
>  
>  /* SCSI stack integration */
>  
> -static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
> +static int sbp2_scsi_queuecommand_lck(struct scsi_cmnd *cmd, scsi_done_fn_t done)
>  {
>  	struct sbp2_logical_unit *lu = cmd->device->hostdata;
>  	struct fw_device *device = target_device(lu->tgt);
> @@ -1534,6 +1534,8 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
>  	return retval;
>  }
>  
> +static DEF_SCSI_QCMD(sbp2_scsi_queuecommand)
> +
>  static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
>  {
>  	struct sbp2_logical_unit *lu = sdev->hostdata;
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index cfc1d65..1e1e347 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1123,7 +1123,7 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
>  	}
>  }
>  
> -static int srp_queuecommand(struct scsi_cmnd *scmnd,
> +static int srp_queuecommand_lck(struct scsi_cmnd *scmnd,
>  			    void (*done)(struct scsi_cmnd *))
>  {
>  	struct srp_target_port *target = host_to_target(scmnd->device->host);
> @@ -1196,6 +1196,8 @@ err:
>  	return SCSI_MLQUEUE_HOST_BUSY;
>  }
>  
> +static DEF_SCSI_QCMD(srp_queuecommand)
> +
>  static int srp_alloc_iu_bufs(struct srp_target_port *target)
>  {
>  	int i;
> diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
> index e15220f..1c81a6f 100644
> --- a/drivers/message/fusion/mptfc.c
> +++ b/drivers/message/fusion/mptfc.c
> @@ -650,7 +650,7 @@ mptfc_slave_alloc(struct scsi_device *sdev)
>  }
>  
>  static int
> -mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
> +mptfc_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  {
>  	struct mptfc_rport_info	*ri;
>  	struct fc_rport	*rport = starget_to_rport(scsi_target(SCpnt->device));
> @@ -681,6 +681,8 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  	return mptscsih_qcmd(SCpnt,done);
>  }
>  
> +static DEF_SCSI_QCMD(mptfc_qcmd)
> +
>  /*
>   *	mptfc_display_port_link_speed - displaying link speed
>   *	@ioc: Pointer to MPT_ADAPTER structure
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index 83a5115..d48c2c6 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -1889,7 +1889,7 @@ mptsas_slave_alloc(struct scsi_device *sdev)
>  }
>  
>  static int
> -mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
> +mptsas_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  {
>  	MPT_SCSI_HOST	*hd;
>  	MPT_ADAPTER	*ioc;
> @@ -1913,6 +1913,8 @@ mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  	return mptscsih_qcmd(SCpnt,done);
>  }
>  
> +static DEF_SCSI_QCMD(mptsas_qcmd)
> +
>  /**
>   *	mptsas_mptsas_eh_timed_out - resets the scsi_cmnd timeout
>   *		if the device under question is currently in the
> diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
> index 0e28031..6d9568d 100644
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -780,7 +780,7 @@ static int mptspi_slave_configure(struct scsi_device *sdev)
>  }
>  
>  static int
> -mptspi_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
> +mptspi_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  {
>  	struct _MPT_SCSI_HOST *hd = shost_priv(SCpnt->device->host);
>  	VirtDevice	*vdevice = SCpnt->device->hostdata;
> @@ -805,6 +805,8 @@ mptspi_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  	return mptscsih_qcmd(SCpnt,done);
>  }
>  
> +static DEF_SCSI_QCMD(mptspi_qcmd)
> +
>  static void mptspi_slave_destroy(struct scsi_device *sdev)
>  {
>  	struct scsi_target *starget = scsi_target(sdev);
> diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
> index ea6b219..97bdf82 100644
> --- a/drivers/message/i2o/i2o_scsi.c
> +++ b/drivers/message/i2o/i2o_scsi.c
> @@ -506,7 +506,7 @@ static struct i2o_driver i2o_scsi_driver = {
>   *	Locks: takes the controller lock on error path only
>   */
>  
> -static int i2o_scsi_queuecommand(struct scsi_cmnd *SCpnt,
> +static int i2o_scsi_queuecommand_lck(struct scsi_cmnd *SCpnt,
>  				 void (*done) (struct scsi_cmnd *))
>  {
>  	struct i2o_controller *c;
> @@ -688,7 +688,9 @@ static int i2o_scsi_queuecommand(struct scsi_cmnd *SCpnt,
>  
>        exit:
>  	return rc;
> -};
> +}
> +
> +static DEF_SCSI_QCMD(i2o_scsi_queuecommand)
>  
>  /**
>   *	i2o_scsi_abort - abort a running command
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 50286d8..6bd2dbc 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -76,7 +76,7 @@ static void zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
>  	scpnt->scsi_done(scpnt);
>  }
>  
> -static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
> +static int zfcp_scsi_queuecommand_lck(struct scsi_cmnd *scpnt,
>  				  void (*done) (struct scsi_cmnd *))
>  {
>  	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
> @@ -127,6 +127,8 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
>  	return ret;
>  }
>  
> +static DEF_SCSI_QCMD(zfcp_scsi_queuecommand)
> +
>  static int zfcp_scsi_slave_alloc(struct scsi_device *sdev)
>  {
>  	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index fcf08b3..b7bd5b0 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1765,7 +1765,7 @@ out:
>  } /* End twa_scsi_eh_reset() */
>  
>  /* This is the main scsi queue function to handle scsi opcodes */
> -static int twa_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
> +static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  {
>  	int request_id, retval;
>  	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> @@ -1812,6 +1812,8 @@ out:
>  	return retval;
>  } /* End twa_scsi_queue() */
>  
> +static DEF_SCSI_QCMD(twa_scsi_queue)
> +
>  /* This function hands scsi cdb's to the firmware */
>  static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id, char *cdb, int use_sg, TW_SG_Entry *sglistarg)
>  {
> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index 6a95d11..13e39e1 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -1501,7 +1501,7 @@ out:
>  } /* End twl_scsi_eh_reset() */
>  
>  /* This is the main scsi queue function to handle scsi opcodes */
> -static int twl_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
> +static int twl_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  {
>  	int request_id, retval;
>  	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> @@ -1536,6 +1536,8 @@ out:
>  	return retval;
>  } /* End twl_scsi_queue() */
>  
> +static DEF_SCSI_QCMD(twl_scsi_queue)
> +
>  /* This function tells the controller to shut down */
>  static void __twl_shutdown(TW_Device_Extension *tw_dev)
>  {
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index b112534..64bd7c5 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -1947,7 +1947,7 @@ static int tw_scsiop_test_unit_ready_complete(TW_Device_Extension *tw_dev, int r
>  } /* End tw_scsiop_test_unit_ready_complete() */
>  
>  /* This is the main scsi queue function to handle scsi opcodes */
> -static int tw_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *)) 
> +static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *)) 
>  {
>  	unsigned char *command = SCpnt->cmnd;
>  	int request_id = 0;
> @@ -2023,6 +2023,8 @@ static int tw_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
>  	return retval;
>  } /* End tw_scsi_queue() */
>  
> +static DEF_SCSI_QCMD(tw_scsi_queue)
> +
>  /* This function is the interrupt service routine */
>  static irqreturn_t tw_interrupt(int irq, void *dev_instance) 
>  {
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index 89fc1c8..12a1301 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -1749,8 +1749,8 @@ NCR_700_intr(int irq, void *dev_id)
>  	return IRQ_RETVAL(handled);
>  }
>  
> -STATIC int
> -NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
> +static int
> +NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
>  {
>  	struct NCR_700_Host_Parameters *hostdata = 
>  		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
> @@ -1904,6 +1904,8 @@ NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
>  	return 0;
>  }
>  
> +STATIC DEF_SCSI_QCMD(NCR_700_queuecommand)
> +
>  STATIC int
>  NCR_700_abort(struct scsi_cmnd * SCp)
>  {
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index fc0b4b8..f66c33b 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2807,7 +2807,7 @@ static int BusLogic_host_reset(struct scsi_cmnd * SCpnt)
>    Outgoing Mailbox for execution by the associated Host Adapter.
>  */
>  
> -static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRoutine) (struct scsi_cmnd *))
> +static int BusLogic_QueueCommand_lck(struct scsi_cmnd *Command, void (*CompletionRoutine) (struct scsi_cmnd *))
>  {
>  	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Command->device->host->hostdata;
>  	struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[Command->device->id];
> @@ -2994,6 +2994,7 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(BusLogic_QueueCommand)
>  
>  #if 0
>  /*
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 5d2f148..fe0d740 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -952,7 +952,7 @@ static void NCR5380_exit(struct Scsi_Host *instance)
>   *	Locks: host lock taken by caller
>   */
>  
> -static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *)) 
> +static int NCR5380_queue_command_lck(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *)) 
>  {
>  	struct Scsi_Host *instance = cmd->device->host;
>  	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
> @@ -1021,6 +1021,7 @@ static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(NCR5380_queue_command)
>  
>  /**
>   *	NCR5380_main	-	NCR state machines
> diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
> index 6961f78..c91888a 100644
> --- a/drivers/scsi/NCR53c406a.c
> +++ b/drivers/scsi/NCR53c406a.c
> @@ -693,7 +693,7 @@ static void wait_intr(void)
>  }
>  #endif
>  
> -static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
> +static int NCR53c406a_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
>  {
>  	int i;
>  
> @@ -726,6 +726,8 @@ static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(NCR53c406a_queue)
> +
>  static int NCR53c406a_host_reset(Scsi_Cmnd * SCpnt)
>  {
>  	DEB(printk("NCR53c406a_reset called\n"));
> diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
> index dbbc601..dc5ac6e 100644
> --- a/drivers/scsi/a100u2w.c
> +++ b/drivers/scsi/a100u2w.c
> @@ -911,7 +911,7 @@ static int inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struc
>   *	queue the command down to the controller
>   */
>  
> -static int inia100_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
> +static int inia100_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
>  {
>  	struct orc_scb *scb;
>  	struct orc_host *host;		/* Point to Host adapter control block */
> @@ -930,6 +930,8 @@ static int inia100_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(inia100_queue)
> +
>  /*****************************************************************************
>   Function name  : inia100_abort
>   Description    : Abort a queued command.
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 29c0ed1..2c93d94 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -248,7 +248,7 @@ static struct aac_driver_ident aac_drivers[] = {
>   *	TODO: unify with aac_scsi_cmd().
>   */
>  
> -static int aac_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +static int aac_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct Scsi_Host *host = cmd->device->host;
>  	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
> @@ -267,6 +267,8 @@ static int aac_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
>  	return (aac_scsi_cmd(cmd) ? FAILED : 0);
>  }
>  
> +static DEF_SCSI_QCMD(aac_queuecommand)
> +
>  /**
>   *	aac_info		-	Returns the host adapter name
>   *	@shost:		Scsi host to report on
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 0ec3da6..081c6de 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -9500,7 +9500,7 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
>   * in the 'scp' result field.
>   */
>  static int
> -advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
> +advansys_queuecommand_lck(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
>  {
>  	struct Scsi_Host *shost = scp->device->host;
>  	int asc_res, result = 0;
> @@ -9525,6 +9525,8 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
>  	return result;
>  }
>  
> +static DEF_SCSI_QCMD(advansys_queuecommand)
> +
>  static ushort __devinit AscGetEisaChipCfg(PortAddr iop_base)
>  {
>  	PortAddr eisa_cfg_iop = (PortAddr) ASC_GET_EISA_SLOT(iop_base) |
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index 8eab858..c5169f0 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -1056,7 +1056,7 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
>   *  queue a command
>   *
>   */
> -static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
> +static int aha152x_queue_lck(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
>  {
>  #if 0
>  	if(*SCpnt->cmnd == REQUEST_SENSE) {
> @@ -1070,6 +1070,8 @@ static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
>  	return aha152x_internal_queue(SCpnt, NULL, 0, done);
>  }
>  
> +static DEF_SCSI_QCMD(aha152x_queue)
> +
>  
>  /*
>   *  
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index 4f785f2..195823a 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -558,7 +558,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
>  	};
>  }
>  
> -static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
> +static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
>  {
>  	unchar ahacmd = CMD_START_SCSI;
>  	unchar direction;
> @@ -718,6 +718,8 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(aha1542_queuecommand)
> +
>  /* Initialize mailboxes */
>  static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
>  {
> diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
> index 0107a4c..d058f1a 100644
> --- a/drivers/scsi/aha1740.c
> +++ b/drivers/scsi/aha1740.c
> @@ -331,7 +331,7 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
>  	return IRQ_RETVAL(handled);
>  }
>  
> -static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
> +static int aha1740_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
>  {
>  	unchar direction;
>  	unchar *cmd = (unchar *) SCpnt->cmnd;
> @@ -503,6 +503,8 @@ static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(aha1740_queuecommand)
> +
>  /* Query the board for its irq_level and irq_type.  Nothing else matters
>     in enhanced mode on an EISA bus. */
>  
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index 88ad848..25d0666 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -573,7 +573,7 @@ ahd_linux_info(struct Scsi_Host *host)
>   * Queue an SCB to the controller.
>   */
>  static int
> -ahd_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
> +ahd_linux_queue_lck(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
>  {
>  	struct	 ahd_softc *ahd;
>  	struct	 ahd_linux_device *dev = scsi_transport_device_data(cmd->device);
> @@ -588,6 +588,8 @@ ahd_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
>  	return rtn;
>  }
>  
> +static DEF_SCSI_QCMD(ahd_linux_queue)
> +
>  static struct scsi_target **
>  ahd_linux_target_in_softc(struct scsi_target *starget)
>  {
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index aeea7a6..4a359bb 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -528,7 +528,7 @@ ahc_linux_info(struct Scsi_Host *host)
>   * Queue an SCB to the controller.
>   */
>  static int
> -ahc_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
> +ahc_linux_queue_lck(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
>  {
>  	struct	 ahc_softc *ahc;
>  	struct	 ahc_linux_device *dev = scsi_transport_device_data(cmd->device);
> @@ -548,6 +548,8 @@ ahc_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
>  	return rtn;
>  }
>  
> +static DEF_SCSI_QCMD(ahc_linux_queue)
> +
>  static inline struct scsi_target **
>  ahc_linux_target_in_softc(struct scsi_target *starget)
>  {
> diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
> index aee73fa..4ff60a0 100644
> --- a/drivers/scsi/aic7xxx_old.c
> +++ b/drivers/scsi/aic7xxx_old.c
> @@ -10234,7 +10234,7 @@ static void aic7xxx_buildscb(struct aic7xxx_host *p, struct scsi_cmnd *cmd,
>   * Description:
>   *   Queue a SCB to the controller.
>   *-F*************************************************************************/
> -static int aic7xxx_queue(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
> +static int aic7xxx_queue_lck(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
>  {
>    struct aic7xxx_host *p;
>    struct aic7xxx_scb *scb;
> @@ -10292,6 +10292,8 @@ static int aic7xxx_queue(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
>    return (0);
>  }
>  
> +static DEF_SCSI_QCMD(aic7xxx_queue)
> +
>  /*+F*************************************************************************
>   * Function:
>   *   aic7xxx_bus_device_reset
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 05a78e5..2e2d6da 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -2081,7 +2081,7 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
>  	}
>  }
>  
> -static int arcmsr_queue_command(struct scsi_cmnd *cmd,
> +static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
>  	void (* done)(struct scsi_cmnd *))
>  {
>  	struct Scsi_Host *host = cmd->device->host;
> @@ -2124,6 +2124,8 @@ static int arcmsr_queue_command(struct scsi_cmnd *cmd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(arcmsr_queue_command)
> +
>  static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb)
>  {
>  	struct MessageUnit_A __iomem *reg = acb->pmuA;
> diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
> index 918ccf8..ec16672 100644
> --- a/drivers/scsi/arm/acornscsi.c
> +++ b/drivers/scsi/arm/acornscsi.c
> @@ -2511,7 +2511,7 @@ acornscsi_intr(int irq, void *dev_id)
>   *	      done - function called on completion, with pointer to command descriptor
>   * Returns  : 0, or < 0 on error.
>   */
> -int acornscsi_queuecmd(struct scsi_cmnd *SCpnt,
> +static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
>  		       void (*done)(struct scsi_cmnd *))
>  {
>      AS_Host *host = (AS_Host *)SCpnt->device->host->hostdata;
> @@ -2561,6 +2561,8 @@ int acornscsi_queuecmd(struct scsi_cmnd *SCpnt,
>      return 0;
>  }
>  
> +DEF_SCSI_QCMD(acornscsi_queuecmd)
> +
>  /*
>   * Prototype: void acornscsi_reportstatus(struct scsi_cmnd **SCpntp1, struct scsi_cmnd **SCpntp2, int result)
>   * Purpose  : pass a result to *SCpntp1, and check if *SCpntp1 = *SCpntp2
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index 9e71ac6..a2fc7ad 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -2198,7 +2198,7 @@ no_command:
>   * Returns: 0 on success, else error.
>   * Notes: io_request_lock is held, interrupts are disabled.
>   */
> -int fas216_queue_command(struct scsi_cmnd *SCpnt,
> +static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
>  			 void (*done)(struct scsi_cmnd *))
>  {
>  	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
> @@ -2240,6 +2240,8 @@ int fas216_queue_command(struct scsi_cmnd *SCpnt,
>  	return result;
>  }
>  
> +DEF_SCSI_QCMD(fas216_queue_command)
> +
>  /**
>   * fas216_internal_done - trigger restart of a waiting thread in fas216_noqueue_command
>   * @SCpnt: Command to wake
> @@ -2263,7 +2265,7 @@ static void fas216_internal_done(struct scsi_cmnd *SCpnt)
>   * Returns: scsi result code.
>   * Notes: io_request_lock is held, interrupts are disabled.
>   */
> -int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
> +static int fas216_noqueue_command_lck(struct scsi_cmnd *SCpnt,
>  			   void (*done)(struct scsi_cmnd *))
>  {
>  	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
> @@ -2310,6 +2312,8 @@ int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
>  	return 0;
>  }
>  
> +DEF_SCSI_QCMD(fas216_noqueue_command)
> +
>  /*
>   * Error handler timeout function.  Indicate that we timed out,
>   * and wake up any error handler process so it can continue.
> diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
> index 158ebc3..88b2928 100644
> --- a/drivers/scsi/atari_NCR5380.c
> +++ b/drivers/scsi/atari_NCR5380.c
> @@ -910,7 +910,7 @@ static int __init NCR5380_init(struct Scsi_Host *instance, int flags)
>   *
>   */
>  
> -static int NCR5380_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
> +static int NCR5380_queue_command_lck(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
>  {
>  	SETUP_HOSTDATA(cmd->device->host);
>  	Scsi_Cmnd *tmp;
> @@ -1022,6 +1022,8 @@ static int NCR5380_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(NCR5380_queue_command)
> +
>  /*
>   * Function : NCR5380_main (void)
>   *
> diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
> index ab5bdda..930f052 100644
> --- a/drivers/scsi/atp870u.c
> +++ b/drivers/scsi/atp870u.c
> @@ -605,7 +605,7 @@ handled:
>   *
>   *	Queue a command to the ATP queue. Called with the host lock held.
>   */
> -static int atp870u_queuecommand(struct scsi_cmnd * req_p, 
> +static int atp870u_queuecommand_lck(struct scsi_cmnd * req_p, 
>  			 void (*done) (struct scsi_cmnd *))
>  {
>  	unsigned char c;
> @@ -694,6 +694,8 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(atp870u_queuecommand)
> +
>  /**
>   *	send_s870	-	send a command to the controller
>   *	@host: host
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 8daa716..4b8103e 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -1120,7 +1120,7 @@ bfad_im_itnim_work_handler(struct work_struct *work)
>   * Scsi_Host template entry, queue a SCSI command to the BFAD.
>   */
>  static int
> -bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
> +bfad_im_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
>  {
>  	struct bfad_im_port_s *im_port =
>  		(struct bfad_im_port_s *) cmnd->device->host->hostdata[0];
> @@ -1187,6 +1187,8 @@ out_fail_cmd:
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(bfad_im_queuecommand)
> +
>  void
>  bfad_os_rport_online_wait(struct bfad_s *bfad)
>  {
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index 54f50b0..8f1b5c8 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -1080,7 +1080,7 @@ static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
>   *        and is expected to be held on return.
>   *
>   **/
> -static int dc395x_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct DeviceCtlBlk *dcb;
>  	struct ScsiReqBlk *srb;
> @@ -1154,6 +1154,7 @@ complete:
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(dc395x_queue_command)
>  
>  /*
>   * Return the disk geometry for the given SCSI device.
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index 23dec00..cffcb10 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -423,7 +423,7 @@ static int adpt_slave_configure(struct scsi_device * device)
>  	return 0;
>  }
>  
> -static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
> +static int adpt_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
>  {
>  	adpt_hba* pHba = NULL;
>  	struct adpt_device* pDev = NULL;	/* dpt per device information */
> @@ -491,6 +491,8 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
>  	return adpt_scsi_to_i2o(pHba, cmd, pDev);
>  }
>  
> +static DEF_SCSI_QCMD(adpt_queue)
> +
>  static int adpt_bios_param(struct scsi_device *sdev, struct block_device *dev,
>  		sector_t capacity, int geom[])
>  {
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index d1c3137..f9d61d4 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -1758,7 +1758,7 @@ static void scsi_to_dev_dir(unsigned int i, struct hostdata *ha)
>  
>  }
>  
> -static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
> +static int eata2x_queuecommand_lck(struct scsi_cmnd *SCpnt,
>  			       void (*done) (struct scsi_cmnd *))
>  {
>  	struct Scsi_Host *shost = SCpnt->device->host;
> @@ -1843,6 +1843,8 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(eata2x_queuecommand)
> +
>  static int eata2x_eh_abort(struct scsi_cmnd *SCarg)
>  {
>  	struct Scsi_Host *shost = SCarg->device->host;
> diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
> index 60886c1..4a9641e 100644
> --- a/drivers/scsi/eata_pio.c
> +++ b/drivers/scsi/eata_pio.c
> @@ -335,7 +335,7 @@ static inline unsigned int eata_pio_send_command(unsigned long base, unsigned ch
>  	return 0;
>  }
>  
> -static int eata_pio_queue(struct scsi_cmnd *cmd,
> +static int eata_pio_queue_lck(struct scsi_cmnd *cmd,
>  		void (*done)(struct scsi_cmnd *))
>  {
>  	unsigned int x, y;
> @@ -438,6 +438,8 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(eata_pio_queue)
> +
>  static int eata_pio_abort(struct scsi_cmnd *cmd)
>  {
>  	unsigned int loop = 100;
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index e2bc779..5755852 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -916,7 +916,7 @@ static void esp_event_queue_full(struct esp *esp, struct esp_cmd_entry *ent)
>  	scsi_track_queue_full(dev, lp->num_tagged - 1);
>  }
>  
> -static int esp_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +static int esp_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct scsi_device *dev = cmd->device;
>  	struct esp *esp = shost_priv(dev->host);
> @@ -941,6 +941,8 @@ static int esp_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(esp_queuecommand)
> +
>  static int esp_check_gross_error(struct esp *esp)
>  {
>  	if (esp->sreg & ESP_STAT_SPAM) {
> diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
> index 2ad95aa..a2c6135 100644
> --- a/drivers/scsi/fd_mcs.c
> +++ b/drivers/scsi/fd_mcs.c
> @@ -1072,7 +1072,7 @@ static int fd_mcs_release(struct Scsi_Host *shpnt)
>  	return 0;
>  }
>  
> -static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
> +static int fd_mcs_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
>  {
>  	struct Scsi_Host *shpnt = SCpnt->device->host;
>  
> @@ -1122,6 +1122,8 @@ static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(fd_mcs_queue)
> +
>  #if DEBUG_ABORT || DEBUG_RESET
>  static void fd_mcs_print_info(Scsi_Cmnd * SCpnt)
>  {
> diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
> index e296bcc..69b7aa5 100644
> --- a/drivers/scsi/fdomain.c
> +++ b/drivers/scsi/fdomain.c
> @@ -1419,7 +1419,7 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
>     return IRQ_HANDLED;
>  }
>  
> -static int fdomain_16x0_queue(struct scsi_cmnd *SCpnt,
> +static int fdomain_16x0_queue_lck(struct scsi_cmnd *SCpnt,
>  		void (*done)(struct scsi_cmnd *))
>  {
>     if (in_command) {
> @@ -1469,6 +1469,8 @@ static int fdomain_16x0_queue(struct scsi_cmnd *SCpnt,
>     return 0;
>  }
>  
> +static DEF_SCSI_QCMD(fdomain_16x0_queue)
> +
>  #if DEBUG_ABORT
>  static void print_info(struct scsi_cmnd *SCpnt)
>  {
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 198cbab..22d0240 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -349,7 +349,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
>   * Routine to send a scsi cdb
>   * Called with host_lock held and interrupts disabled.
>   */
> -int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
> +static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
>  {
>  	struct fc_lport *lp;
>  	struct fc_rport *rport;
> @@ -457,6 +457,8 @@ out:
>  	return ret;
>  }
>  
> +DEF_SCSI_QCMD(fnic_queuecommand)
> +
>  /*
>   * fnic_fcpio_fw_reset_cmpl_handler
>   * Routine to handle fw reset completion
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 8411018..98aad81 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -4004,7 +4004,7 @@ static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,se
>  }
>  
> 
> -static int gdth_queuecommand(struct scsi_cmnd *scp,
> +static int gdth_queuecommand_lck(struct scsi_cmnd *scp,
>  				void (*done)(struct scsi_cmnd *))
>  {
>      gdth_ha_str *ha = shost_priv(scp->device->host);
> @@ -4022,6 +4022,8 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
>      return __gdth_queuecommand(ha, scp, cmndinfo);
>  }
>  
> +static DEF_SCSI_QCMD(gdth_queuecommand)
> +
>  static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
>  				struct gdth_cmndinfo *cmndinfo)
>  {
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index c5d0606..e50039b 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1926,7 +1926,7 @@ sglist_finished:
>  }
>  
> 
> -static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
> +static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
>  	void (*done)(struct scsi_cmnd *))
>  {
>  	struct ctlr_info *h;
> @@ -2020,6 +2020,8 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(hpsa_scsi_queue_command)
> +
>  static void hpsa_scan_start(struct Scsi_Host *sh)
>  {
>  	struct ctlr_info *h = shost_to_hba(sh);
> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index 0729f15..10b6555 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -751,7 +751,7 @@ static void hptiop_post_req_mv(struct hptiop_hba *hba,
>  		MVIOP_MU_QUEUE_ADDR_HOST_BIT | size_bit, hba);
>  }
>  
> -static int hptiop_queuecommand(struct scsi_cmnd *scp,
> +static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
>  				void (*done)(struct scsi_cmnd *))
>  {
>  	struct Scsi_Host *host = scp->device->host;
> @@ -819,6 +819,8 @@ cmd_done:
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(hptiop_queuecommand)
> +
>  static const char *hptiop_info(struct Scsi_Host *host)
>  {
>  	return driver_name_long;
> diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
> index 9a4b69d..bc90b40 100644
> --- a/drivers/scsi/ibmmca.c
> +++ b/drivers/scsi/ibmmca.c
> @@ -1691,7 +1691,7 @@ static int __devexit ibmmca_remove(struct device *dev)
>  }
>  
>  /* The following routine is the SCSI command queue for the midlevel driver */
> -static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
> +static int ibmmca_queuecommand_lck(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
>  {
>  	unsigned int ldn;
>  	unsigned int scsi_cmd;
> @@ -1996,6 +1996,8 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(ibmmca_queuecommand)
> +
>  static int __ibmmca_abort(Scsi_Cmnd * cmd)
>  {
>  	/* Abort does not work, as the adapter never generates an interrupt on
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 00d08b2..57cad7e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -1606,7 +1606,7 @@ static inline int ibmvfc_host_chkready(struct ibmvfc_host *vhost)
>   * Returns:
>   *	0 on success / other on failure
>   **/
> -static int ibmvfc_queuecommand(struct scsi_cmnd *cmnd,
> +static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
>  			       void (*done) (struct scsi_cmnd *))
>  {
>  	struct ibmvfc_host *vhost = shost_priv(cmnd->device->host);
> @@ -1672,6 +1672,8 @@ static int ibmvfc_queuecommand(struct scsi_cmnd *cmnd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(ibmvfc_queuecommand)
> +
>  /**
>   * ibmvfc_sync_completion - Signal that a synchronous command has completed
>   * @evt:	ibmvfc event struct
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 67f78a4..0419584 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -713,7 +713,7 @@ static inline u16 lun_from_dev(struct scsi_device *dev)
>   * @cmd:	struct scsi_cmnd to be executed
>   * @done:	Callback function to be called when cmd is completed
>  */
> -static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
> +static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
>  				 void (*done) (struct scsi_cmnd *))
>  {
>  	struct srp_cmd *srp_cmd;
> @@ -766,6 +766,8 @@ static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
>  	return ibmvscsi_send_srp_event(evt_struct, hostdata, 0);
>  }
>  
> +static DEF_SCSI_QCMD(ibmvscsi_queuecommand)
> +
>  /* ------------------------------------------------------------
>   * Routines for driver initialization
>   */
> diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
> index 4734ab0..99aa0e5 100644
> --- a/drivers/scsi/imm.c
> +++ b/drivers/scsi/imm.c
> @@ -926,7 +926,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
>  	return 0;
>  }
>  
> -static int imm_queuecommand(struct scsi_cmnd *cmd,
> +static int imm_queuecommand_lck(struct scsi_cmnd *cmd,
>  		void (*done)(struct scsi_cmnd *))
>  {
>  	imm_struct *dev = imm_dev(cmd->device->host);
> @@ -949,6 +949,8 @@ static int imm_queuecommand(struct scsi_cmnd *cmd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(imm_queuecommand)
> +
>  /*
>   * Apparently the disk->capacity attribute is off by 1 sector 
>   * for all disk drives.  We add the one here, but it should really
> diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
> index 52bdc6d..6568aab 100644
> --- a/drivers/scsi/in2000.c
> +++ b/drivers/scsi/in2000.c
> @@ -334,7 +334,7 @@ static uchar calc_sync_xfer(unsigned int period, unsigned int offset)
>  
>  static void in2000_execute(struct Scsi_Host *instance);
>  
> -static int in2000_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
> +static int in2000_queuecommand_lck(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
>  {
>  	struct Scsi_Host *instance;
>  	struct IN2000_hostdata *hostdata;
> @@ -431,6 +431,8 @@ static int in2000_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
>  	    return 0;
>  }
>  
> +static DEF_SCSI_QCMD(in2000_queuecommand)
> +
>  
> 
>  /*
> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 1087977..9627d06 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -2639,7 +2639,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
>   *	will cause the mid layer to call us again later with the command)
>   */
>  
> -static int i91u_queuecommand(struct scsi_cmnd *cmd,
> +static int i91u_queuecommand_lck(struct scsi_cmnd *cmd,
>  		void (*done)(struct scsi_cmnd *))
>  {
>  	struct initio_host *host = (struct initio_host *) cmd->device->host->hostdata;
> @@ -2656,6 +2656,8 @@ static int i91u_queuecommand(struct scsi_cmnd *cmd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(i91u_queuecommand)
> +
>  /**
>   *	i91u_bus_reset		-	reset the SCSI bus
>   *	@cmnd: Command block we want to trigger the reset for
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index fa60d7d..5bbaee5 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -5709,7 +5709,7 @@ static void ipr_scsi_done(struct ipr_cmnd *ipr_cmd)
>   *	SCSI_MLQUEUE_DEVICE_BUSY if device is busy
>   *	SCSI_MLQUEUE_HOST_BUSY if host is busy
>   **/
> -static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
> +static int ipr_queuecommand_lck(struct scsi_cmnd *scsi_cmd,
>  			    void (*done) (struct scsi_cmnd *))
>  {
>  	struct ipr_ioa_cfg *ioa_cfg;
> @@ -5792,6 +5792,8 @@ static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(ipr_queuecommand)
> +
>  /**
>   * ipr_ioctl - IOCTL handler
>   * @sdev:	scsi device struct
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index f83a116..f76c819 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -1046,7 +1046,7 @@ static int ips_eh_reset(struct scsi_cmnd *SC)
>  /*    Linux obtains io_request_lock before calling this function            */
>  /*                                                                          */
>  /****************************************************************************/
> -static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
> +static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
>  {
>  	ips_ha_t *ha;
>  	ips_passthru_t *pt;
> @@ -1137,6 +1137,8 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
>  	return (0);
>  }
>  
> +static DEF_SCSI_QCMD(ips_queue)
> +
>  /****************************************************************************/
>  /*                                                                          */
>  /* Routine Name: ips_biosparam                                              */
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index e340373..2924363 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -1753,7 +1753,7 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
>   * This is the i/o strategy routine, called by the SCSI layer. This routine
>   * is called with the host_lock held.
>   */
> -int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
> +static int fc_queuecommand_lck(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct fc_lport *lport;
>  	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
> @@ -1851,6 +1851,8 @@ out:
>  	spin_lock_irq(lport->host->host_lock);
>  	return rc;
>  }
> +
> +DEF_SCSI_QCMD(fc_queuecommand)
>  EXPORT_SYMBOL(fc_queuecommand);
>  
>  /**
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 633e090..c15fde8 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1599,7 +1599,7 @@ enum {
>  	FAILURE_SESSION_NOT_READY,
>  };
>  
> -int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
> +static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
>  {
>  	struct iscsi_cls_session *cls_session;
>  	struct Scsi_Host *host;
> @@ -1736,6 +1736,8 @@ fault:
>  	spin_lock(host->host_lock);
>  	return 0;
>  }
> +
> +DEF_SCSI_QCMD(iscsi_queuecommand)
>  EXPORT_SYMBOL_GPL(iscsi_queuecommand);
>  
>  int iscsi_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index 55f09e9..29251fa 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -189,7 +189,7 @@ int sas_queue_up(struct sas_task *task)
>   * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
>   * call us without holding an IRQ spinlock...
>   */
> -int sas_queuecommand(struct scsi_cmnd *cmd,
> +static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
>  		     void (*scsi_done)(struct scsi_cmnd *))
>  	__releases(host->host_lock)
>  	__acquires(dev->sata_dev.ap->lock)
> @@ -254,6 +254,8 @@ out:
>  	return res;
>  }
>  
> +DEF_SCSI_QCMD(sas_queuecommand)
> +
>  static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
>  {
>  	struct sas_task *task = TO_SAS_TASK(cmd);
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index f64b65a..581837b 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -2899,7 +2899,7 @@ void lpfc_poll_timeout(unsigned long ptr)
>   *   SCSI_MLQUEUE_HOST_BUSY - Block all devices served by this host temporarily.
>   **/
>  static int
> -lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
> +lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
>  {
>  	struct Scsi_Host  *shost = cmnd->device->host;
>  	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
> @@ -3060,6 +3060,8 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(lpfc_queuecommand)
> +
>  /**
>   * lpfc_abort_handler - scsi_host_template eh_abort_handler entry point
>   * @cmnd: Pointer to scsi_cmnd data structure.
> diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
> index 3ddb4dc..6c42dff 100644
> --- a/drivers/scsi/mac53c94.c
> +++ b/drivers/scsi/mac53c94.c
> @@ -66,7 +66,7 @@ static void cmd_done(struct fsc_state *, int result);
>  static void set_dma_cmds(struct fsc_state *, struct scsi_cmnd *);
>  
> 
> -static int mac53c94_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +static int mac53c94_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct fsc_state *state;
>  
> @@ -99,6 +99,8 @@ static int mac53c94_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(mac53c94_queue)
> +
>  static int mac53c94_host_reset(struct scsi_cmnd *cmd)
>  {
>  	struct fsc_state *state = (struct fsc_state *) cmd->device->host->hostdata;
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 7ceb5cf..ca7dc61 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -366,7 +366,7 @@ mega_runpendq(adapter_t *adapter)
>   * The command queuing entry point for the mid-layer.
>   */
>  static int
> -megaraid_queue(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
> +megaraid_queue_lck(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
>  {
>  	adapter_t	*adapter;
>  	scb_t	*scb;
> @@ -409,6 +409,8 @@ megaraid_queue(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
>  	return busy;
>  }
>  
> +static DEF_SCSI_QCMD(megaraid_queue)
> +
>  /**
>   * mega_allocate_scb()
>   * @adapter - pointer to our soft state
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> index a7810a1..dea0860 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -1484,7 +1484,7 @@ mbox_post_cmd(adapter_t *adapter, scb_t *scb)
>   * Queue entry point for mailbox based controllers.
>   */
>  static int
> -megaraid_queue_command(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
> +megaraid_queue_command_lck(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
>  {
>  	adapter_t	*adapter;
>  	scb_t		*scb;
> @@ -1513,6 +1513,8 @@ megaraid_queue_command(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
>  	return if_busy;
>  }
>  
> +static DEF_SCSI_QCMD(megaraid_queue_command)
> +
>  /**
>   * megaraid_mbox_build_cmd - transform the mid-layer scsi commands
>   * @adapter	: controller's soft state
> diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
> index eb29d50..7451bc0 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.c
> +++ b/drivers/scsi/megaraid/megaraid_sas.c
> @@ -1334,7 +1334,7 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
>   * @done:			Callback entry point
>   */
>  static int
> -megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
> +megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
>  {
>  	u32 frame_count;
>  	struct megasas_cmd *cmd;
> @@ -1417,6 +1417,8 @@ megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(megasas_queue_command)
> +
>  static struct megasas_instance *megasas_lookup_instance(u16 host_no)
>  {
>  	int i;
> diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
> index 1f784fd..197aa1b 100644
> --- a/drivers/scsi/mesh.c
> +++ b/drivers/scsi/mesh.c
> @@ -1627,7 +1627,7 @@ static void cmd_complete(struct mesh_state *ms)
>   * Called by midlayer with host locked to queue a new
>   * request
>   */
> -static int mesh_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +static int mesh_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct mesh_state *ms;
>  
> @@ -1648,6 +1648,8 @@ static int mesh_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(mesh_queue)
> +
>  /*
>   * Called to handle interrupts, either call by the interrupt
>   * handler (do_mesh_interrupt) or by other functions in
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 16e99b6..1a96a00 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -3315,7 +3315,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
>   * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
>   */
>  static int
> -_scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
> +_scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
>  	struct MPT2SAS_DEVICE *sas_device_priv_data;
> @@ -3441,6 +3441,8 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
>  	return SCSI_MLQUEUE_HOST_BUSY;
>  }
>  
> +static DEF_SCSI_QCMD(_scsih_qcmd)
> +
>  /**
>   * _scsih_normalize_sense - normalize descriptor and fixed format sense data
>   * @sense_buffer: sense data returned by target
> diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
> index d013a2a..581c839 100644
> --- a/drivers/scsi/ncr53c8xx.c
> +++ b/drivers/scsi/ncr53c8xx.c
> @@ -8029,7 +8029,7 @@ static int ncr53c8xx_slave_configure(struct scsi_device *device)
>  	return 0;
>  }
>  
> -static int ncr53c8xx_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
> +static int ncr53c8xx_queue_command_lck (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
>  {
>       struct ncb *np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
>       unsigned long flags;
> @@ -8068,6 +8068,8 @@ printk("ncr53c8xx : command successfully queued\n");
>       return sts;
>  }
>  
> +static DEF_SCSI_QCMD(ncr53c8xx_queue_command)
> +
>  irqreturn_t ncr53c8xx_intr(int irq, void *dev_id)
>  {
>       unsigned long flags;
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 4c1e545..c8b641c 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -909,7 +909,7 @@ static int nsp32_setup_sg_table(struct scsi_cmnd *SCpnt)
>  	return TRUE;
>  }
>  
> -static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
> +static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  {
>  	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
>  	nsp32_target *target;
> @@ -1050,6 +1050,8 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(nsp32_queuecommand)
> +
>  /* initialize asic */
>  static int nsp32hw_init(nsp32_hw_data *data)
>  {
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index 9326c2c..be3f33d 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -184,7 +184,7 @@ static void nsp_scsi_done(struct scsi_cmnd *SCpnt)
>  	SCpnt->scsi_done(SCpnt);
>  }
>  
> -static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
> +static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
>  			    void (*done)(struct scsi_cmnd *))
>  {
>  #ifdef NSP_DEBUG
> @@ -264,6 +264,8 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(nsp_queuecommand)
> +
>  /*
>   * setup PIO FIFO transfer mode and enable/disable to data out
>   */
> diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
> index 0ae27cb..8552296 100644
> --- a/drivers/scsi/pcmcia/sym53c500_cs.c
> +++ b/drivers/scsi/pcmcia/sym53c500_cs.c
> @@ -547,7 +547,7 @@ SYM53C500_info(struct Scsi_Host *SChost)
>  }
>  
>  static int 
> -SYM53C500_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
> +SYM53C500_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  {
>  	int i;
>  	int port_base = SCpnt->device->host->io_port;
> @@ -583,6 +583,8 @@ SYM53C500_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(SYM53C500_queue)
> +
>  static int 
>  SYM53C500_host_reset(struct scsi_cmnd *SCpnt)
>  {
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index cf89091..5e76a62 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -3478,7 +3478,7 @@ static int pmcraid_copy_sglist(
>   *	  SCSI_MLQUEUE_DEVICE_BUSY if device is busy
>   *	  SCSI_MLQUEUE_HOST_BUSY if host is busy
>   */
> -static int pmcraid_queuecommand(
> +static int pmcraid_queuecommand_lck(
>  	struct scsi_cmnd *scsi_cmd,
>  	void (*done) (struct scsi_cmnd *)
>  )
> @@ -3584,6 +3584,8 @@ static int pmcraid_queuecommand(
>  	return rc;
>  }
>  
> +static DEF_SCSI_QCMD(pmcraid_queuecommand)
> +
>  /**
>   * pmcraid_open -char node "open" entry, allowed only users with admin access
>   */
> diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
> index 7bc2d79..d164c96 100644
> --- a/drivers/scsi/ppa.c
> +++ b/drivers/scsi/ppa.c
> @@ -798,7 +798,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
>  	return 0;
>  }
>  
> -static int ppa_queuecommand(struct scsi_cmnd *cmd,
> +static int ppa_queuecommand_lck(struct scsi_cmnd *cmd,
>  		void (*done) (struct scsi_cmnd *))
>  {
>  	ppa_struct *dev = ppa_dev(cmd->device->host);
> @@ -821,6 +821,8 @@ static int ppa_queuecommand(struct scsi_cmnd *cmd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(ppa_queuecommand)
> +
>  /*
>   * Apparently the disk->capacity attribute is off by 1 sector 
>   * for all disk drives.  We add the one here, but it should really
> diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
> index 92ffbb5..cd178b9 100644
> --- a/drivers/scsi/ps3rom.c
> +++ b/drivers/scsi/ps3rom.c
> @@ -211,7 +211,7 @@ static int ps3rom_write_request(struct ps3_storage_device *dev,
>  	return 0;
>  }
>  
> -static int ps3rom_queuecommand(struct scsi_cmnd *cmd,
> +static int ps3rom_queuecommand_lck(struct scsi_cmnd *cmd,
>  			       void (*done)(struct scsi_cmnd *))
>  {
>  	struct ps3rom_private *priv = shost_priv(cmd->device->host);
> @@ -260,6 +260,8 @@ static int ps3rom_queuecommand(struct scsi_cmnd *cmd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(ps3rom_queuecommand)
> +
>  static int decode_lv1_status(u64 status, unsigned char *sense_key,
>  			     unsigned char *asc, unsigned char *ascq)
>  {
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index b8166ec..5dec684 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -727,7 +727,7 @@ qla1280_info(struct Scsi_Host *host)
>   * context which is a big NO! NO!.
>   **************************************************************************/
>  static int
> -qla1280_queuecommand(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
> +qla1280_queuecommand_lck(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
>  {
>  	struct Scsi_Host *host = cmd->device->host;
>  	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
> @@ -756,6 +756,8 @@ qla1280_queuecommand(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
>  	return status;
>  }
>  
> +static DEF_SCSI_QCMD(qla1280_queuecommand)
> +
>  enum action {
>  	ABORT_COMMAND,
>  	DEVICE_RESET,
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 1830e6e..35f3f5d 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -535,7 +535,7 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
>  }
>  
>  static int
> -qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  {
>  	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
>  	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
> @@ -609,6 +609,8 @@ qc24_fail_command:
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(qla2xxx_queuecommand)
> +
>  
>  /*
>   * qla2x00_eh_wait_on_command
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index f4cd846..4a3223d 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -464,7 +464,7 @@ void qla4xxx_srb_compl(struct kref *ref)
>   * completion handling).   Unfortunely, it sometimes calls the scheduler
>   * in interrupt context which is a big NO! NO!.
>   **/
> -static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
> +static int qla4xxx_queuecommand_lck(struct scsi_cmnd *cmd,
>  				void (*done)(struct scsi_cmnd *))
>  {
>  	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
> @@ -538,6 +538,8 @@ qc_fail_command:
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(qla4xxx_queuecommand)
> +
>  /**
>   * qla4xxx_mem_free - frees memory allocated to adapter
>   * @ha: Pointer to host adapter structure.
> diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
> index 1ad5155..c3a9151 100644
> --- a/drivers/scsi/qlogicfas408.c
> +++ b/drivers/scsi/qlogicfas408.c
> @@ -439,7 +439,7 @@ irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id)
>   *	Queued command
>   */
>  
> -int qlogicfas408_queuecommand(struct scsi_cmnd *cmd,
> +static int qlogicfas408_queuecommand_lck(struct scsi_cmnd *cmd,
>  			      void (*done) (struct scsi_cmnd *))
>  {
>  	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
> @@ -459,6 +459,8 @@ int qlogicfas408_queuecommand(struct scsi_cmnd *cmd,
>  	return 0;
>  }
>  
> +DEF_SCSI_QCMD(qlogicfas408_queuecommand)
> +
>  /* 
>   *	Return bios parameters 
>   */
> diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
> index f8c561c..664c957 100644
> --- a/drivers/scsi/qlogicpti.c
> +++ b/drivers/scsi/qlogicpti.c
> @@ -1003,7 +1003,7 @@ static int qlogicpti_slave_configure(struct scsi_device *sdev)
>   *
>   * "This code must fly." -davem
>   */
> -static int qlogicpti_queuecommand(struct scsi_cmnd *Cmnd, void (*done)(struct scsi_cmnd *))
> +static int qlogicpti_queuecommand_lck(struct scsi_cmnd *Cmnd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct Scsi_Host *host = Cmnd->device->host;
>  	struct qlogicpti *qpti = (struct qlogicpti *) host->hostdata;
> @@ -1052,6 +1052,8 @@ toss_command:
>  	return 1;
>  }
>  
> +static DEF_SCSI_QCMD(qlogicpti_queuecommand)
> +
>  static int qlogicpti_return_status(struct Status_Entry *sts, int id)
>  {
>  	int host_status = DID_ERROR;
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 348fba0..e3d0629 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -634,12 +634,13 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
>   * Description: a serial number identifies a request for error recovery
>   * and debugging purposes.  Protected by the Host_Lock of host.
>   */
> -static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
> +void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  {
>  	cmd->serial_number = host->cmd_serial_number++;
>  	if (cmd->serial_number == 0) 
>  		cmd->serial_number = host->cmd_serial_number++;
>  }
> +EXPORT_SYMBOL(scsi_cmd_get_serial);
>  
>  /**
>   * scsi_dispatch_command - Dispatch a command to the low-level driver.
> @@ -651,7 +652,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
>  int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  {
>  	struct Scsi_Host *host = cmd->device->host;
> -	unsigned long flags = 0;
>  	unsigned long timeout;
>  	int rtn = 0;
>  
> @@ -737,15 +737,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  		goto out;
>  	}
>  
> -	spin_lock_irqsave(host->host_lock, flags);
> -	/*
> -	 * AK: unlikely race here: for some reason the timer could
> -	 * expire before the serial number is set up below.
> -	 *
> -	 * TODO: kill serial or move to blk layer
> -	 */
> -	scsi_cmd_get_serial(host, cmd); 
> -
>  	if (unlikely(host->shost_state == SHOST_DEL)) {
>  		cmd->result = (DID_NO_CONNECT << 16);
>  		scsi_done(cmd);
> @@ -753,7 +744,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  		trace_scsi_dispatch_cmd_start(cmd);
>  		rtn = host->hostt->queuecommand(cmd, scsi_done);
>  	}
> -	spin_unlock_irqrestore(host->host_lock, flags);
> +
>  	if (rtn) {
>  		trace_scsi_dispatch_cmd_error(cmd, rtn);
>  		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 2c36bae..2f1f9b0 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3538,7 +3538,7 @@ static void sdebug_remove_adapter(void)
>  }
>  
>  static
> -int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
> +int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
>  {
>  	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
>  	int len, k;
> @@ -3884,6 +3884,8 @@ write:
>  			     (delay_override ? 0 : scsi_debug_delay));
>  }
>  
> +static DEF_SCSI_QCMD(scsi_debug_queuecommand)
> +
>  static struct scsi_host_template sdebug_driver_template = {
>  	.proc_info =		scsi_debug_proc_info,
>  	.proc_name =		sdebug_proc_name,
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 1de30eb..d0e765f 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -781,17 +781,14 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  	struct Scsi_Host *shost = sdev->host;
>  	DECLARE_COMPLETION_ONSTACK(done);
>  	unsigned long timeleft;
> -	unsigned long flags;
>  	struct scsi_eh_save ses;
>  	int rtn;
>  
>  	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
>  	shost->eh_action = &done;
>  
> -	spin_lock_irqsave(shost->host_lock, flags);
>  	scsi_log_send(scmd);
>  	shost->hostt->queuecommand(scmd, scsi_eh_done);
> -	spin_unlock_irqrestore(shost->host_lock, flags);
>  
>  	timeleft = wait_for_completion_timeout(&done, timeout);
>  
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 9c73dbd..29b11a5 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -572,7 +572,7 @@ stex_slave_destroy(struct scsi_device *sdev)
>  }
>  
>  static int
> -stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
> +stex_queuecommand_lck(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
>  {
>  	struct st_hba *hba;
>  	struct Scsi_Host *host;
> @@ -698,6 +698,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(stex_queuecommand)
> +
>  static void stex_scsi_done(struct st_ccb *ccb)
>  {
>  	struct scsi_cmnd *cmd = ccb->cmd;
> diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
> index 713620e..4f0e548 100644
> --- a/drivers/scsi/sun3_NCR5380.c
> +++ b/drivers/scsi/sun3_NCR5380.c
> @@ -908,7 +908,7 @@ static int NCR5380_init (struct Scsi_Host *instance, int flags)
>   */
>  
>  /* Only make static if a wrapper function is used */
> -static int NCR5380_queue_command(struct scsi_cmnd *cmd,
> +static int NCR5380_queue_command_lck(struct scsi_cmnd *cmd,
>  				 void (*done)(struct scsi_cmnd *))
>  {
>      SETUP_HOSTDATA(cmd->device->host);
> @@ -1019,6 +1019,8 @@ static int NCR5380_queue_command(struct scsi_cmnd *cmd,
>      return 0;
>  }
>  
> +static DEF_SCSI_QCMD(NCR5380_queue_command)
> +
>  /*
>   * Function : NCR5380_main (void) 
>   *
> diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
> index e5c369b..190107a 100644
> --- a/drivers/scsi/sym53c416.c
> +++ b/drivers/scsi/sym53c416.c
> @@ -734,7 +734,7 @@ const char *sym53c416_info(struct Scsi_Host *SChost)
>  	return info;
>  }
>  
> -int sym53c416_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
> +static int sym53c416_queuecommand_lck(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
>  {
>  	int base;
>  	unsigned long flags = 0;
> @@ -761,6 +761,8 @@ int sym53c416_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
>  	return 0;
>  }
>  
> +DEF_SCSI_QCMD(sym53c416_queuecommand)
> +
>  static int sym53c416_host_reset(Scsi_Cmnd *SCpnt)
>  {
>  	int base;
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
> index 8b955b5..6b97ded 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -505,7 +505,7 @@ void sym_log_bus_error(struct Scsi_Host *shost)
>   * queuecommand method.  Entered with the host adapter lock held and
>   * interrupts disabled.
>   */
> -static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
> +static int sym53c8xx_queue_command_lck(struct scsi_cmnd *cmd,
>  					void (*done)(struct scsi_cmnd *))
>  {
>  	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
> @@ -536,6 +536,8 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(sym53c8xx_queue_command)
> +
>  /*
>   *  Linux entry point of the interrupt handler.
>   */
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index 27866b0..a124a28f 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -1883,7 +1883,7 @@ dc390_ScsiRstDetect( struct dc390_acb* pACB )
>      return;
>  }
>  
> -static int DC390_queuecommand(struct scsi_cmnd *cmd,
> +static int DC390_queuecommand_lck(struct scsi_cmnd *cmd,
>  		void (*done)(struct scsi_cmnd *))
>  {
>  	struct scsi_device *sdev = cmd->device;
> @@ -1944,6 +1944,8 @@ static int DC390_queuecommand(struct scsi_cmnd *cmd,
>  	return SCSI_MLQUEUE_DEVICE_BUSY;
>  }
>  
> +static DEF_SCSI_QCMD(DC390_queuecommand)
> +
>  static void dc390_dumpinfo (struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
>  {
>      struct pci_dev *pdev;
> diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
> index 5d9fdee..968dc5ae 100644
> --- a/drivers/scsi/u14-34f.c
> +++ b/drivers/scsi/u14-34f.c
> @@ -1248,7 +1248,7 @@ static void scsi_to_dev_dir(unsigned int i, unsigned int j) {
>  
>  }
>  
> -static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *)) {
> +static int u14_34f_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *)) {
>     unsigned int i, j, k;
>     struct mscp *cpp;
>  
> @@ -1329,6 +1329,8 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
>     return 0;
>  }
>  
> +static DEF_SCSI_QCMD(u14_34f_queuecommand)
> +
>  static int u14_34f_eh_abort(struct scsi_cmnd *SCarg) {
>     unsigned int i, j;
>  
> diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
> index 27aa40f..0571ef9 100644
> --- a/drivers/scsi/ultrastor.c
> +++ b/drivers/scsi/ultrastor.c
> @@ -700,7 +700,7 @@ static inline void build_sg_list(struct mscp *mscp, struct scsi_cmnd *SCpnt)
>  	mscp->transfer_data_length = transfer_length;
>  }
>  
> -static int ultrastor_queuecommand(struct scsi_cmnd *SCpnt,
> +static int ultrastor_queuecommand_lck(struct scsi_cmnd *SCpnt,
>  				void (*done) (struct scsi_cmnd *))
>  {
>      struct mscp *my_mscp;
> @@ -825,6 +825,8 @@ retry:
>      return 0;
>  }
>  
> +static DEF_SCSI_QCMD(ultrastor_queuecommand)
> +
>  /* This code must deal with 2 cases:
>  
>     1. The command has not been written to the OGM.  In this case, set
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index 2689445..a18996d 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -690,7 +690,7 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
>  	return 0;
>  }
>  
> -static int pvscsi_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +static int pvscsi_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  {
>  	struct Scsi_Host *host = cmd->device->host;
>  	struct pvscsi_adapter *adapter = shost_priv(host);
> @@ -719,6 +719,8 @@ static int pvscsi_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(pvscsi_queue)
> +
>  static int pvscsi_abort(struct scsi_cmnd *cmd)
>  {
>  	struct pvscsi_adapter *adapter = shost_priv(cmd->device->host);
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index b701bf2..5f697e0 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -371,8 +371,8 @@ calc_sync_msg(unsigned int period, unsigned int offset, unsigned int fast,
>  	msg[1] = offset;
>  }
>  
> -int
> -wd33c93_queuecommand(struct scsi_cmnd *cmd,
> +static int
> +wd33c93_queuecommand_lck(struct scsi_cmnd *cmd,
>  		void (*done)(struct scsi_cmnd *))
>  {
>  	struct WD33C93_hostdata *hostdata;
> @@ -468,6 +468,8 @@ wd33c93_queuecommand(struct scsi_cmnd *cmd,
>  	return 0;
>  }
>  
> +DEF_SCSI_QCMD(wd33c93_queuecommand)
> +
>  /*
>   * This routine attempts to start a scsi command. If the host_card is
>   * already connected, we give up immediately. Otherwise, look through
> diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
> index 333580b..db451ae 100644
> --- a/drivers/scsi/wd7000.c
> +++ b/drivers/scsi/wd7000.c
> @@ -1082,7 +1082,7 @@ static irqreturn_t wd7000_intr(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
> +static int wd7000_queuecommand_lck(struct scsi_cmnd *SCpnt,
>  		void (*done)(struct scsi_cmnd *))
>  {
>  	Scb *scb;
> @@ -1139,6 +1139,8 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(wd7000_queuecommand)
> +
>  static int wd7000_diagnostics(Adapter * host, int code)
>  {
>  	static IcbDiag icb = { ICB_OP_DIAGNOSTICS };
> diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> index 41d9acf..defc34a 100644
> --- a/drivers/staging/hv/storvsc_drv.c
> +++ b/drivers/staging/hv/storvsc_drv.c
> @@ -595,7 +595,7 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
>  /*
>   * storvsc_queuecommand - Initiate command processing
>   */
> -static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
> +static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
>  				void (*done)(struct scsi_cmnd *))
>  {
>  	int ret;
> @@ -783,6 +783,8 @@ retry_request:
>  	return ret;
>  }
>  
> +static DEF_SCSI_QCMD(storvsc_queuecommand)
> +
>  static int storvsc_merge_bvec(struct request_queue *q,
>  			      struct bvec_merge_data *bmd, struct bio_vec *bvec)
>  {
> diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
> index a267140..da4f42a 100644
> --- a/drivers/staging/keucr/scsiglue.c
> +++ b/drivers/staging/keucr/scsiglue.c
> @@ -87,7 +87,7 @@ static int slave_configure(struct scsi_device *sdev)
>  
>  /* This is always called with scsi_lock(host) held */
>  //----- queuecommand() ---------------------
> -static int queuecommand(struct scsi_cmnd *srb, void (*done)(struct scsi_cmnd *))
> +static int queuecommand_lck(struct scsi_cmnd *srb, void (*done)(struct scsi_cmnd *))
>  {
>  	struct us_data *us = host_to_us(srb->device->host);
>  
> @@ -117,6 +117,8 @@ static int queuecommand(struct scsi_cmnd *srb, void (*done)(struct scsi_cmnd *))
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(queuecommand)
> +
>  /***********************************************************************
>   * Error handling functions
>   ***********************************************************************/
> diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
> index 5a47805..1197f8b 100644
> --- a/drivers/usb/image/microtek.c
> +++ b/drivers/usb/image/microtek.c
> @@ -573,7 +573,7 @@ mts_build_transfer_context(struct scsi_cmnd *srb, struct mts_desc* desc)
>  
> 
>  static int
> -mts_scsi_queuecommand(struct scsi_cmnd *srb, mts_scsi_cmnd_callback callback)
> +mts_scsi_queuecommand_lck(struct scsi_cmnd *srb, mts_scsi_cmnd_callback callback)
>  {
>  	struct mts_desc* desc = (struct mts_desc*)(srb->device->host->hostdata[0]);
>  	int err = 0;
> @@ -626,6 +626,8 @@ out:
>  	return err;
>  }
>  
> +static DEF_SCSI_QCMD(mts_scsi_queuecommand)
> +
>  static struct scsi_host_template mts_scsi_host_template = {
>  	.module			= THIS_MODULE,
>  	.name			= "microtekX6",
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index a688b1e..689ee1f 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -285,7 +285,7 @@ static int slave_configure(struct scsi_device *sdev)
>  
>  /* queue a command */
>  /* This is always called with scsi_lock(host) held */
> -static int queuecommand(struct scsi_cmnd *srb,
> +static int queuecommand_lck(struct scsi_cmnd *srb,
>  			void (*done)(struct scsi_cmnd *))
>  {
>  	struct us_data *us = host_to_us(srb->device->host);
> @@ -315,6 +315,8 @@ static int queuecommand(struct scsi_cmnd *srb,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(queuecommand)
> +
>  /***********************************************************************
>   * Error handling functions
>   ***********************************************************************/
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 2054b1e..662a363 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -433,7 +433,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
>  	return 0;
>  }
>  
> -static int uas_queuecommand(struct scsi_cmnd *cmnd,
> +static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
>  					void (*done)(struct scsi_cmnd *))
>  {
>  	struct scsi_device *sdev = cmnd->device;
> @@ -491,6 +491,8 @@ static int uas_queuecommand(struct scsi_cmnd *cmnd,
>  	return 0;
>  }
>  
> +static DEF_SCSI_QCMD(uas_queuecommand)
> +
>  static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
>  {
>  	struct scsi_device *sdev = cmnd->device;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index d0a6a84..2b5d474 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -504,6 +504,21 @@ struct scsi_host_template {
>  	u64 vendor_id;
>  };
>  
> +#define DEF_SCSI_QCMD(func_name) \
> +	int func_name (struct scsi_cmnd *cmd,			\
> +		       void (*done)(struct scsi_cmnd *))	\
> +	{								\
> +		unsigned long irq_flags;				\
> +		int rc;							\
> +		struct Scsi_Host *shost = cmd->device->host;		\
> +		spin_lock_irqsave(shost->host_lock, irq_flags);		\
> +		scsi_cmd_get_serial(shost, cmd);			\
> +		rc = func_name##_lck (cmd, done);			\
> +		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
> +		return rc;						\
> +	}
> +
> +
>  /*
>   * shost state: If you alter this, you also need to alter scsi_sysfs.c
>   * (for the ascii descriptions) and the state model enforcer:
> @@ -752,6 +767,7 @@ extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
>  extern void scsi_host_put(struct Scsi_Host *t);
>  extern struct Scsi_Host *scsi_host_lookup(unsigned short);
>  extern const char *scsi_host_state_name(enum scsi_host_state);
> +extern void scsi_cmd_get_serial(struct Scsi_Host *, struct scsi_cmnd *);
>  
>  extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

