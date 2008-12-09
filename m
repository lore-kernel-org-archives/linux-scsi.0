From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: rmmod qlogic driver stuck
Date: Tue, 09 Dec 2008 14:04:55 +0300
Message-ID: <493E50D7.3020808@vlnb.net>
References: <1228736014.6291.221.camel@galr-linux.storwiz.com>	 <9BECC90A-21CB-4600-A6F9-9ABEAEB48839@qlogic.com>	 <1228758532.6291.229.camel@galr-linux.storwiz.com> <1228805044.6291.248.camel@galr-linux.storwiz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:54918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYLILEt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2008 06:04:49 -0500
In-Reply-To: <1228805044.6291.248.camel@galr-linux.storwiz.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gal Rosen <galr@storwize.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com


Gal Rosen wrote:
> Ok, now the picture is more clear.
> It happened only with the virtual ports.
> With physical port and LUNs that defined with write cache enable rmmod
> succeeded, and on the messages file I see:
> [57972.480234] sd 40:0:0:1: [sdb] Synchronizing SCSI cache
> [57972.530263] sd 40:0:0:1: [sdb] Result: hostbyte=DID_NO_CONNECT
> driverbyte=DRIVER_OK,SUGGEST_OK
> 
> While with virtual port I see only:
> [57972.480234] sd 40:0:0:1: [sdb] Synchronizing SCSI cache
> and never get the Result.
> 
> Anyone has an idea?

I can guess that the remote device was disconnected before 
SYNCHRONIZE_CACHE command was sent to it, so it either doesn't go to 
anywhere, or goes to nowhere. Then SCSI mid-layer is waiting for it to 
finish, maybe, infinitely (unlikely) or until some timeout.

> Thanks,
> Gal.
> 
> On Mon, 2008-12-08 at 19:48 +0200, Gal Rosen wrote:
>> On Mon, 2008-12-08 at 09:23 -0800, Seokmann Ju wrote:
>>> On Dec 8, 2008, at 3:33 AM, Gal Rosen wrote:
>>>
>>>> Hi,
>>>>
>>>> I am working against IBM Total Storage DS4000 with LSI INF-01-00 Rev:
>>>> 0534 controller. First I don't understand why this controller  
>>>> present 32
>>>> access LUNs instead of one.
>>>>
>>>> But my main issue is when I create virtual port and then try to rmmod
>>>> the qlogic driver, it stuck. I must say that I made changes to the
>>>> qlogic driver which add possibility to create virtual port in FC-AL
>>>> topology. The base driver is from kernel 2.6.26.2.
>>>>
>>>> Here is a part of the messages file:
>>>>
>>>> [ 1814.053285] scsi(7): DPC handler exiting
>>> [snip]
>>>> host5 is the physical port, and host8 is the virtual port that created
>>>> on host5.
>>>> This issue does not occur against CLARiiON for instanse.
>>> As you may know, the NPIV feature implemented in such a way to work only
>>> in switched fabric topology.
>>> It requires certain switch with NPIV capable to be able to make the
>>> feature fully working.
>> Yes, I know that, but we use the Multi ID feature in Qlogic 24xx
>> firmware, to create the virtual port in LOOP topology.
>>
>> I found that if I configure the LUN in the array to write cache disable
>> this problem does not occur; does this tell something to anyone ?
>> I don't think that it related to the vport, it will happened also with
>> physical port.
>>
>> Gal.
>>> Thank you,
>>> Seokmann
>>>
>>>>
>>>> Please help !!!
>>>>
>>>> Thanks,
>>>> Gal Rosen.
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux- 
>>>> scsi" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
