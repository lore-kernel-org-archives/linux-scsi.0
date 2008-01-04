From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: Open-FCoE on linux-scsi
Date: Fri, 4 Jan 2008 22:47:17 +0900
Message-ID: <20080104225015Z.tomof@acm.org>
References: <10A7D0016239E24092DEF05CCC582E4302BB68C8@fmsmsx411.amr.corp.intel.com>
	<200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>
	<10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44824 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYADNrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jan 2008 08:47:31 -0500
In-Reply-To: <10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robert.w.love@intel.com
Cc: tomof@acm.org, yi.zou@intel.com, christopher.leech@intel.com, vasu.dev@intel.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jpfujita.tomonori@lab.ntt.co.jp

On Thu, 3 Jan 2008 13:58:29 -0800
"Love, Robert W" <robert.w.love@intel.com> wrote:

> >Talking about stability is a bit premature, I think. The first thing
> >to do is finding a design that can be accepted into mainline.
> 
> How can we get this started? We've provided our current solution, but
> need feedback to guide us in the right direction. We've received little
> quips about libsa and libcrc and now it looks like we should look at
> what we can move to userspace (see below), but that's all the feedback
> we've got so far. Can you tell us what you think about our current
> architecture? Then we could discuss your concerns... 

I think that you have got littel feedback since few people have read
the code. Hopefully, this discussion gives some information.

My main concern is transport class integration. But they are just
mine. The SCSI maintainer and FC people might have different opinions.


> >> 2) Abstractions- We consider libsa a big bug, which we're trying to
> >> strip down piece by piece. Vasu took out the LOG_SA code and I'm
> looking
> >> into changing the ASSERTs to BUG_ON/WARN_ONs. That isn't all of it,
> but
> >> that's how we're breaking it down.
> >
> >Agreed, libsa (and libcrc) should be removed.
> >
> >
> >> 3) Target- The duplicate code of the target is too much. I want to
> >> integrate the target into our -upstream tree. Without doing that,
> fixes
> >> to the -upstream tree won't benefit the target and it will get into
> >> worse shape than it already is, unless someone is porting those
> patches
> >> to the target too. I think that ideally we'd want to reduce the
> target's
> >> profile and move it to userspace under tgt.
> >>
> >> 4) Userspace/Kernel interaction- It's our belief that netlink is the
> >> preferred mechanism for kernel/userspace interaction. Yi has
> converted
> >> the FCoE ioctl code to netlink and is looking into openfc next.
> >
> >There are other options and I'm not sure that netlink is the best. I
> >think that there is no general consensus about the best mechanism for
> >kernel/userspace interaction. Even ioctl is still accepted into
> >mainline (e.g. kvm).
> >
> >I expect you get an idea to use netlink from open-iscsi, but unlike
> >open-iscsi, for now the FCoE code does just configuration with
> >kernel/userspace interaction. open-iscsi has non-data path in user
> >space so the kernel need to send variable-length data (PDUs, event,
> >etc) to user space via netlink. So open-iscsi really needs netlink.
> >If you have the FCoE non-data path in user space, netlink would work
> >well for you.
> 
> We definitely got the netlink direction from open-iscsi. Combining your
> comment that "It's hard to convince the kernel maintainers to merge
> something into mainline that which can be implemented in user space"
> with 
> "If you have the FCoE non-data path in user space, netlink would work
> well for you", makes it sound like this is an architectural change we
> should consider.

I think they are different topics (though they are related).

"It's hard to convince the kernel maintainers to merge something into
mainline that which can be implemented in user space" applies to the
target driver.

You can fully implement FCoE target software in user space, right? So
if so, it's hard to push it into kernel.

The trend to push the non-data path to user space applies to the
initiator driver. Initiator drivers are expected to run in kernel
space but open-iscsi driver was split and the non-data part was moved
to user space. The kernel space and user-space parts work
together. It's completely different from iSCSI target drivers that can
be implemented fully in user space.


> I'm not sure how strong the trend is though. Is moving
> non data-path code to userspace a requirement? (you might have answered
> me already by saying you had 2x failed upstream attempts)

I don't know. You need to ask James.


> >I would add one TODO item, better integration with scsi_transport_fc.
> >If we have HW FCoE HBAs in the future, we need FCoE support in the fc
> >transport class (you could use its netlink mechanism for event
> >notification).
> 
> What do you have in mind in particular? Our layers are, 
> 
> SCSI
> Openfc
> FCoE
> net_devive
> NIC driver
> 
> So, it makes sense to me that we fit under scsi_transport_fc. I like our
> layering- we clearly have SCSI on our top edge and net_dev at our bottom
> edge. My initial reaction would be to resist merging openfc and fcoe and
> creating a scsi_transport_fcoe.h interface.

As I wrote in another mail, this part is the major issue for me.


> >BTW, I think that the name 'openfc' is a bit strange. Surely, the
> >mainline iscsi initiator driver is called 'open-iscsi' but it doesn't
> >have any functions or files called 'open*'. It's just the project
> >name.
> 
> Understood, but open-iscsi doesn't have the layering scheme that we do.
> Since we're providing a Fibre Channel protocol processing layer that
> different transport types can register with I think the generic name is
> appropriate. Anyway, I don't think anyone here is terribly stuck on the
> name; it's not a high priority at this time.

open-iscsi provides the proper abstraction. It can handles different
transport types, tcp and RDMA (iSER). It supports software iSCSI
drivers and HW iSCSI HBAs drivers. They are done via iscsi transport
class (and libiscsi).
