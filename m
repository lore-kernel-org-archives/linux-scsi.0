From: Matthias Eble <psychotrahe@gmail.com>
Subject: Re: Persistent reservation behaviour/compliance with redundant controllers
Date: Wed, 22 Jan 2014 21:43:47 +0100
Message-ID: <CAKbOo_J77vGR5zQP0LhJ2n1qsxObEhz8=OEer2jPaka2Cpek9g@mail.gmail.com>
References: <CAKbOo_KMG+M8F06S4wo9vta6PJjpgXzMX9ri-vr=PY0QYASPLg@mail.gmail.com>
	<52CB2C44.7040503@suse.com>
	<CAKbOo_+LxN7UN11nxrD7pQ5Evffb-jdbW9BmPJ47NWiSXG-=nQ@mail.gmail.com>
	<1389049579.2811.12.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:55340 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaAVUnt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2014 15:43:49 -0500
Received: by mail-la0-f49.google.com with SMTP id y1so747269lam.8
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 12:43:47 -0800 (PST)
In-Reply-To: <1389049579.2811.12.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org

2014/1/7 James Bottomley <James.Bottomley@hansenpartnership.com>
>
> On Mon, 2014-01-06 at 23:53 +0100, Matthias Eble wrote:
> > 2014/1/6 Lee Duncan <lduncan@suse.com>:
> > > On 12/25/2013 03:00 PM, Matthias Eble wrote:
> > >> Here's the dmmp map
> > >> 360002ac0000000000000000a00006e6b dm-6 3PARdata,VV
> > >> size=2.0T features='0' hwhandler='0' wp=rw
> > >> `-+- policy='round-robin 0' prio=1 status=active
> > >>   |- 3:0:1:4  sdg  8:96    active ready running
> > >>   |- 3:0:3:4  sdl  8:176   active ready running
> > >>   |- 5:0:3:4  sdbg 67:160  active ready running
> > >>   `- 5:0:1:4  sdce 69:32   active ready running
> > >>
> > >> There can only be two registrations at a time: (sdg XOR sdl) and (sdbg XOR sdce)
> > >> Now my question is: Does this comply to the standard?
> > >>
> > >
> > > I _believe_ the problem is that you are re-registering the same
> > > I_T_Nexus through /dev/sdl, your second attempt at registration, as you
> > > did when you used /dev/sdg, your original registration.
> >
> >
> > Can sdg and sdl be the same I_T_Nexus at a time?
> > Right now, they are handled like that.
> > In my understanding, every scsi disk device represents an I_T_Nexus.
>
> No, every SCSI disk is an I_T_L nexus.  There's no actual device object
> in Linux for an I_T nexus.


Hi All,

I'd like to document the progress and findings in lots of off-list emails with
HP's t10 members.
Maybe someone on the net will face the same problem.

First of all, the SPC wording isn't 100% precise. For most commands, the Lun
context is implicit. So if the standards state "I_T Nexus", I_T_L Nexuses are
meant, as the reservation commands are always lun specific.

That said, PR-registrations need to be done for every
I_T_L Nexus -> every single dmmp path (/dev/sdX)

So we started to test the behaviour of the 3Par system.
It seems that there are some quirks in the 3Par implementation.
The error that led to my initial question is that the target port
identifier isn't included in the target's reservation handling.
Thus all PR commands from one host port are considered the same.
Regardless of the target port over which they were received.
(As seen in attached commands #5 or #6 after issuing #2 )
Note that the investigations haven't been finished.


For those who are interested, here are the findings (verbose output stripped):


1.# sg_persist --in --read-keys /dev/sdl
  3PARdata  VV                3122
  Peripheral device type: disk
  PR generation=0x44, there are NO registered reservation keys

register via sdl:
2.# sg_persist -vvv -d /dev/sdl --no-inquiry --out --register
--param-sark=0x420480a02900006c
    PR out: command (Register) successful

test for scp3r23 table 33 compliance (same key on registered I_T Nexus
should succeed): False
3.# sg_persist -vvv -d /dev/sdl --no-inquiry --out --register
--param-sark=0x420480a02900006c
    persistent reserve out: scsi status: Reservation Conflict
    PR out: command failed

now with a *different key* (should conflict): True
4.# sg_persist -vvv -d /dev/sdl --no-inquiry --out --register
--param-sark=0x420480a02900006d
    persistent reserve out: scsi status: Reservation Conflict
    PR out: command failed

Same behaviour using another path/I_T_L Nexus (should succeed in both cases):
5.# sg_persist -vvv -d /dev/sdg --no-inquiry --out --register
--param-sark=0x420480a02900006c
    persistent reserve out: scsi status: Reservation Conflict
    PR out: command failed
6.# sg_persist -vvv -d /dev/sdg --no-inquiry --out --register
--param-sark=0x420480a02900006d
    persistent reserve out: scsi status: Reservation Conflict
    PR out: command failed

Unregister via sdg :-/
7.# sg_persist -vvv -d /dev/sdg --no-inquiry --out --register
--param-rk=0x420480a02900006c
    PR out: command (Register) successful

Additionally, read-full-status service action and ALL_TG_PT are not
supported, right now.


That's it for now.

Thanks for your replies,
Matthias
