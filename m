From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Thu, 11 Nov 2010 06:16:11 -0800
Message-ID: <20101111141611.GA4679@kroah.com>
References: <4CC1DAA2.7030602@vlnb.net> <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <20101111120453.GA672@kroah.com> <4CDBF837.7050608@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:33485 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab0KKOP3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 09:15:29 -0500
Content-Disposition: inline
In-Reply-To: <4CDBF837.7050608@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

On Thu, Nov 11, 2010 at 04:05:43PM +0200, Boaz Harrosh wrote:
> On 11/11/2010 02:04 PM, Greg KH wrote:
> > On Thu, Nov 11, 2010 at 11:59:28AM +0200, Boaz Harrosh wrote:
> >> 4. Exactly Like 3 but without the extra kref member
> >>    Only x_put() changes and x_kref_release() now receives
> >>    an x_object
> >>
> >> int x_put(struct object_x *x)
> >> {
> >> 	if (kobject_put(&x->kobj) == 1)
> >> 		// Like above [3] x_kref_release()
> >> 		x_kref_release(x);
> >> }
> > 
> > This is racy, please never do this.
> > 
> 
> The last ref belongs to the core code. 1 means there are no
> more external clients on the object. So it can not race with
> decrements. But I guess there is a possibility that it can
> race with new increments.

Exactly.

> If it is the case that new increments
> can only come from, say, sysfs access, then if we call the
> x_put() == 1 after we are unregistered from sysfs and no new
> users are allowed then the counter can only go down and we
> have the last reference. No?

Just don't do this, it's not worth it and will break over time when
others mess with the code.

Also note that kobject_put() does not even return a value, so the code
above will not even compile, let alone work.

thanks,

greg k-h
