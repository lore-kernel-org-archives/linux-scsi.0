From: =?UTF-8?B?546L56We?= <oujin.rera@gmail.com>
Subject: Re: dma_mask on scsi_calculate_bounce_limit
Date: Fri, 19 Nov 2010 12:11:34 +0530
Message-ID: <AANLkTimb6iHPTUCco+stpPCGZJUGC3ePBTik6=GOaa6H@mail.gmail.com>
References: <AANLkTin4V6ZZ5T5x+had0+4hL3JzGyR3sa68qaJeZBYv@mail.gmail.com>
	<1290093715.3041.13.camel@mulgrave.site>
	<AANLkTinHZC9iFjG1wyJTrRN_aMRkaGUgH=n2CF0wUG8f@mail.gmail.com>
	<1290127944.11007.46.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48876 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab0KSGlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2010 01:41:35 -0500
Received: by yxf34 with SMTP id 34so2466969yxf.19
        for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 22:41:34 -0800 (PST)
In-Reply-To: <1290127944.11007.46.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 19, 2010 at 6:22 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Fri, 2010-11-19 at 01:54 +0800, =A4=FD=AF=AB wrote:
>> On Thu, Nov 18, 2010 at 11:21 PM, James Bottomley
>> <James.Bottomley@suse.de> wrote:
>> > On Thu, 2010-11-18 at 14:20 +0530, =A4=FD=AF=AB wrote:
>> >> Hi
>> >>
>> >> I have enabled DMA for my host device and when i connect a scsi d=
evice
>> >> to the host, it crashes in the following code..
>> >>
>> >> Function: scsi_calculate_bounce_limit
>> >>
>> >>  if (host_dev && host_dev->dma_mask)
>> >>                 bounce_limit =3D *host_dev->dma_mask;
>> >>
>> >> "*dma_mask" is illegal pointer operation. I would like to underst=
and
>> >> is this known and is there reason behind such a code ?
>> >
>> > It likely means you're operating on a new architecture and its gen=
eric
>> > devices haven't been set up correctly.
>>
>> Could you please more specific on what is generic devices haven't be=
en
>> setup properly...
>
> It means the architecture setup code left a NULL pointer in the gener=
ic
> device which shouldn't be there ... without knowing which architectur=
e
> and seeing the code, it's pretty impossible to be more specific.

It is for ARM and the error is not due to NULL pointer. The code just
checks if it is host mode + dma enabled and it access a normal
interger variable with indirection causing the crash;

int dma_mask;

and accessing dma_mask as "*dma_mask" ??

Anything I am missing :O

>
> James
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
