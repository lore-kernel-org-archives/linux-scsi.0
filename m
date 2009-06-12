From: Grant Grundler <grundler@google.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
	controller
Date: Fri, 12 Jun 2009 09:20:32 -0700
Message-ID: <da824cf30906120920r59d4bf79veacdcf6c3637a25d@mail.gmail.com>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca>
	 <4A31319C.605@linux.vnet.ibm.com>
	 <da824cf30906120808o7857034an32640102d64ca106@mail.gmail.com>
	 <4A3272E3.3010000@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:19936 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZFLQUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 12:20:37 -0400
Received: from spaceape7.eur.corp.google.com (spaceape7.eur.corp.google.com [172.28.16.141])
	by smtp-out.google.com with ESMTP id n5CGKa5s031255
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 09:20:36 -0700
Received: from qw-out-1920.google.com (qwc5.prod.google.com [10.241.193.133])
	by spaceape7.eur.corp.google.com with ESMTP id n5CGKDNh020996
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 09:20:34 -0700
Received: by qw-out-1920.google.com with SMTP id 5so1396048qwc.38
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 09:20:34 -0700 (PDT)
In-Reply-To: <4A3272E3.3010000@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, gregkh@suse.de

On Fri, Jun 12, 2009 at 8:23 AM, Brian King<brking@linux.vnet.ibm.com> =
wrote:
=2E..
> SCSI allows 8 byte LUNs these days. The reference you make here refer=
s
> to bits in CDB which are now reserved.


OK - thanks (also say jejb's follow up - thanks too)

>
>>>> + =C2=A0 =C2=A0 spin_unlock_irqrestore(&pinstance->pending_pool_lo=
ck, lock_flags);
>>>> +
>>>> + =C2=A0 =C2=A0 /* Mulitple paths (IO path, control path) may be s=
ubmitting IOARCBs,
>>>> + =C2=A0 =C2=A0 =C2=A0* hence it is necessary to protect writes to=
 IOA's ioarrin register.
>>>> + =C2=A0 =C2=A0 =C2=A0* All writes to IOA ioarrin are synchronized=
 with host_lock
>>>> + =C2=A0 =C2=A0 =C2=A0*/
>>>> + =C2=A0 =C2=A0 if (lock)
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(pins=
tance->host->host_lock,
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pinstance->host_lock_flags);
>>>> +
>>>> + =C2=A0 =C2=A0 /* apply memory barrier */
>>>> + =C2=A0 =C2=A0 mb();
>>>> + =C2=A0 =C2=A0 /* driver writes lower 32-bit value of IOARCB addr=
ess only */
>>>> + =C2=A0 =C2=A0 write64(cmd->ioa_cb->ioarcb.ioarcb_bus_addr, pinst=
ance->ioarrin);
>>>> +
>>>> + =C2=A0 =C2=A0 if (lock)
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore=
(pinstance->host->host_lock,
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pinstance->h=
ost_lock_flags);
>>> Any way to get rid of this lock flag getting passed in?
>>
>> And I believe due to spinlock/unlock, the mb() is not needed.
>> Spin locks imply memory barriers.
>
> Incorrect.

It's generally correct. Spin unlock implies a memory write barrier.
OS's would be utterly broken if that were not true.

See IA64-linux kernel by David Mosberger and Stephane Eranian.
(Part of section 7.2.1 "Memory Mapped IO", page 303, "Ordering Memory
Accesses on IA-64").

(And while some parts of the book describe APIs that are obsolete,
still a good reference on OS internals/design).

> The memory barrier here ensures that the command being
> constructed for the adapter is in a consistent state and that all
> the writes to the command buffer are flushed to memory before
> the write64 happens, which will trigger the adapter to DMA the
> command buffer and start executing the command.

I understand the application. The mb() is NOT needed.
The spin lock already guarantees cache coherency of
the Memory write (not MMIO writes!).

If anything, mmiowb() is needed.  Off hand, I believe
mmiowb() should be *after* the write64() since we want
to make sure the write64() is delivered to PCI subsystem
(where ordering is enforced) before the CPU releases
the next lock or other semaphore.

And AFAIK, mmiowb() is only required to run on SGI Altix machines
due to the fact that releasing a spinlock does not guarantee ordering
of MMIO transactions on their HW.

(credit to jejb and willy for reminding me of the mmiowb() case).


>>>> +/* Maximum number of adapters supported by current version of the=
 driver */
>>>> +#define PMCRAID_MAX_ADAPTERS =C2=A0 =C2=A0 =C2=A0 =C2=A0 32
>>> Why is there a limit on the max adapters supported?
>>
>> Because of this code I think:
>> +DECLARE_BITMAP(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
>> ...
>> + =C2=A0 =C2=A0 =C2=A0 error =3D alloc_chrdev_region(&dev, 0,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 PMCRAID_MAX_ADAPTE=
RS,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 PMCRAID_DEVFILE);
>>
>> I don't know offhand how to avoid this. Suggestions?
>
> Hopefully, this can be solved by removing the character device altoge=
ther.
> AFAICS, its only used for the ioctls, which should be able to be conv=
erted
> to use other interfaces such as sysfs or netlink.


Ah ok...that sounds better to me too.

thanks,
grant
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
