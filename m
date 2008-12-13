From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Sat, 13 Dec 2008 14:50:06 -0800
Message-ID: <1229208606.4153.1069.camel@haakon2.linux-iscsi.org>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
	 <54939.1229149205@turing-police.cc.vt.edu>
	 <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>
	 <1229162907.4153.857.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130223q13fd98d8gc1e55881a92b939@mail.gmail.com>
	 <1229167118.4153.930.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130356y1fe60713xf844a35c775e161d@mail.gmail.com>
	 <1229181896.3258.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:40443 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752025AbYLMWuJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 17:50:09 -0500
In-Reply-To: <1229181896.3258.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-iscsi-target-dev@googlegroups.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2008-12-13 at 09:24 -0600, James Bottomley wrote:
> On Sat, 2008-12-13 at 12:56 +0100, Bart Van Assche wrote:
> > On Sat, Dec 13, 2008 at 12:18 PM, Nicholas A. Bellinger
> > <nab@linux-iscsi.org> wrote:
> > > Of course I fix bugs when people report them.

Hi James,

> OK, All of you on this thread, why don't you take time out to step back
> and think about the effects this descent into trench warfare is having
> on your observers.
> 

Yes, I think this reflects very poorly on both of us.  I would like to
apologize for my part in thread, and would like to start making forward
progress again.  (eg: more patch bombs :-)

>      1. You're both saying the other side isn't production ready ...
>         it's not a stretch for the rest of us to take this at face
>         value ... about both of you.

So, as some of these larger LIO-Target customers come online in 2009
(including a 500 TB -> 1 PB installation), folks will be able to hear
for themselves how Linux-iSCSI.org code is being used for production.

Also, there will be full-time engineering resources put on
Target_Core_Mod/ConfigFS and LIO_Target v3.0 code in 2009, as we
continue to work towards code submission.

>      2. This ideological opposition to features the other side
>         implements tells me that if it came to a choice, by going with
>         either one of you I'd get an incomplete feature set.

Well, I have no ideological opposition to SCST, just technical concerns
that never get to be addressed.  Which is fine with me, as the pieces I
need for LIO-iSER for generic struct page zero-copy mapping using a
single codepath to Linux storage subsystem that can be shared across
$FABRIC_MODs are already in place for Target_Core_Mod/ConfigFS.  Its
simply a matter of hooking them (the $FABRIC_MODs) up now.

On the other side however, the SCST guys are completely opposed to any
usage of ConfigFS, which is a shame because it really does rock for this
type of usage: lots of groups, attributes, and $STORAGE_OBJECTS
representing Target Ports across multiple $FABRIC_MODs using ConfigFS
symlinks.  Having written a bunch of ConfigFS code that has been up and
running for a few months (most of which was done at LPC), and yet still
some people make noise on their precieved limitiations of ConfigFS.,
without actually ever looking at the code in question.  This obviously
is a bit of a let down.

The good news however is that there are folks in the kernel community
who have given me positive feedback about the use of ConfigFS for target
mode (and the actual code), and related to me that they believe ConfigFS
is the right choice moving forward. (A big thanks to people :-)

>      3. Making obvious partisans of your user base also tells me that if
>         I had to make a choice, whatever it was I'd piss off a large
>         number of people who'd be very vocal about it.
> 

Honestly, I think our respective userbases just want the best upstream
kernel code possible, which is the only thing I am interested in.  

> Since we have a working target solution in the kernel already (STGT),
> why on earth would I be stupid enough to want to even consider either of
> you, coming as you do with the above mentioned baggage?
>
> So stop fighting ... you're not going to backstab your way to inclusion.
> 

Definately not.

> The only identified failing of STGT (and it's theoretical, not
> demonstrated, although I can agree the theory looks correct) is that the
> user space packet processing may cause performance problems on high
> speed networks.  We know from practical tests that these networks have
> to be above 1Gbit because the results were identical for STGT and SCST
> on a 1G network, so it's infiniband or 10Gbit ethernet.
> 

As I mentioned during our discussion @ LPC, I am still interested in
including support for STGT and userspace fabric modules in
Target_Core_Mod/ConfigFS using existing STGT code.

So, I am currently at the point where I am bringing LIO-Target v3.0
online using a generic target API on top of Target_Core_Mod/ConfigFS.
At this point, I am creating my own 'template' of function pointers that
generic target code calls into $FABRIC_MOD.  However, I have been
considering using an existing 'template', and I am leaning to use the
existing the STGT template (moved up to kernel space).  I think that
using an existing 'template' would help $FABRIC_MODs maintainers port
over their code.  Same goes for STGT's struct iscsi_transport for the
LIO-iSER bits..

> So, what it comes down to is that if we had a kernel side protocol
> accelerator for STGT, the project would no longer suffer from this
> theoretical failing.  *Both* of you have such a thing embedded in your
> respective submissions (all 74k LOC of them) so can't you just enhance
> STGT with whichever one is better ..

Ok, in terms of LOC, I am looking at ~22k LOC for
Target_Core_Mod/Configfs (which will be submitted first), and ~18K LOC
for LIO-Target v3.0 (submitted later)

> . actually, if you'd both bury the
> hatchet and work on the enhancement together taking the best of each
> project, we'd have something that worked much better and a unified user
> base and neither side would be able to claim sole credit ... just a
> thought.
> 

I really do apperciate your thoughtful comments, but as long as ConfigFS
is being used, I do not believe the SCST folks have any interest in
working with me, which is OK.  On the bit about claiming sole credit, I
very much understand that it 'takes a village' for something as complex
as what we are discussing here, and I am very much willing to share
credit where credit is due.  I am 100% commited for the long haul to the
best generic kernel target infrastructure and $FABRIC_MODs, and am very
much looking forward to working with people who share this same passion
to produce the best possible code.

Many thanks for your most valuable of time,

--nab


