From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: Open-FCoE on linux-scsi
Date: Thu, 03 Jan 2008 19:35:31 +0900
Message-ID: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>
References: <10A7D0016239E24092DEF05CCC582E43028A671C@fmsmsx411.amr.corp.intel.com>
	<200712281911.lBSJBWnB020367@mbox.iij4u.or.jp>
	<10A7D0016239E24092DEF05CCC582E4302BB68C8@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:55392 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYACKiw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2008 05:38:52 -0500
In-Reply-To: <10A7D0016239E24092DEF05CCC582E4302BB68C8@fmsmsx411.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robert.w.love@intel.com
Cc: tomof@acm.org, yi.zou@intel.com, christopher.leech@intel.com, vasu.dev@intel.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: Open-FCoE on linux-scsi
Date: Mon, 31 Dec 2007 08:34:38 -0800

> >> Hello SCSI mailing list,
> >>
> >> 	I'd just like to introduce ourselves a bit before we get
> >> started. My name is Robert Love and I'm joined by a team of engineers
> >> including Vasu Dev, Chris Leech and Yi Zou. We are committed to
> >> maintaining the Open-FCoE project. Aside from Intel engineers we
> expect
> >> engineers from other companies to contribute to Open-FCoE.
> >>
> >> 	Our goal is to get the initiator code upstream. We have a lot of
> >> working code but recognize that we're early in this project's
> >> development. We're looking for direction from you, the experts, on
> what
> >> this project should grow into.
> >
> >I've just added a new fcoe target driver to tgt:
> >
> >http://stgt.berlios.de/
> >
> That's great; we'll check it out as soon as everyone is back from the
> holidays.

It's still an experiment. Patches are welcome.


> >The driver runs in user space unlike your target mode driver (I just
> >modified your FCoE code to run it in user space).
> >
> There seems to be a trend to move non-data-path code userspace, however,

Implementing FCoE target drive in user space has no connection with a
trend to move non-data-path code user space. It does all the data-path
in user space.

The examples of the trend to move non-data-path code userspace are
open-iscsi, multi-path, etc, I think.


> I don't like having so much duplicate code. We were going to investigate
> if we could redesign the target code to have less of a profile and just
> depend on the initiator modules instead of recompiling openfc as
> openfc_tgt.
> 
> What's the general opinion on this? Duplicate code vs. more kernel code?
> I can see that you're already starting to clean up the code that you
> ported. Does that mean the duplicate code isn't an issue to you? When we
> fix bugs in the initiator they're not going to make it into your tree
> unless you're diligent about watching the list.

It's hard to convince the kernel maintainers to merge something into
mainline that which can be implemented in user space. I failed twice
(with two iSCSI target implementations).

Yeah, duplication is not good but the user space code has some
great advantages. Both approaches have the pros and cons.


> >The initiator driver succeeded to log in a target, see logical units,
> >and perform some I/Os. It's still very unstable but it would be
> >useful for FCoE developers.
> >
> >
> >I would like to help you push the Open-FCoE initiator to mainline
> >too. What are on your todo list and what you guys working on now?
> 
> We would really appreciate the help! The best way I could come up with
> to coordinate this effort was through the BZ-
> http://open-fcoe.org/bugzilla. I was going to write a BZ wiki entry to
> help new contributors, but since I haven't yet, here's the bottom line.
> Sign-up to the BZ, assign bugs to yourself from my name (I'm the default
> assignee now) and also file bugs as you find them. I don't want to
> impose much process, but this will allow all of us to know what everyone
> else is working on.
> 
> The main things that I think need to be fixed are (in no particular
> order)-
> 
> 1) Stability- Just straight up bug fixing. This is ongoing and everyone
> is looking at bugs.

Talking about stability is a bit premature, I think. The first thing
to do is finding a design that can be accepted into mainline.


> 2) Abstractions- We consider libsa a big bug, which we're trying to
> strip down piece by piece. Vasu took out the LOG_SA code and I'm looking
> into changing the ASSERTs to BUG_ON/WARN_ONs. That isn't all of it, but
> that's how we're breaking it down.

Agreed, libsa (and libcrc) should be removed.


> 3) Target- The duplicate code of the target is too much. I want to
> integrate the target into our -upstream tree. Without doing that, fixes
> to the -upstream tree won't benefit the target and it will get into
> worse shape than it already is, unless someone is porting those patches
> to the target too. I think that ideally we'd want to reduce the target's
> profile and move it to userspace under tgt.
> 
> 4) Userspace/Kernel interaction- It's our belief that netlink is the
> preferred mechanism for kernel/userspace interaction. Yi has converted
> the FCoE ioctl code to netlink and is looking into openfc next.

There are other options and I'm not sure that netlink is the best. I
think that there is no general consensus about the best mechanism for
kernel/userspace interaction. Even ioctl is still accepted into
mainline (e.g. kvm).

I expect you get an idea to use netlink from open-iscsi, but unlike
open-iscsi, for now the FCoE code does just configuration with
kernel/userspace interaction. open-iscsi has non-data path in user
space so the kernel need to send variable-length data (PDUs, event,
etc) to user space via netlink. So open-iscsi really needs netlink.
If you have the FCoE non-data path in user space, netlink would work
well for you.

I would add one TODO item, better integration with scsi_transport_fc.
If we have HW FCoE HBAs in the future, we need FCoE support in the fc
transport class (you could use its netlink mechanism for event
notification).


BTW, I think that the name 'openfc' is a bit strange. Surely, the
mainline iscsi initiator driver is called 'open-iscsi' but it doesn't
have any functions or files called 'open*'. It's just the project
name.
