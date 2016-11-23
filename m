From: wangyijing <wangyijing@huawei.com>
Subject: Re: [RFC PATCH] scsi: libsas: fix WARN on device removal
Date: Wed, 23 Nov 2016 09:07:32 +0800
Message-ID: <5834EBD4.5010104@huawei.com>
References: <1478185120-5509-1-git-send-email-john.garry@huawei.com>
 <be84afd4-640d-1913-404a-505fd72c1324@huawei.com>
 <b800ae5c-f275-728c-27b4-230663757781@huawei.com>
 <CAPcyv4g+XzCuHsUvqeE+r8hqgPK3yq=E9k23a89XcLs96bkphg@mail.gmail.com>
 <CAPcyv4hvuFLhS2sYXkccXMTSh-ggxo7uHN2Qt6i5g8GkyBksrw@mail.gmail.com>
 <9870e7bc-a472-1913-1930-ac022e8ad5e8@huawei.com>
 <58257D52.6090507@huawei.com>
 <93ae84f6-75a2-f576-808e-f98c6256b6a6@huawei.com>
 <58258631.1090203@huawei.com>
 <9bdd2ca5-aa72-6a18-b66d-8e791e4852c7@huawei.com>
 <CAPcyv4g7_kDAZNZ2ikBRgFsX-hFpcXEV2xg9YS0Ha7PjSBkzVQ@mail.gmail.com>
 <ca8ce351-ae6c-6878-4cd7-af7af11122ad@huawei.com>
 <CAPcyv4gO2oHg2FjVu89cmy7E7+9QPm4AVF_zSy04C3QXiM0UPw@mail.gmail.com>
 <7d4e4aa5-0d15-ca8c-243f-24c60e1378ed@huawei.com>
 <CAPcyv4jtK4A0mKnBxuurncy8YSLPBC6_nEcanzF3v38TJya8mw@mail.gmail.com>
 <96fb83c2-ef02-181c-b27d-bb4c3dbc8194@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([119.145.14.52]:22649 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752353AbcKWBLX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 20:11:23 -0500
In-Reply-To: <96fb83c2-ef02-181c-b27d-bb4c3dbc8194@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Dan Williams <dan.j.williams@intel.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linuxarm@huawei.com, lindar_liu@usish.com, Tejun Heo <tj@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>

>>
>> The events are not lost.
> 
> In sas_queue_event(), if there is a particular event pending for a port/PHY, we cannot queue further same event types for that port/PHY. I think my colleagues found issue where we try to enqueue multiple complementary events.

Yes， we found this issue in our local tests.

> 
>> The new problem this patch introduces is
>> delaying sas port deletion where it was previously immediate.  So now
>> we can get into a situation where the port has gone down and can start
>> processing a port up event before the previous deletion work has run.
>>
>>>>
>>>>> And it's a very noisy warning, as in 6K lines on the console when an
>>>>> expander is unplugged.
>>>>
>>>>
>>>> Does something like this modulate the failure?
>>
>> I'm curious if we simply need to fix the double deletion of the
>> sas_port bsg queue, could you try the changes below?
>>
> 
> No, I just tested it on a root port and we get the same WARN.
> 
>>>>
>>>> diff --git a/drivers/scsi/scsi_transport_sas.c
>>>> b/drivers/scsi/scsi_transport_sas.c            index
>>>> 60b651bfaa01..11401e5c88ba 100644
>>>>                  --- a/drivers/scsi/scsi_transport_sas.c
>>>> +++ b/drivers/scsi/scsi_transport_sas.c
>>>> @@ -262,9 +262,10 @@ static void sas_bsg_remove(struct Scsi_Host
>>>> *shost, struct sas_rphy *rphy
>>>>  {
>>>>         struct request_queue *q;
>>>>
>>>> -       if (rphy)
>>>> +       if (rphy) {
>>>>                 q = rphy->q;
>>>> -       else
>>>> +               rphy->q = NULL;
>>>> +       } else
>>>>                 q = to_sas_host_attrs(shost)->q;
>>>>
>>>>         if (!q)
>>>>
>>>> .
>>>>
>>>
>>>
>>
>> .
>>
> 
> 
> 
> .
> 

