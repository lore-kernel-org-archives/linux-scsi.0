From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing
 task
Date: Mon, 09 Aug 2010 11:17:16 +0300
Message-ID: <4C5FB98C.7090107@gmail.com>
References: <20100806161622.GA8696@localhost.localdomain> <4C5C448C.2040509@gmail.com> <4C5C5BEF.8040509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50454 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab0HIIRb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2010 04:17:31 -0400
Received: by wyb39 with SMTP id 39so9625115wyb.19
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2010 01:17:30 -0700 (PDT)
In-Reply-To: <4C5C5BEF.8040509@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, sgruszka@redhat.com, satyasrinivasp@hcl.in, jeff@garzik.org

  Thanks for your answer, I was just asking because this driver is used=
=20
by an inexpensive and quite popular SAS/SATA controller (Supermicro=20
AOC-SASLP-MV8), but unfortunately nobody has responded to the various=20
reports of bugs and general instability.

I am willing to do my part in helping out, including testing patches an=
d=20
maybe a small donation to a developer.


On 6/8/2010 10:01 =CE=BC=CE=BC, David Milburn wrote:
> Konstantinos Skarlatos wrote:
>>  Hello,
>>
>> Does this patch fix any of the mvs_abort_task:rc=3D 5 and the other=20
>> problems that are being reported for this driver? for more info=20
>> please see http://marc.info/?l=3Dlinux-scsi&m=3D127583131805429&w=3D=
2
>
> No, these problems begin with the warning from ata_qc_issue,
> it says that a non-NCQ command is being issued, but there is
> an active NCQ command on the link.
>
> BTW, I should have added:
>
> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
>
> David
>
>>
>> On 6/8/2010 7:16 =C3=8E=C2=BC=C3=8E=C2=BC, David Milburn wrote:
>>> mvs_lu_reset should not call mvs_release_task phy number of times,
>>> each phy is handled in mvs_release_task.
>>>
>>> Signed-off-by: David Milburn<dmilburn@redhat.com>
>>> Cc: Stanislaw Gruszka<sgruszka@redhat.com>
>>> Cc: Srinivas<satyasrinivasp@hcl.in>
>>> Cc: Andy Yan<ayan@marvell.com>
>>> ---
>>>   drivers/scsi/mvsas/mv_sas.c |    6 ++----
>>>   1 files changed, 2 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sa=
s.c
>>> index adedaa9..013ab8d 100644
>>> --- a/drivers/scsi/mvsas/mv_sas.c
>>> +++ b/drivers/scsi/mvsas/mv_sas.c
>>> @@ -1551,7 +1551,7 @@ static int mvs_debug_I_T_nexus_reset(struct=20
>>> domain_device *dev)
>>>   int mvs_lu_reset(struct domain_device *dev, u8 *lun)
>>>   {
>>>       unsigned long flags;
>>> -    int i, phyno[WIDE_PORT_MAX_PHY], num , rc =3D TMF_RESP_FUNC_FA=
ILED;
>>> +    int rc =3D TMF_RESP_FUNC_FAILED;
>>>       struct mvs_tmf_task tmf_task;
>>>       struct mvs_device * mvi_dev =3D dev->lldd_dev;
>>>       struct mvs_info *mvi =3D mvi_dev->mvi_info;
>>> @@ -1560,10 +1560,8 @@ int mvs_lu_reset(struct domain_device *dev,=20
>>> u8 *lun)
>>>       mvi_dev->dev_status =3D MVS_DEV_EH;
>>>       rc =3D mvs_debug_issue_ssp_tmf(dev, lun,&tmf_task);
>>>       if (rc =3D=3D TMF_RESP_FUNC_COMPLETE) {
>>> -        num =3D mvs_find_dev_phyno(dev, phyno);
>>>           spin_lock_irqsave(&mvi->lock, flags);
>>> -        for (i =3D 0; i<  num; i++)
>>> -            mvs_release_task(mvi, dev);
>>> +        mvs_release_task(mvi, dev);
>>>           spin_unlock_irqrestore(&mvi->lock, flags);
>>>       }
>>>       /* If failed, fall-through I_T_Nexus reset */
>>> --=20
>>> To unsubscribe from this list: send the line "unsubscribe=20
>>> linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
