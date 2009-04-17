From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and implementation.
Date: Fri, 17 Apr 2009 21:43:24 +0400
Message-ID: <49E8BFBC.8010006@vlnb.net>
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com> <49E85F1C.7040106@vlnb.net> <49E8832F.6070302@linux.vnet.ibm.com> <ac3eb2510904170724l654b00b4k79156138f9fd926d@mail.gmail.com> <49E8A551.7050307@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762222AbZDQRn3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 13:43:29 -0400
In-Reply-To: <49E8A551.7050307@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Daniel Debonzi, on 04/17/2009 07:50 PM wrote:
> Hi Kay,
> 
> Thanks for the inputs.
> 
> Do you mean that uses struct device is the right way to do it instead of 
> kobjects or it is just a option to get things on right places into sysfs?
> 
> I don't know this struct closely but my first impression looking to the 
> source code is that it is tied with hardware and has some complexity we 
> probably don't need. What do you think?

I agree, looks like using struct device instead of struct kobject should 
additionally complicate the code a lot for not clear gain.

> Regards,
> Daniel Debonzi
> 
> 
> Kay Sievers wrote:
>> On Fri, Apr 17, 2009 at 15:25, Daniel Debonzi
>> <debonzi@linux.vnet.ibm.com> wrote:
>>> Vladislav Bolkhovitin wrote:
>>>>> Based on all I read this last days, I believe we are not allowed to
>>>>> include the directory scsi_tgt on /sys root. I think it has to be in a
>>>>> existent directory reserved for this sort of application. I just didn't
>>>>> figured out which one it would be.
>> Right, there will be no new out-of-/sys/devices/ top-level device dir,
>> unless you convince everybody to have a scsifs, which would be in
>> /sys/kernel/scsi/, and which would not use the driver core device
>> stuff at all. :)
>>
>>>> /sys/class? It already has scsi_device, scsi_disk, scsi_generic and
>>>> scsi_host.
>> If it's a bus or a class, it does not matter. What you need to include
>> is a "struct device" (and not a kobject) if you want them to show up
>> in the common directories.
>>
>>> I don't think so because all the directories on /sys/class have symlinks to
>>> the files somewhere else. However I noticed that many of them on my system
>>> are on /sys/device/virtual
>> All "struct device" devices appear in /sys/devices/, that's the single
>> place the hierarchy is expressed. The classification, meaning the
>> "collection of devices of the same subsystem" happens in /sys/bus/
>> /sys/class/, therefore they are only flat lists of links. Virtual are
>> devices which have no parent assigned. The driver core prepends
>> virtual to them, when they are registered.
>>
>> Kay
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

