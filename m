From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH] [SCSI] esas2r: remove redundant NULL check on buffer
Date: Thu, 16 Mar 2017 17:09:35 -0400
Message-ID: <c304f4f4-8e4a-f716-ecd0-7f3ff7980dbc@attotech.com>
References: <20170315164624.17264-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:48901 "EHLO
        NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752380AbdCPWnp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2017 18:43:45 -0400
In-Reply-To: <20170315164624.17264-1-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On 03/15/2017 12:46 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> buffer is a pointer to the static char array event_buffer and
> therefore can never be null, so the check is redundant. Remove it.
>
> Detected by CoverityScan, CID#1077556 ("Logically Dead Code")
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/esas2r/esas2r_log.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
> index a82030a..65fdf22 100644
> --- a/drivers/scsi/esas2r/esas2r_log.c
> +++ b/drivers/scsi/esas2r/esas2r_log.c
> @@ -130,11 +130,6 @@ static int esas2r_log_master(const long level,
>
>  		spin_lock_irqsave(&event_buffer_lock, flags);
>
> -		if (buffer == NULL) {
> -			spin_unlock_irqrestore(&event_buffer_lock, flags);
> -			return -1;
> -		}
> -
>  		memset(buffer, 0, buflen);
>
>  		/*
>

Thanks,

Acked-by: Bradley Grove <bgrove@attotech.com>



This electronic transmission and any attachments hereto are intended only for the use of the individual or entity to which it is addressed and may contain confidential information belonging to ATTO Technology, Inc. If you have reason to believe that you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution or the taking of any action in reliance on the contents of this electronic transmission is strictly prohibited. If you have reason to believe that you have received this transmission in error, please notify ATTO immediately by return e-mail and delete and destroy this communication.   
