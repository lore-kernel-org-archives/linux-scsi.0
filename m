From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Wed, 15 Feb 2017 07:34:54 +0100
Message-ID: <20170215063454.GA15020@lst.de>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54587 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751768AbdBOGe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 01:34:57 -0500
Content-Disposition: inline
In-Reply-To: <20170215021230.11181-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Ram Pai <linuxram@us.ibm.com>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>

Hi Damien,

this looks reasonable, but we should ask Guilherme and Ram to confirm
it fixes their originally reported issue.  I've added them to Cc.

On Wed, Feb 15, 2017 at 11:12:30AM +0900, Damien Le Moal wrote:
> Commit "mpt3sas: Force request partial completion alignment" was not
> considering the case of REQ_TYPE_FS commands not operating on sector
> size units (e.g. REQ_OP_ZONE_REPORT and its 64B aligned partial
> replies). This could result is incorrectly retrying (forever) those
> commands.
> 
> Move the partial completion alignement check of mpt3sas to a generic
> implementation in sd_done so that the check comes after good_bytes and
> resid corrections done in that function depending on the request
> command. The check is added to the initial command switch so that
> commands with special payload size handling are ignored.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> 
> ---
> 
> Changes from v3:
> - Moved check to initial switch-case so that commands with special payload
>   handling are ignored.
> 
> Changes from v2:
> - Fixed good_bytes calculation after correction of unaligned resid
>   It should be good_bytes=scsi_buflen() - resid, and not good_bytes-=resid
> 
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 ---------------
>  drivers/scsi/sd.c                    | 20 ++++++++++++++++++++
>  2 files changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 0b5b423..1961535 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -4658,7 +4658,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>  	struct MPT3SAS_DEVICE *sas_device_priv_data;
>  	u32 response_code = 0;
>  	unsigned long flags;
> -	unsigned int sector_sz;
>  
>  	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
>  	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
> @@ -4717,20 +4716,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>  	}
>  
>  	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
> -
> -	/* In case of bogus fw or device, we could end up having
> -	 * unaligned partial completion. We can force alignment here,
> -	 * then scsi-ml does not need to handle this misbehavior.
> -	 */
> -	sector_sz = scmd->device->sector_size;
> -	if (unlikely(scmd->request->cmd_type == REQ_TYPE_FS && sector_sz &&
> -		     xfer_cnt % sector_sz)) {
> -		sdev_printk(KERN_INFO, scmd->device,
> -		    "unaligned partial completion avoided (xfer_cnt=%u, sector_sz=%u)\n",
> -			    xfer_cnt, sector_sz);
> -		xfer_cnt = round_down(xfer_cnt, sector_sz);
> -	}
> -
>  	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
>  	if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
>  		log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1f5d92a..d05a328 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1790,6 +1790,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  {
>  	int result = SCpnt->result;
>  	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
> +	unsigned int sector_size = SCpnt->device->sector_size;
> +	unsigned int resid;
>  	struct scsi_sense_hdr sshdr;
>  	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
>  	struct request *req = SCpnt->request;
> @@ -1820,6 +1822,24 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  			scsi_set_resid(SCpnt, blk_rq_bytes(req));
>  		}
>  		break;
> +	default:
> +		/*
> +	 	 * In case of bogus fw or device, we could end up having
> +	 	 * an unaligned partial completion. Check this here and force
> +	 	 * alignment.
> +	 	 */
> +		resid = scsi_get_resid(SCpnt);
> +		if (resid & (sector_size - 1)) {
> +			SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
> +				"Unaligned partial completion (resid=%u, sector_sz=%u)\n",
> +				resid, sector_size));
> +			resid = round_up(resid, sector_size);
> +			if (resid < good_bytes)
> +				good_bytes -= resid;
> +			else
> +				good_bytes = 0;
> +			scsi_set_resid(SCpnt, resid);
> +		}
>  	}
>  
>  	if (result) {
> -- 
> 2.9.3
> 
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
> 
> This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
---end quoted text---
