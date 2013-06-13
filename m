From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 00/10] [RFC] SCSI: esas2r: ATTO Technology ExpressSAS 6G
 SAS/SATA RAID Adapter Driver
Date: Thu, 13 Jun 2013 22:00:42 +0000
Message-ID: <1371160841.2261.31.camel@dabdike>
References: <1371133868-13794-1-git-send-email-bgrove@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:43753 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3FMWAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jun 2013 18:00:44 -0400
In-Reply-To: <1371133868-13794-1-git-send-email-bgrove@attotech.com>
Content-Language: en-US
Content-ID: <73469F9962287142BAB2AC9EB367BAAC@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bradley Grove <bgrove@attotech.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jseba@attotech.com" <jseba@attotech.com>

On Thu, 2013-06-13 at 10:30 -0400, Bradley Grove wrote:
> This is a new driver for ATTO Technology's ExpressSAS series of hardware RAID 
> adapters.  It supports the following adapters:
> 
>     - ExpressSAS R60F
>     - ExpressSAS R680
>     - ExpressSAS R608
>     - ExpressSAS R644
> 
> This patch is split into ten parts to make reviewing easier.   You'll need to
> apply all of them to get the complete patch.
> 
> We have done some testing under x86 and x64 architectures, but the code is 
> still under development and we expect to find additional issues.  We appreciate
> any review comments.

This isn't an exhaustive review by any means, but what I noticed just
from a quick skim over the driver is this:


> +#ifdef HOST_BIG_ENDIAN
> +	*((u16 *)&vrq->scsi.handle + 0) = a->cmd_ref_no++;
> +#else
> +	*((u16 *)&vrq->scsi.handle + 1) = a->cmd_ref_no++;
> +#endif

Looks obviously wrong (there is no HOST_BIG_ENDIAN define in the code).
I think what you want here is

*((u16 *)&vrq->scsi.handle) = cpu_to_be16(a->cmd_ref_no++);

There's also a lot of open coded linked list handling code like this:


> +/* Remove a request from a double-linked list */
> +static inline void esas2r_dequeue(struct esas2r_request *rq)

and 

> +/* Add a request to a double-linked list */
> +static inline void esas2r_enqueue(struct esas2r_request *head,
> +				  struct esas2r_request *rq)

Please don't do this.  Use the linux struct list_head (in list.h)
instead ... it's a common pattern that everyone thinks they have to
write their own linked lists and everyone invariably makes a mistake
doing it ... just using the provided handlers avoids a lot of the
problems.

You also have some hidden singly linked list open coding (like the
free_sg_list) which you should use the struct hlist primitives for.

Could you go through the driver and check for primitives which should
already be in Linux?  Another example of this is all the alignment ones
you have in the file ... you should be using the ALIGN macro.

You have another pattern of using memmove() where you should be using
memcpy().  memmove() is for the case where source and destination may
overlap and it can be less efficient than memcpy on a lot of platforms. 

If I read the code right, you've got a lun limit at 255, so you should
probably be setting max_lun in the host template (and checking the
value) to prevent accidents since you use the rest of the flags word for
command data.

James

