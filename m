From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sg: fix integer overflow
Date: Fri, 24 Jan 2014 08:56:27 -0800
Message-ID: <1390582587.2275.22.camel@dabdike.int.hansenpartnership.com>
References: <alpine.LRH.2.02.1401241131380.12824@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45832 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbaAXQ43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 11:56:29 -0500
In-Reply-To: <alpine.LRH.2.02.1401241131380.12824@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Fri, 2014-01-24 at 11:34 -0500, Mikulas Patocka wrote:
> On alpha, USER_HZ may be higher than HZ. This results in integer overflow
> in MULDIV.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  drivers/scsi/sg.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-3.13/drivers/scsi/sg.c
> ===================================================================
> --- linux-3.13.orig/drivers/scsi/sg.c	2014-01-20 21:44:02.000000000 +0100
> +++ linux-3.13/drivers/scsi/sg.c	2014-01-24 17:28:02.000000000 +0100
> @@ -856,8 +856,10 @@ sg_ioctl(struct file *filp, unsigned int
>  			return result;
>  		if (val < 0)
>  			return -EIO;
> +#if USER_HZ < HZ
>  		if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
>  		    val = MULDIV (INT_MAX, USER_HZ, HZ);
> +#endif

Is this really a problem worth fixing?  Is USER_HZ ever greater than HZ?

>  		sfp->timeout_user = val;

If it can happen, this needs fixing as well:

>  		sfp->timeout = MULDIV (val, HZ, USER_HZ);

any val that would divide to less than 1 will now set the timeout to
zero, which will cause the queue default timeout to be applied instead.

I'd fix it in the macro rather than having code peppered with #ifs

James



