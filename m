From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 23 Aug 2010 19:44:27 +0200
Message-ID: <AANLkTinkYCPA-ZdWFhdriCyrK7J8Okj5HWqg7JsGZ7ry@mail.gmail.com>
References: <4C69653E.6050808@vlnb.net>
	<1282077040.16098.47.camel@mulgrave.site>
	<4C6C1DC1.8090208@vlnb.net>
	<1282164188.10878.22.camel@mulgrave.site>
	<4C702030.2070306@vlnb.net>
	<1282423128.3015.35.camel@mulgrave.site>
	<AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>
	<1282582740.11194.17.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:55867 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0HWRoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2010 13:44:34 -0400
In-Reply-To: <1282582740.11194.17.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Gennadiy Nerubayev <parakie@gmail.com>, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Aug 23, 2010 at 6:59 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> On Sun, 2010-08-22 at 18:10 -0400, Gennadiy Nerubayev wrote:
> > [ ... ]
> > Hi James,
> >
> > (disclaimer: I'm a hoi polloi SCST user)
> >
> > I'm not sure if I understand why there is a need for a replacement
> > target to reuse existing code, and would definitely appreciate a br=
ief
> > explanation or a pointer to an earlier one.
>
> The best thread on the topic is this massive one:
>
> http://marc.info/?t=3D120109820100005
>
> I want replacement because evidence suggests that multiple things doi=
ng
> the same thing don't get as much attention as a single one. =A0We nee=
d to
> support STGT because it's the one that has the in-kernel user base.
> Just breaking them constitutes an ABI problem under the new kernel
> rules.
>
> > But even that aside, I'm
> > curious if the criteria for what a replacement target must have for
> > (at least potential) inclusion into the kernel were ever clearly
> > outlined in the past. If they were, then there probably would have
> > been things like interested contenders, deadlines, feature
> > comparisons, code reviews, and so on, right?
>
> Yes, in that thread.
>
> My basic conclusion was that there's no incredible discriminator betw=
een
> LIO and STGT (although there are reams written on which performs bett=
er
> in which circumsances, is useful for clustering, supports ALUA, etc.
> each with partisans for the features). =A0If the two communities can'=
t
> work together (as seems to be the case) and I have to choose one, I'l=
l
> go by what helps me which, as I've said before, are:
>
> =A0 =A0 1. That it would be a drop in replacement for STGT (our curre=
nt
> =A0 =A0 =A0 =A0in-kernel target mode driver), since he only wanted a =
single
> =A0 =A0 =A0 =A0SCSI target infrastructure.
>
> =A0 =A0 2. That it used a modern sysfs based control and configuratio=
n
> =A0 =A0 =A0 =A0plane.
>
> =A0 =A0 3. That the code was reviewed as clean enough for inclusion.
>
>
> > Now, I can't claim familiarity with the kernel development process,=
 or
> > any "political" workings in it. The aforementioned however would se=
em
> > like a logical way of doing this since I assume that for whatever
> > reason, there is a strict limit to only one generic SCSI target in =
the
> > Linux kernel, and obviously as per this thread the current one is
> > being replaced.
>
> Well, my preference would be to keep STGT. =A0However, I indicated to=
 both
> target infrastructures that if they could satisfy the above, I'd be O=
K
> with replacing STGT, so I'm not about to go back on that after causin=
g
> quite a large amount of work.

And when did you indicate that ?

Sorry James, but the above looks to me like an interesting attempt to
rewrite history. What you repeated a few times in that thread from
January 2008 is that you were not convinced that a kernel-based
storage target could outperform a user-space target implementation. So
at least the impression was created that you were not going to accept
a kernel-based storage target for inclusion in the Linux kernel. In
another thread from December 2008 you repeated that view . A literal
quote from http://lkml.indiana.edu/hypermail/linux/kernel/0812.1/02168.=
html:

<quote>
The only identified failing of STGT (and it's theoretical, not
demonstrated, although I can agree the theory looks correct) is that th=
e
user space packet processing may cause performance problems on high
speed networks. We know from practical tests that these networks have
to be above 1Gbit because the results were identical for STGT and SCST
on a 1G network, so it's infiniband or 10Gbit ethernet.

So, what it comes down to is that if we had a kernel side protocol
accelerator for STGT, the project would no longer suffer from this
theoretical failing. *Both* of you have such a thing embedded in your
respective submissions (all 74k LOC of them) so can't you just enhance
STGT with whichever one is better ... actually, if you'd both bury the
hatchet and work on the enhancement together taking the best of each
project, we'd have something that worked much better and a unified user
base and neither side would be able to claim sole credit ... just a
thought.
</quote>

While about two years ago you were not convinced that a kernel-based
storage target could outperform a user-space based storage target,
recently you announced that a kernel-based storage target is going to
be integrated. I have no problem that someone changes his opinion, but
you should not try to make people believe that you have always been in
favor of a kernel-based storage target.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
