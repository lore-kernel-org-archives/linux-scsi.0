From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Thu, 24 Mar 2011 10:29:39 +0900
Message-ID: <20110324102939R.fujita.tomonori@lab.ntt.co.jp>
References: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
	<20110324074600L.fujita.tomonori@lab.ntt.co.jp>
	<1300922917.18039.147.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:51724 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1CXBhi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 21:37:38 -0400
In-Reply-To: <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Wed, 23 Mar 2011 16:28:37 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> > Hmm, you prefer 'zero C userspace code'? On the other hand, you insist
> > that requiring user Python userspace code to set up ibmvscsis is a
> > better approach even when the kernel space can set up everything for
> > ibmvscsis?
> > 
> 
> Yes, because we expect userspace to drive creation of the current
> configfs group layout.
> 
> The configfs maintainer explictly requested to drop the ability to drive
> the config_group creation from kernel-space that I had implemented
> originally, and which has not been included in the mainline target v4.0
> control plane.
> 
> It's folks like Joel and Greg-KH that need to be convinced in order for
> me to consider this type of logic for for mainline target code.  I do

Can you stop insisting that configfs can't do that so the target core
can't do that?

We should think about what is the best design for the target code
first.

> > And iSCSI setup usually needs userspace code such as iSNS
> > anyway. You'll add iSNS to kernel too.
> > 
> 
> iSNS should be walking the /sys/kernel/config/target/iscsi layout, and
> should not require any kernel code at all.

How you draw the line? Why iSNS can live in user space?

For example, you say that iSNS should live in user space. The similar
feature to sending the list of target lives in kernel space.


> What about for the boot1.kernel.org cases where we can expect 1000s of
> R/O clients in the future to a proper 10 Gb/sec uplink.  
> 
> Why do all of these types of logins need to talk with a userspace login
> queue interface?

I prefer less kernel space code.


>  Why do we need to worry about an interface in the
> first place for the standard iSCSI login case..?  What happens if this
> daemon is unexpectedly killed..?  Do I now have to worry about

Can you stop such pointless argument? What happens if the iscsi target
kernel module crashed?

Linux systems already depend on some essential user space daemons. We
know how to deal with them.


> implementing a multi-threaded userspace daemon to handle the high login
> volume public iSCSI target case..?

I'm pretty sure that even single-threaded userspace deamon can handle
iSCSI login operations.


> > The user space daemon can read configfs easily to do the same thing.
> 
> But reading the of the configfs layout is not the problem, yes..?

I don't think so. The user space doesn't cache the configfs info. So
the rule is pretty simple.
