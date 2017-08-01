From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [RFC 2/9] zfcp: decouple TMF response handler from scsi_cmnd
Date: Tue, 1 Aug 2017 18:22:42 +0200
Message-ID: <6b6c0415-2d56-95c4-2109-7342d4346037@linux.vnet.ibm.com>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-3-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751676AbdHAQWs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 12:22:48 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v71GLRZH019608
        for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2017 12:22:48 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2c2t95sdu3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2017 12:22:47 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 1 Aug 2017 17:22:45 +0100
In-Reply-To: <20170725141427.35258-3-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

Just for the records, in case anyone wants to resurrect this later on:
This patch is buggy.

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> Do not get scsi_device via req->data any more, but pass an optional(!)
> scsi_device to zfcp_fsf_fcp_handler_common(). The latter must now guard
> any access to scsi_device as it can be NULL.
> 
> Since we always have at least a zfcp port as scope, pass this as mandatory
> argument to zfcp_fsf_fcp_handler_common() because we cannot get it through
> scsi_device => zfcp_scsi_dev => port any more.
> 
> Hence, the callers of zfcp_fsf_fcp_handler_common() must resolve req->data.
> 
> TMF handling now has different context data in fsf_req->data
> depending on the TMF scope in fcp_cmnd->fc_tm_flags:
> * scsi_device if FCP_TMF_LUN_RESET,
> * zfcp_port if FCP_TMF_TGT_RESET.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>   drivers/s390/scsi/zfcp_fsf.c | 72 ++++++++++++++++++++++++++++----------------
>   1 file changed, 46 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index 69d1dc3ec79d..8b2b2ea552d6 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c

> @@ -2296,10 +2304,21 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
> 
>   static void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)
>   {
> +	struct fcp_cmnd *fcp_cmnd;
> +	struct zfcp_port *port;
> +	struct scsi_device *sdev;
>   	struct fcp_resp_with_ext *fcp_rsp;
>   	struct fcp_resp_rsp_info *rsp_info;
> 
> -	zfcp_fsf_fcp_handler_common(req);
> +	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;
> +	if (fcp_cmnd->fc_tm_flags & FCP_TMF_LUN_RESET) {
> +		sdev = req->data;
> +		port = sdev_to_zfcp(sdev)->port;

Below described bug causes, in case of a LUN reset, a wrong type 
interpretation because we interpret req->data as scsi_device but the 
request function had assigned a zfcp_port to it. Dereferencing the port 
field leads to a kernel page fault in (Soft)IRQ context ending up in a 
panic.

> +	} else { > +		sdev = NULL;
> +		port = req->data;
> +	}
> +	zfcp_fsf_fcp_handler_common(req, port, sdev);
> 
>   	fcp_rsp = &req->qtcb->bottom.io.fcp_rsp.iu;
>   	rsp_info = (struct fcp_resp_rsp_info *) &fcp_rsp[1];
> @@ -2340,7 +2359,9 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
>   		goto out;
>   	}
> 
> -	req->data = scmnd;
> +	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;

While I moved the pointer assignment here,
the memory it points to is only filled in below with:
zfcp_fc_scsi_to_fcp(fcp_cmnd, scmnd, tm_flags).
The still freshly allocated QTCB is pre-initialized with zero.
Hence, the subsequent boolean expression always evaluates to false
since no flag is set yet.
Thus, a LUN reset erroneously has:
req->data = (void *)sdev_to_zfcp(scmnd->device)->port.

A fix would be to base the boolean expression on function argument 
tm_flags rather than the QTCB content:
(tm_flags & FCP_TMF_LUN_RESET).
To not confuse people, I would also undo the move of the fcp_cmnd 
pointer assignment.

I won't send a new version with this fix,
because it turned out the FCP channel always requires a valid LUN handle 
(even for a target reset), so I'm settling on scsi_device as common 
context for any TMF, similarly like Hannes did.
Once I've successfully completed function test of v2 of my patch set,
I'm going to re-submit the full refactored set.

> +	req->data = (fcp_cmnd->fc_tm_flags & FCP_TMF_LUN_RESET) ?
> +		scmnd->device : (void *)sdev_to_zfcp(scmnd->device)->port;
>   	req->handler = zfcp_fsf_fcp_task_mgmt_handler;
>   	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
>   	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
> @@ -2350,7 +2371,6 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
> 
>   	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
> 
> -	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;
>   	zfcp_fc_scsi_to_fcp(fcp_cmnd, scmnd, tm_flags);
> 
>   	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
> 

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
