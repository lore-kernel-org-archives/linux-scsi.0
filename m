From: Paul Guo <ggang@tilera.com>
Subject: Re: [PATCH] [SCSI] mvsas: Fix the kernel panic due to unaligned data
 access
Date: Mon, 10 Jun 2013 00:31:54 +0800
Message-ID: <51B4ADFA.5@tilera.com>
References: <5189F864.5080808@tilera.com> <51B42AE9.2080405@tilera.com> <F766E4F80769BD478052FB6533FA745D3ED4419C13@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usmamail.tilera.com ([12.216.194.151]:15299 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3FIQb7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jun 2013 12:31:59 -0400
In-Reply-To: <F766E4F80769BD478052FB6533FA745D3ED4419C13@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>

Xiangliang,

I do not have a chance to test on x86 now. Not sure whether
I can find an available environment for x86 testing.
But this change is so simple and in theory it is harmless
to x86. For architectures which do need aligned data access,
they should have the same symptom as arch/tile.

Thanks,
Paul


> Hi, Paul
> Do you have tested it on X86 or arm? If work fine, I agree with it.
>=20
>=20
>> -----Original Message-----
>> From: Paul Guo [mailto:ggang@tilera.com]
>> Sent: 2013=C4=EA6=D4=C29=C8=D5 15:13
>> To: Xiangliang Yu; linux-scsi@vger.kernel.org
>> Cc: JBottomley@Parallels.com
>> Subject: Re: [PATCH] [SCSI] mvsas: Fix the kernel panic due to unali=
gned data
>> access
>>
>> Ping. Anyone who knows the driver please speak up, either yes or no
>> or need more info. This is a really small fix.
>>
>> Thanks,
>> Paul
>>
>>> It's easy to find the address and symbol that causes the unalignd d=
ata
>>> access according to the stack dump information. The following small
>>> patch will fix it.
>>>
>>> This change is harmless for platforms (like x86/x64) which support
>>> unaligned data access but is critical for platforms those do not su=
pport
>>> unaligned data access (like our platform: arch/tile).
>>>
>>> I sent the patch but did not ping the status. I sync-up the workspa=
ce
>>> and re-generate the patch again. Feel free to give me any feedback.=
 It's
>>> really annoying to maintain the change internally.
>>>
>>> Thanks,
>>> Paul
>>>
>>>
>>> Signed-off-by: Paul Guo <ggang@tilera.com>
>>> ---
>>>  drivers/scsi/mvsas/mv_sas.c |    5 +++--
>>>  drivers/scsi/mvsas/mv_sas.h |    1 +
>>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sa=
s.c
>>> index fd3b283..18e133e 100644
>>> --- a/drivers/scsi/mvsas/mv_sas.c
>>> +++ b/drivers/scsi/mvsas/mv_sas.c
>>> @@ -1852,10 +1852,11 @@ int mvs_slot_complete(struct mvs_info *mvi,=
 u32
>> rx_desc, u32 flags)
>>>     }
>>>
>>>     /* error info record present */
>>> -   if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response)))=
 {
>>> +   if (unlikely((rx_desc & RXQ_ERR) &&
>>> +                 get_unaligned_le64((u64 *) slot->response))) {
>>>             mv_dprintk("port %d slot %d rx_desc %X has error info"
>>>                     "%016llX.\n", slot->port->sas_port.id, slot_idx=
,
>>> -                    rx_desc, (u64)(*(u64 *)slot->response));
>>> +                    rx_desc, get_unaligned_le64((u64 *) slot->resp=
onse));
>>>             tstat->stat =3D mvs_slot_err(mvi, task, slot_idx);
>>>             tstat->resp =3D SAS_TASK_COMPLETE;
>>>             goto out;
>>> diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sa=
s.h
>>> index c04a4f5..c89c145 100644
>>> --- a/drivers/scsi/mvsas/mv_sas.h
>>> +++ b/drivers/scsi/mvsas/mv_sas.h
>>> @@ -39,6 +39,7 @@
>>>  #include <linux/irq.h>
>>>  #include <linux/slab.h>
>>>  #include <linux/vmalloc.h>
>>> +#include <linux/unaligned.h>
>>>  #include <scsi/libsas.h>
>>>  #include <scsi/scsi.h>
>>>  #include <scsi/scsi_tcq.h>
>>>
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
