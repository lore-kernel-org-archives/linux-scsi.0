From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] zfcp: fix sense_buffer access bug
Date: Mon, 28 Jan 2008 08:46:25 +0100
Message-ID: <20080128074624.GA4622@schmichrtp.de.ibm.com>
References: <20080127124124H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:2510 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYA1Hq1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jan 2008 02:46:27 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate6.de.ibm.com (8.13.8/8.13.8) with ESMTP id m0S7kPIp506666
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jan 2008 07:46:25 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0S7kO88999608
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jan 2008 08:46:24 +0100
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0S7kOpI026339
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jan 2008 08:46:24 +0100
Content-Disposition: inline
In-Reply-To: <20080127124124H.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sun, Jan 27, 2008 at 12:41:50PM +0900, FUJITA Tomonori wrote:
> The commit de25deb18016f66dcdede165d07654559bb332bc changed
> scsi_cmnd.sense_buffer from a static array to a dynamically allocated
> buffer. We can't access to sense_buffer in '&cmd->sense_buffer' way.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/s390/scsi/zfcp_fsf.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index fe57941..a9a147d 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -4224,10 +4224,10 @@ zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *fsf_req)
> 
>  		ZFCP_LOG_TRACE("%i bytes sense data provided by FCP\n",
>  			       fcp_rsp_iu->fcp_sns_len);
> -		memcpy(&scpnt->sense_buffer,
> +		memcpy(scpnt->sense_buffer,
>  		       zfcp_get_fcp_sns_info_ptr(fcp_rsp_iu), sns_len);
>  		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE,
> -			      (void *) &scpnt->sense_buffer, sns_len);
> +			      (void *)scpnt->sense_buffer, sns_len);
>  	}
> 
>  	/* check for overrun */

ACK for fixing the access to the sense buffer.

We are working internally on cleaning up the zfcp messages. With this
change, the 'trace' and 'hex dump' messages will disappear. So, could
you simply remove the ZFCP_HEX_DUMP message above, instead of fixing
it?

Christof
