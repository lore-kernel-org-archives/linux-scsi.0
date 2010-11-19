From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: dma_mask on scsi_calculate_bounce_limit
Date: Fri, 19 Nov 2010 10:13:29 -0500
Message-ID: <4CE69419.2020201@interlog.com>
References: <AANLkTin4V6ZZ5T5x+had0+4hL3JzGyR3sa68qaJeZBYv@mail.gmail.com>	<1290093715.3041.13.camel@mulgrave.site>	<AANLkTinHZC9iFjG1wyJTrRN_aMRkaGUgH=n2CF0wUG8f@mail.gmail.com>	<1290127944.11007.46.camel@mulgrave.site> <AANLkTimb6iHPTUCco+stpPCGZJUGC3ePBTik6=GOaa6H@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39495 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab0KSPNg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2010 10:13:36 -0500
In-Reply-To: <AANLkTimb6iHPTUCco+stpPCGZJUGC3ePBTik6=GOaa6H@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?Big5?B?pP2vqw==?= <oujin.rera@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 10-11-19 01:41 AM, =A4=FD=AF=AB wrote:
> On Fri, Nov 19, 2010 at 6:22 AM, James Bottomley
> <James.Bottomley@suse.de>  wrote:
>> On Fri, 2010-11-19 at 01:54 +0800, =A4=FD=AF=AB wrote:
>>> On Thu, Nov 18, 2010 at 11:21 PM, James Bottomley
>>> <James.Bottomley@suse.de>  wrote:
>>>> On Thu, 2010-11-18 at 14:20 +0530, =A4=FD=AF=AB wrote:
>>>>> Hi
>>>>>
>>>>> I have enabled DMA for my host device and when i connect a scsi d=
evice
>>>>> to the host, it crashes in the following code..
>>>>>
>>>>> Function: scsi_calculate_bounce_limit
>>>>>
>>>>>   if (host_dev&&  host_dev->dma_mask)
>>>>>                  bounce_limit =3D *host_dev->dma_mask;
>>>>>
>>>>> "*dma_mask" is illegal pointer operation. I would like to underst=
and
>>>>> is this known and is there reason behind such a code ?
>>>>
>>>> It likely means you're operating on a new architecture and its gen=
eric
>>>> devices haven't been set up correctly.
>>>
>>> Could you please more specific on what is generic devices haven't b=
een
>>> setup properly...
>>
>> It means the architecture setup code left a NULL pointer in the gene=
ric
>> device which shouldn't be there ... without knowing which architectu=
re
>> and seeing the code, it's pretty impossible to be more specific.
>=20
> It is for ARM and the error is not due to NULL pointer. The code just
> checks if it is host mode + dma enabled and it access a normal
> interger variable with indirection causing the crash;
>=20
> int dma_mask;
>=20
> and accessing dma_mask as "*dma_mask" ??
>=20
> Anything I am missing :O

Yes, supplying more information.

I'm familiar with AT91SAM9G20 which is an ARM based
microcontroller. The directory of interest in the kernel
source is arch/arm/mach-at91 and for the G20 the
at91sam9260_devices.c file defines its DMA masks for
its devices. In all cases that I can see the dma_mask is
the address of a u64 holding DMA_BIT_MASK(32) .

There are no real SCSI devices on the G20 but USB
might be regarded as SCSI "once removed". And the
USB devices on the G20 have dma_mask values as
described above.

Doug Gilbert

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
