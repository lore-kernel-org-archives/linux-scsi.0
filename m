From: "Meena Shanmugam, TLS-Chennai" <smeena@hcl.in>
Subject: RE: MVSAS 1669:mvs_abort_task:rc= 5
Date: Thu, 15 Oct 2009 12:14:21 +0530
Message-ID: <3CD4E24D4F537D439B71EB28963F98F46815EA2169@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
References: <e938503f0910142007k7fca9ebcx856a19010feb812b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:35497 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078AbZJOGpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2009 02:45:16 -0400
In-Reply-To: <e938503f0910142007k7fca9ebcx856a19010feb812b@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andy yan <andyysj@gmail.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Thanks Andy. Sg_tablesize fix solved my problem.

Meena
________________________________________
=46rom: andy yan [mailto:andyysj@gmail.com]=20
Sent: Thursday, October 15, 2009 8:38 AM
To: Meena Shanmugam, TLS-Chennai; James E.J. Bottomley
Cc: linux-scsi
Subject: Re: MVSAS 1669:mvs_abort_task:rc=3D 5

Meena,
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Thanks for your info, the macro DISABLE_HOT=
PLUG_DMA_FIX should be disabled, it is a very important bug fix for hot=
 plug,
and I have found the root cause of the problem you are facing, mvsas se=
t=20
=A0=A0=A0=A0=A0 .sg_tablesize=A0=A0=A0 =A0=A0=A0 =3D SG_ALL,
but it is not a correct value for the 6440 chipset, and it need updatin=
g, please keep DISABLE_HOTPLUG_DMA_FIX disabled, and set sg_tablesize t=
o
64, then verify this issue, thanks!

James,=20
=A0=A0=A0=A0=A0=A0=A0 I will send out a patch for this and other bug fi=
xes.

Andy
On Wed, Oct 14, 2009 at 11:39 PM, Meena Shanmugam, TLS-Chennai <smeena@=
hcl.in> wrote:
Hi,

I am also facing the same problem with this driver. I'm using Adaptec A=
SC-1045 which uses the Marvell 88SE6440 chip. In my case, this could be=
 reproduced with RAID-5 configured with 3 SATA drives. While analysing =
the problem, it looks like the prd table is getting corrupted in the SA=
TA path triggers the issue.

----mvs_sas.c---
=A0726 #ifndef DISABLE_HOTPLUG_DMA_FIX
=A0727 =A0 =A0 =A0 =A0 if (task->data_dir =3D=3D DMA_FROM_DEVICE)
=A0728 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP->dma_fix(asi->bulk=
_buffer_dma,
=A0729 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 TRASH_BUCKET_SIZ=
E, tei->n_elem, buf_prd);
=A0730 #endif
-----------

The hang issue doesn't occur after enabling DISABLE_HOTPLUG_DMA_FIX in =
mvs_sas.h file. Please let me know if this fix solves the issue. Btw, I=
'm not sure about the reason why this macro is disabled by default. Som=
eone who is aware about this change can throw light on this. Meanwhile,=
 I'm running some overnight test to see if this workaround/fix is harml=
ess.

Sorry for the disclaimer that will be appended by my organization's mai=
l server.

Thanks,
Meena,
HCL Technologies.

On Wed, Oct 14, 2009 at 7:55 AM, Christian Vilhelm
<christian.vilhelm@univ-lille2.fr>=A0wrote:
>
> Thomas Fjellstrom wrote:
>>
>> On Tue October 13 2009, andy yan wrote:
>>>
>>> I will send you a patch for debugging this issue, please help to tr=
y and
>>> send back the log, thanks!
>>
>> I will do whatever I can to help get this resolved :) I have some C =
skills, but no kernel/device driver experience, so at the very least I =
should be able to do builds and make small changes if needed, in additi=
on to patching and endless reboots ;D
>
> I'm also willing to help.
> The card is not on a production server and the disks connected to the=
 card do not contain any valuable data so I can make any test wanted.
>

=46WIW I have the same card and the same problems. I'll be travelling
the next two weeks +, but after that I can do tests etc.

(Actually I'll probably also be purchasing one of those known-good LSI
PCIe SAS cards discussed in the very recent xfs+md slowdown thread.
Suggest you check it out if you haven't read it.)

- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
DISCLAIMER:
-----------------------------------------------------------------------=
------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and =
intended for the named recipient(s) only.
It shall not attach any liability on the originator or HCL or its affil=
iates. Any views or opinions presented in
this email are solely those of the author and may not necessarily refle=
ct the opinions of HCL or its affiliates.
Any form of reproduction, dissemination, copying, disclosure, modificat=
ion, distribution and / or publication of
this message without the prior written consent of the author of this e-=
mail is strictly prohibited. If you have
received this email in error please delete it and notify the sender imm=
ediately. Before opening any mail and
attachments please check them for viruses and defect.

-----------------------------------------------------------------------=
------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at =A0http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
