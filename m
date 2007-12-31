From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: Open-FCoE on linux-scsi
Date: Mon, 31 Dec 2007 08:34:38 -0800
Message-ID: <10A7D0016239E24092DEF05CCC582E4302BB68C8@fmsmsx411.amr.corp.intel.com>
References: <10A7D0016239E24092DEF05CCC582E43028A671C@fmsmsx411.amr.corp.intel.com> <200712281911.lBSJBWnB020367@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23545 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbXLaQel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Dec 2007 11:34:41 -0500
Content-class: urn:content-classes:message
In-Reply-To: <200712281911.lBSJBWnB020367@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: "Zou, Yi" <yi.zou@intel.com>, "Leech, Christopher" <christopher.leech@intel.com>, "Dev, Vasu" <vasu.dev@intel.com>, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

>> Hello SCSI mailing list,
>>
>> 	I'd just like to introduce ourselves a bit before we get
>> started. My name is Robert Love and I'm joined by a team of engineers
>> including Vasu Dev, Chris Leech and Yi Zou. We are committed to
>> maintaining the Open-FCoE project. Aside from Intel engineers we
expect
>> engineers from other companies to contribute to Open-FCoE.
>>
>> 	Our goal is to get the initiator code upstream. We have a lot of
>> working code but recognize that we're early in this project's
>> development. We're looking for direction from you, the experts, on
what
>> this project should grow into.
>
>I've just added a new fcoe target driver to tgt:
>
>http://stgt.berlios.de/
>
That's great; we'll check it out as soon as everyone is back from the
holidays.

>The driver runs in user space unlike your target mode driver (I just
>modified your FCoE code to run it in user space).
>
There seems to be a trend to move non-data-path code userspace, however,
I don't like having so much duplicate code. We were going to investigate
if we could redesign the target code to have less of a profile and just
depend on the initiator modules instead of recompiling openfc as
openfc_tgt.

What's the general opinion on this? Duplicate code vs. more kernel code?
I can see that you're already starting to clean up the code that you
ported. Does that mean the duplicate code isn't an issue to you? When we
fix bugs in the initiator they're not going to make it into your tree
unless you're diligent about watching the list.

>The initiator driver succeeded to log in a target, see logical units,
>and perform some I/Os. It's still very unstable but it would be
>useful for FCoE developers.
>
>
>I would like to help you push the Open-FCoE initiator to mainline
>too. What are on your todo list and what you guys working on now?

We would really appreciate the help! The best way I could come up with
to coordinate this effort was through the BZ-
http://open-fcoe.org/bugzilla. I was going to write a BZ wiki entry to
help new contributors, but since I haven't yet, here's the bottom line.
Sign-up to the BZ, assign bugs to yourself from my name (I'm the default
assignee now) and also file bugs as you find them. I don't want to
impose much process, but this will allow all of us to know what everyone
else is working on.

The main things that I think need to be fixed are (in no particular
order)-

1) Stability- Just straight up bug fixing. This is ongoing and everyone
is looking at bugs.

2) Abstractions- We consider libsa a big bug, which we're trying to
strip down piece by piece. Vasu took out the LOG_SA code and I'm looking
into changing the ASSERTs to BUG_ON/WARN_ONs. That isn't all of it, but
that's how we're breaking it down.

3) Target- The duplicate code of the target is too much. I want to
integrate the target into our -upstream tree. Without doing that, fixes
to the -upstream tree won't benefit the target and it will get into
worse shape than it already is, unless someone is porting those patches
to the target too. I think that ideally we'd want to reduce the target's
profile and move it to userspace under tgt.

4) Userspace/Kernel interaction- It's our belief that netlink is the
preferred mechanism for kernel/userspace interaction. Yi has converted
the FCoE ioctl code to netlink and is looking into openfc next.

We have various other little things going on as well. Our validation
team is beginning to file bugs in the BZ and we're working on our
internal processes around that effort. I'm also trying to setup a "smoke
test" system that will do a quick automated test so that I can confirm
patches won't break the code base.
