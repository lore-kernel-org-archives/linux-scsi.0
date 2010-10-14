From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Thu, 14 Oct 2010 13:04:13 -0700
Message-ID: <20101014200413.GA30831@kroah.com>
References: <4CA653F0.1010008@vlnb.net>
 <4CA656AD.8020408@vlnb.net>
 <20101009212047.GB27180@kroah.com>
 <4CB36592.6060909@vlnb.net>
 <20101011213235.GA11489@kroah.com>
 <4CB4AEB9.30501@vlnb.net>
 <20101012190345.GA25737@kroah.com>
 <4CB75E81.7000208@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35312 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab0JNULS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2010 16:11:18 -0400
Content-Disposition: inline
In-Reply-To: <4CB75E81.7000208@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

On Thu, Oct 14, 2010 at 11:48:17PM +0400, Vladislav Bolkhovitin wrote:
> Originally I thought you are asking to make tgt_kobj be not embedded in
> struct scst_tgt, but a pointer in it, so scst_tgtt_release() will
> kfree() tgt_kobj. Hence, all the above I wrote about why we have
> tgt_kobj embedded.
> 
> But now I feel like you are asking that scst_tgtt_release() should
> kfree() tgt, not tgt_kobj.
> 
> Is it correct?

I am asking that ANY kobject release function call kfree to release the
memory that object is embedded in.  That is how kobjects work, please
read the documentation for more details.

> We have a simple and straightforward errors recovery semantic: if
> scst_tgt_sysfs_create() failed, then tgt_kobj returned deinited as if
> scst_tgt_sysfs_create() has never been called. This is a regular
> practice in the kernel: don't return half-initialized objects.

True.

> If we implement freeing tgt in scst_tgtt_release() as you requesting, we
> will need to add in the error recovery path additional recovery code to
> track and delete half-initialized tgt_kobj. Particularly, we will need
> to add additional flag to track that tgt_kobj initialized, hence needs
> deleting. Similar flag and code will be added in all similar to scst_tgt
> SCST objects.
> 
> This code will be quite errors prone as you can see on the example of
> device_register() which on failure requires device_put() to be called
> (http://lkml.org/lkml/2010/9/19/93).

That's not "error prone", it's "people don't read the provided
documentation about how to use the API".

And yes, one could argue to make the API easier to use, and patches are
always welcome to do so.

> (I'm not questioning device_register() implementation, there might be
> very good reasons to implement it this way (I don't know), I mean, it
> is too easy to forget to do the needed recovery of the half-created
> objects as this case demonstrating.)

There are good reasons, but the most important one being, if you pass
off an object, as of that moment in time, you had better handle the
reference counting correctly.  If you think of it this way, cleanup
logic is even simpler as that's the only rule you ever need to think
about, none of thies "half-initialized" stuff.

> Could you confirm if I understand you correctly and need to implement
> freeing tgt in the kobject release() function, please?

Again, yes.  Please read the documentation.

thanks,

greg k-h
