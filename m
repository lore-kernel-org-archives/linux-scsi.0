From: Matthias Eble <psychotrahe@gmail.com>
Subject: Persistent reservation behaviour/compliance with redundant controllers
Date: Thu, 26 Dec 2013 00:00:38 +0100
Message-ID: <CAKbOo_KMG+M8F06S4wo9vta6PJjpgXzMX9ri-vr=PY0QYASPLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f194.google.com ([209.85.223.194]:49662 "EHLO
	mail-ie0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3LYXAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Dec 2013 18:00:39 -0500
Received: by mail-ie0-f194.google.com with SMTP id tp5so3438741ieb.5
        for <linux-scsi@vger.kernel.org>; Wed, 25 Dec 2013 15:00:39 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I'm experiencing a behaviour that doesn't comply to the SPC3/4 standards from
my point of view. I have read the t10 drafts to understand scsi3 persistent
reservations (PR). Probably I simply got the standard wrong, but maybe somebody
can bring light into the situation.

My understanding of SPC-3/4 is that with PR, registrations should happen on any
I_T Nexus accessing a volume. To me, in a dm-multipath environment, this
translates to "register every single path".

But that doesn't work on our 3Par 7400.
Now the question is, who is wrong? Me (likely :-), or HP/3Par (unlikely).


Here's the dmmp map
360002ac0000000000000000a00006e6b dm-6 3PARdata,VV
size=2.0T features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 3:0:1:4  sdg  8:96    active ready running
  |- 3:0:3:4  sdl  8:176   active ready running
  |- 5:0:3:4  sdbg 67:160  active ready running
  `- 5:0:1:4  sdce 69:32   active ready running


Here are the commands:
1: starting with a clean state:
   # sg_persist --in --read-keys /dev/sdg
     3PARdata  VV                3122
     Peripheral device type: disk
     PR generation=0x3a, there are NO registered reservation keys

2: first registration (sdg) works fine:
   # sg_persist -d /dev/sdg --no-inquiry --out --register \
                --param-sark=0x420480a029000067

3: however registering sdl fails:
   # sg_persist -d /dev/sdl --no-inquiry --out --register \
                --param-sark=0x420480a02900006c
      persistent reserve out: scsi status: Reservation Conflict

When I --register-*ignore* the second device, the command succeeds.
But the first registration key for sdg gets substituted by the new one for sdl.
The same thing happens the other way around when sdg is register-ignore'd
again.

There can only be two registrations at a time: (sdg XOR sdl) and (sdbg XOR sdce)
Now my question is: Does this comply to the standard?

My core problem is that I'd like to ensure that no registration is missing
by accident.

I hope that somebody on this list is kind enough to answer my question or
give me a hint. HP was not able to direct it to a capable person in the
last 9 months. *sigh*


Any help is appreciated!

Thanks in advance,
Matthias



3Par specific information:
3Par systems have a transparent controller(node) failover feature.
In the example above, scsi host3 has two paths to the same volume.
The paths are provided by two different controller nodes.
If one node fails, the other node can take over the path transparently.
To me it looks like the SG3PR implementation is too transparent when it
comes to SG3PR.
