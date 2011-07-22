From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Subject: Re: [linux-pm] [RFC] Disable disk spinup during system resume
Date: Fri, 22 Jul 2011 16:50:34 +0100
Message-ID: <4E299C4A.6060802@draigBrady.com>
References: <Pine.LNX.4.44L0.1107220951280.1923-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:1195 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754489Ab1GVPxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 11:53:05 -0400
In-Reply-To: <Pine.LNX.4.44L0.1107220951280.1923-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>

On 22/07/11 15:05, Alan Stern wrote:
> On Fri, 22 Jul 2011, P=C3=A1draig Brady wrote:
>=20
>> On 21/07/11 17:49, Alan Stern wrote:
>>> On Thu, 21 Jul 2011, P=C3=A1draig Brady wrote:
>>>
>>>> On 21/07/11 15:49, Alan Stern wrote:
>>>>> On Thu, 21 Jul 2011, P=C3=A1draig Brady wrote:
>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> I have a secondary sata disk (sda)  in my system that
>>>>>> I would like not to spinup on resume.
>>>>
>>>>
>>
>>> What happens if you kill all the running processes (or as many as=20
>>> possible) before starting the suspend?
>>>
>>> Also, how do you initiate the suspend?  Do you use a program, or do=
 you=20
>>> simply "echo mem >/sys/power/state"?
>>
>> I just rebooted with init=3D/bin/sh and did
>>
>> sdparm -r -C STOP /dev/sda
>> echo 0 > /sys/block/sda/device/scsi_disk/*/manage_start_stop
>> echo mem > /sys/power/state
>>
>> When I hit the power button to resume
>> sda started spinning again :(
>=20
> I have no idea why.  Unless maybe the BIOS started the drive.
>=20
> Here's another test you can try.  Before starting the suspend, make=20
> sure no filesystems are mounted on sda and do:
>=20
> 	echo scsi remove-single-device 0 0 0 0 >/proc/scsi/scsi
>=20
> (replace the "0 0 0 0" with the appropriate Host, Channel, ID, and LU=
N=20
> values for your sda drive).  This will erase all knowledge of that=20
> drive from the kernel.  If it still spins up during resume, you can b=
e=20
> sure the kernel isn't responsible.

drive still spins up on resume.

cheers,
P=C3=A1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
