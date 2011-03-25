From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Fri, 25 Mar 2011 14:14:50 -0700
Message-ID: <1301087690.6087.126.camel@haakon2.linux-iscsi.org>
References: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
	 <20110324074600L.fujita.tomonori@lab.ntt.co.jp>
	 <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
	 <20110324102939R.fujita.tomonori@lab.ntt.co.jp>
	 <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
	 <1301012333.4087.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60987 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1CYVWG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 17:22:06 -0400
In-Reply-To: <1301012333.4087.24.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Thu, 2011-03-24 at 19:18 -0500, James Bottomley wrote:
> On Wed, 2011-03-23 at 23:59 -0700, Nicholas A. Bellinger wrote:
> > On Thu, 2011-03-24 at 10:29 +0900, FUJITA Tomonori wrote:
> > > On Wed, 23 Mar 2011 16:28:37 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > > Hmm, you prefer 'zero C userspace code'? On the other hand, you insist
> > > > > that requiring user Python userspace code to set up ibmvscsis is a
> > > > > better approach even when the kernel space can set up everything for
> > > > > ibmvscsis?
> > > > > 
> > > > 
> > > > Yes, because we expect userspace to drive creation of the current
> > > > configfs group layout.
> > > > 
> > > > The configfs maintainer explictly requested to drop the ability to drive
> > > > the config_group creation from kernel-space that I had implemented
> > > > originally, and which has not been included in the mainline target v4.0
> > > > control plane.
> > > > 
> > > > It's folks like Joel and Greg-KH that need to be convinced in order for
> > > > me to consider this type of logic for for mainline target code.  I do
> > > 
> > > Can you stop insisting that configfs can't do that so the target core
> > > can't do that?
> > > 
> > 
> > That's certainly not what I am insisting upon.  I am trying to explain
> > that we currently have a configfs control plane that is native for
> > target mode.
> > 
> > In the last three years to get to this point, I have developed prototype
> > code and asked upstream review for:
> > 
> > *) Creating logic to drive configuration from kernel-space for configfs
> > *) Tried at creating sysfs -> configfs symlinks for referencing target
> > core backend devices
> > 
> > So far both of these attempts at patches have been firmly rejected by
> > the configfs and sysfs maintainers.
> > 
> > I am not saying that configfs is the end-all for all generic target mode
> > control plane, but what I am saying is that I have yet to see the code
> > for a different control plane that makes me want to move the away from a
> > 'native configfs' to 'a configfs/sysfs hyrbid', or something else all
> > together for mainline target code.
> 
> OK, so what about an upcall to userspace to create the necessary
> directories?  That could be driven by the kernel and still not require
> any implementation in configfs.
> 

I think finding a way to do this is a good idea for the target fabric
endpoints as long as we can ensure that symlinks from target core
backports in target_core_mod to fabric Port/LUNs are still driven by
interpreted userspace code.

Allowing certain modules to drive target struct config_group endpoint
creation/deletion from kernel-space is fine with me, but I think for
something like this to really work they need to be done interchangebly.

At this point I would be leaning for uevent for something like this
(this would work on a 64-bit kernel / 32-bit user environment, right).  

Do you have any kernel code pointers handy that I can grok as a future
target v4.1 feature..?

> > > We should think about what is the best design for the target code
> > > first.
> > > 
> > > > > And iSCSI setup usually needs userspace code such as iSNS
> > > > > anyway. You'll add iSNS to kernel too.
> > > > > 
> > > > 
> > > > iSNS should be walking the /sys/kernel/config/target/iscsi layout, and
> > > > should not require any kernel code at all.
> > > 
> > > How you draw the line? Why iSNS can live in user space?
> > > 
> > > For example, you say that iSNS should live in user space. The similar
> > > feature to sending the list of target lives in kernel space.
> > > 
> > > 
> > 
> > iSNS is a seperate protocol, and there is no hard-requirement of iSNS
> > client logic to be in place in order for basic iSCSI login to function.
> > 
> > > > What about for the boot1.kernel.org cases where we can expect 1000s of
> > > > R/O clients in the future to a proper 10 Gb/sec uplink.  
> > > > 
> > > > Why do all of these types of logins need to talk with a userspace login
> > > > queue interface?
> > > 
> > > I prefer less kernel space code.
> > > 
> > > 
> > > >  Why do we need to worry about an interface in the
> > > > first place for the standard iSCSI login case..?  What happens if this
> > > > daemon is unexpectedly killed..?  Do I now have to worry about
> > > 
> > > Can you stop such pointless argument? What happens if the iscsi target
> > > kernel module crashed?
> > > 
> > > Linux systems already depend on some essential user space daemons. We
> > > know how to deal with them.
> > > 
> > > 
> > 
> > Sorry, but I have no interest in adding the extra complexity to handle
> > this for the default case.
> 
> Look at it this way: there's no way an implementation of all the RFC3720
> authentication methods (let alone the extensions) is going into the
> kernel, so you need a user space interface anyway.  Once you have one,
> creating two paths: one in-kernel and one via upcall just doubles the
> maintenance load and the amount of work that has to be done fixing bugs.
> As far as I can see, authentication isn't in the fast path, so there's
> no real need for any of it to be in-kernel in the first place.
> 

To clarify my stance here.  I was not implying that we use two seperate
in-kernel and userspace level iSCSI login codebases, or that maintenance
load has anything to do with my choice of iSCSI login implementation for
this particular point.

What I am saying is that only the optional to implement iSCSI
authentication *payloads* should have a request/response interface with
userspace daemons for those types of auth libs that we always expect to
reside in userspace.  This is what iscsi-target v2 had originally been
doing for CHAP and SRP (using a loopback socket to a userspace daemon)
until I decided to make add RFC-3720 required default CHAP support into
iscsi-target v3 using libcrypto md5.

The reasons why I really like a design where only the 'optional to
implement' iSCSI authentication payloads in iSCSI login stage CSG=0
interact with userspace is:

*) In future code, it allows 'optional to implement' userspace
authentication daemons to function seperately per iSCSI TargetName
+TargetPortalGroupTag context.  eg: Different authentication daemon
processes can function independently on each target endpoint context.

*) In current code, it allows incoming iSCSI TargetName
+TargetPortalGroup reference to struct iscsi_portal_group <-> struct
iscsi_np, and InitiatorName+ISID to target core struct se_node_acl in
kernel-space without global userspace sychronization.  eg: iscsi_np
kthreads are independent of userspace

*) In current code, it allows for the AuthMethod=None iSCSI login case
to skip the iSCSI login authentication phase all-together (by-passing
login stage CSG=0) and perform the login in kernel-space without global
userspace sychronization.

*) In current code, it allows the RFC-3720 required CHAP support to
'just-work' out of the box when you load iscsi_target_mod.ko

*) The vast majority of iSCSI initiators on Linux and non Linux
platforms only support CHAP.

So that said, having to do any type of global or non-global userspace
sychronization for the second and third point above is what I strongly
consider to be a functional step backwards from what exists in
iscsi-target v4.1 and has been proposed in PATCH-v2.

Having to sychronize all iSCSI login state with userspace code is a
awkward approach for an in-kernel iSCSI target, especially for one who's
control plane is built from the ground up to be real-time configurable
from configfs.

--nab

