From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 32/47] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
Date: Mon, 24 Jul 2017 20:10:19 +0200
Message-ID: <e459fe23-44e8-1149-82b0-2eb794de65d0@linux.vnet.ibm.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-33-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42219 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754323AbdGXSK0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 14:10:26 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6OI9sf5096451
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 14:10:26 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bwfk2jgg2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 14:10:26 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Mon, 24 Jul 2017 19:10:23 +0100
In-Reply-To: <1498638793-44672-33-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On 06/28/2017 10:32 AM, Hannes Reinecke wrote:
> The target reset function should only depend on the scsi target,
> not the scsi command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

>   drivers/s390/scsi/zfcp_scsi.c               | 20 ++++++++++--

>   drivers/scsi/scsi_debug.c                   | 21 ++++---------
>   drivers/scsi/scsi_error.c                   |  5 +--

>   include/scsi/scsi_host.h                    |  2 +-

>   33 files changed, 214 insertions(+), 174 deletions(-)

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index dd7bea0..92a3902 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -309,9 +309,25 @@ static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
>   	return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_LUN_RESET);
>   }
> 
> -static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
> +/*
> + * Note: We need to select a LUN as the storage array doesn't
> + * necessarily supports LUN 0 and might refuse the target reset.
> + */

Do you have any real experience with targets regarding this?

Did you even try this and it failed?
If so, how did it fail?

It seems other drivers hardcode LUN 0 for target reset [see below].

At least you made a similar loop to search for a suitable "victim" 
scsi_device with some other driver changes below, so zfcp is not the 
only one.

In fact, this is one of my open questions in my own patch set:
Is the TMF flag in the FCP_CMND IU sufficient or does the transmission 
path require a valid FCP_LUN also in the same IU even for a target reset.

> +static int zfcp_scsi_eh_target_reset_handler(struct scsi_target *starget)
>   {
> -	return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_TGT_RESET);
> +	struct fc_rport *rport = starget_to_rport(starget);
> +	struct Scsi_Host *shost = rport_to_shost(rport);
> +	struct scsi_device *sdev = NULL, *tmp_sdev;
> +

In "[PATCH 09/47] zfcp: open-code fc_block_scsi_eh() for host reset" you 
introduced a shost lock, but here you did not?

Does the midlayer already hold an shost lock when calling any of these 
eh callbacks?

Not sure if that's the corresponding part of 
Documentation/scsi/scsi_eh.txt (but even if, I don't understand who's 
supposed to have the shost lock):
> [2-1-2] Flow of scmds through EH
>  2. EH starts
>     ACTION: move all scmds to EH's local eh_work_q.  shost->eh_cmd_q
> 	    is cleared.
>     LOCKING: shost->host_lock (not strictly necessary, just for
>              consistency)
> [2-2-3] Things to consider
>  - For consistency, when accessing/modifying shost data structure,
>    grab shost->host_lock.


> +	shost_for_each_device(tmp_sdev, shost) {
> +		if (tmp_sdev->id == starget->id) {
> +			sdev = tmp_sdev;
> +			break;
> +		}
> +	}
> +	if (!sdev)
> +		return FAILED;
> +	return zfcp_task_mgmt_function(sdev, FCP_TMF_TGT_RESET);
>   }

Ah, this "solves" the problem of needing a scsi_device even though we 
only get scsi_target as scope argument.

> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 107c0f6..573bd43 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -5226,16 +5226,16 @@ void lpfc_poll_timeout(unsigned long ptr)
>    *  0x2002 - Success
>    **/
>   static int
> -lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
> +lpfc_target_reset_handler(struct scsi_target *starget)
>   {
> -	struct Scsi_Host  *shost = cmnd->device->host;
> +	struct fc_rport *rport = starget_to_rport(starget);
> +	struct Scsi_Host  *shost = rport_to_shost(rport);
>   	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>   	struct lpfc_rport_data *rdata;
>   	struct lpfc_nodelist *pnode;
> -	unsigned tgt_id = cmnd->device->id;
> -	uint64_t lun_id = cmnd->device->lun;
> +	unsigned tgt_id = starget->id;
> +	uint64_t lun_id = 0;



> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index f990ab4d..db40ddf 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c

> @@ -4038,42 +4040,43 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)

> +	shost_for_each_device(sdev, shost) {
> +		if (!sdev->hostdata)
> +			continue;
> +		mr_device_priv_data = sdev->hostdata;
> +		if (mr_device_priv_data->is_tm_capable) {
> +			devhandle = megasas_get_tm_devhandle(sdev);
> +			break;
> +		}
> +	}
> +

> -	devhandle = megasas_get_tm_devhandle(scmd->device);

>   	ret = megasas_issue_tm(instance, devhandle,
> -			scmd->device->channel, scmd->device->id, 0,
> +			starget->channel, starget->id, 0,
>   			MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET);

The called function seems to internally have hardcoded LUN 0:

static int
megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
	uint channel, uint id, u16 smid_task, u8 type)
{
...
	mpi_request->LUN[1] = 0;

> -static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
> +static int pmcraid_eh_target_reset_handler(struct scsi_target *starget)
>   {
> -	scmd_printk(KERN_INFO, scmd,
> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	struct scsi_device *scsi_dev = NULL, *tmp;
> +
> +	shost_for_each_device(tmp, shost) {
> +		if ((tmp->channel == starget->channel) &&
> +		    (tmp->id == starget->id)) {
> +			scsi_dev = tmp;
> +			break;
> +		}
> +	}
> +	if (!scsi_dev)
> +		return FAILED;
> +	sdev_printk(KERN_INFO, scsi_dev,
>   		    "Doing target reset due to an I/O command timeout.\n");
> -	return pmcraid_reset_device(scmd->device,
> +	return pmcraid_reset_device(scsi_dev,
>   				    PMCRAID_INTERNAL_TIMEOUT,
>   				    RESET_DEVICE_TARGET);
>   }



> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1e89598..37e511f 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3809,39 +3809,30 @@ static int scsi_debug_device_reset(struct scsi_cmnd * SCpnt)
>   	return SUCCESS;
>   }
> 
> -static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
> +static int scsi_debug_target_reset(struct scsi_target *starget)
>   {
> +	struct Scsi_Host *hp = dev_to_shost(&starget->dev);

> -	if (!hp)
> -		goto lie;

Does dev_to_shost(&starget->dev) in this particular case always return 
!=NULL?
I would hope that starget always has an shost as some ancestor in driver 
core.

Other than that question, the scsi_debug change looks good.

(Although I don't understand how this function actually triggers the 
forgetting of pending requests on the scope in addition to setting the 
unit attention bit, but then again I'm not familiar with scsi_debug 
internals.)

> +		starget_printk(KERN_INFO, starget, "%s\n", __func__);
>   	sdbg_host = *(struct sdebug_host_info **)shost_priv(hp);
>   	if (sdbg_host) {
>   		list_for_each_entry(devip,
>   				    &sdbg_host->dev_info_list,
>   				    dev_list)
> -			if (devip->target == sdp->id) {
> +			if (devip->target == starget->id) {
>   				set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
>   				++k;
>   			}
>   	}
>   	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
> -		sdev_printk(KERN_INFO, sdp,
> +		starget_printk(KERN_INFO, starget,
>   			    "%s: %d device(s) found in target\n", __func__, k);
> -lie:
> +
>   	return SUCCESS;
>   }
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 9dd51ed..368a961 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -810,14 +810,15 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
>   	int rtn;
>   	struct Scsi_Host *host = scmd->device->host;
>   	struct scsi_host_template *hostt = host->hostt;
> +	struct scsi_target *starget = scsi_target(scmd->device);
> 
>   	if (!hostt->eh_target_reset_handler)
>   		return FAILED;
> 
> -	rtn = hostt->eh_target_reset_handler(scmd);
> +	rtn = hostt->eh_target_reset_handler(starget);
>   	if (rtn == SUCCESS) {
>   		spin_lock_irqsave(host->host_lock, flags);
> -		__starget_for_each_device(scsi_target(scmd->device), NULL,
> +		__starget_for_each_device(starget, NULL,
>   					  __scsi_report_device_reset);
>   		spin_unlock_irqrestore(host->host_lock, flags);
>   	}

looks good

> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 0c5ce78..33bc523 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -146,7 +146,7 @@ struct scsi_host_template {
>   	 */
>   	int (* eh_abort_handler)(struct scsi_cmnd *);
>   	int (* eh_device_reset_handler)(struct scsi_cmnd *);
> -	int (* eh_target_reset_handler)(struct scsi_cmnd *);
> +	int (* eh_target_reset_handler)(struct scsi_target *);
>   	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
>   	int (* eh_host_reset_handler)(struct Scsi_Host *);
> 

looks good



-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
