From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC PATCH] SCSI host lock push-down
Date: Sun, 07 Nov 2010 10:24:02 +0200
Message-ID: <4CD66222.5040808@panasas.com>
References: <20101105002409.GA21714@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20101105002409.GA21714@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/05/2010 02:24 AM, Jeff Garzik wrote:
> 
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

Well now isn't that simple? One nit for me though.
I would like to see a more scary name for above something like:
DEF_SCSI_QCMD_WITH_LOCKING or
DEF_SCSI_QCMD_OLD_WAY

Something that calls for a cleanup and removal the first time
the driver is touched.

Otherwise I think this is the only form that should make it safe
for this Kernel.

(The rename could be nice also though it is one additional hunk in
 each driver. Did you use a script to produce this?)

Thanks
Boaz

<snip>

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

