From: Greg KH <greg@kroah.com>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 19 Nov 2010 13:19:04 -0800
Message-ID: <20101119211904.GB28606@kroah.com>
References: <20101113235938.GA1827@kroah.com>
 <4CE1017E.4090409@panasas.com>
 <20101115161620.GB5981@kroah.com>
 <4CE16B8E.1000300@panasas.com>
 <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
 <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com>
 <4CE2846C.6070501@vlnb.net>
 <4CE59482.3050002@gmail.com>
 <20101118214619.GA29097@kroah.com>
 <4CE6BB4A.5060606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57741 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab0KSVTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2010 16:19:11 -0500
Content-Disposition: inline
In-Reply-To: <4CE6BB4A.5060606@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vvvvvst@gmail.com>
Cc: Richard Williams <richard@etechsoft.com>, Bart Van Assche <bvanassche@acm.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, Hannes Reinecke <hare@suse.de>, Andy Yan <ayan@marvell.com>, Andrew Morton <akpm@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>

On Fri, Nov 19, 2010 at 09:00:42PM +0300, Vladislav Bolkhovitin wrote:
> Greg KH, on 11/19/2010 12:46 AM wrote:
> > On Fri, Nov 19, 2010 at 12:02:58AM +0300, Vladislav Bolkhovitin wrote:
> >> Since nobody objected, Greg, could you consider to ACK SCST SYSFS
> >> management interface in /sys/kernel/scst_tgt/, please? Please find the
> >> SCST SYSFS ABI documentation file you requested below.
> > 
> > No, sorry, again, you should not be using kobjects, and do not polute
> > the main /sys/kernel/ namespace with this.
> 
> Which other namespace should we "polute" then?

None.  Use 'struct device'

> > Use 'struct device' please, that is what it is there for, and is what
> > the rest of the kernel is using. And use the rest of the
> > driver/bus/device infrastructure as your model will work with it just
> > fine.
> 
> Greg, sorry, I don't understand your requirements and, because of this,
> we can't go ahead implementing them. Could you explain your position,
> please?

I have multiple times.

> None of the SCST objects are Linux devices. None of them has entries in
> /dev, none of them needs to send any events to udev and none of them
> sends or receives data from DMA, hence has any DMA parameters or
> restrictions. So, how can them fit into the driver/bus/device model you
> are enforcing?

That doesn't matter.  They are still "devices" that the kernel knows
about and as such, fit into the device tree of everything in the kernel.

> Sorry, but we have an impression that you are judging without seeing the
> full picture. Isn't it a duty of a subsystem's maintainer to see full
> picture before deciding if it's good or bad?

It's the duty of a subsystem's maintainer to enforce the correct model
of the kernel, and that is what I am doing.

Again, this is the last email I'm writing on this topic, as none of the
previous ones seem to be sinking in.

good luck,

greg k-h
