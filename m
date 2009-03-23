From: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
Subject: RE: kernel panics and errors on lsi 1064e
Date: Mon, 23 Mar 2009 20:01:10 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0903231945440.15110@tassadar.physics.auth.gr>
References: <Pine.LNX.4.64.0903201242300.27079@tassadar.physics.auth.gr>
 <1237562844.12008.55.camel@localhost.localdomain>
 <Pine.LNX.4.64.0903202204490.1954@tassadar.physics.auth.gr>
 <0D1E8821739E724A86F4D16902CE275C1410DBBE2D@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tassadar.physics.auth.gr ([155.207.123.25]:58477 "EHLO
	tassadar.physics.auth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbZCWSBd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2009 14:01:33 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1410DBBE2D@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Mohapatra, Sisir" <Sisir.Mohapatra@lsi.com>

On Mon, 23 Mar 2009, Desai, Kashyap wrote:

> Hi,
>
> After firmware upgrade, you are seeing only MPT logs but system is running fine. Those prints are not harmful, but it requires attention why it happened? I need some information to help you further.
>
> 1. Information of driver version. (cat /proc/mpt/version)

[root@wn024 ~]# cat /proc/mpt/version
mptlinux-3.12.19.00rh
   Fusion MPT base driver
   Fusion MPT SPI host driver
   Fusion MPT SAS host driver

> 2. Information of firmware. (cat /proc/mpt/iocX/info)

[root@wn024 ~]# cat /proc/mpt/ioc0/info
ioc0:
   ProductID = 0x2204 (LSISAS1064E)
   FWVersion = 0x011b0000
   MsgVersion = 0x0105
   FirstWhoInit = 0x00
   EventState = 0x01
   CurrentHostMfaHighAddr = 0x00000002
   CurrentSenseBufferHighAddr = 0x00000002
   MaxChainDepth = 0x22 frames
   MinBlockSize = 0x20 bytes
   RequestFrames @ 0x0000010256482800 (Dma @ 0x0000000256482800)
     {CurReqSz=128} x {CurReqDepth=268} = 34304 bytes ^= 0x9000
     {MaxReqSz=128}   {MaxReqDepth=483}
   Frames   @ 0x0000010256480000 (Dma @ 0x0000000256480000)
     {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^= 0x2880
     {MaxRepSz=0}   {MaxRepDepth=511}
   MaxDevices = 173
   MaxBuses = 1
   PortNumber = 1 (of 1)
     WWN = 50015175F3B90000

> 3. Driver log level setting.
>       MPT driver has debug_level settings to get more logs.
>       Check "cat /sys/class/scsi_host/host*/proc_name"
>       Use index number for "mptsas" from result of previous command.
>       "echo 0x8188 > /sys/class/scsi_host/host<index>/debug_level".
>
>
> NOTE: Above debug level settings are available from some version onwards.
>       Driver used by you may not have this support, depending upon driver	version.

Yes, debug_level is not there.

Intel in its site about the mb has an apparently ancient driver 
http://downloadmirror.intel.com/13241/ENG/LinuxMPT_Rel_Notes_3.02.83.20-1.txt. 
I tried the sysctl -ww dev.scsi.logging_level="0x1000" as they suggest and 
it seems to produce tones of irrelevant output. Disabled it.

I am downloading 
http://www.lsi.com/DistributionSystem/AssetDocument/support/downloads/hbas/sas/software_drivers/linux/MPTLINUX_RHEL4_SLES9_PH14-3.13.04.00-2.zip
at the moment and will give it a try.

Cheers,

>
> Please provide us log with driver debug enable as mention in #3 will help to debug further.
>
> Added Sisir and Sathya in CC list.
>
> Thanks
> Kashyap
>
>
>
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dimitris Zilaskos
> Sent: Saturday, March 21, 2009 1:41 AM
> To: James Bottomley
> Cc: linux-scsi@vger.kernel.org; Moore, Eric
> Subject: Re: kernel panics and errors on lsi 1064e
>
>
> Thank you for you reply,
>
>> So that's the right thing to do (or better yet, contact LSI support to
>> see if they have a newer version).
>
> Will do so
>
>> This has become a log information, so the IOC firmware now dealt with
>> whatever the problem was.
>>
>>
>>> Is something broken here? I am close to ask for the systems to be replaced.
>>
>> You imply that with the firmware upgrade, nothing now goes wrong, so
>> everything sounds to be OK.
>
>
> Well it has been only 3 days, and these strange messages keep showing up,
> so I am still worried because it will be harder to get them replaced later
> and at the same time have the users complaining. But it looks like my
> options are limited.
>
>
>
>
> -- 
> =============================================================================
> Dimitris Zilaskos
> GridAUTH Operations Centre @ Aristotle University of Thessaloniki , Greece
> Tel: +302310998988 Fax: +302310994309
> http://www.grid.auth.gr
> =============================================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Internal Virus Database is out of date.
> Checked by AVG - www.avg.com
> Version: 8.0.237 / Virus Database: 270.11.10/1995 - Release Date: 03/11/09 08:28:00
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
