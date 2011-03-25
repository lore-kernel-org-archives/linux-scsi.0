From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
 initial merge
Date: Thu, 24 Mar 2011 19:18:53 -0500
Message-ID: <1301012333.4087.24.camel@mulgrave.site>
References: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
	 <20110324074600L.fujita.tomonori@lab.ntt.co.jp>
	 <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
	 <20110324102939R.fujita.tomonori@lab.ntt.co.jp>
	 <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51975 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab1CYATE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2011 20:19:04 -0400
In-Reply-To: <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Wed, 2011-03-23 at 23:59 -0700, Nicholas A. Bellinger wrote:
> On Thu, 2011-03-24 at 10:29 +0900, FUJITA Tomonori wrote:
> > On Wed, 23 Mar 2011 16:28:37 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > > Hmm, you prefer 'zero C userspace code'? On the other hand, you insist
> > > > that requiring user Python userspace code to set up ibmvscsis is a
> > > > better approach even when the kernel space can set up everything for
> > > > ibmvscsis?
> > > > 
> > > 
> > > Yes, because we expect userspace to drive creation of the current
> > > configfs group layout.
> > > 
> > > The configfs maintainer explictly requested to drop the ability to drive
> > > the config_group creation from kernel-space that I had implemented
> > > originally, and which has not been included in the mainline target v4.0
> > > control plane.
> > > 
> > > It's folks like Joel and Greg-KH that need to be convinced in order for
> > > me to consider this type of logic for for mainline target code.  I do
> > 
> > Can you stop insisting that configfs can't do that so the target core
> > can't do that?
> > 
> 
> That's certainly not what I am insisting upon.  I am trying to explain
> that we currently have a configfs control plane that is native for
> target mode.
> 
> In the last three years to get to this point, I have developed prototype
> code and asked upstream review for:
> 
> *) Creating logic to drive configuration from kernel-space for configfs
> *) Tried at creating sysfs -> configfs symlinks for referencing target
> core backend devices
> 
> So far both of these attempts at patches have been firmly rejected by
> the configfs and sysfs maintainers.
> 
> I am not saying that configfs is the end-all for all generic target mode
> control plane, but what I am saying is that I have yet to see the code
> for a different control plane that makes me want to move the away from a
> 'native configfs' to 'a configfs/sysfs hyrbid', or something else all
> together for mainline target code.

OK, so what about an upcall to userspace to create the necessary
directories?  That could be driven by the kernel and still not require
any implementation in configfs.

> > We should think about what is the best design for the target code
> > first.
> > 
> > > > And iSCSI setup usually needs userspace code such as iSNS
> > > > anyway. You'll add iSNS to kernel too.
> > > > 
> > > 
> > > iSNS should be walking the /sys/kernel/config/target/iscsi layout, and
> > > should not require any kernel code at all.
> > 
> > How you draw the line? Why iSNS can live in user space?
> > 
> > For example, you say that iSNS should live in user space. The similar
> > feature to sending the list of target lives in kernel space.
> > 
> > 
> 
> iSNS is a seperate protocol, and there is no hard-requirement of iSNS
> client logic to be in place in order for basic iSCSI login to function.
> 
> > > What about for the boot1.kernel.org cases where we can expect 1000s of
> > > R/O clients in the future to a proper 10 Gb/sec uplink.  
> > > 
> > > Why do all of these types of logins need to talk with a userspace login
> > > queue interface?
> > 
> > I prefer less kernel space code.
> > 
> > 
> > >  Why do we need to worry about an interface in the
> > > first place for the standard iSCSI login case..?  What happens if this
> > > daemon is unexpectedly killed..?  Do I now have to worry about
> > 
> > Can you stop such pointless argument? What happens if the iscsi target
> > kernel module crashed?
> > 
> > Linux systems already depend on some essential user space daemons. We
> > know how to deal with them.
> > 
> > 
> 
> Sorry, but I have no interest in adding the extra complexity to handle
> this for the default case.

Look at it this way: there's no way an implementation of all the RFC3720
authentication methods (let alone the extensions) is going into the
kernel, so you need a user space interface anyway.  Once you have one,
creating two paths: one in-kernel and one via upcall just doubles the
maintenance load and the amount of work that has to be done fixing bugs.
As far as I can see, authentication isn't in the fast path, so there's
no real need for any of it to be in-kernel in the first place.

James


