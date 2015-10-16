From: Zhengping Zhou <johnzzpcrystal@gmail.com>
Subject: Re: [PATCH 1/1] scsi subsystem : fix function __scsi_device_lookup
Date: Fri, 16 Oct 2015 20:08:49 +0800
Message-ID: <CALXdtC4so0we1JfJ_E9f6PMw90oL4=aCO9vO9bYCQc7sWof-3Q@mail.gmail.com>
References: <1444894715-4906-1-git-send-email-johnzzpcrystal@gmail.com>
	<561F5B86.5090409@suse.de>
	<CALXdtC4P3fzftnAczKMcSftqpbNEDrL9f1xgVAfMquakRGc2Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33738 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbbJPMIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2015 08:08:50 -0400
Received: by lffv3 with SMTP id v3so79046347lff.0
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2015 05:08:49 -0700 (PDT)
In-Reply-To: <CALXdtC4P3fzftnAczKMcSftqpbNEDrL9f1xgVAfMquakRGc2Uw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Jej B <James.Bottomley@hansenpartnership.com>

2015-10-15 16:22 GMT+08:00 Zhengping Zhou <johnzzpcrystal@gmail.com>:
> Yes
>
> But it's interesting ,when you continue to add this device (with the
> same LUN, target, bus, and host number!) to the list,scsi_add_device
> will call scsi_probe_and_add_lun,and it will call
> scsi_device_lookup_by_target(starget, lun) to recheck its existence
> finally.but scsi_device_lookup_by_target doesn't has the problem  wha=
t
> I mentioned in this patch .So it's OK when you add this device again.
>
> Forgive my poor English!
> 2015-10-15 15:53 GMT+08:00 Hannes Reinecke <hare@suse.de>:
>> On 10/15/2015 09:38 AM, Zhengping Zhou wrote:
>>> when a scsi_device is unpluged from scsi controller, if the
>>> scsi_device is still be used by application layer,it won't be
>>> released until users release it. In this case, scsi_device_remove j=
ust set
>>> the scsi_device's state to be SDEV_DEL. But if you plug the disk
>>> just before the old scsi_device is released, then there will be two
>>> scsi_device structures in scsi_host->__devices. when the next unplu=
ging
>>> event happens,some low-level drivers will check whether the scsi_de=
vice
>>> has been added to host (for example, the megaraid sas series contro=
ller)
>>> by calling scsi_device_lookup(call __scsi_device_lookup).
>>> __scsi_device_lookup will return the first scsi_device. Because its
>>> state is SDEV_DEL, the scsi_device_lookup will return NULL finally,
>>> making the low-level driver assume that the scsi_device has been
>>> removed,and won't call scsi_device_remove,which will lead the
>>> failure of hot swap.
>>> Signed-off-by: Zhengping Zhou <johnzzpcrystal@gmail.com>
>>> ---
>>> Hi all:
>>>       I'm sorry to bother again,that's my second time to send
>>>       this patch.
>>>       I find a bug about the failure of hot swap when I am using
>>>       megaraid sas series controller. Finally I have found that
>>>       when controller receives the event of hot swap, it will first=
ly
>>>       check whether the device is added to the system/host by calli=
ng
>>>       scsi_device_lookup.The logics in function megasas_aen_polling
>>>       is as follows:
>>>             case MR_EVT_PD_REMOVED:
>>>                     if (megasas_get_pd_list(instance) =3D=3D 0) {
>>>                     for (i =3D 0; i < MEGASAS_MAX_PD_CHANNELS; i++)=
 {
>>>                             for (j =3D 0;
>>>                             j < MEGASAS_MAX_DEV_PER_CHANNEL;
>>>                             j++) {
>>>
>>>                             pd_index =3D
>>>                             (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
>>>
>>>                             sdev1 =3D scsi_device_lookup(host, i, j=
, 0);
>>>
>>>                             if (instance->pd_list[pd_index].driveSt=
ate
>>>                                     =3D=3D MR_PD_STATE_SYSTEM) {
>>>                                     if (sdev1)
>>>                                             scsi_device_put(sdev1);
>>>                             } else {
>>>                                     if (sdev1) {
>>>                                             scsi_remove_device(sdev=
1);
>>>                                             scsi_device_put(sdev1);
>>>                                     }
>>>                             }
>>>                             }
>>>                     }
>>>                     }
>>>       If the previous scsi_device is not released, this will lead t=
he
>>>       appearance of two scsi_devices which correspond with the same=
 disk.
>>>       And when the disk is unpluged afterwards, the controller will=
 assume
>>>       that this disk has never been added into the system/host. Thu=
s it won't
>>>       call scsi_device_remove. When I finish this modification, thi=
s problem
>>>       is fixed.So far, I have successfully test PCI_DEVICE_ID_LSI_S=
AS0073SKINNY
>>>       and PCI_DEVICE_ID_LSI_FURY.
>>> Thanks
>>> Zhengping
>>> ---
>>>  drivers/scsi/scsi.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>>> index 207d6a7..5251d6d 100644
>>> --- a/drivers/scsi/scsi.c
>>> +++ b/drivers/scsi/scsi.c
>>> @@ -1118,6 +1118,8 @@ struct scsi_device *__scsi_device_lookup(stru=
ct Scsi_Host *shost,
>>>       struct scsi_device *sdev;
>>>
>>>       list_for_each_entry(sdev, &shost->__devices, siblings) {
>>> +             if (sdev->sdev_state =3D=3D SDEV_DEL)
>>> +                     continue;
>>>               if (sdev->channel =3D=3D channel && sdev->id =3D=3D i=
d &&
>>>                               sdev->lun =3D=3Dlun)
>>>                       return sdev;
>>>
>> Ho-hum.
>>
>> So lookup will return NULL, which then will cause the subsequent
>> functions to assume the scsi_device is not present, right?
>>
>> And if you're _really_ unlucky it'll continue to add this device
>> (with the same LUN, target, bus, and host number!) to the list,
>> resulting in us having _two_ devices with the same number on the lis=
t.
>>
>> Happy lookup.
>>
>> I guess this calls for the lock rework from Johannes ...
>>
>> Cheers,
>>
>> Hannes
>> --
>> Dr. Hannes Reinecke                            zSeries & Storage
>> hare@suse.de                                   +49 911 74053 688
>> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norto=
n
>> HRB 21284 (AG N=C3=BCrnberg)




You can compare the function __scsi_device_lookup_by_target and the
function __scsi_device_lookup.
It will be more easy to figure out this patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
