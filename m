From: Hannes Reinecke <hare@suse.de>
Subject: Re: =?UTF-8?B?562U5aSNOiBSZTogW1BhdGNoXSBzY3NpX2Vycm9yOiBzaG91bGQ=?=
 =?UTF-8?B?IG5vdCBnZXQgc2Vuc2UgZm9yIHRpbWVvdXQgSU8gaW4gc2NzaSBlcnJvciBoYW4=?=
 =?UTF-8?B?ZGxlcg==?=
Date: Sat, 01 Aug 2015 09:37:39 +0200
Message-ID: <55BC7743.6080207@suse.de>
References: <OFAF74C95C.6058723F-ON48257E93.00322982-48257E93.00363C6C@zte.com.cn> <55BB756D.5090606@suse.de> <OF7187F435.4453DB49-ON48257E94.000CC72C-48257E94.000D6550@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbbHAHhu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Aug 2015 03:37:50 -0400
In-Reply-To: <OF7187F435.4453DB49-ON48257E94.000CC72C-48257E94.000D6550@zte.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jiang.biao2@zte.com.cn
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, cai.qu@zte.com.cn, long.chun@zte.com.cn, tan.hu@zte.com.cn, chen.donghai@zte.com.cn

On 08/01/2015 04:26 AM, jiang.biao2@zte.com.cn wrote:
> Hannes Reinecke <hare@suse.de> =E5=86=99=E4=BA=8E 2015/07/31 21:17:33=
:
>=20
>> Hannes Reinecke <hare@suse.de>=20
>> 2015/07/31 21:17
>>
>> =E6=94=B6=E4=BB=B6=E4=BA=BA
>>
>> jiang.biao2@zte.com.cn, linux-scsi@vger.kernel.org, JBottomley@odin.=
com,=20
>=20
>>
>> =E6=8A=84=E9=80=81
>>
>> =E4=B8=BB=E9=A2=98
>>
>> Re: [Patch] scsi_error: should not get sense for timeout IO in scsi=20
>> error handler
>>
>> On 07/31/2015 11:52 AM, jiang.biao2@zte.com.cn wrote:
>>> scsi_error: should not get sense for timeout IO in scsi error handl=
er
>>>
>>> When an IO timeout occurs, the IO will be aborted in
>>> scsi_abort_command() and SCSI_EH_ABORT_SCHEDULED will be set. Becau=
se
>>> of that, the SCSI_EH_CANCEL_CMD will be clear in scsi_eh_scmd_add()=
=2E
>>> So when scsi error handler starts, it will get sense for this
>>> timeout IO and the scmd of the IO request will be reused. In that
>>> case, the scmd may be double released when racing with io_done(),
>>> which will result in crash.
>>> SO SCSI_EH_ABORT_SCHEDULED should also be checked when getting sens=
e.
>>> The bug maybe reproduced when the link between host and disk is
>>> unstable.
>>>
>>> Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
>>> Signed-off-by: Long Chun <long.chun@zte.com.cn>
>>> Reviewed-by: Tan Hu <tan.hu@zte.com.cn>
>>> Reviewed-by: Chen Donghai <chen.donghai@zte.com.cn>
>>> Reviewed-by: Cai Qu <cai.qu@zte.com.cn>
>>>
>>> diff -uprN drivers/scsi/scsi_error.c drivers_new/scsi/scsi_error.c
>>> --- scsi/scsi_error.c   2015-07-31 16:03:18.000000000 +0800
>>> +++ scsi_new/scsi_error.c       2015-07-31 16:29:25.000000000 +0800
>>> @@ -1156,9 +1156,14 @@ int scsi_eh_get_sense(struct list_head *
>>>         struct Scsi_Host *shost;
>>>         int rtn;
>>>
>>> +       /*
>>> +        * If SCSI_EH_ABORT_SCHEDULED has been set, it is timeout I=
O,
>>> +        * should not get sense.
>>> +        */
>>>         list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>>>                 if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
>>> -                   SCSI_SENSE_VALID(scmd))
>>> +                   (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) ||
>>> +                    SCSI_SENSE_VALID(scmd))
>>>                         continue;
>>>
>>>                 shost =3D scmd->device->host;
>>> --
>> _Actually_ you need to test for both, SCSI_EH_CANCEL_CMD _and_
>> SCSI_EH_ABORT_SCHEDULED.
>> Not every driver is required to implement and/or support
>> asynchronous command aborts, and those will be setting
>> SCSI_EH_CANCEL_CMD even though they've run into a timeout.
> That's right, but SCSI_EH_CANCEL_CMD _has_ already been tested=20
> in the current code, so there's no need to add in the patch.=20
> After patched, both SCSI_EH_CANCEL_CMD _and_=20
> SCSI_EH_ABORT_SCHEDULED are tested here, that'll ensure no=20
> getting sense for timeout io.
>=20
Ah, right. I've misread the patch.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
