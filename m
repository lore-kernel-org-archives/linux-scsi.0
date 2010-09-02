From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Thu, 02 Sep 2010 13:25:58 -0700
Message-ID: <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	 <1282144271.3035.31.camel@mulgrave.site>
	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>
	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	 <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>
	 <4C73DA15.2010207@vlnb.net> <1282661876.2993.20.camel@mulgrave.site>
	 <4C7421FB.2060007@vlnb.net>
	 <1282685014.32007.51.camel@haakon2.linux-iscsi.org>
	 <4C76CA57.3050405@vlnb.net>
	 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
	 <4C79484B.3090607@vlnb.net>
	 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
	 <4C7C18CE.5020103@vlnb.net>
	 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
	 <4C7FFD1A.8090509@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.ne1.yahoo.com ([98.138.84.183]:31590 "HELO
	smtp105.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757055Ab0IBU35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2010 16:29:57 -0400
In-Reply-To: <4C7FFD1A.8090509@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, 2010-09-02 at 23:38 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger, on 08/31/2010 01:46 AM wrote:
> > Again, I still have no idea what you are trying to conjour up.  The
> > passthrough for STGT compatibility with TCM_Loop via SG_IO and BSG has
> > already been merged by Tomo-san into tgt.git.  Futhermore, we are using
> > the same TCM_Loop high level multi-fabric WWPN emulation together with
> > new (and old) QEMU HBA emulation into KVM guest using SG_IO and BSG as
> > well.
> 
> The patches were good, but don't mislead people about that. For sake of 
> clearness, what you called "the passthrough for STGT compatibility with 
> TCM_Loop via SG_IO and BSG" has nothing with LIO/TCM_Loop. What merged 
> fixed problems STGT had in the pass-through implementation. It at the 
> same time fixed problems with SCST's scst_local, so similarly can be 
> called "the passthrough for STGT compatibility with scst_local via SG_IO 
> and BSG".
> 

Uh, I don't think TCM_Loop and scst_local are exactly comparable at this
point.  TCM_Loop supports high level multi-fabric WWPN emulation that
allows it to work transparently with inter-nexus SPC-4 PR operation.
Therefore, using TCM_Loop, STGT userspace fabrics now support both PR
and ALUA emulation from TCM_Loop LUNs.  This is done at struct
config_group_ops->make_group() time to report $PROTO_IDENT and the
necessary WWPN info to TCM Core logic.  TCM_Loop also uses the fabric
indepent configfs handlers for pretty much all of it's control plane
code.

> The same is for the second half of the above. It's for scst_local in the 
> same degree as for TCM_Loop.
> 
> >> I'm not deciding anything, I'm only analyzing and seeing a contradiction:
> >>
> >> 1. James wants only one SCSI target infrastructure in the kernel.
> >>
> >> 2. If drivers/scsi/scsi_tgt_*.c left after the merge of the new SCSI
> >> target infrastructure, it would mean that STGT left as well =>  2 SCSI
> >> target infrastructure in the kernel.
> >>
> >> For me it doesn't matter. I just want clear rules, hence asking for
> >> clarification.
> >
> > Seriously, arguing over the use of people's language from weeks ago once
> > the decision has already been made to move forward is really of little
> > value at this point.
> 
> Does it look I'm arguing? Again, I'm analyzing and asking for 
> clarification in the contradictions I see. I don't like when such 
> important decisions are done behind closed doors and kept in a secret.
> 

I really have no idea what you are talking about 'behind closed doors'..

Have you not been watching the amount of TCM/LIO patches on the
linux-scsi list for the last 18 months..?  

> >>> It is obvious to even an casual observer from watching the TCM/LIO patch
> >>> series that have been flying across the linux-scsi wire the last 24
> >>> months that the major features (including PR and ALUA, and new fabric
> >>> module drivers) have been developed individual feature bit by feature
> >>> bit using a distributed git workflow in a bisectable manner.  Each
> >>> series was produced in such a manner that each patch could be reviewed
> >>> individually by those interested parties.
> >>
> >> That's a nice, but quite meaningless LIO advertisement. SCST is using
> >> the same bisectable, distributed and reviewable workflow.
> >
> > Actually, that is incorrect.  Your project uses a centralized
> > development model, which has it's obvious limitiations in terms of
> > speed, flexability, and community scale.  But really, don't take my word
> > for it, you can hear it for yourself directly from the horse's mouth
> > here:
> >
> > http://www.youtube.com/watch?v=4XpnKHJAok8
> >
> > I also very strongly suggest you find a transcript of this talk so you
> > can really understand what Linus means here wrt to a distributed
> > development workflow.
> 
> Well, Nicholas, are you really understanding what you are writing? We in 
> our projects have fully the same distributed (or centralized, if you 
> like it) development model. Have you noticed how many developers SCST 
> project has? We have our responsibility areas (target drivers, 
> scstadmin, etc.) and commit in them. The way how we get updates for the 
> rest of the kernel doesn't matter. Git is better for such huge projects 
> as the kernel, but for our relatively small and centralized by nature 
> due to small size (sub)projects it doesn't matter and won't bring any value.
> 

I find it hard to beleive you are actually going to agrue against a git
workflow for a target mode subsystem maintainer, well considering that
git was made by a linux kernel maintainer (Linus) for distributed linux
kernel development (everybody else)..?

Again, I suggest you watch the Russian translation of that talk on
youtube and really understand what he means, aside from the insults to
subversion users.

> >>> This is the big difference between our respective development processes.
> >>> This is the case not only for SCSI feature bits that TCM/LIO and SCST
> >>> share, but for features in TCM/LIO v4 that are unique and not available
> >>> in any other target implemention, anywhere.  And yes, I am most
> >>> certainly talking about code beyond just the SCSI level fabric emulation
> >>> bits you are mentioning above.
> >>
> >> Can you list us benefits for an average user of that work?
> >
> > Well, amougst the biggest advantages is actually having a sane ConfigFS
> > interface that can represent the parent / child relationship between
> > data structures across multiple LKMs.
> 
> Does STGT represent it in an insane manner?
> 
> > Not only does this give us a
> > proper representation of TCM and fabric data structures that can be
> > accesses directly by an advanced user in /sys/kernel/config/target/, it
> > also provides an ideal foundation to build 1) a userspace library in
> > intrepted languages and 2) create high level applications using said
> > userspace libraries that allow compatiblity to be contained in the lib
> > below.
> >
> > But wrt to actual kernel code (because this is a kernel list), the
> > shortlog for the RFC posting below nicely sums up what TCM v4 is
> > bringing to the table:
> >
> > http://lkml.org/lkml/2010/8/30/88
> 
> I have no doubts in benefits to TCM. But I have asked about benefits 
> _for an average user_. STGT already can do what you listed above.
> 

Again, from above how it benefits users:

1) a userspace library in intrepted languages and 2) create high level
applications using said userspace libraries that allow compatiblity to
be contained in the lib below.

2) create high level applications using said userspace libraries that
allow compatiblity to be contained in the lib.

> Also what advantages and additional value it has over what SCST 
> *already* provides since 2007?
> 
> >>>> But all my attempts to explain my view are just blindly
> >>>> ignored without any considerations, so I have no idea how more I can
> >>>> explain it.
> >>>>
> >>>
> >>> Then I suggest you learn a better way of communicating your ideas if you
> >>> really want to work with members of the LIO/STGT development
> >>> communities.
> >>>
> >>> First, I suggest you start explaining your ideas with actual kernel code
> >>> that is 1) human readable and 2) presented in such a manner that makes
> >>> it accessable for others with skills possibly different (and greater)
> >>> than your own to review and give feedback.
> >>
> >> I have sent patches twice, the second time few months ago. Weren't they
> >> human readable and accessible for kernel developers who are experts in
> >> dealing with sent by e-mail patches?
> >
> > I think a proper kernel subsystem maintainer workflow has to do alot
> > more to do these days than just sending patches over email, than it did
> > say 10 years ago.  Like it or not, git is the language of the mainline
> > kernel development process, and trying to imagine a *new* kernel
> > subsystem maintainer (besides say, someone like akpm) not using git is
> > quite a stretch of the imagination at this point.
> 
> So, do you believe that as soon as we migrate to git all the obstacles 
> for the SCST merge would be immediately removed?
> 

Uhhh, I don't think so.  Aside from your obvious project workflow
issues, the fact that SCST completly lacks a proper user-space driven
representation of parent / child relationships between kernel level data
structures in a fabric independent manner, while still allow for fabric
dependent groups and attributes is a most definately show-stopper for
me.

Best,

--nab

