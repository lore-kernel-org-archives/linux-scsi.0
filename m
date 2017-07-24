From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 15/47] scsi_transport_fc: Use fc_rport as argument for
 fc_block_scsi_eh
Date: Mon, 24 Jul 2017 18:34:06 +0200
Message-ID: <2e811ad2-4dd2-f010-9794-2d00f0f49778@linux.vnet.ibm.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-16-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752492AbdGXQeN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 12:34:13 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6OGT5B7063235
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 12:34:12 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bwegfs9qp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 12:34:12 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Mon, 24 Jul 2017 17:34:10 +0100
In-Reply-To: <1498638793-44672-16-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


On 06/28/2017 10:32 AM, Hannes Reinecke wrote:
> fc_block_scsi_eh() works on a remote port, so we should be using
> that as an argument, and not the scsi command.

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index d7d4a63..e3160fc 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -150,6 +150,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
>   	struct zfcp_adapter *adapter =
>   		(struct zfcp_adapter *) scsi_host->hostdata[0];
>   	struct zfcp_fsf_req *old_req, *abrt_req;
> +	struct fc_rport *rport = starget_to_rport(scsi_target(scpnt->device));
>   	unsigned long flags;
>   	unsigned long old_reqid = (unsigned long) scpnt->host_scribble;
>   	int retval = SUCCESS, ret;
> @@ -176,7 +177,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
>   			break;
> 
>   		zfcp_erp_wait(adapter);
> -		ret = fc_block_scsi_eh(scpnt);
> +		ret = fc_block_scsi_eh(rport);

I think for abort handlers some original fc_block_scsi_eh with scsi_cmnd 
as argument would be perfectly valid as this really has the scope of a 
particular single command.

Do you really want to touch all abort handlers just because of this?

In my zfcp decoupling I had created a new fc_block_rport for 
TMFs/host_reset and kept using the old fc_block_scsi_eh (which does the 
argument lifting and simply delegates to the new fc_block_rport) for the 
abort handler.
Admittedly, of course, I also did so because I did not touch all other 
users/callers of the old function with the scsi_cmnd argument.

>   		if (ret) {
>   			zfcp_dbf_scsi_abort("abrt_bl", scpnt, NULL);
>   			return ret;
> @@ -262,6 +263,7 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
>   {
>   	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
>   	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
> +	struct fc_port *rport = zfcp_sdev->port->rport;

port->rport could be NULL

[async zfcp_scsi_rport_block()]

>   	struct zfcp_fsf_req *fsf_req = NULL;
>   	int retval = SUCCESS, ret;
>   	int retry = 3;
> @@ -272,7 +274,7 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
>   			break;
> 
>   		zfcp_erp_wait(adapter);
> -		ret = fc_block_scsi_eh(scpnt);
> +		ret = fc_block_scsi_eh(rport);
>   		if (ret)
>   			return ret;
> 

> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 6dd0922..f83e512 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3273,7 +3273,7 @@ struct fc_rport *
> 
>   /**
>    * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
> - * @cmnd: SCSI command that scsi_eh is trying to recover
> + * @rport: remote port to be checked
>    *
>    * This routine can be called from a FC LLD scsi_eh callback. It
>    * blocks the scsi_eh thread until the fc_rport leaves the
> @@ -3285,10 +3285,9 @@ struct fc_rport *
>    *	    FAST_IO_FAIL if the fast_io_fail_tmo fired, this should be
>    *	    passed back to scsi_eh.
>    */
> -int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
> +int fc_block_scsi_eh(struct fc_rport *rport)
>   {
> -	struct Scsi_Host *shost = cmnd->device->host;
> -	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
> +	struct Scsi_Host *shost = rport_to_shost(rport);
>   	unsigned long flags;
> 
>   	spin_lock_irqsave(shost->host_lock, flags);
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> index e308cd5..5b26943 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -804,7 +804,7 @@ void fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
>   struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
>   		struct fc_vport_identifiers *);
>   int fc_vport_terminate(struct fc_vport *vport);
> -int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
> +int fc_block_scsi_eh(struct fc_rport *rport);
>   enum blk_eh_timer_return fc_eh_timed_out(struct scsi_cmnd *scmd);
> 
>   static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job *job)
> 

Aside from above thoughts, the coding of the argument change seems good.


-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
