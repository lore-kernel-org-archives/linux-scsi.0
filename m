From: Gregory Haskins <ghaskins@novell.com>
Subject: Re: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 13:44:49 -0500
Message-ID: <496F8421.3070703@novell.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>	 <20090114163557.11e097f2.akpm@linux-foundation.org>	 <20090115012147.GW29283@parisc-linux.org>	 <20090114180431.f4a96543.akpm@linux-foundation.org>	 <1232028766.5966.10.camel@localhost.localdomain>	 <20090115094442.b6394544.akpm@linux-foundation.org>	 <20090115180052.GG29283@parisc-linux.org> <1232043287.21980.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC409C44FCCB2283E4B13E426"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42958 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456AbZAOSmF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 13:42:05 -0500
In-Reply-To: <1232043287.21980.65.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <srostedt@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC409C44FCCB2283E4B13E426
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Steven Rostedt wrote:
> On Thu, 2009-01-15 at 11:00 -0700, Matthew Wilcox wrote:
>  =20
>> On Thu, Jan 15, 2009 at 09:44:42AM -0800, Andrew Morton wrote:
>>    =20
>>>> Me too.  Anecdotally, I haven't noticed this in my lab machines, but=

>>>> what I have noticed is on someone else's laptop (a hyperthreaded ato=
m)
>>>> that I was trying to demo powertop on was that IPI reschedule interr=
upts
>>>> seem to be out of control ... they were ticking over at a really hig=
h
>>>> rate and preventing the CPU from spending much time in the low C and=
 P
>>>> states.  To me this implicates some scheduler problem since that's t=
he
>>>> primary producer of IPI reschedules ... I think it wouldn't be a
>>>> significant extrapolation to predict that the scheduler might be the=

>>>> cause of the above problem as well.
>>>>
>>>>        =20
>>> Good point.
>>>
>>> The context switch rate actually went down a bit.
>>>
>>> I wonder if the Intel test people have records of /proc/interrupts fo=
r
>>> the various kernel versions.
>>>      =20
>> I think Chinang does, but he's out of office today.  He did say in an
>> earlier reply:
>>
>>    =20
>>> I took a quick look at the interrupts figure between 2.6.24 and 2.6.2=
7.
>>> i/o interuputs is slightly down in 2.6.27 (due to reduce throughput).=

>>> But both NMI and reschedule interrupt increased.  Reschedule interrup=
ts
>>> is 2x of 2.6.24.
>>>      =20
>> So if the reschedule interrupt is happening twice as often, and the
>> context switch rate is basically unchanged, I guess that means the
>> scheduler is doing a lot more work to get approximately the same
>> results.  And that seems like a bad thing.
>>    =20

I would be very interested in gathering some data in this area.  One
thing that pops to mind is to instrument the resched-ipi with
ftrace_printk() and gather a trace of this system in action.  I assume
that I wouldn't have access to this OLTP suite, so I may need a
volunteer to try this for me.  I could put together an instrumentation
patch for the testers convenience if they prefer.

Another data-point I wouldn't mind seeing is  looking at the scheduler
statistics, particularly with my sched-top utility, which you can find he=
re:

http://rt.wiki.kernel.org/index.php/Schedtop_utility

(Note you may want to exclude the sched_info stats, as they are
inherently noisy and make it hard to see the real trends.  To do this
run it with: 'schedtop -x "sched_info"'

In the meantime, I will try similar approaches here on other non-OLTP
based workloads to see if I spy anything that looks amiss.
=20
-Greg



--------------enigC409C44FCCB2283E4B13E426
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAklvhCEACgkQlOSOBdgZUxlcxwCeJFUsBVbF29BKSBT4XgJVu7/S
zCAAnihcG0gXrh9cTRCruQXbAAmHyOYD
=K8M/
-----END PGP SIGNATURE-----

--------------enigC409C44FCCB2283E4B13E426--
