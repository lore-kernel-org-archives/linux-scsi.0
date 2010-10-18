From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fix id computation in scsi_eh_target_reset()
Date: Mon, 18 Oct 2010 00:33:13 -0500
Message-ID: <4CBBDC19.1090806@cs.wisc.edu>
References: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37837 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab0JRFdr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 01:33:47 -0400
In-Reply-To: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 10/14/2010 09:04 AM, Hillf Danton wrote:
> There seems that the id of the tgtr_scmd processed by
> scsi_try_target_reset() does not match the id in case that
> SUCCESS is returned by scsi_try_target_reset().
>
> The mismatch is fixed, and the loop to find the next highest
> is also simplified.
>
> Signed-off-by: Hillf Danton<dhillf@gmail.com>
> ---
>
> --- a/drivers/scsi/scsi_error.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/scsi_error.c	2010-10-14 21:45:56.000000000 +0800
> @@ -1173,14 +1173,19 @@ static int scsi_eh_target_reset(struct S
>   			list_for_each_entry(scmd, work_q, eh_entry) {
>   				if (scmd_id(scmd)>  id&&
>   				(!tgtr_scmd ||
> -				     scmd_id(tgtr_scmd)>  scmd_id(scmd)))
> +				     scmd_id(tgtr_scmd)>  scmd_id(scmd))) {
>   						tgtr_scmd = scmd;
> +						if (1 + id == scmd_id(scmd))
> +							break;
> +				}
>   			}
>   		}
>   		if (!tgtr_scmd)
>   			/* no more commands, that's it */
>   			break;
>
> +		id = scmd_id(tgtr_scmd);
> +
>   		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
>   						  "to target %d\n",
>   						  current->comm, id));


Thanks. Fixes the extra target resets I have been seeing and commands 
not getting cleaned up properly.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
