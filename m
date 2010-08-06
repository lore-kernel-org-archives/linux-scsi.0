From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing
 task
Date: Fri, 06 Aug 2010 14:01:03 -0500
Message-ID: <4C5C5BEF.8040509@redhat.com>
References: <20100806161622.GA8696@localhost.localdomain> <4C5C448C.2040509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965198Ab0HFTBK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 15:01:10 -0400
In-Reply-To: <4C5C448C.2040509@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, sgruszka@redhat.com, satyasrinivasp@hcl.in, jeff@garzik.org

Konstantinos Skarlatos wrote:
>  Hello,
>=20
> Does this patch fix any of the mvs_abort_task:rc=3D 5 and the other=20
> problems that are being reported for this driver? for more info pleas=
e=20
> see http://marc.info/?l=3Dlinux-scsi&m=3D127583131805429&w=3D2

No, these problems begin with the warning from ata_qc_issue,
it says that a non-NCQ command is being issued, but there is
an active NCQ command on the link.

BTW, I should have added:

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>

David

>=20
> On 6/8/2010 7:16 =C3=8E=C2=BC=C3=8E=C2=BC, David Milburn wrote:
>> mvs_lu_reset should not call mvs_release_task phy number of times,
>> each phy is handled in mvs_release_task.
>>
>> Signed-off-by: David Milburn<dmilburn@redhat.com>
>> Cc: Stanislaw Gruszka<sgruszka@redhat.com>
>> Cc: Srinivas<satyasrinivasp@hcl.in>
>> Cc: Andy Yan<ayan@marvell.com>
>> ---
>>   drivers/scsi/mvsas/mv_sas.c |    6 ++----
>>   1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas=
=2Ec
>> index adedaa9..013ab8d 100644
>> --- a/drivers/scsi/mvsas/mv_sas.c
>> +++ b/drivers/scsi/mvsas/mv_sas.c
>> @@ -1551,7 +1551,7 @@ static int mvs_debug_I_T_nexus_reset(struct=20
>> domain_device *dev)
>>   int mvs_lu_reset(struct domain_device *dev, u8 *lun)
>>   {
>>       unsigned long flags;
>> -    int i, phyno[WIDE_PORT_MAX_PHY], num , rc =3D TMF_RESP_FUNC_FAI=
LED;
>> +    int rc =3D TMF_RESP_FUNC_FAILED;
>>       struct mvs_tmf_task tmf_task;
>>       struct mvs_device * mvi_dev =3D dev->lldd_dev;
>>       struct mvs_info *mvi =3D mvi_dev->mvi_info;
>> @@ -1560,10 +1560,8 @@ int mvs_lu_reset(struct domain_device *dev, u=
8=20
>> *lun)
>>       mvi_dev->dev_status =3D MVS_DEV_EH;
>>       rc =3D mvs_debug_issue_ssp_tmf(dev, lun,&tmf_task);
>>       if (rc =3D=3D TMF_RESP_FUNC_COMPLETE) {
>> -        num =3D mvs_find_dev_phyno(dev, phyno);
>>           spin_lock_irqsave(&mvi->lock, flags);
>> -        for (i =3D 0; i<  num; i++)
>> -            mvs_release_task(mvi, dev);
>> +        mvs_release_task(mvi, dev);
>>           spin_unlock_irqrestore(&mvi->lock, flags);
>>       }
>>       /* If failed, fall-through I_T_Nexus reset */
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
