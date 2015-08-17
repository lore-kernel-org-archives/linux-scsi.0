From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] pm80xx: Don't override ts->stat on IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY
Date: Mon, 17 Aug 2015 15:51:08 +0200
Message-ID: <mqd4mjyowfn.fsf@c203.arch.suse.de>
References: <1439816682-9781-1-git-send-email-jthumshirn@suse.de>
	<CAD+HZHWtvfc1YBM+FdVt1vV8rjkk7GVmX9-NRWXjh=1U4Ez+dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD+HZHWtvfc1YBM+FdVt1vV8rjkk7GVmX9-NRWXjh=1U4Ez+dg@mail.gmail.com>
	(Jack Wang's message of "Mon, 17 Aug 2015 15:28:22 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: lindar_liu <lindar_liu@usish.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "pmchba@pmcs.com" <pmchba@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jack Wang <xjtuwjp@gmail.com> writes:

> 2015-08-17 15:04 GMT+02:00 Johannes Thumshirn <jthumshirn@suse.de>:
>> In case XXX returns with a status of IO_OPEN_CNX_ERROR_HW_RESOURCE_B=
USY

Apparently I've hit enter to fast. This shouldn't be XXX but
psataPayload->status. I'll be sending a v2 :-(.

>> ts->stat gets set to SAS_OPEN_REJECT but a missing 'break' statement=
 causes a
>> fallthrough to the default handler of the switch statement overridin=
g ts->stat
>> to SAS_DEV_NO_RESPONSE.
>>
>> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>
> Thanks, please feel free to add:
> Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
>
>> ---
>>  drivers/scsi/pm8001/pm8001_hwi.c | 1 +
>>  drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/=
pm8001_hwi.c
>> index 96dcc09..d0feec5 100644
>> --- a/drivers/scsi/pm8001/pm8001_hwi.c
>> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
>> @@ -2642,6 +2642,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm=
8001_ha, void *piomb)
>>                 ts->resp =3D SAS_TASK_COMPLETE;
>>                 ts->stat =3D SAS_OPEN_REJECT;
>>                 ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;
>> +               break;
>>         default:
>>                 PM8001_IO_DBG(pm8001_ha,
>>                         pm8001_printk("Unknown status 0x%x\n", statu=
s));
>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/=
pm80xx_hwi.c
>> index 05cce46..18d4ac4 100644
>> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>> @@ -2314,6 +2314,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm=
8001_ha, void *piomb)
>>                 ts->resp =3D SAS_TASK_COMPLETE;
>>                 ts->stat =3D SAS_OPEN_REJECT;
>>                 ts->open_rej_reason =3D SAS_OREJ_RSVD_RETRY;
>> +               break;
>>         default:
>>                 PM8001_IO_DBG(pm8001_ha,
>>                         pm8001_printk("Unknown status 0x%x\n", statu=
s));
>> --
>> 2.5.0
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
