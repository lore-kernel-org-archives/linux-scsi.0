From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 46/47] scsi: Move eh_device_reset_handler() to use
 scsi_device as argument
Date: Mon, 24 Jul 2017 20:42:56 +0200
Message-ID: <2c33b11b-5a1d-f61f-720d-7356f503f292@linux.vnet.ibm.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-47-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36570 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754799AbdGXSnE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 14:43:04 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6OIcak0101308
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 14:43:03 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bwkyxen2v-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 14:43:03 -0400
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Mon, 24 Jul 2017 19:43:01 +0100
In-Reply-To: <1498638793-44672-47-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

sparse review comments below...

On 06/28/2017 10:33 AM, Hannes Reinecke wrote:
> When resetting a device we shouldn't depend on an existing SCSI
> device, so use 'struct scsi_device' as argument for
> eh_device_reset_handler().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   Documentation/scsi/scsi_eh.txt                  |  2 +-
>   Documentation/scsi/scsi_mid_low_api.txt         |  4 +--

>   drivers/s390/scsi/zfcp_scsi.c                   |  4 +--

>   drivers/scsi/scsi_debug.c                       | 18 ++++++-------
>   drivers/scsi/scsi_error.c                       | 35 +++++++++++++++++--------

>   include/scsi/scsi_host.h                        |  2 +-
>   60 files changed, 287 insertions(+), 307 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
> index cb9f4bc22..f8a6566 100644
> --- a/Documentation/scsi/scsi_eh.txt
> +++ b/Documentation/scsi/scsi_eh.txt
> @@ -206,7 +206,7 @@ hostt EH callbacks.  Callbacks may be omitted and omitted ones are
>   considered to fail always.
> 
>   int (* eh_abort_handler)(struct scsi_cmnd *);
> -int (* eh_device_reset_handler)(struct scsi_cmnd *);
> +int (* eh_device_reset_handler)(struct scsi_device *);
>   int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
>   int (* eh_host_reset_handler)(struct Scsi_Host *);
> 
> diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
> index e2609a63..28dc029 100644
> --- a/Documentation/scsi/scsi_mid_low_api.txt
> +++ b/Documentation/scsi/scsi_mid_low_api.txt
> @@ -874,7 +874,7 @@ Details:
> 
>   /**
>    *      eh_device_reset_handler - issue SCSI device reset
> - *      @scp: identifies SCSI device to be reset
> + *      @sdev: identifies SCSI device to be reset
>    *
>    *      Returns SUCCESS if command aborted else FAILED
>    *
> @@ -887,7 +887,7 @@ Details:
>    *
>    *      Optionally defined in: LLD
>    **/
> -     int eh_device_reset_handler(struct scsi_cmnd * scp)
> +     int eh_device_reset_handler(struct scsi_device * sdev)
> 
> 
>   /**


> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 92a3902..23b5a7d 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -304,9 +304,9 @@ static int zfcp_task_mgmt_function(struct scsi_device *sdev, u8 tm_flags)
>   	return retval;
>   }
> 
> -static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
> +static int zfcp_scsi_eh_device_reset_handler(struct scsi_device *sdev)
>   {
> -	return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_LUN_RESET);
> +	return zfcp_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
>   }
> 
>   /*


> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 37e511f..9029500 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3793,19 +3793,17 @@ static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
>   	return SUCCESS;
>   }
> 
> -static int scsi_debug_device_reset(struct scsi_cmnd * SCpnt)
> +static int scsi_debug_device_reset(struct scsi_device * sdp)
>   {
> +	struct sdebug_dev_info *devip =
> +		(struct sdebug_dev_info *)sdp->hostdata;
> +
>   	++num_dev_resets;
> -	if (SCpnt && SCpnt->device) {
> -		struct scsi_device *sdp = SCpnt->device;
> -		struct sdebug_dev_info *devip =
> -				(struct sdebug_dev_info *)sdp->hostdata;
> 
> -		if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
> -			sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
> -		if (devip)
> -			set_bit(SDEBUG_UA_POR, devip->uas_bm);
> -	}
> +	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
> +		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
> +	if (devip)
> +		set_bit(SDEBUG_UA_POR, devip->uas_bm);
>   	return SUCCESS;
>   }
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 368a961..4a7fe97f 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -844,7 +844,7 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
>   	if (!hostt->eh_device_reset_handler)
>   		return FAILED;
> 
> -	rtn = hostt->eh_device_reset_handler(scmd);
> +	rtn = hostt->eh_device_reset_handler(scmd->device);
>   	if (rtn == SUCCESS)
>   		__scsi_report_device_reset(scmd->device, NULL);
>   	return rtn;

up to here it looks good,
however ...

> @@ -1106,6 +1106,7 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
>    * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.

__scsi_eh_finish_cmd  ?

>    * @scmd:	Original SCSI cmd that eh has finished.
>    * @done_q:	Queue for processed commands.
> + * @result:	Final command status to be set
>    *
>    * Notes:
>    *    We don't want to use the normal command completion while we are are

Did this hunk slip in accidentally?
I don't see a new additional argument result being introduced with 
either the new __scsi_eh_finish_cmd() nor the old scsi_eh_finish_cmd().
However, the former __scsi_eh_finish_cmd() seems to have an additional 
argument @host_byte:. Maybe that should go where @result: is above, 
because the old kernel doc now belongs to the new __scsi_eh_finish_cmd().

But then you'd also need to change the function name in the kernel doc?!

> @@ -1114,10 +1115,18 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
>    *    keep a list of pending commands for final completion, and once we
>    *    are ready to leave error handling we handle completion for real.
>    */
> -void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
> +void __scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q,
> +			int host_byte)

Should new internal helper function be declared static?

>   {
> +	if (host_byte)
> +		set_host_byte(scmd, host_byte);
>   	list_move_tail(&scmd->eh_entry, done_q);
>   }
> +
> +void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
> +{
> +	__scsi_eh_finish_cmd(scmd, done_q, 0);
> +}
>   EXPORT_SYMBOL(scsi_eh_finish_cmd);
> 
>   /**
> @@ -1284,7 +1293,8 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
>   				if (finish_cmds &&
>   				    (try_stu ||
>   				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
> -					scsi_eh_finish_cmd(scmd, done_q);
> +					__scsi_eh_finish_cmd(scmd, done_q,
> +							     DID_RESET);
>   				else
>   					list_move_tail(&scmd->eh_entry, work_q);
>   			}
> @@ -1429,8 +1439,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
>   							 work_q, eh_entry) {
>   					if (scmd->device == sdev &&
>   					    scsi_eh_action(scmd, rtn) != FAILED)
> -						scsi_eh_finish_cmd(scmd,
> -								   done_q);
> +						__scsi_eh_finish_cmd(scmd,
> +								     done_q,
> +								     DID_RESET);
>   				}
>   			}
>   		} else {
> @@ -1498,7 +1509,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
>   			if (rtn == SUCCESS)
>   				list_move_tail(&scmd->eh_entry, &check_list);
>   			else if (rtn == FAST_IO_FAIL)
> -				scsi_eh_finish_cmd(scmd, done_q);
> +				__scsi_eh_finish_cmd(scmd, done_q,
> +						     DID_TRANSPORT_DISRUPTED);
>   			else
>   				/* push back on work queue for further processing */
>   				list_move(&scmd->eh_entry, work_q);
> @@ -1563,8 +1575,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
>   			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>   				if (channel == scmd_channel(scmd)) {
>   					if (rtn == FAST_IO_FAIL)
> -						scsi_eh_finish_cmd(scmd,
> -								   done_q);
> +						__scsi_eh_finish_cmd(scmd,
> +								     done_q,
> +								     DID_TRANSPORT_DISRUPTED);
>   					else
>   						list_move_tail(&scmd->eh_entry,
>   							       &check_list);
> @@ -1607,9 +1620,9 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
>   		if (rtn == SUCCESS) {
>   			list_splice_init(work_q, &check_list);
>   		} else if (rtn == FAST_IO_FAIL) {
> -			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
> -					scsi_eh_finish_cmd(scmd, done_q);
> -			}
> +			list_for_each_entry_safe(scmd, next, work_q, eh_entry)
> +				__scsi_eh_finish_cmd(scmd, done_q,
> +						     DID_TRANSPORT_DISRUPTED);

I can somewhat imagine why you set DID_TRANSPORT_DISRUPTED for the cases 
above where the eh callback told us FAST_IO_FAIL.
However, here you (now) seem to do it unconditionally. As a result this 
seems to render all attempts to return either a proper FAST_IO_FAIL or 
SUCCESS from a host_reset_handler() futile?

>   		} else {
>   			SCSI_LOG_ERROR_RECOVERY(3,
>   				shost_printk(KERN_INFO, shost,

How is this related to just changing the callback argument?

Haven't we previously set the host_byte to anything?

Is the above part rather an independent change or even fix which should 
live in a separate topical commit explaining why and what it does?

(I don't understand especially the DID_RESET cases.)


> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 8b93197..bc97e41 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -681,26 +681,26 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>   	return ret;
>   }
> 
> -static int virtscsi_device_reset(struct scsi_cmnd *sc)
> +static int virtscsi_device_reset(struct scsi_device *sdev)
>   {
> -	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
> +	struct virtio_scsi *vscsi = shost_priv(sdev->host);
>   	struct virtio_scsi_cmd *cmd;
> 
> -	sdev_printk(KERN_INFO, sc->device, "device reset\n");
> +	sdev_printk(KERN_INFO, sdev, "device reset\n");
>   	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
>   	if (!cmd)
>   		return FAILED;
> 
>   	memset(cmd, 0, sizeof(*cmd));
> -	cmd->sc = sc;
> +	cmd->sc = NULL;

I hope we are protected to never land in virtscsi_complete_cmd() with 
cmd->sc==NULL, not even e.g. if the virtio queue gets hot unplugged the 
hard way in parallel (forcing some completion to drain).
I'm thinking of commit 773c7220e22d193e5667c352fcbf8d47eefc817f
("scsi: virtio_scsi: Reject commands when virtqueue is broken").

>   	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
>   		.type = VIRTIO_SCSI_T_TMF,
>   		.subtype = cpu_to_virtio32(vscsi->vdev,
>   					     VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET),
>   		.lun[0] = 1,
> -		.lun[1] = sc->device->id,
> -		.lun[2] = (sc->device->lun >> 8) | 0x40,
> -		.lun[3] = sc->device->lun & 0xff,
> +		.lun[1] = sdev->id,
> +		.lun[2] = (sdev->lun >> 8) | 0x40,
> +		.lun[3] = sdev->lun & 0xff,
>   	};
>   	return virtscsi_tmf(vscsi, cmd);
>   }


> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 33bc523..7095076 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -145,7 +145,7 @@ struct scsi_host_template {
>   	 * Status: REQUIRED	(at least one of them)
>   	 */
>   	int (* eh_abort_handler)(struct scsi_cmnd *);
> -	int (* eh_device_reset_handler)(struct scsi_cmnd *);
> +	int (* eh_device_reset_handler)(struct scsi_device *);
>   	int (* eh_target_reset_handler)(struct scsi_target *);
>   	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
>   	int (* eh_host_reset_handler)(struct Scsi_Host *);
> 

anything else, that I quoted but did not comment, looks good


-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
