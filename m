From: Matthias Eble <psychotrahe@gmail.com>
Subject: Re: Persistent reservation behaviour/compliance with redundant controllers
Date: Mon, 6 Jan 2014 23:53:44 +0100
Message-ID: <CAKbOo_+LxN7UN11nxrD7pQ5Evffb-jdbW9BmPJ47NWiSXG-=nQ@mail.gmail.com>
References: <CAKbOo_KMG+M8F06S4wo9vta6PJjpgXzMX9ri-vr=PY0QYASPLg@mail.gmail.com>
	<52CB2C44.7040503@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:39599 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441AbaAFWxq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2014 17:53:46 -0500
Received: by mail-lb0-f171.google.com with SMTP id w7so10220436lbi.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2014 14:53:44 -0800 (PST)
In-Reply-To: <52CB2C44.7040503@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org

2014/1/6 Lee Duncan <lduncan@suse.com>:
> On 12/25/2013 03:00 PM, Matthias Eble wrote:
>> Here's the dmmp map
>> 360002ac0000000000000000a00006e6b dm-6 3PARdata,VV
>> size=2.0T features='0' hwhandler='0' wp=rw
>> `-+- policy='round-robin 0' prio=1 status=active
>>   |- 3:0:1:4  sdg  8:96    active ready running
>>   |- 3:0:3:4  sdl  8:176   active ready running
>>   |- 5:0:3:4  sdbg 67:160  active ready running
>>   `- 5:0:1:4  sdce 69:32   active ready running
>>
>> There can only be two registrations at a time: (sdg XOR sdl) and (sdbg XOR sdce)
>> Now my question is: Does this comply to the standard?
>>
>
> I _believe_ the problem is that you are re-registering the same
> I_T_Nexus through /dev/sdl, your second attempt at registration, as you
> did when you used /dev/sdg, your original registration.


Can sdg and sdl be the same I_T_Nexus at a time?
Right now, they are handled like that.
In my understanding, every scsi disk device represents an I_T_Nexus.


# lsscsi -t | egrep '/dev/sd(g|l|bg|ce)'
    [3:0:1:4]    disk    fc:0x20120002ac006e6b,0x14ad40  /dev/sdg
    [3:0:3:4]    disk    fc:0x21120002ac006e6b,0x14ad80  /dev/sdl
    [5:0:1:4]    disk    fc:0x22110002ac006e6b,0x0aad40  /dev/sdce
    [5:0:3:4]    disk    fc:0x23110002ac006e6b,0x0aad80  /dev/sdbg


> What are you really trying to do? Are you testing that persistent
> reservations "work" or trying to figure them out?

I am testing PR on a specific storage system, which seems to behave differently
like the ones before.

> I have a "persistent reservations for dummies" document I wrote that I
> can send you off list, if you like.

I think I know how PRs work. Yet I'd be happy about your document.
