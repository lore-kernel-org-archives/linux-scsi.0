From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH 1/3] esas2r: fir error handling in do_fm_api
Date: Mon, 24 Nov 2014 15:53:35 -0500
Message-ID: <54739ACF.5040906@attotech.com>
References: <1416144934-21338-1-git-send-email-thenzl@redhat.com> <1416144934-21338-2-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:29362 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051AbaKXVIm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 16:08:42 -0500
In-Reply-To: <1416144934-21338-2-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>


Looks good.

Acked-by: Bradley Grove <bgrove@attotech.com>

Thanks,
Brad

On 11/16/2014 08:35 AM, Tomas Henzl wrote:
> This patch fixes an error path and rearranges error handling.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>   drivers/scsi/esas2r/esas2r_ioctl.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
> index d89a0277a8..9ac8207554 100644
> --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> +++ b/drivers/scsi/esas2r/esas2r_ioctl.c
> @@ -117,9 +117,8 @@ static void do_fm_api(struct esas2r_adapter *a, struct esas2r_flash_img *fi)
>
>   	rq = esas2r_alloc_request(a);
>   	if (rq == NULL) {
> -		up(&a->fm_api_semaphore);
>   		fi->status = FI_STAT_BUSY;
> -		return;
> +		goto free_sem;
>   	}
>
>   	if (fi == &a->firmware.header) {
> @@ -135,7 +134,7 @@ static void do_fm_api(struct esas2r_adapter *a, struct esas2r_flash_img *fi)
>   		if (a->firmware.header_buff == NULL) {
>   			esas2r_debug("failed to allocate header buffer!");
>   			fi->status = FI_STAT_BUSY;
> -			return;
> +			goto free_req;
>   		}
>
>   		memcpy(a->firmware.header_buff, fi,
> @@ -171,9 +170,10 @@ all_done:
>   				  a->firmware.header_buff,
>   				  (dma_addr_t)a->firmware.header_buff_phys);
>   	}
> -
> -	up(&a->fm_api_semaphore);
> +free_req:
>   	esas2r_free_request(a, (struct esas2r_request *)rq);
> +free_sem:
> +	up(&a->fm_api_semaphore);
>   	return;
>
>   }
>

