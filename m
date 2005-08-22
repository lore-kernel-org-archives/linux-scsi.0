From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] correct attribute_container list usage
Date: Mon, 22 Aug 2005 14:46:17 -0700
Message-ID: <20050822214617.GA26441@us.ibm.com>
References: <1124723180.5211.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44729 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751269AbVHVVqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 17:46:22 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7MLkKaF001796
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 17:46:20 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7MLkHpD289402
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 17:46:17 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7MLkGHG012653
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 17:46:16 -0400
Content-Disposition: inline
In-Reply-To: <1124723180.5211.25.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Aug 22, 2005 at 10:06:19AM -0500, James Bottomley wrote:

> +/* FIXME: can't break out of this unless klist_iter_exit is also
> + * called before doing the break
> + */
> +#define klist_for_each_entry(pos, head, member, iter) \
> +	for (klist_iter_init(head, iter); (pos = ({ \
> +		struct klist_node *n = klist_next(iter); \
> +		n ? ({ klist_iter_exit(iter) ; NULL; }) : \
> +			container_of(n, typeof(*pos), member);\
> +	}) ) != NULL; )
> +			
> +

> -		spin_lock(&cont->containers_lock);
> -		list_for_each_entry_safe(ic, tmp, &cont->containers, node) {
> +
> +		klist_for_each_entry(ic, &cont->containers, node, &iter) {
>  			if (dev != ic->classdev.dev)
>  				continue;
> -			list_del(&ic->node);
> +			klist_remove(&ic->node);
>  			if (fn)
>  				fn(cont, dev, &ic->classdev);

Did you test with CONFIG_DEBUG_SLAB enabled?

I have a workaround for problems with device_for_each_child() not being
"safe", I'm trying to verify it right now, but the underlying problem is
in klist_next(), I don't have a general solution for it (it looks hard to
fix).

-- Patrick Mansfield
