From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: Re: ata mapping mvsas driver question
Date: Thu, 12 Jan 2017 13:41:06 +0100
Message-ID: <c9684a81-901d-03ea-e322-c27089c4b204@powercraft.nl>
References: <362cdbe9-3633-499e-9ee4-b1a8afed2e40@powercraft.nl>
 <2d56a20b-628f-d621-6c9b-ba5cdf8bf6a0@powercraft.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.cambriumhosting.nl ([217.19.16.174]:53634 "EHLO
        relay02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750819AbdALMlO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 07:41:14 -0500
Received: from relay02.cambriumhosting.nl (localhost [127.0.0.1])
        by relay02.cambriumhosting.nl (Postfix) with ESMTP id 8AEA8805C1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 13:41:11 +0100 (CET)
Received: from yessica.powercraft.nl (ebony.powercraft.nl [84.245.27.193])
        by relay02.cambriumhosting.nl (Postfix) with ESMTP id 7E48580570
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 13:41:11 +0100 (CET)
Received: from [IPv6:2a02:58:5:2e00:a9e:1ff:fe32:7cf4] (unknown [IPv6:2a02:58:5:2e00:a9e:1ff:fe32:7cf4])
        by yessica.powercraft.nl (Postfix) with ESMTPSA id 7D12C20B35
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 13:39:41 +0100 (CET)
In-Reply-To: <2d56a20b-628f-d621-6c9b-ba5cdf8bf6a0@powercraft.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Anyone that know how to figure out the mapping?

Kind regards,

Jelle de Jong

On 08/12/16 13:57, Jelle de Jong wrote:
> Hello everybody,
>
> Can anyone help me out with my question?
>
> Thank you in advance.
>
> Kind regards,
>
> Jelle de Jong
>
> On 26/11/16 21:43, Jelle de Jong wrote:
>> Hello everybody,
>>
>> I am trying to find the mapping for ata22.00. due to some repeated
>> issues:
>>
>> # 3.16.36-1+deb8u2~bpo70+1 crazing down
>> http://paste.debian.net/hidden/54c12fae/
>>
>> # smart status 16 disks WDC 1TB RE SATA
>> http://paste.debian.net/hidden/8bfe8d2f/
>>
>> "[473315.445703] ata22.00: exception Emask 0x0 SAct 0x7fe00007 SErr 0x0
>> action 0x6 frozen"
>>
>> lsscsi --verbose doesn’t provide me with the ata details?
>> http://paste.debian.net/hidden/430599a0/
>>
>> root@shirley:~# lsscsi --verbose
>> [0:0:0:0]    disk    ATA      WDC WD1003FBYX-0 1V01  /dev/sdc
>>   dir: /sys/bus/scsi/devices/0:0:0:0
>> [/sys/devices/pci0000:00/0000:00:1c.0/0000:08:00.0/host0/port-0:0/expander-0:0/port-0:0:0/end_device-0:0:0/target0:0:0/0:0:0:0]
>>
>>
>>
>> I can not find any useful unique_id with the mvsas driver...
>> find /sys/devices/pci0000\:00/0000\:00\:1c.0/0000\:08\:00.0/ -iname
>> unique_id
>>
>> grep ata22 /var/log/messages indicates it is really mapped somewhere...
>>
>> root@shirley:~# readlink /sys/block/sdm
>> ../devices/pci0000:00/0000:00:1c.0/0000:08:00.0/host0/port-0:0/expander-0:0/port-0:0:10/end_device-0:0:10/target0:0:10/0:0:10:0/block/sdm
>>
>>
>>
>> Best I came up with with no results:
>>
>> root@shirley:~# find
>> /sys/devices/pci0000\:00/0000\:00\:1c.0/0000\:08\:00.0/host0/port-0\:0/expander-0\:0/port-0\:0\:10/end_device-0\:0\:10/target0\:0\:10/0\:0\:10\:0/
>>
>> -type f  -exec grep -i ata {} \;
>>
>> Linux shirley 3.16.0-0.bpo.4-amd64 #1 SMP Debian
>> 3.16.36-1+deb8u2~bpo70+1 (2016-10-19) x86_64 GNU/Linux
>> root@shirley:~# lsmod mvsas
>> Usage: lsmod
>>
>> root@shirley:~# modinfo mvsas
>> filename:
>> /lib/modules/3.16.0-0.bpo.4-amd64/kernel/drivers/scsi/mvsas/mvsas.ko
>> license:        GPL
>> version:        0.8.16
>>
>> Thank you in advance!
>>
>> Kind regards,
>>
>> Jelle de Jong
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
