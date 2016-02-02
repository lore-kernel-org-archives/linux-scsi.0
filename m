From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
Date: Tue, 2 Feb 2016 10:09:56 -0800
Message-ID: <20160202180956.GB13880@infradead.org>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
 <56AAC605.1080707@cs.wisc.edu>
 <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com>
 <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
 <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com>
 <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu>
 <4c4653b259cd4f1887505dfc61d500a8@XCH-ALN-006.cisco.com>
 <56ABBCFF.9060003@cs.wisc.edu>
 <26376c0ade5645cfac5cc248a97528ba@XCH-ALN-006.cisco.com>
 <56ABF6A6.8070506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913AbcBBSJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 13:09:59 -0500
Content-Disposition: inline
In-Reply-To: <56ABF6A6.8070506@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>, "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

On Fri, Jan 29, 2016 at 05:32:54PM -0600, Mike Christie wrote:
> Hey Christoph and Hannes,
> 
> The dh/alua changes that added this:
> 
>         error = scsi_dh_add_device(sdev);
>         if (error) {
>                 sdev_printk(KERN_INFO, sdev,
>                                 "failed to add device handler: %d\n",
> error);
>                 return error;
>         }
> 
> to scsi_sysfs_add_sdev are adding a regression.
> 
> 1. If that fails, then we forget to do device_del before doing the
> return. My patch in this thread added that back, so we do not see the
> sysfs oopses anymore. But.....

Ok.

> 2. It looks like in older kernels, we would allow misconfigured targets
> like this one to still setup devices. Do we want that old behavior back?
> Should we just ignore the return value from scsi_dh_add_device above?
> Note that in this case, it is LIO so it can be easily fixed on the
> target side by just setting it up properly. I do not think other targets
> would hit this type of issue.

Be liberal in what you accept..  I guess we need to continue allowing
to connect to these broken targets, but a warning would be useful.

Can you send a patch?
