From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/5] megaraid_sas: Move poll_aen_lock initializer
Date: Thu, 26 Jul 2012 12:38:12 +0400
Message-ID: <1343291892.3115.13.camel@dabdike>
References: <CAHtARFHi3xyomKhrUg0r7soQFbUtPeiLkYeZ2YgmaU3gYktuYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49195 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751372Ab2GZIi6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2012 04:38:58 -0400
In-Reply-To: <CAHtARFHi3xyomKhrUg0r7soQFbUtPeiLkYeZ2YgmaU3gYktuYA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>, stable <stable@kernel.org>

On Tue, 2012-07-17 at 18:20 -0700, adam radford wrote:
> Cc: stable

That's not how to add a stable tag, please see
Documentation/stable_kernel_rules.txt

> James/linux-scsi,
> 
> The following patch from Kashyap Desai for megaraid_sas moves the

That's also not how you do someone else's patch ... this needs a

From: Kashyap Desai <Kashyap.Desai@lsi.com>

At the top for git to get the authorship correct.

James

> poll_aen_lock initializer from megasas_probe_one() to megasas_init().
> This prevents a crash when a user loads the driver and tries to issue
> a poll() system call on the ioctl interface with no adapters present.
> 
> Signed-off-by: Kashyap Desai <Kashyap.Desai@lsi.com>
> Signed-off-by: Adam Radford <aradford@gmail.com>
> 
> diff -Naur scsi/drivers/scsi/megaraid/megaraid_sas_base.c
> scsi.new/drivers/scsi/megaraid/megaraid_sas_base.c
> --- scsi/drivers/scsi/megaraid/megaraid_sas_base.c	2012-07-17
> 14:57:32.890231627 -0700
> +++ scsi.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-07-17
> 14:59:37.285232167 -0700
> @@ -4095,7 +4095,6 @@
>  	spin_lock_init(&instance->cmd_pool_lock);
>  	spin_lock_init(&instance->hba_lock);
>  	spin_lock_init(&instance->completion_lock);
> -	spin_lock_init(&poll_aen_lock);
> 
>  	mutex_init(&instance->aen_mutex);
>  	mutex_init(&instance->reset_mutex);
> @@ -5421,6 +5420,8 @@
>  	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
>  	       MEGASAS_EXT_VERSION);
> 
> +	spin_lock_init(&poll_aen_lock);
> +
>  	support_poll_for_event = 2;
>  	support_device_change = 1;


