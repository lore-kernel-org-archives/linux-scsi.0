From: Lee Duncan <lduncan@suse.com>
Subject: Re: Persistent reservation behaviour/compliance with redundant controllers
Date: Mon, 06 Jan 2014 14:20:52 -0800
Message-ID: <52CB2C44.7040503@suse.com>
References: <CAKbOo_KMG+M8F06S4wo9vta6PJjpgXzMX9ri-vr=PY0QYASPLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:45783 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbaAFWk7 (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Mon, 6 Jan 2014 17:40:59 -0500
In-Reply-To: <CAKbOo_KMG+M8F06S4wo9vta6PJjpgXzMX9ri-vr=PY0QYASPLg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Eble <psychotrahe@gmail.com>, linux-scsi@vger.kernel.org

On 12/25/2013 03:00 PM, Matthias Eble wrote:
> Hi all,
> 
> I'm experiencing a behaviour that doesn't comply to the SPC3/4 standards from
> my point of view. I have read the t10 drafts to understand scsi3 persistent
> reservations (PR). Probably I simply got the standard wrong, but maybe somebody
> can bring light into the situation.
> 
> My understanding of SPC-3/4 is that with PR, registrations should happen on any
> I_T Nexus accessing a volume. To me, in a dm-multipath environment, this
> translates to "register every single path".
> 
> But that doesn't work on our 3Par 7400.
> Now the question is, who is wrong? Me (likely :-), or HP/3Par (unlikely).
> 
> 
> Here's the dmmp map
> 360002ac0000000000000000a00006e6b dm-6 3PARdata,VV
> size=2.0T features='0' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=1 status=active
>   |- 3:0:1:4  sdg  8:96    active ready running
>   |- 3:0:3:4  sdl  8:176   active ready running
>   |- 5:0:3:4  sdbg 67:160  active ready running
>   `- 5:0:1:4  sdce 69:32   active ready running
> 
> 
> Here are the commands:
> 1: starting with a clean state:
>    # sg_persist --in --read-keys /dev/sdg
>      3PARdata  VV                3122
>      Peripheral device type: disk
>      PR generation=0x3a, there are NO registered reservation keys
> 
> 2: first registration (sdg) works fine:
>    # sg_persist -d /dev/sdg --no-inquiry --out --register \
>                 --param-sark=0x420480a029000067
> 
> 3: however registering sdl fails:
>    # sg_persist -d /dev/sdl --no-inquiry --out --register \
>                 --param-sark=0x420480a02900006c
>       persistent reserve out: scsi status: Reservation Conflict
> 
> When I --register-*ignore* the second device, the command succeeds.
> But the first registration key for sdg gets substituted by the new one for sdl.
> The same thing happens the other way around when sdg is register-ignore'd
> again.
> 
> There can only be two registrations at a time: (sdg XOR sdl) and (sdbg XOR sdce)
> Now my question is: Does this comply to the standard?
> 
> My core problem is that I'd like to ensure that no registration is missing
> by accident.

Matthias:

I _believe_ the problem is that you are re-registering the same
I_T_Nexus through /dev/sdl, your second attempt at registration, as you
did when you used /dev/sdg, your original registration.

What are you really trying to do? Are you testing that persistent
reservations "work" or trying to figure them out?

I have a "persistent reservations for dummies" document I wrote that I
can send you off list, if you like.

> 
> I hope that somebody on this list is kind enough to answer my question or
> give me a hint. HP was not able to direct it to a capable person in the
> last 9 months. *sigh*
> 
> 
> Any help is appreciated!
> 
> Thanks in advance,
> Matthias

-- 
Lee Duncan
SUSE Labs
