From: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
Subject: RE: kernel panics and errors on lsi 1064e
Date: Tue, 7 Apr 2009 13:56:46 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0904071346230.13438@tassadar.physics.auth.gr>
References: <Pine.LNX.4.64.0903201242300.27079@tassadar.physics.auth.gr>
 <1237562844.12008.55.camel@localhost.localdomain>
 <Pine.LNX.4.64.0903202204490.1954@tassadar.physics.auth.gr>
 <0D1E8821739E724A86F4D16902CE275C1410DBBE2D@inbmail01.lsi.com>,<Pine.LNX.4.64.0903232059090.16669@tassadar.physics.auth.gr>
 <0D1E8821739E724A86F4D16902CE275C1410E52A57@inbmail01.lsi.com>
 <Pine.LNX.4.64.0903241108110.26879@tassadar.physics.auth.gr>
 <0D1E8821739E724A86F4D16902CE275C1410DBBF83@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tassadar.physics.auth.gr ([155.207.123.25]:38030 "EHLO
	tassadar.physics.auth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZDGLK1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 07:10:27 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1410DBBF83@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Mohapatra, Sisir" <Sisir.Mohapatra@lsi.com>


Hi,


On Tue, 24 Mar 2009, Desai, Kashyap wrote:

> It has some problem with your initrd.
>
> I will suggest you if you are not keen using mpt driver as part of initrd.
>
> Goto build directory where you have build newer version of MPT driver.
> You will see load, uload shell scripts.
> Run ./uload and ./load in order to get MPT driver loaded.
>
> If you still find problem, then let me know.
>
> Meanwhile, I will find out how to get latest driver for you.
>
> Thanks
> Kashyap Desai



Any news on the new driver?

So far both lsi and intel support departments refused to help. Intel wants 
me to run original RHEL 5 and different Kingston memory modules than the one
their reseller provided with the server before they answer. I will comply 
with their requirements not only to see if it helps (unlikely) , but also
to give the people dealing with purchases a hint about future vendor preference.

No more crashes or strange errors have been recorded so far since my last 
e-mail.

Cheers
>
>
> -----Original Message-----
> From: Dimitris Zilaskos [mailto:dzila@tassadar.physics.auth.gr]
> Sent: Tuesday, March 24, 2009 2:41 PM
> To: Desai, Kashyap
> Cc: James Bottomley; linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya; Mohapatra, Sisir
> Subject: RE: kernel panics and errors on lsi 1064e
>
>
> I attach the dmesg output just in case.
>
> Still no luck finding newer driver version.
>
> Cheers,
>
> On Tue, 24 Mar 2009, Desai, Kashyap wrote:
>
>> Hi,
>>
>>
>> 3.13.04.00 is very old version. Can you go for version 3.18.00.00-1 driver version ?
>>
>> To enable debug you have to follow these steps.
>>
>> 1.  ./makempt  (Is this file present for you ? If not then I can send you.)
>> 2.  ./update
>> 3.  mkinitrd
>>
>> Thanks
>> Kashyap Desai
>> ________________________________________
>> From: Dimitris Zilaskos [dzila@tassadar.physics.auth.gr]
>> Sent: Monday, March 23, 2009 3:33 PM
>> To: Desai, Kashyap
>> Cc: James Bottomley; linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya; Mohapatra, Sisir
>> Subject: RE: kernel panics and errors on lsi 1064e
>>
>> ok now i have this:
>>
>>
>> cat /proc/mpt/version
>> mptlinux-3.13.04.00
>>   Fusion MPT base driver
>>   Fusion MPT SAS host driver
>>   Fusion MPT SPI host driver
>>   Fusion MPT ioctl driver
>>
>> but still no debug_level
>>
>> However I did some tricks to get the driver load so I am not sure I did
>> not mess up.
>>
>> a) the included binaries are up to 2.6.9-78 kernel so I used the sources
>> tarball prvided.
>> b) Executed "compile"
>> c) Executed "update"
>> d) c) had problems finding mptscsi.ko which was removed by the process.
>> e) copied the missing files from another node
>> f) ran mkinitrd manually
>> g) rebooted, some complains on dmesg about beeing unable to load mptscsi,
>> other than that server booted fine.
>>
>> Preliminary test with the new driver resulted in no errors, but that's not
>> the same as a real world case. Still the debug_level is not there. Do I
>> need another driver?
>>
>> Cheers,
>>
>>
>> --
>> =============================================================================
>> Dimitris Zilaskos
>> GridAUTH Operations Centre @ Aristotle University of Thessaloniki , Greece
>> Tel: +302310998988 Fax: +302310994309
>> http://www.grid.auth.gr
>> =============================================================================
>>
>> On Mon, 23 Mar 2009, Desai, Kashyap wrote:
>>
>>> Hi,
>>>
>>> After firmware upgrade, you are seeing only MPT logs but system is running fine. Those prints are not harmful, but it requires attention why it happened? I need some information to help you further.
>>>
>>> 1. Information of driver version. (cat /proc/mpt/version)
>>> 2. Information of firmware. (cat /proc/mpt/iocX/info)
>>> 3. Driver log level setting.
>>>       MPT driver has debug_level settings to get more logs.
>>>       Check "cat /sys/class/scsi_host/host*/proc_name"
>>>       Use index number for "mptsas" from result of previous command.
>>>       "echo 0x8188 > /sys/class/scsi_host/host<index>/debug_level".
>>>
>>>
>>> NOTE: Above debug level settings are available from some version onwards.
>>>       Driver used by you may not have this support, depending upon driver     version.
>>>
>>> Please provide us log with driver debug enable as mention in #3 will help to debug further.
>>>
>>> Added Sisir and Sathya in CC list.
>>>
>>> Thanks
>>> Kashyap
>>>
>>>
>>>
>>> -----Original Message-----
>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dimitris Zilaskos
>>> Sent: Saturday, March 21, 2009 1:41 AM
>>> To: James Bottomley
>>> Cc: linux-scsi@vger.kernel.org; Moore, Eric
>>> Subject: Re: kernel panics and errors on lsi 1064e
>>>
>>>
>>> Thank you for you reply,
>>>
>>>> So that's the right thing to do (or better yet, contact LSI support to
>>>> see if they have a newer version).
>>>
>>> Will do so
>>>
>>>> This has become a log information, so the IOC firmware now dealt with
>>>> whatever the problem was.
>>>>
>>>>
>>>>> Is something broken here? I am close to ask for the systems to be replaced.
>>>>
>>>> You imply that with the firmware upgrade, nothing now goes wrong, so
>>>> everything sounds to be OK.
>>>
>>>
>>> Well it has been only 3 days, and these strange messages keep showing up,
>>> so I am still worried because it will be harder to get them replaced later
>>> and at the same time have the users complaining. But it looks like my
>>> options are limited.
>>>
>>>
>>>
>>>
>>> --
>>> =============================================================================
>>> Dimitris Zilaskos
>>> GridAUTH Operations Centre @ Aristotle University of Thessaloniki , Greece
>>> Tel: +302310998988 Fax: +302310994309
>>> http://www.grid.auth.gr
>>> =============================================================================
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> Internal Virus Database is out of date.
>>> Checked by AVG - www.avg.com
>>> Version: 8.0.237 / Virus Database: 270.11.10/1995 - Release Date: 03/11/09 08:28:00
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
