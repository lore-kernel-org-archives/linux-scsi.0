From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
 initial merge
Date: Fri, 25 Mar 2011 10:06:51 -0500
Message-ID: <1301065611.4073.7.camel@mulgrave.site>
References: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
	 <20110324074600L.fujita.tomonori@lab.ntt.co.jp>
	 <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
	 <20110324102939R.fujita.tomonori@lab.ntt.co.jp>
	 <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
	 <1301012333.4087.24.camel@mulgrave.site>
	 <AANLkTik2UxAO3uZ8r1U0bqYVX+0zHGUAd8uuiPzVQq57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab1CYPHC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Mar 2011 11:07:02 -0400
In-Reply-To: <AANLkTik2UxAO3uZ8r1U0bqYVX+0zHGUAd8uuiPzVQq57@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Fri, 2011-03-25 at 12:31 +0100, Bart Van Assche wrote:
> On Fri, Mar 25, 2011 at 1:18 AM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> >> OK, so what about an upcall to userspace to create the necessary
> > directories?  That could be driven by the kernel and still not require
> > any implementation in configfs.
> 
> Hi James,
> 
> I might have missed something, but which upcall mechanism are you
> referring to ? Personally I'm not fond of the upcall concept because
> as far as I can see any synchronous upcall mechanism can potentially
> be used to trigger lock inversions not detectable by the PROVE_LOCKING
> mechanism.

Any ... we have relay, netlink, uevent etc.

I don't see how there could be a lock inversion.  Upcalls are by
definition asynchronous.

The use case for ibmvscsi, which seems the most pressing, is simply that
on load it unpacks the config information, does the upcall and exits.
The daemon creates the necessary directories with the information and
the vscsi interface is functional once everything is set up.  There's no
locking problems in that use case.

> Regarding kernel-space driven directory creation in configfs: I have
> been wondering whether it is possible to implement any configuration
> filesystem such that directories can be created synchronously from
> kernel space without triggering lock inversion. I don't see this as a
> configfs limitation but as an inherent limitation of a configuration
> filesystem. In a similar way a self-declarative kernel interface like
> sysfs has the limitation that it is not possible to add configfs-style
> configuration functionality without triggering lock inversion. Both
> sysfs and configfs have important advantages over mechanisms like
> ioctl() and netlink but there are some disadvantages too.

Explain first what lock inversion problems you see ... those usually
only happen if you have the in the kernel upcall thread waiting for
completion.

James


