From: Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] remove name length check in a workqueue
Date: Wed, 10 Aug 2005 10:45:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.58.0508101044110.31617@devserv.devel.redhat.com>
References: <1123683544.5093.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57770 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S965139AbVHJOpP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 10:45:15 -0400
In-Reply-To: <1123683544.5093.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>


yeah ... cannot remember why i have done it originally :-|

Acked-by: Ingo Molnar <mingo@redhat.com>

	Ingo

On Wed, 10 Aug 2005, James Bottomley wrote:

> Ingo,
> 
> This has been in the workqueue code in day one, for no real reason that
> I can see.  We just tripped over it in SCSI because the fibre channel
> transport class creates one workqueue per host with the name scsi_wq_%d
> which trips this after we get to 100.  Unfortunately we just came across
> someone with > 100 host adapters ...
> 
> I think the solution is just to get rid of the artificial limit.
> 
> James
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -308,8 +308,6 @@ struct workqueue_struct *__create_workqu
>  	struct workqueue_struct *wq;
>  	struct task_struct *p;
>  
> -	BUG_ON(strlen(name) > 10);
> -
>  	wq = kmalloc(sizeof(*wq), GFP_KERNEL);
>  	if (!wq)
>  		return NULL;
> 
> 
