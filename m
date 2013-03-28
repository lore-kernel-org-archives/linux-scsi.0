From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch] scsi_dh_hp_sw.c: return DEV_OFFLINED when blk_get_request
 fails
Date: Thu, 28 Mar 2013 14:49:09 -0500
Message-ID: <51549EB5.4060109@cs.wisc.edu>
References: <x49y5d7xqv7.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42178 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab3C1TtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Mar 2013 15:49:19 -0400
In-Reply-To: <x49y5d7xqv7.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Joe Lawrence <joe.lawrence@stratus.com>

On 03/28/2013 02:32 PM, Jeff Moyer wrote:
> Hi,
> 
> If blk_get_requet fails here, it means that the queue is dead.  It seems
> better to return a DEV_OFFLINED error code than the misleading
> TEMP_UNAVAIL.  Comments?
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> index 084062b..eec24d3 100644
> --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> @@ -118,7 +118,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
>  retry:
>  	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
>  	if (!req)
> -		return SCSI_DH_RES_TEMP_UNAVAIL;
> +		return SCSI_DH_DEV_OFFLINED;

Can we always assume that if using GFP_NOIO then resource allocation
failures will never be returned to us? If so, then the patch is fine. If
not then do we want to base this patch on top of "block: handle pointer
error from blk_get_request" and check the return value. If -ENOMEM then
return SCSI_DH_RES_TEMP_UNAVAIL, and if -ENODEV then return
SCSI_DH_DEV_OFFLINED.

You probably then want to also fix up scsi_dh_alua and scsi_dh_emc the
same way. It looks like they have the same issue.

scsi_dh_emc looks like it has extra errors in that the failure checks
for send_inquiry_cmd do not handle get_req failures properly. It looks
like it ignore them if the senselen is not set.


>  
>  	req->cmd_type = REQ_TYPE_BLOCK_PC;
>  	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
