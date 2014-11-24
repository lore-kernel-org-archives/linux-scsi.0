From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH 3/3] esas2r: fix an oversight in setting return value
Date: Mon, 24 Nov 2014 15:58:03 -0500
Message-ID: <54739BDB.6030302@attotech.com>
References: <1416144934-21338-1-git-send-email-thenzl@redhat.com> <1416144934-21338-4-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:29362 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbaKXVIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 16:08:43 -0500
In-Reply-To: <1416144934-21338-4-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org

Acked-by: Bradley Grove <bgrove@attotech.com>

Thanks,
Brad

On 11/16/2014 08:35 AM, Tomas Henzl wrote:
> The patch moves an error code assigment to a 'default' case
> in the previous switch statement.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>   drivers/scsi/esas2r/esas2r_ioctl.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
> index c88b9f9491..baf913047b 100644
> --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> +++ b/drivers/scsi/esas2r/esas2r_ioctl.c
> @@ -1524,9 +1524,12 @@ ioctl_done:
>   		case -EINVAL:
>   			ioctl->header.return_code = IOCTL_INVALID_PARAM;
>   			break;
> +
> +		default:
> +			ioctl->header.return_code = IOCTL_GENERAL_ERROR;
> +			break;
>   		}
>
> -		ioctl->header.return_code = IOCTL_GENERAL_ERROR;
>   	}
>
>   	/* Always copy the buffer back, if only to pick up the status */
>

