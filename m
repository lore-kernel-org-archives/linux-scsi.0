From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: fix integer overflow
Date: Fri, 24 Jan 2014 11:36:32 -0500
Message-ID: <52E29690.4060300@interlog.com>
References: <alpine.LRH.2.02.1401241131380.12824@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40969 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaAXQgp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 11:36:45 -0500
In-Reply-To: <alpine.LRH.2.02.1401241131380.12824@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On 14-01-24 11:34 AM, Mikulas Patocka wrote:
> On alpha, USER_HZ may be higher than HZ. This results in integer overflow
> in MULDIV.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> Cc: stable@vger.kernel.org
>
> ---
>   drivers/scsi/sg.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> Index: linux-3.13/drivers/scsi/sg.c
> ===================================================================
> --- linux-3.13.orig/drivers/scsi/sg.c	2014-01-20 21:44:02.000000000 +0100
> +++ linux-3.13/drivers/scsi/sg.c	2014-01-24 17:28:02.000000000 +0100
> @@ -856,8 +856,10 @@ sg_ioctl(struct file *filp, unsigned int
>   			return result;
>   		if (val < 0)
>   			return -EIO;
> +#if USER_HZ < HZ
>   		if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
>   		    val = MULDIV (INT_MAX, USER_HZ, HZ);
> +#endif
>   		sfp->timeout_user = val;
>   		sfp->timeout = MULDIV (val, HZ, USER_HZ);
>
>

