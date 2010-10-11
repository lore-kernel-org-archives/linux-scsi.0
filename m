From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to
 MegaRAID SAS drive
Date: Mon, 11 Oct 2010 15:20:39 +0200
Message-ID: <4CB30F27.9090009@redhat.com>
References: <AANLkTin53S+C_+QzF-drs5BUAx=k7YeiHrTaQGTFSc_a@mail.gmail.com>	 <4CAF3E04.1050304@redhat.com> <1286555954.2985.110.camel@mulgrave.site> <4CAF70CD.6020307@redhat.com> <4CB0D2AF.7080609@redhat.com> <4B6A08C587958942AA3002690DD4F8C30100F5506B@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab0JKNVn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2010 09:21:43 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30100F5506B@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@suse.de>, bo yang <boyang1288@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 10/11/2010 02:55 PM, Yang, Bo wrote:
> Tomas,
>
>  =20
>> Another correction - flush_scheduled_work is already present in mega=
ss_detach_one
>> it only should be moved away from the if statement.
>>    =20
> The flush_scheduled_work is for schedule_delayed_work().  We need to =
flush it and remove.
>  =20
I'm not saying it should be removed, I think a move outside from the 'i=
f' block
makes it work for ev->hotplug_work and for the newly added instance->wo=
rk_init


diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megara=
id/megaraid_sas.c
index 55951f4..7773707 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -4088,9 +4088,9 @@ static void __devexit megasas_detach_one(struct p=
ci_dev *pdev)
 		struct megasas_aen_event *ev =3D instance->ev;
 		cancel_delayed_work(
 			(struct delayed_work *)&ev->hotplug_work);
-		flush_scheduled_work();
-		instance->ev =3D NULL;
 	}
+	flush_scheduled_work();
+	instance->ev =3D NULL;
=20
 	tasklet_kill(&instance->isr_tasklet);
=20
--

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]=20
> Sent: Saturday, October 09, 2010 4:38 PM
> To: James Bottomley
> Cc: bo yang; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@=
vger.kernel.org; Yang, Bo
> Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Re=
set to MegaRAID SAS drive
>
> On 10/08/2010 09:28 PM, Tomas Henzl wrote:
>  =20
>> On 10/08/2010 06:39 PM, James Bottomley wrote:
>>  =20
>>    =20
>>> On Fri, 2010-10-08 at 17:51 +0200, Tomas Henzl wrote:
>>>  =20
>>>    =20
>>>      =20
>>>> On 09/23/2010 04:36 AM, bo yang wrote:
>>>>    =20
>>>>      =20
>>>>        =20
>>>>> This patch is too big.  I am using attachment to submit.  Please
>>>>> use attached file to apply.  Also let me know if it can't be acce=
pted.
>>>>>
>>>>> To add the Online controller reset support, driver need to do:
>>>>> a). reset the controller chips -- Xscale and Gen2 which will chan=
ge
>>>>> the function calls and add the reset function related to this two
>>>>> chips.
>>>>> b). during the reset, driver will store the pending cmds which no=
t
>>>>> returned by FW to driver's pending queue.  Driver will re-issue t=
hose
>>>>> pending cmds again to FW after the OCR finished.
>>>>> c). In driver's timeout routine, driver will report to OS as rese=
t.
>>>>> Also driver's queue routine will block the cmds until the OCR
>>>>> finished.
>>>>> d). in Driver's ISR routine, if driver get the FW state as state
>>>>> change, FW in Failure status and FW support online controller
>>>>> reset (OCR), driver will start to do the controller reset.
>>>>> e). In driver's IOCTL routine, the application cmds will wait for=
 the
>>>>> OCR to finish, then issue the cmds to FW.
>>>>>
>>>>> Signed-off-by Bo Yang<bo.yang@lsi.com>
>>>>>
>>>>> ---
>>>>>  drivers/scsi/megaraid/megaraid_sas.c |  756 ++++++++++++++++++++=
++++++++++++---
>>>>>  drivers/scsi/megaraid/megaraid_sas.h |   88 +++-
>>>>>  2 files changed, 787 insertions(+), 57 deletions(-)
>>>>>      =20
>>>>>        =20
>>>>>          =20
>>>> Hi Bo,
>>>> in the workqueue function you sleep for 30s,
>>>> it's scheduled here - schedule_work(&instance->work_init);
>>>>
>>>> +process_fw_state_change_wq(struct work_struct *work)
>>>> +{
>>>> ...
>>>> +		/*waitting for about 20 second before start the second init*/
>>>> +		for (wait =3D 0; wait < 30; wait++) {
>>>> +			msleep(1000);
>>>> +		}
>>>>    =20
>>>>      =20
>>>>        =20
>>> this lot should be ssleep(20) if you want a 20 sec sleep.
>>>  =20
>>>    =20
>>>      =20
>> please do that on every place where you use the=20
>> "for (wait =3D 0; wait < n; wait++) msleep(1000);" construction
>>
>>  =20
>>    =20
>>>> - this is not a good practice to sleep for a so long time I think
>>>>    =20
>>>>      =20
>>>>        =20
>> this long sleep might might be ok, if the workqueue is used only rar=
ely
>> is it so?
>>
>>  =20
>>    =20
>>>> - you should use in your exit function some synchronization=20
>>>>   for example 'cancel_work_sync', without that if someone rmmods y=
our=20
>>>>   module, it could then lead to a memory corruption
>>>>    =20
>>>>      =20
>>>>        =20
>>> Actually flush_scheduled_work() should be fine ... it will force th=
e
>>> module removal to wait for completion ... cancellation can be error
>>> prone, so just forcing the wait sounds easier.
>>>  =20
>>>    =20
>>>      =20
> Another correction - flush_scheduled_work is already present in megas=
s_detach_one
> it only should be moved away from the if statement.
>
>
>  =20
>> someone told that cancel_work_sync is safer then flush_scheduled_wor=
k
>> but I'm not an expert, so ok=20
>>
>> Tomas
>>
>>  =20
>>    =20
>>> James
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>  =20
>>>    =20
>>>      =20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>  =20
>>    =20
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=
=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=
z=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=
=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=
=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
