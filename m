From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: Open-FCoE on linux-scsi
Date: Thu, 3 Jan 2008 13:58:29 -0800
Message-ID: <10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com>
References: <10A7D0016239E24092DEF05CCC582E43028A671C@fmsmsx411.amr.corp.intel.com><200712281911.lBSJBWnB020367@mbox.iij4u.or.jp><10A7D0016239E24092DEF05CCC582E4302BB68C8@fmsmsx411.amr.corp.intel.com> <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57036 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbYACV6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 16:58:44 -0500
Content-class: urn:content-classes:message
In-Reply-To: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: "Zou, Yi" <yi.zou@intel.com>, "Leech, Christopher" <christopher.leech@intel.com>, "Dev, Vasu" <vasu.dev@intel.com>, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

>From: "Love, Robert W" <robert.w.love@intel.com>
>Subject: RE: Open-FCoE on linux-scsi
>Date: Mon, 31 Dec 2007 08:34:38 -0800
>
>> >> Hello SCSI mailing list,
>> >>
>> >> 	I'd just like to introduce ourselves a bit before we get
>> >> started. My name is Robert Love and I'm joined by a team of
engineers
>> >> including Vasu Dev, Chris Leech and Yi Zou. We are committed to
>> >> maintaining the Open-FCoE project. Aside from Intel engineers we
>> expect
>> >> engineers from other companies to contribute to Open-FCoE.
>> >>
>> >> 	Our goal is to get the initiator code upstream. We have a lot of
>> >> working code but recognize that we're early in this project's
>> >> development. We're looking for direction from you, the experts, on
>> what
>> >> this project should grow into.
>> >
>> >I've just added a new fcoe target driver to tgt:
>> >
>> >http://stgt.berlios.de/
>> >
>> That's great; we'll check it out as soon as everyone is back from the
>> holidays.
>
>It's still an experiment. Patches are welcome.
>
>
>> >The driver runs in user space unlike your target mode driver (I just
>> >modified your FCoE code to run it in user space).
>> >
>> There seems to be a trend to move non-data-path code userspace,
however,
>
>Implementing FCoE target drive in user space has no connection with a
>trend to move non-data-path code user space. It does all the data-path
>in user space.
>
>The examples of the trend to move non-data-path code userspace are
>open-iscsi, multi-path, etc, I think.
>
>
>> I don't like having so much duplicate code. We were going to
investigate
>> if we could redesign the target code to have less of a profile and
just
>> depend on the initiator modules instead of recompiling openfc as
>> openfc_tgt.
>>
>> What's the general opinion on this? Duplicate code vs. more kernel
code?
>> I can see that you're already starting to clean up the code that you
>> ported. Does that mean the duplicate code isn't an issue to you? When
we
>> fix bugs in the initiator they're not going to make it into your tree
>> unless you're diligent about watching the list.
>
>It's hard to convince the kernel maintainers to merge something into
>mainline that which can be implemented in user space. I failed twice
>(with two iSCSI target implementations).
>
>Yeah, duplication is not good but the user space code has some
>great advantages. Both approaches have the pros and cons.
>
>
>> >The initiator driver succeeded to log in a target, see logical
units,
>> >and perform some I/Os. It's still very unstable but it would be
>> >useful for FCoE developers.
>> >
>> >
>> >I would like to help you push the Open-FCoE initiator to mainline
>> >too. What are on your todo list and what you guys working on now?
>>
>> We would really appreciate the help! The best way I could come up
with
>> to coordinate this effort was through the BZ-
>> http://open-fcoe.org/bugzilla. I was going to write a BZ wiki entry
to
>> help new contributors, but since I haven't yet, here's the bottom
line.
>> Sign-up to the BZ, assign bugs to yourself from my name (I'm the
default
>> assignee now) and also file bugs as you find them. I don't want to
>> impose much process, but this will allow all of us to know what
everyone
>> else is working on.
>>
>> The main things that I think need to be fixed are (in no particular
>> order)-
>>
>> 1) Stability- Just straight up bug fixing. This is ongoing and
everyone
>> is looking at bugs.
>
>Talking about stability is a bit premature, I think. The first thing
>to do is finding a design that can be accepted into mainline.

How can we get this started? We've provided our current solution, but
need feedback to guide us in the right direction. We've received little
quips about libsa and libcrc and now it looks like we should look at
what we can move to userspace (see below), but that's all the feedback
we've got so far. Can you tell us what you think about our current
architecture? Then we could discuss your concerns... 

>
>
>> 2) Abstractions- We consider libsa a big bug, which we're trying to
>> strip down piece by piece. Vasu took out the LOG_SA code and I'm
looking
>> into changing the ASSERTs to BUG_ON/WARN_ONs. That isn't all of it,
but
>> that's how we're breaking it down.
>
>Agreed, libsa (and libcrc) should be removed.
>
>
>> 3) Target- The duplicate code of the target is too much. I want to
>> integrate the target into our -upstream tree. Without doing that,
fixes
>> to the -upstream tree won't benefit the target and it will get into
>> worse shape than it already is, unless someone is porting those
patches
>> to the target too. I think that ideally we'd want to reduce the
target's
>> profile and move it to userspace under tgt.
>>
>> 4) Userspace/Kernel interaction- It's our belief that netlink is the
>> preferred mechanism for kernel/userspace interaction. Yi has
converted
>> the FCoE ioctl code to netlink and is looking into openfc next.
>
>There are other options and I'm not sure that netlink is the best. I
>think that there is no general consensus about the best mechanism for
>kernel/userspace interaction. Even ioctl is still accepted into
>mainline (e.g. kvm).
>
>I expect you get an idea to use netlink from open-iscsi, but unlike
>open-iscsi, for now the FCoE code does just configuration with
>kernel/userspace interaction. open-iscsi has non-data path in user
>space so the kernel need to send variable-length data (PDUs, event,
>etc) to user space via netlink. So open-iscsi really needs netlink.
>If you have the FCoE non-data path in user space, netlink would work
>well for you.

We definitely got the netlink direction from open-iscsi. Combining your
comment that "It's hard to convince the kernel maintainers to merge
something into mainline that which can be implemented in user space"
with 
"If you have the FCoE non-data path in user space, netlink would work
well for you", makes it sound like this is an architectural change we
should consider. I'm not sure how strong the trend is though. Is moving
non data-path code to userspace a requirement? (you might have answered
me already by saying you had 2x failed upstream attempts)

>
>I would add one TODO item, better integration with scsi_transport_fc.
>If we have HW FCoE HBAs in the future, we need FCoE support in the fc
>transport class (you could use its netlink mechanism for event
>notification).

What do you have in mind in particular? Our layers are, 

SCSI
Openfc
FCoE
net_devive
NIC driver

So, it makes sense to me that we fit under scsi_transport_fc. I like our
layering- we clearly have SCSI on our top edge and net_dev at our bottom
edge. My initial reaction would be to resist merging openfc and fcoe and
creating a scsi_transport_fcoe.h interface.
 
>
>
>BTW, I think that the name 'openfc' is a bit strange. Surely, the
>mainline iscsi initiator driver is called 'open-iscsi' but it doesn't
>have any functions or files called 'open*'. It's just the project
>name.

Understood, but open-iscsi doesn't have the layering scheme that we do.
Since we're providing a Fibre Channel protocol processing layer that
different transport types can register with I think the generic name is
appropriate. Anyway, I don't think anyone here is terribly stuck on the
name; it's not a high priority at this time.
