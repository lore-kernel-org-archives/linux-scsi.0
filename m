From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH 2/3] esas2r: fix an error path in esas2r_ioctl_handler
Date: Mon, 24 Nov 2014 15:56:16 -0500
Message-ID: <54739B70.5030401@attotech.com>
References: <1416144934-21338-1-git-send-email-thenzl@redhat.com> <1416144934-21338-3-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:29362 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750792AbaKXVIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 16:08:43 -0500
In-Reply-To: <1416144934-21338-3-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>


Acked-by: Bradley Grove <bgrove@attotech.com>

Thanks,
Brad


On 11/16/2014 08:35 AM, Tomas Henzl wrote:
> Is seems strange to manipulate nvram_semaphore when in this place,
> this patch fixes it.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>   drivers/scsi/esas2r/esas2r_ioctl.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
> index 9ac8207554..c88b9f9491 100644
> --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> +++ b/drivers/scsi/esas2r/esas2r_ioctl.c
> @@ -1420,9 +1420,10 @@ int esas2r_ioctl_handler(void *hostdata, int cmd, void __user *arg)
>
>   		rq = esas2r_alloc_request(a);
>   		if (rq == NULL) {
> -			up(&a->nvram_semaphore);
> -			ioctl->data.prw.code = 0;
> -			break;
> +			kfree(ioctl);
> +			esas2r_log(ESAS2R_LOG_WARN,
> +			   "could not allocate an internal request");
> +			return -ENOMEM;
>   		}
>
>   		code = esas2r_write_params(a, rq,
>

