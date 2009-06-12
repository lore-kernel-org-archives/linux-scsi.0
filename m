From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller
Date: Fri, 12 Jun 2009 11:17:24 -0500
Message-ID: <4A327F94.2020506@linux.vnet.ibm.com>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca> <4A31319C.605@linux.vnet.ibm.com> <da824cf30906120808o7857034an32640102d64ca106@mail.gmail.com> <4A3272E3.3010000@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:40754 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760763AbZFLQR0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 12:17:26 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5CGEQTD030873
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 10:14:26 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5CGHQrL226476
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 10:17:26 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5CGHPZF012721
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 10:17:25 -0600
In-Reply-To: <4A3272E3.3010000@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, gregkh@suse.de

Brian King wrote:
>>>> +     spin_unlock_irqrestore(&pinstance->pending_pool_lock, lock_flags);
>>>> +
>>>> +     /* Mulitple paths (IO path, control path) may be submitting IOARCBs,
>>>> +      * hence it is necessary to protect writes to IOA's ioarrin register.
>>>> +      * All writes to IOA ioarrin are synchronized with host_lock
>>>> +      */
>>>> +     if (lock)
>>>> +             spin_lock_irqsave(pinstance->host->host_lock,
>>>> +                               pinstance->host_lock_flags);
>>>> +
>>>> +     /* apply memory barrier */
>>>> +     mb();
>>>> +     /* driver writes lower 32-bit value of IOARCB address only */
>>>> +     write64(cmd->ioa_cb->ioarcb.ioarcb_bus_addr, pinstance->ioarrin);
>>>> +
>>>> +     if (lock)
>>>> +             spin_unlock_irqrestore(pinstance->host->host_lock,
>>>> +                                    pinstance->host_lock_flags);
>>> Any way to get rid of this lock flag getting passed in?
>> And I believe due to spinlock/unlock, the mb() is not needed.
>> Spin locks imply memory barriers.
> 
> Incorrect. The memory barrier here ensures that the command being
> constructed for the adapter is in a consistent state and that all
> the writes to the command buffer are flushed to memory before
> the write64 happens, which will trigger the adapter to DMA the
> command buffer and start executing the command.

After a chat on IRC with Grant and others, it looks like I was
looking at the wrong spin_unlock. The spin_unlock of the
pending_pool_lock should be sufficient to guarantee cache coherency
of the command buffer wrt to DMA.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


