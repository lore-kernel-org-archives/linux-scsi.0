From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 04/11] megaraid_sas : Firmware crash dump feature support
Date: Wed, 10 Sep 2014 17:28:40 +0200
Message-ID: <54106E28.1030807@redhat.com>
References: <201409061328.s86DS6lO012975@palmhbs0.lsi.com> <540F22A2.3040906@redhat.com> <55ba5d7cdee7dbcce18dc1a2bbbefc03@mail.gmail.com> <94D0CD8314A33A4D9D801C0FE68B402958C70F51@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbaIJPba (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 11:31:30 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C70F51@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Sumit Saxena <sumit.saxena@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, Kashyap Desai <kashyap.desai@avagotech.com>, "aradford@gmail.com" <aradford@gmail.com>, Michal Schmidt <mschmidt@redhat.com>, "amirv@mellanox.com" <amirv@mellanox.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>, "Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>

On 09/10/2014 05:06 PM, Elliott, Robert (Server Storage) wrote:
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Sumit Saxena
>>
>>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>>>
>>> With several controllers in a system this may take a lot memory,
>>> could you also in case when a kdump kernel is running lower it,
>>> by not using this feature?
>>>
>> Agreed, we will disable this feature for kdump kernel by adding
>> "reset_devices" global varaiable.
>> That check is required for only one place, throughout the code, this
>> feature will remain disabled.  Code snippet for the same-
>>
>>         instance->crash_dump_drv_support =3D (!reset_devices) &&
>> crashdump_enable &&
>>                                 instance->crash_dump_fw_support &&
>>                                 instance->crash_dump_buf);
>>         if(instance->crash_dump_drv_support) {
>>                 printk(KERN_INFO "megaraid_sas: FW Crash dump is
>> supported\n");
>>                 megasas_set_crash_dump_params(instance,
>> MR_CRASH_BUF_TURN_OFF);
>>
>>         } else {
>> ..
>>         }
> Network drivers have been running into similar problems.
>
> There's a new patch from Amir coming through net-next to make=20
> is_kdump_kernel() (in crash_dump.h) accessible to modules.
> That may be a better signal than reset_devices that the
> driver should use minimal resources.
>
> http://comments.gmane.org/gmane.linux.network/324737
>
> I'm not sure about the logistics of a SCSI patch depending
> on a net-next patch.

Probably better to start with reset_devices and switch to is_kdump_kern=
el()
later.=20
This is not a discussion about reset_devices versus is_kdump_kernel, bu=
t
while it looks good to have it distinguished - is the reset_devices act=
ually
used anywhere else than in kdump kernel?
=20

>
> ---
> Rob Elliott    HP Server Storage
>
>
>
>
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=
=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=
z=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=
=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
