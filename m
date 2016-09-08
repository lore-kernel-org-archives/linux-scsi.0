From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: squash lines for simple wrapper functions
Date: Thu, 8 Sep 2016 15:41:34 +0200
Message-ID: <20160908134134.7cqbb2kdmxnu5ogl@c203.arch.suse.de>
References: <1473201538-17637-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473201538-17637-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Hannes Reinicke <hare@suse.de>, Uday Lingala <uday.lingala@avagotech.com>, lindar_liu@usish.com, Tomas Henzl <thenzl@redhat.com>, Sumit Saxena <sumit.saxena@avagotech.com>, MPT-FusionLinux.pdl@broadcom.com, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Hannes Reinecke <hare@suse.com>, Jack Wang <jinpu.wang@profitbricks.com>, James Smart <james.smart@avagotech.com>, Ching Huang <ching2048@areca.com.tw>, Benny Halevy <bhalevy@primarydata.com>, megaraidlinux.pdl@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 07, 2016 at 07:38:58AM +0900, Masahiro Yamada wrote:
> Remove unneeded variables and assignments.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
> 
>  drivers/scsi/aic7xxx/aic79xx_osm.c  |  6 +-----
>  drivers/scsi/arcmsr/arcmsr_hba.c    |  4 +---
>  drivers/scsi/esas2r/esas2r_ioctl.c  | 20 ++++++++------------
>  drivers/scsi/lpfc/lpfc_attr.c       |  8 ++------
>  drivers/scsi/lpfc/lpfc_ct.c         |  6 +-----
>  drivers/scsi/lpfc/lpfc_scsi.c       |  5 +----
>  drivers/scsi/lpfc/lpfc_sli.c        |  5 +----
>  drivers/scsi/megaraid/megaraid_mm.c |  6 +-----
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 30 ++++++++++--------------------
>  drivers/scsi/osd/osd_initiator.c    |  5 +----
>  drivers/scsi/pm8001/pm8001_ctl.c    | 10 ++--------
>  drivers/scsi/sg.c                   | 10 +++-------
>  12 files changed, 32 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index 2588b8f..1169e85 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -767,11 +767,7 @@ ahd_linux_biosparam(struct scsi_device *sdev, struct block_device *bdev,
>  static int
>  ahd_linux_abort(struct scsi_cmnd *cmd)
>  {
> -	int error;
> -	
> -	error = ahd_linux_queue_abort_cmd(cmd);
> -
> -	return error;
> +	return ahd_linux_queue_abort_cmd(cmd);
>  }
>  
>  /*

I think here the whole wrapper can be deleted. It's doesn't even change the function signature.

static int ahd_linux_abort(struct scsi_cmnd *cmd)
vs.
static int ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)


> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 7640498..f1c86f5 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -3946,9 +3946,7 @@ sleep:
>  static int arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
>  		struct CommandControlBlock *ccb)
>  {
> -	int rtn;
> -	rtn = arcmsr_polling_ccbdone(acb, ccb);
> -	return rtn;
> +	return arcmsr_polling_ccbdone(acb, ccb);
>  }
>  
>  static int arcmsr_abort(struct scsi_cmnd *cmd)

Ditto.

> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
> index 3e84834..12c6284 100644
> --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> +++ b/drivers/scsi/esas2r/esas2r_ioctl.c
> @@ -373,18 +373,14 @@ static bool csmi_ioctl_tunnel(struct esas2r_adapter *a,
>  
>  static bool check_lun(struct scsi_lun lun)
>  {
> -	bool result;
> -
> -	result = ((lun.scsi_lun[7] == 0) &&
> -		  (lun.scsi_lun[6] == 0) &&
> -		  (lun.scsi_lun[5] == 0) &&
> -		  (lun.scsi_lun[4] == 0) &&
> -		  (lun.scsi_lun[3] == 0) &&
> -		  (lun.scsi_lun[2] == 0) &&
> -/* Byte 1 is intentionally skipped */
> -		  (lun.scsi_lun[0] == 0));
> -
> -	return result;
> +	return (lun.scsi_lun[7] == 0) &&
> +	       (lun.scsi_lun[6] == 0) &&
> +	       (lun.scsi_lun[5] == 0) &&
> +	       (lun.scsi_lun[4] == 0) &&
> +	       (lun.scsi_lun[3] == 0) &&
> +	       (lun.scsi_lun[2] == 0) &&
> +		/* Byte 1 is intentionally skipped */
> +	       (lun.scsi_lun[0] == 0);
>  }
>  
>  static int csmi_ioctl_callback(struct esas2r_adapter *a,

Looks OK.

> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index f101990..79cb019 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -2625,12 +2625,8 @@ lpfc_oas_lun_state_change(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
>  			  uint8_t tgt_wwpn[], uint64_t lun,
>  			  uint32_t oas_state, uint8_t pri)
>  {
> -
> -	int rc;
> -
> -	rc = lpfc_oas_lun_state_set(phba, vpt_wwpn, tgt_wwpn, lun,
> -				    oas_state, pri);
> -	return rc;
> +	return lpfc_oas_lun_state_set(phba, vpt_wwpn, tgt_wwpn, lun,
> +				      oas_state, pri);
>  }
>  
>  /**

static ssize_t lpfc_oas_lun_state_change(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
	       				 uint8_t tgt_wwpn[], uint64_t lun,
					 uint32_t oas_state, uint8_t pri)
vs.
static size_t lpfc_oas_lun_state_set(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
       	      		   	     uint8_t tgt_wwpn[], uint64_t lun,
				     uint32_t oas_state, uint8_t pri)

And only one caller lpfc_oas_lun_store()
				      


> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 63e48d4..383943d 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -188,12 +188,8 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
>  int
>  lpfc_ct_handle_unsol_abort(struct lpfc_hba *phba, struct hbq_dmabuf *dmabuf)
>  {
> -	int handled;
> -
>  	/* CT upper level goes through BSG */
> -	handled = lpfc_bsg_ct_unsol_abort(phba, dmabuf);
> -
> -	return handled;
> +	return lpfc_bsg_ct_unsol_abort(phba, dmabuf);
>  }
>  
>  static void

Ditto, though the comments suggest it's intented.

> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index d197aa1..59188b6 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -2857,10 +2857,7 @@ lpfc_bg_crc(uint8_t *data, int count)
>  static uint16_t
>  lpfc_bg_csum(uint8_t *data, int count)
>  {
> -	uint16_t ret;
> -
> -	ret = ip_compute_csum(data, count);
> -	return ret;
> +	return ip_compute_csum(data, count);
>  }
>  
>  /*

just exchange lpfc_bg_csum() with ip_compute_csum() in lpfc_calc_bg_err().

> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 7080ce2..633b64d 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -624,10 +624,7 @@ __lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xritag)
>  struct lpfc_sglq *
>  __lpfc_get_active_sglq(struct lpfc_hba *phba, uint16_t xritag)
>  {
> -	struct lpfc_sglq *sglq;
> -
> -	sglq =  phba->sli4_hba.lpfc_sglq_active_list[xritag];
> -	return sglq;
> +	return phba->sli4_hba.lpfc_sglq_active_list[xritag];
>  }
>  
>  /**

Looks OK.

> diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
> index 4cf9ed9..2c1df98 100644
> --- a/drivers/scsi/megaraid/megaraid_mm.c
> +++ b/drivers/scsi/megaraid/megaraid_mm.c
> @@ -1242,11 +1242,7 @@ static long
>  mraid_mm_compat_ioctl(struct file *filep, unsigned int cmd,
>  		      unsigned long arg)
>  {
> -	int err;
> -
> -	err = mraid_mm_ioctl(filep, cmd, arg);
> -
> -	return err;
> +	return mraid_mm_ioctl(filep, cmd, arg);
>  }
>  #endif
>

Looks OK.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index 7d00f09..dc0e8e7 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -2355,15 +2355,13 @@ out_unlock_pciaccess:
>  long
>  _ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
> -	long ret;
> -
> -	/* pass MPI25_VERSION | MPI26_VERSION value,
> +	/*
> +	 * pass MPI25_VERSION | MPI26_VERSION value,
>  	 * to indicate that this ioctl cmd
>  	 * came from mpt3ctl ioctl device.
>  	 */
> -	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg, 0,
> -		MPI25_VERSION | MPI26_VERSION);
> -	return ret;
> +	return _ctl_ioctl_main(file, cmd, (void __user *)arg, 0,
> +			       MPI25_VERSION | MPI26_VERSION);
>  }
>  
>  /**

Looks OK

> @@ -2375,13 +2373,11 @@ _ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  long
>  _ctl_mpt2_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
> -	long ret;
> -
> -	/* pass MPI2_VERSION value, to indicate that this ioctl cmd
> +	/*
> +	 * pass MPI2_VERSION value, to indicate that this ioctl cmd
>  	 * came from mpt2ctl ioctl device.
>  	 */
> -	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg, 0, MPI2_VERSION);
> -	return ret;
> +	return _ctl_ioctl_main(file, cmd, (void __user *)arg, 0, MPI2_VERSION);
>  }
>  #ifdef CONFIG_COMPAT
>  /**

Looks OK.

> @@ -2395,11 +2391,8 @@ _ctl_mpt2_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  long
>  _ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
>  {
> -	long ret;
> -
> -	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg, 1,
> -		MPI25_VERSION | MPI26_VERSION);
> -	return ret;
> +	return _ctl_ioctl_main(file, cmd, (void __user *)arg, 1,
> +			       MPI25_VERSION | MPI26_VERSION);
>  }
>  
>  /**

Looks OK.

> @@ -2413,10 +2406,7 @@ _ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
>  long
>  _ctl_mpt2_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
>  {
> -	long ret;
> -
> -	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg, 1, MPI2_VERSION);
> -	return ret;
> +	return _ctl_ioctl_main(file, cmd, (void __user *)arg, 1, MPI2_VERSION);
>  }
>  #endif
>

Looks OK.

> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 2f2a991..86d7092 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -396,11 +396,8 @@ EXPORT_SYMBOL(osd_dev_fini);
>  
>  static struct osd_request *_osd_request_alloc(gfp_t gfp)
>  {
> -	struct osd_request *or;
> -
>  	/* TODO: Use mempool with one saved request */
> -	or = kzalloc(sizeof(*or), gfp);
> -	return or;
> +	return kzalloc(sizeof(struct osd_request), gfp);
>  }
>  
>  static void _osd_request_free(struct osd_request *or)

Looks OK, though I don't see the reason for having
_osd_request_alloc() at all.

> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index be8269c..5bf3cb0 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -456,10 +456,7 @@ static DEVICE_ATTR(iop_log, S_IRUGO, pm8001_ctl_iop_log_show, NULL);
>  static ssize_t pm8001_ctl_fatal_log_show(struct device *cdev,
>  	struct device_attribute *attr, char *buf)
>  {
> -	ssize_t count;
> -
> -	count = pm80xx_get_fatal_dump(cdev, attr, buf);
> -	return count;
> +	return pm80xx_get_fatal_dump(cdev, attr, buf);
>  }
>  
>  static DEVICE_ATTR(fatal_log, S_IRUGO, pm8001_ctl_fatal_log_show, NULL);

One could argue it's not needed but it actually makes the arch a bit
cleaner with the wrapper, so OK.

> @@ -474,10 +471,7 @@ static DEVICE_ATTR(fatal_log, S_IRUGO, pm8001_ctl_fatal_log_show, NULL);
>  static ssize_t pm8001_ctl_gsm_log_show(struct device *cdev,
>  	struct device_attribute *attr, char *buf)
>  {
> -	ssize_t count;
> -
> -	count = pm8001_get_gsm_dump(cdev, SYSFS_OFFSET, buf);
> -	return count;
> +	return pm8001_get_gsm_dump(cdev, SYSFS_OFFSET, buf);
>  }
>  
>  static DEVICE_ATTR(gsm_log, S_IRUGO, pm8001_ctl_gsm_log_show, NULL);

Probably just like the above, haven't checked.

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index ae7d9bd..181dad0 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1129,13 +1129,9 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
>  		return -ENXIO;
>  
>  	sdev = sdp->device;
> -	if (sdev->host->hostt->compat_ioctl) { 
> -		int ret;
> -
> -		ret = sdev->host->hostt->compat_ioctl(sdev, cmd_in, (void __user *)arg);
> -
> -		return ret;
> -	}
> +	if (sdev->host->hostt->compat_ioctl)
> +		return sdev->host->hostt->compat_ioctl(sdev, cmd_in,
> +						       (void __user *)arg);
>  	
>  	return -ENOIOCTLCMD;
>  }
> -- 
> 1.9.1
> 

Looks OK.

For the re-consider cases, please have a look at them and re-send as
individual patches (can be in a series).

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
