From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Wed, 23 Mar 2011 16:28:37 -0700
Message-ID: <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
References: <1300875726.21880.542.camel@haakon2.linux-iscsi.org>
	 <20110323200722G.fujita.tomonori@lab.ntt.co.jp>
	 <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
	 <20110324074600L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56158 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972Ab1CWXfu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 19:35:50 -0400
In-Reply-To: <20110324074600L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Thu, 2011-03-24 at 07:46 +0900, FUJITA Tomonori wrote:
> On Wed, 23 Mar 2011 14:37:34 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > > Removing several thousand lines from kernel isn't benefit?
> > > 
> > > 
> > 
> > No, not when it adds complexity without benefit for the default case and
> > introduces unnecessary userspace C code.
> > 
> > At this point in lio-utils.git for target v4 code, we require zero C
> > userspace code for the default operation of iscsi-target, and I want to
> > keep it this way.  
> 
> Hmm, you prefer 'zero C userspace code'? On the other hand, you insist
> that requiring user Python userspace code to set up ibmvscsis is a
> better approach even when the kernel space can set up everything for
> ibmvscsis?
> 

Yes, because we expect userspace to drive creation of the current
configfs group layout.

The configfs maintainer explictly requested to drop the ability to drive
the config_group creation from kernel-space that I had implemented
originally, and which has not been included in the mainline target v4.0
control plane.

It's folks like Joel and Greg-KH that need to be convinced in order for
me to consider this type of logic for for mainline target code.  I do
agree some modules like ibmviscsis are a very good canidate to revisit
the discussion for something like this.  However I still think we can
achieve the same results with more flexiable python library code that
provides an API to programmers to drive the underlying target configfs
control plane, than trying to add this logic direct in kernel code,
regardless of fabric module type.

> I can't understand your logic.
> 
> And iSCSI setup usually needs userspace code such as iSNS
> anyway. You'll add iSNS to kernel too.
> 

iSNS should be walking the /sys/kernel/config/target/iscsi layout, and
should not require any kernel code at all.

> 
> > Maintaining backwards compatibility with interpreted script code for the
> > fabric control plane makes life so much eaiser than any kernel <-> user
> > C API that I have ever encountered.
> 
> I think that the target can use open-iscsi's kernel <-> user
> interface. All the userspace code needs is passing negotiated iSCSI
> parameters. Once a nexus establishes, the user space will never do
> anything for it. So no complicity like open-iscsi.
> 

What about for the boot1.kernel.org cases where we can expect 1000s of
R/O clients in the future to a proper 10 Gb/sec uplink.  

Why do all of these types of logins need to talk with a userspace login
queue interface?  Why do we need to worry about an interface in the
first place for the standard iSCSI login case..?  What happens if this
daemon is unexpectedly killed..?  Do I now have to worry about
implementing a multi-threaded userspace daemon to handle the high login
volume public iSCSI target case..?

Can we please just use iSCSI $TARGET_WWN endpoint specific kernel-level
login for high volume bko type operation, and allow other TPG contexts
to use an userspace passthrough for the other optional authentication
cases from RFC-3720 that we are not going to support in-kernel..?

> 
> > > In other words, what the approach to do the pre-nexus operations like
> > > IET (or SCST) can't do?
> > 
> > Because it does not makes sense for the default case, and adds
> > unnecessary complexity to the iscsi-target login process.
> 
> Well, I don't think so.
> 
> 
> > Using mainline libcrypto for CHAP works as expected and allows us to
> > provide one-way and mutual authentication for iSCSI discovery and
> > explict initiator NodeACLs via configfs attributes without any userspace
> > C dependcies.
> 
> The user space daemon can read configfs easily to do the same thing.

But reading the of the configfs layout is not the problem, yes..?

It's the synchronization between a kernel and userspace daemon for every
login attempt that does not require standard or disabled authentication,
and having to use another interface for this and worry about all of the
extra things that come with this type of design. 

iscsi_target_mod has never required this to function, and I still don't
see a reason why we should enforce a hard-requirement to do this for all
iSCSI login cases.

--nab

