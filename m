From: "Meena Shanmugam, TLS-Chennai" <smeena@hcl.in>
Subject: RE:  MVSAS 1669:mvs_abort_task:rc= 5
Date: Wed, 14 Oct 2009 21:09:07 +0530
Message-ID: <3CD4E24D4F537D439B71EB28963F98F46815EA2115@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
References: <4CA9DA403FFEC64AA62B3C295F8D47B72126836F2E@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:49654 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761854AbZJNQCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2009 12:02:22 -0400
In-Reply-To: <4CA9DA403FFEC64AA62B3C295F8D47B72126836F2E@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "tfjellstrom@shaw.ca" <tfjellstrom@shaw.ca>

Hi,

I am also facing the same problem with this driver. I'm using Adaptec A=
SC-1045 which uses the Marvell 88SE6440 chip. In my case, this could be=
 reproduced with RAID-5 configured with 3 SATA drives. While analysing =
the problem, it looks like the prd table is getting corrupted in the SA=
TA path triggers the issue.

----mvs_sas.c---
 726 #ifndef DISABLE_HOTPLUG_DMA_FIX
 727         if (task->data_dir =3D=3D DMA_FROM_DEVICE)
 728                 MVS_CHIP_DISP->dma_fix(asi->bulk_buffer_dma,
 729                         TRASH_BUCKET_SIZE, tei->n_elem, buf_prd);
 730 #endif
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
More majordomo info at  http://vger.kernel.org/majordomo-info.html

DISCLAIMER:
-----------------------------------------------------------------------=
------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and =
intended for the named recipient(s) only.=20
It shall not attach any liability on the originator or HCL or its affil=
iates. Any views or opinions presented in=20
this email are solely those of the author and may not necessarily refle=
ct the opinions of HCL or its affiliates.=20
Any form of reproduction, dissemination, copying, disclosure, modificat=
ion, distribution and / or publication of=20
this message without the prior written consent of the author of this e-=
mail is strictly prohibited. If you have=20
received this email in error please delete it and notify the sender imm=
ediately. Before opening any mail and=20
attachments please check them for viruses and defect.

-----------------------------------------------------------------------=
------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
