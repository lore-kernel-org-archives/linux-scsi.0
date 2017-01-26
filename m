From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: mvsas escalated kernel crash and ata mapping mvsas driver question
Date: Thu, 26 Jan 2017 14:30:43 +0100
Message-ID: <CAD+HZHUTaW5eM4eVmjARBo8qUt5tb0yuBULDtZX0W4Qwzf_toA@mail.gmail.com>
References: <362cdbe9-3633-499e-9ee4-b1a8afed2e40@powercraft.nl>
 <2d56a20b-628f-d621-6c9b-ba5cdf8bf6a0@powercraft.nl> <c9684a81-901d-03ea-e322-c27089c4b204@powercraft.nl>
 <d8615494-756f-0fe9-9969-8e850fc5984d@powercraft.nl> <CAD+HZHW-0keq5RUiqMGpO_EnOLa7Z6ZeAtwtkGXvThi=sf4siw@mail.gmail.com>
 <879d8f02-5bb6-fe8a-0fea-9ad8943a15cf@powercraft.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:35631 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752145AbdAZNao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jan 2017 08:30:44 -0500
Received: by mail-ot0-f173.google.com with SMTP id 65so174690847otq.2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 05:30:44 -0800 (PST)
In-Reply-To: <879d8f02-5bb6-fe8a-0fea-9ad8943a15cf@powercraft.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jelle de Jong <jelledejong@powercraft.nl>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

2017-01-26 12:53 GMT+01:00 Jelle de Jong <jelledejong@powercraft.nl>:
> Beste Jack,
>
> I set the queue_depth to 1 and timeout to 300 for all SATA disk connected to
> the mvsas controller [ARC-1300ix-16].
>
> Does this mean that ata21 is mapped to /dev/sdq!
>
> root@sweeney:~# dmesg | grep ata21 | grep device
> [    4.788568] sas: ata21: end_device-0:0:26: dev error handler
>
> root@sweeney:~# lsscsi -v | grep end_device-0:0:26
>   dir: /sys/bus/scsi/devices/0:0:14:0
> [/sys/devices/pci0000:00/0000:00:1c.0/0000:08:00.0/host0/port-0:0/expander-0:0/port-0:0:26/end_device-0:0:26/target0:0:14/0:0:14:0]
>
> root@sweeney:~# lsscsi -v | grep 0:0:14:0
> [0:0:14:0]   disk    ATA      WDC WD1003FBYX-0 1V01  /dev/sdq
>   dir: /sys/bus/scsi/devices/0:0:14:0
> [/sys/devices/pci0000:00/0000:00:1c.0/0000:08:00.0/host0/port-0:0/expander-0:0/port-0:0:26/end_device-0:0:26/target0:0:14/0:0:14:0]
>
> I added the following to my rc.local
>
> vim /etc/rc.local
>
> for disk in sd{c..r}; do
>     echo deadline > /sys/block/$disk/queue/scheduler
>     echo 0 > /sys/block/$disk/queue/iosched/front_merges
>     echo 150 > /sys/block/$disk/queue/iosched/read_expire
>     echo 1500 > /sys/block/$disk/queue/iosched/write_expire
>     echo 1 > /sys/block/$disk/device/queue_depth;
>     echo 300 > /sys/block/$disk/device/timeout;
> done
>
> I hope the performance impact of queue_depth = 1 is not to much....

Yes, sdq maps to ata21.

Regards,
Jack


>
> Kind regards,
>
> Jelle de Jong
>
> On 26/01/17 11:17, Jack Wang wrote:
>>
>> 2017-01-26 10:51 GMT+01:00 Jelle de Jong <jelledejong@powercraft.nl>:
>>>
>>> Hello everybody,
>>>
>>> I got a server that seemingly random gets kernel crashes, due to an
>>> escalation of events from most likely the mvsas based disk controller.
>>>
>>> The harddisk should be okay, I replaced a whole bunch to be sure, but the
>>> server does not get stable. I can not seem to figure out how to map for
>>> example ata21.00 to an disk so I can do a deep badblock check.
>>>
>>> I have to complete boot with kernel crash log saved with additional
>>> information.
>>>
>>> http://paste.debian.net/plainh/96325d89
>>>
>>> Can somebody take a look and maybe help?
>>>
>>>
>>> 08:00.0 SCSI storage controller: Areca Technology Corp. ARC-1300ix-16
>>> 16-Port PCI-Express to SAS Non-RAID Host Adapter (rev 02)
>>>
>>> Kind regards,
>>>
>>> Jelle de Jong
>>
>>
>> Your IO error seems related to NCQ, have you tried to disable NCQ?
>>
>> echo 1 > /sys/block/sdX/device/queue_depth
>>
>> Maybe try 4.10-rc5 is also a option?
>>
>> Regards,
>> Jack
>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
