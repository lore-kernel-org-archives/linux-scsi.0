From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Persistent reservation behaviour/compliance with redundant
 controllers
Date: Tue, 07 Jan 2014 07:06:19 +0800
Message-ID: <1389049579.2811.12.camel@dabdike>
References: <CAKbOo_KMG+M8F06S4wo9vta6PJjpgXzMX9ri-vr=PY0QYASPLg@mail.gmail.com>
	 <52CB2C44.7040503@suse.com>
	 <CAKbOo_+LxN7UN11nxrD7pQ5Evffb-jdbW9BmPJ47NWiSXG-=nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54330 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755928AbaAFXGX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2014 18:06:23 -0500
In-Reply-To: <CAKbOo_+LxN7UN11nxrD7pQ5Evffb-jdbW9BmPJ47NWiSXG-=nQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Eble <psychotrahe@gmail.com>
Cc: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org

On Mon, 2014-01-06 at 23:53 +0100, Matthias Eble wrote:
> 2014/1/6 Lee Duncan <lduncan@suse.com>:
> > On 12/25/2013 03:00 PM, Matthias Eble wrote:
> >> Here's the dmmp map
> >> 360002ac0000000000000000a00006e6b dm-6 3PARdata,VV
> >> size=2.0T features='0' hwhandler='0' wp=rw
> >> `-+- policy='round-robin 0' prio=1 status=active
> >>   |- 3:0:1:4  sdg  8:96    active ready running
> >>   |- 3:0:3:4  sdl  8:176   active ready running
> >>   |- 5:0:3:4  sdbg 67:160  active ready running
> >>   `- 5:0:1:4  sdce 69:32   active ready running
> >>
> >> There can only be two registrations at a time: (sdg XOR sdl) and (sdbg XOR sdce)
> >> Now my question is: Does this comply to the standard?
> >>
> >
> > I _believe_ the problem is that you are re-registering the same
> > I_T_Nexus through /dev/sdl, your second attempt at registration, as you
> > did when you used /dev/sdg, your original registration.
> 
> 
> Can sdg and sdl be the same I_T_Nexus at a time?
> Right now, they are handled like that.
> In my understanding, every scsi disk device represents an I_T_Nexus.

No, every SCSI disk is an I_T_L nexus.  There's no actual device object
in Linux for an I_T nexus.

James

