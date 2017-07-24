From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 24/47] zfcp: use scsi device as argument for
 zfcp_task_mgmt_function()
Date: Mon, 24 Jul 2017 19:15:13 +0200
Message-ID: <10b400c6-aa86-05d4-e3c7-d9676eaa409c@linux.vnet.ibm.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-25-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754741AbdGXRPW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 13:15:22 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6OHDX8D031592
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 13:15:22 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bwegftvt7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 13:15:19 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Mon, 24 Jul 2017 18:15:17 +0100
In-Reply-To: <1498638793-44672-25-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>



On 06/28/2017 10:32 AM, Hannes Reinecke wrote:
> zfcp_task_mgmt_function() is only used for lun and device reset,
> so it should be using the scsi device as an argument, not the
> scsi command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/s390/scsi/zfcp_ext.h  |  2 +-
>   drivers/s390/scsi/zfcp_fc.h   |  9 +--------
>   drivers/s390/scsi/zfcp_fsf.c  | 21 +++++++++++----------
>   drivers/s390/scsi/zfcp_scsi.c | 12 ++++++------
>   4 files changed, 19 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
> index 57f1d4a..64d4db7 100644
> --- a/drivers/s390/scsi/zfcp_ext.h
> +++ b/drivers/s390/scsi/zfcp_ext.h
> @@ -117,7 +117,7 @@ extern int zfcp_fsf_send_els(struct zfcp_adapter *, u32,
>   			     struct zfcp_fsf_ct_els *, unsigned int);
>   extern int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *);
>   extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
> -extern struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *, u8);
> +extern struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_device *, u8);
>   extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *);
>   extern void zfcp_fsf_reqid_check(struct zfcp_qdio *, int);
> 
> diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
> index df2b541..f08eaf9 100644
> --- a/drivers/s390/scsi/zfcp_fc.h
> +++ b/drivers/s390/scsi/zfcp_fc.h
> @@ -206,19 +206,12 @@ struct zfcp_fc_wka_ports {
>    * zfcp_fc_scsi_to_fcp - setup FCP command with data from scsi_cmnd
>    * @fcp: fcp_cmnd to setup
>    * @scsi: scsi_cmnd where to get LUN, task attributes/flags and CDB
> - * @tm: task management flags to setup task management command
>    */
>   static inline
> -void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi,
> -			 u8 tm_flags)
> +void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi)
>   {
>   	int_to_scsilun(scsi->device->lun, (struct scsi_lun *) &fcp->fc_lun);
> 
> -	if (unlikely(tm_flags)) {
> -		fcp->fc_tm_flags = tm_flags;
> -		return;
> -	}
> -
>   	fcp->fc_pri_ta = FCP_PTA_SIMPLE;
> 
>   	if (scsi->sc_data_direction == DMA_FROM_DEVICE)

When I wrote my zfcp decoupling patch series I did a lot of git history 
research in order to double check if my changes are OK.

Here, I figured that I'd like to separately revert commit 2443c8b23aea 
("[SCSI] zfcp: Merge FCP task management setup with regular FCP command 
setup"), because this introduced a dependency on the unsuitable SCSI 
command for scsi_eh / TMF. Even though it was one of the first commits I 
posted upstream as newbie zfcp maintainer... little did I know.

> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index 27ff38f..c4bd3d4 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -2036,10 +2036,9 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)

> -static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req)
> +static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req,
> +					struct scsi_device *sdev)


> @@ -2120,7 +2119,7 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)

> -	zfcp_fsf_fcp_handler_common(req);
> +	zfcp_fsf_fcp_handler_common(req, scpnt->device);

> @@ -2296,8 +2295,9 @@ static void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)
>   {

> +	struct scsi_device *sdev = req->data;
> 
> -	zfcp_fsf_fcp_handler_common(req);
> +	zfcp_fsf_fcp_handler_common(req, sdev);

Moving the resolving of req->data into the callers of 
zfcp_fsf_fcp_handler_common() I did the same way in my own patch series.

> @@ -2313,12 +2313,12 @@ static void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)

> -struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
> +struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_device *sdev,
>   					    u8 tm_flags)

> @@ -2338,7 +2338,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,

> -	req->data = scmnd;
> +	req->data = sdev;

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 5fada93..dd7bea0 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -259,17 +259,17 @@ static void zfcp_scsi_forget_cmnds(struct zfcp_scsi_dev *zsdev, u8 tm_flags)

> -static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
> +static int zfcp_task_mgmt_function(struct scsi_device *sdev, u8 tm_flags)
>   {
> -	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
> +	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
>   	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
> -	struct fc_port *rport = zfcp_sdev->port->rport;

This smells very odd: fc_port instead of fc_*r*port.
Looks like this was introduced buggy in "[PATCH 15/47] 
scsi_transport_fc: Use fc_rport as argument for fc_block_scsi_eh" and 
should be avoided for bisectability.

> +	struct fc_rport *rport = zfcp_sdev->port->rport;

> -		fsf_req = zfcp_fsf_fcp_task_mgmt(scpnt, tm_flags);
> +		fsf_req = zfcp_fsf_fcp_task_mgmt(sdev, tm_flags);

>   static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
>   {
> -	return zfcp_task_mgmt_function(scpnt, FCP_TMF_LUN_RESET);
> +	return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_LUN_RESET);
>   }
> 
>   static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>   {
> -	return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
> +	return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_TGT_RESET);
>   }

Won't the target_reset_handler eventually have scsi_target as argument 
and thus we will not have any particular scsi_device to pass anymore 
later in the patch set?

In my patch series, I replaced scsi_cmnd with a mandatory zfcp_port and 
an optional(!) scsi_device for the TMF call chains in zfcp.
I thought scsi_device must be optional because it only exists for LUN 
reset but not for target reset.
Does this make sense?

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
