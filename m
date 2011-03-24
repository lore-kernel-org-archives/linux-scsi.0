From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Wed, 23 Mar 2011 23:59:40 -0700
Message-ID: <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
References: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
	 <20110324074600L.fujita.tomonori@lab.ntt.co.jp>
	 <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
	 <20110324102939R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37265 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab1CXHGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2011 03:06:52 -0400
In-Reply-To: <20110324102939R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Thu, 2011-03-24 at 10:29 +0900, FUJITA Tomonori wrote:
> On Wed, 23 Mar 2011 16:28:37 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > > Hmm, you prefer 'zero C userspace code'? On the other hand, you insist
> > > that requiring user Python userspace code to set up ibmvscsis is a
> > > better approach even when the kernel space can set up everything for
> > > ibmvscsis?
> > > 
> > 
> > Yes, because we expect userspace to drive creation of the current
> > configfs group layout.
> > 
> > The configfs maintainer explictly requested to drop the ability to drive
> > the config_group creation from kernel-space that I had implemented
> > originally, and which has not been included in the mainline target v4.0
> > control plane.
> > 
> > It's folks like Joel and Greg-KH that need to be convinced in order for
> > me to consider this type of logic for for mainline target code.  I do
> 
> Can you stop insisting that configfs can't do that so the target core
> can't do that?
> 

That's certainly not what I am insisting upon.  I am trying to explain
that we currently have a configfs control plane that is native for
target mode.

In the last three years to get to this point, I have developed prototype
code and asked upstream review for:

*) Creating logic to drive configuration from kernel-space for configfs
*) Tried at creating sysfs -> configfs symlinks for referencing target
core backend devices

So far both of these attempts at patches have been firmly rejected by
the configfs and sysfs maintainers.

I am not saying that configfs is the end-all for all generic target mode
control plane, but what I am saying is that I have yet to see the code
for a different control plane that makes me want to move the away from a
'native configfs' to 'a configfs/sysfs hyrbid', or something else all
together for mainline target code.

> We should think about what is the best design for the target code
> first.
> 
> > > And iSCSI setup usually needs userspace code such as iSNS
> > > anyway. You'll add iSNS to kernel too.
> > > 
> > 
> > iSNS should be walking the /sys/kernel/config/target/iscsi layout, and
> > should not require any kernel code at all.
> 
> How you draw the line? Why iSNS can live in user space?
> 
> For example, you say that iSNS should live in user space. The similar
> feature to sending the list of target lives in kernel space.
> 
> 

iSNS is a seperate protocol, and there is no hard-requirement of iSNS
client logic to be in place in order for basic iSCSI login to function.

> > What about for the boot1.kernel.org cases where we can expect 1000s of
> > R/O clients in the future to a proper 10 Gb/sec uplink.  
> > 
> > Why do all of these types of logins need to talk with a userspace login
> > queue interface?
> 
> I prefer less kernel space code.
> 
> 
> >  Why do we need to worry about an interface in the
> > first place for the standard iSCSI login case..?  What happens if this
> > daemon is unexpectedly killed..?  Do I now have to worry about
> 
> Can you stop such pointless argument? What happens if the iscsi target
> kernel module crashed?
> 
> Linux systems already depend on some essential user space daemons. We
> know how to deal with them.
> 
> 

Sorry, but I have no interest in adding the extra complexity to handle
this for the default case.

> > implementing a multi-threaded userspace daemon to handle the high login
> > volume public iSCSI target case..?
> 
> I'm pretty sure that even single-threaded userspace deamon can handle
> iSCSI login operations.
> 

No, I don't want a single threaded userspace interface for handling
iSCSI login logic for default operation.  This is an unnecessary
bottleneck.

> 
> > > The user space daemon can read configfs easily to do the same thing.
> > 
> > But reading the of the configfs layout is not the problem, yes..?
> 
> I don't think so. The user space doesn't cache the configfs info. So
> the rule is pretty simple.

It's more complicated than that.  We have to then start referencing
things like struct se_node_acl usage to userspace when locating an
explict NodeACL during login.  What happens if the explict NodeACL is
removed from configfs context while userspace code is running..?  What
happens if the entire TPG is removed during an active userspace login..?
It all has to be sychronized with a userspace daemon through a single
thread that needs to know about the network portals, TPG layout and
explict NodeACls in order to complete a iSCSI login.

I do not want to deal with any global userspace sychronization for the
default iSCSI login case, especially for high volume public demo-mode
access.  This only adds unnecessary complexity to the current
iscsi-target code, and I have no interest to make this type of
fundemental change to iscsi-target design at this point without a strong
practical benefit for existing code.  I need a signficant reason to drop
everyhing that has been functioning for years and re-invent the wheel,
again, in userspace.  I have not yet to heard a convincing case for
doing any of this.

--nab


