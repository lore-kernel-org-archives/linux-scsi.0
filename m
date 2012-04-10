From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Properly handle
 errors from the host
Date: Tue, 10 Apr 2012 15:13:39 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF90250E2@BY2PRD0310MB378.namprd03.prod.outlook.com>
References: <1333654012-23850-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:23387
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758995Ab2DJPQU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Apr 2012 11:16:20 -0400
In-Reply-To: <1333654012-23850-1-git-send-email-kys@microsoft.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Thursday, April 05, 2012 3:27 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com
> Cc: KY Srinivasan
> Subject: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Properly handle errors from
> the host
> 
> If the host returns error for pass through commands, deal with them
> appropriately. I would like to thank James for patiently helping
> me with this patch.

James,

Thank you for suggesting the fix here. I hope this is what you were looking for.

Regards,

K. Y
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   20 +++++++++++++++-----
>  1 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 83a1972..528d52b 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -785,12 +785,22 @@ static void storvsc_command_completion(struct
> storvsc_cmd_request *cmd_request)
>  	/*
>  	 * If there is an error; offline the device since all
>  	 * error recovery strategies would have already been
> -	 * deployed on the host side.
> +	 * deployed on the host side. However, if the command
> +	 * were a pass-through command deal with it appropriately.
>  	 */
> -	if (vm_srb->srb_status == SRB_STATUS_ERROR)
> -		scmnd->result = DID_TARGET_FAILURE << 16;
> -	else
> -		scmnd->result = vm_srb->scsi_status;
> +	scmnd->result = vm_srb->scsi_status;
> +
> +	if (vm_srb->srb_status == SRB_STATUS_ERROR) {
> +		switch (scmnd->cmnd[0]) {
> +		case ATA_16:
> +		case ATA_12:
> +			set_host_byte(scmnd, DID_PASSTHROUGH);
> +			break;
> +		default:
> +			set_host_byte(scmnd, DID_TARGET_FAILURE);
> +		}
> +	}
> +
> 
>  	/*
>  	 * If the LUN is invalid; remove the device.
> --
> 1.7.4.1
> 
> 
> 



