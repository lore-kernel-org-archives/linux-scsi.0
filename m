From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] SCSI: fix the return value of scsi_target_queue_read()
Date: Tue, 14 Sep 2010 14:15:54 -0500
Message-ID: <4C8FC9EA.4080501@cs.wisc.edu>
References: <AANLkTin38p4ZfYmkU+ijkky_nwkBBgr=-u9ay37MgZ+W@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46469 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab0INTK3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2010 15:10:29 -0400
In-Reply-To: <AANLkTin38p4ZfYmkU+ijkky_nwkBBgr=-u9ay37MgZ+W@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.Bottomley@suse.de>

On 09/14/2010 08:35 AM, Hillf Danton wrote:
> It seems that zero should be returned if scsi_target_is_busy(starget) is
> true, no matter if sdev is on the starved list.
>
> Signed-off-by: Hillf Danton<dhillf@gmail.com>
> ---
>
> --- o/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c 2010-08-16 08:41:38.000000000
> +0800
> +++ m/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c 2010-09-14 21:04:50.000000000
> +0800
> @@ -1279,8 +1279,8 @@ static inline int scsi_target_queue_read
>    if (list_empty(&sdev->starved_entry)) {
>    list_add_tail(&sdev->starved_entry,
>         &shost->starved_list);
> - return 0;
>    }

I think the formatting in the patch got messed up by your mailer. When 
you resend the patch, you can remove the brackets since you removed the 
return 0 there is no need for them.

> + return 0;
>    }
>
>    /* We're OK to process the command, so we can't be starved */
>

Patch is right. I do not know what I was thinking when I did that.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
