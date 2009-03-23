From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] Common code for init and runtime
Date: Mon, 23 Mar 2009 00:46:19 +0000
Message-ID: <1237769179.4712.10.camel@localhost.localdomain>
References: <FE3F06125A99254E8D92161AA4569C6F0693DCE9@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43035 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757140AbZCWAqY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Mar 2009 20:46:24 -0400
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F0693DCE9@sc-exch02.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Yan <ayan@marvell.com>
Cc: jeff@garzik.org, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>, Ying Chu <jasonchu@marvell.com>, Ke Wei <kewei@marvell.com>

On Thu, 2009-03-19 at 01:50 -0700, Andy Yan wrote:
> From: Andy Yan <ayan@marvell.com>
> Date: Thu, 19 Mar 2009 21:49:44 +0800
> Subject: [PATCH 2/3] Common code for init and runtime
> This patch contains the common code for pci init and disk IO, all
> supported
> chips share the same code, the disk flash is supported. Error handling
> is 
> enhanced with this patch.
> 
>  Signed-off-by: Andy Yan <ayan@marvell.com>
>  Signed-off-by: Ke Wei <kewei@marvell.com>
>  Signed-off-by: Ying Chu <jasonchu@marvell.com>
[...]

I gave it a cursory review, it seems a reasonable copy of mvsas.c

You need to lose all the kernel version dependent code, since you're
aiming this at the current kernel (2.6.29-rc):


> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25)
> +#include "sas_task.c"
> +#endif


> +#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 20)
> +static void mvs_work_queue(struct work_struct *work)
> +{
> +	struct delayed_work *dw = container_of(work, struct
> delayed_work, work);
> +#else
> +static void mvs_work_queue(void *arg)
> +{
> +	struct delayed_work *dw = arg;
> +#endif


> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 24)
> +#include <scsi.h>
> +#define sg_page(sg)	sg->page
> +#define for_each_sg(sglist, sg, nr, __i)	\
> +	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg++)
> +#endif
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25)
> +#define SAS_PROTOCOL_ALL SAS_PROTO_ALL
> +#endif
> +#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 20)
> +#define MV_INIT_DELAYED_WORK(w, f, d)	INIT_DELAYED_WORK(w, f)
> +#else
> +#define MV_INIT_DELAYED_WORK(w, f, d)	INIT_DELAYED_WORK(w, f, (void *)
> d)
> +#endif

etc.

James


