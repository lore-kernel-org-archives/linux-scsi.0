From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: RE: [PATCH 0/5] mpt fusion: Add logging support
Date: Fri, 27 Jul 2007 21:14:02 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0707272037120.23971@filesrv1.baby-dragons.com>
References: <664A4EBB07F29743873A87CF62C26D708B3D56@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.system-techniques.com ([204.91.156.41]:54874 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXG1E0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jul 2007 00:26:40 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D708B3D56@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>

 	Hello Eric ,

On Fri, 27 Jul 2007, Moore, Eric wrote:
> On Friday, July 27, 2007 10:21 AM, wrote:
>> The way your module parameter works is slightly counter intuitive.  On
>> all our other drivers, you can write a value into
>>
>> /sys/module/<module>/parameters/<debug parameter>
>>
>> And have it acted on immediately.  In yours, it seems only to work
>> before the host is probed (because after that, the value in the ioc
>> structure is what's used).
>
> not true,  the debug parameter can be configured prior to the host being
> probed.    We have a command line option called mpt_debug_level, that
> can set the debug level from mptbase.ko.  That way you can enable
> certain debug during probe time prior to the loading of
> mptsas/mptfc/mptspi. Once those upper drivers are loaded, you can toggle
> off and on the debug via the shost_attrib. This is explained in
> mptdebug.h.
 	Where's the mptdebug.h file in linux-2.6.22.1 ? (*)
(*)
  root@filesrv1:/usr/src # find  linux-2.6.22.1/drivers/message/ -name mptdebug.h -print
  root@filesrv1:/usr/src #

 	I take it that that file is only available thru a git repo at this 
time ?  I know it's in the sources you shared with me , but ...
 	Another thing where is shost_attrib defined ?  It's not even in the 
sources you shared with me .

 	Isn't *.h files an odd place to put debug information for a sys admin 
to find so s/he can find out howto debug their problem with a LSI device ?
 	Mind you that's just my opinion .  But It sure would be nice to have 
some relativlty decent document(s) available to this purpose in Documentation .

>> The other question is are you really sure you actually want per host
>> debugging?  is the added flexibility in being able to turn it
>> on and off
>> per host worth the problems of explaining to the users where
>> to find the
>> parameter?  I've got to bet that 95% of the installations only have a
>> single fusion card anyway.  would it not be simpler just to have a
>> global module parameter that can be set and acted on from
>> /sys/modules?
>
> I like having the added flexibility, and potential customers may agree.
> Our driver stack support multiple bus protocols, unlike other vendors,
> and some customers may ship fibre, sas, and spi in a single systems..
> For my personal use, I like being able to have per host debugging, as I
> have multiple cards in my systems.    There are several cases I've
> debugged two controller case, when boot OS is on one controller, and the
> debug efforts on another, in that case I only want to concern myself
> with the debug in question, not boot OS.  The method of debug usesage is
> in mptdebug.h, so I would think people would look there, and figure it
> out.  I also have a script below that sets all the host debug sas chips.
> Does this sound reasonable? If not, let me know.
>
> ---[Cut below]---
> #!/bin/bash
> #set -x
> if (( $# != 1 )); then
> 	echo -e \\n"useage: set_debug_level <level>"
> 	echo -e \\n
> 	exit 1
> fi
>
> scsi_host="/sys/class/scsi_host"
> cd ${scsi_host}
> subfolders=`ls -1`
> for i in ${subfolders};  do
> 	cd ${i}
> 	if [ `cat proc_name` != "mptsas" ]; then
> 		cd ${scsi_host}
> 		continue;
> 	fi;
> 	echo $1 > debug_level
> 	debug_level=`cat debug_level`
> 	echo for ${i} debug_level=$debug_level
> 	cd ${scsi_host}
> done;
> ---[Cut above]---

 	Sure would be nice if this tool worked for scsi hosts instead of just 
sas .  At least that's the way it looks to me .

# ls -1 /sys/class/scsi_host
host0/
host1/
host2/
host3/
host4/
host5/

 	The "if [ `cat proc_name` != "mptsas" ]; then ... fi" section seems to 
preclude the ability to set the debug level when using a non-mptsas host adapter .
 	ie:
# cat host*/proc_name
aic79xx
aic79xx
mptspi
mptspi
mptspi
mptspi

 		Hth ,  JimL

ps:	Might be nice to get your input back on the other notes I've sent .
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
