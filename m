From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Subject: Re: [linux-pm] [RFC] Disable disk spinup during system resume
Date: Fri, 22 Jul 2011 19:03:41 +0100
Message-ID: <4E29BB7D.8030201@draigBrady.com>
References: <Pine.LNX.4.44L0.1107220951280.1923-100000@iolanthe.rowland.org> <4E299C4A.6060802@draigBrady.com> <4E29B5A8.4030204@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:18261 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751578Ab1GVSGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 14:06:13 -0400
In-Reply-To: <4E29B5A8.4030204@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>

On 22/07/11 18:38, Douglas Gilbert wrote:
> On 11-07-22 11:50 AM, P=C3=A1draig Brady wrote:
>> On 22/07/11 15:05, Alan Stern wrote:
>>> On Fri, 22 Jul 2011, P=C3=A1draig Brady wrote:
>>>
>>>> On 21/07/11 17:49, Alan Stern wrote:
>>>>> On Thu, 21 Jul 2011, P=C3=A1draig Brady wrote:
>>>>>
>>>>>> On 21/07/11 15:49, Alan Stern wrote:
>>>>>>> On Thu, 21 Jul 2011, P=C3=A1draig Brady wrote:
>>>>>>>
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I have a secondary sata disk (sda)  in my system that
>>>>>>>> I would like not to spinup on resume.
>>>>>>
>>>>>>
>>>>
>>>>> What happens if you kill all the running processes (or as many as
>>>>> possible) before starting the suspend?
>>>>>
>>>>> Also, how do you initiate the suspend?  Do you use a program, or =
do
>>>>> you
>>>>> simply "echo mem>/sys/power/state"?
>>>>
>>>> I just rebooted with init=3D/bin/sh and did
>>>>
>>>> sdparm -r -C STOP /dev/sda
>>>> echo 0>  /sys/block/sda/device/scsi_disk/*/manage_start_stop
>>>> echo mem>  /sys/power/state
>>>>
>>>> When I hit the power button to resume
>>>> sda started spinning again :(
>>>
>>> I have no idea why.  Unless maybe the BIOS started the drive.
>>>
>>> Here's another test you can try.  Before starting the suspend, make
>>> sure no filesystems are mounted on sda and do:
>>>
>>>     echo scsi remove-single-device 0 0 0 0>/proc/scsi/scsi
>>>
>>> (replace the "0 0 0 0" with the appropriate Host, Channel, ID, and =
LUN
>>> values for your sda drive).  This will erase all knowledge of that
>>> drive from the kernel.  If it still spins up during resume, you can=
 be
>>> sure the kernel isn't responsible.
>>
>> drive still spins up on resume.
>=20
> Did the disk (/dev/sda) spin down after
>    sdparm -r -C STOP /dev/sda

y

> ? I'm guessing that neither the root file system nor swap
> are located on /dev/sda ?

correct

I now notice the `hdparm -s` option which might be applicable:

"Enable/disable the power-on in standby feature,
 if supported by the drive. VERY DANGEROUS"

Now I'm wary of enabling that because I do need
the drive enabled on first boot as the bios in this
dell laptop can only boot from a disk in this sata slot.
(I unmount and spin down after boot).

Seems like I might be left doing a spinup and spindown
at each resume.

cheers,
P=C3=A2draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
