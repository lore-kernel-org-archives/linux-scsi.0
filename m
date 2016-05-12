From: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: UBSAN: Undefined behaviour in drivers/scsi/aic7xxx/aic7xxx_core.c:2831:31
Date: Thu, 12 May 2016 17:56:04 -0400
Message-ID: <CAKb7Uvh8U1ncRg1jCnAVrdew=HyF+jNpY6=MknHgKyJmAdJEkw@mail.gmail.com>
References: <alpine.LRH.2.20.1605121859240.4797@math.ut.ee>
	<1463083710.2380.46.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36781 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbcELV4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2016 17:56:06 -0400
In-Reply-To: <1463083710.2380.46.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, May 12, 2016 at 4:08 PM, James Bottomley
<jejb@linux.vnet.ibm.com> wrote:
> On Thu, 2016-05-12 at 19:02 +0300, Meelis Roos wrote:
>> This is from a dual-AthlonMP 32-bit x86 system with onboard Adaptec
>> SCSI
>> controller, once during bootup.
>>
>> [    4.896307]
>> =====================================================================
>> ===========
>> [    4.896471] UBSAN: Undefined behaviour in
>> drivers/scsi/aic7xxx/aic7xxx_core.c:2831:31
>> [    4.896629] shift exponent -1 is negative
>
> Is this some sort of false positive?  The shift in question is
>
>         devinfo->target_mask = (0x01 << devinfo->target_offset);
>
> The code which calls this in ahc_linux_initialize_scsi_bus() looks to
> be looping from 0-16 (or variations).  Since the value passed in is
> unsigned, it would have to be set to ~0, which doesn't seem possible.

It's getting called from ahc_reset_channel, which does:

        ahc_compile_devinfo(&devinfo,
                            CAM_TARGET_WILDCARD,
                            CAM_TARGET_WILDCARD,
                            CAM_LUN_WILDCARD,
                            channel, ROLE_UNKNOWN);

drivers/scsi/aic7xxx/cam.h:#define      CAM_TARGET_WILDCARD ((u_int)~0)

  -ilia
