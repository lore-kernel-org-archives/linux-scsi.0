From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 19 Nov 2010 12:22:02 -0800
Message-ID: <20101119202202.GB6323@core.coreip.homeip.net>
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
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47796 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab0KSUWO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2010 15:22:14 -0500
Content-Disposition: inline
In-Reply-To: <4CE6BB4A.5060606@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vvvvvst@gmail.com>
Cc: Greg KH <greg@kroah.com>, Richard Williams <richard@etechsoft.com>, Bart Van Assche <bvanassche@acm.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, Hannes Reinecke <hare@suse.de>, Andy Yan <ayan@marvell.com>, Andrew Morton <akpm@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>

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
> 
> > Use 'struct device' please, that is what it is there for, and is what
> > the rest of the kernel is using. And use the rest of the
> > driver/bus/device infrastructure as your model will work with it just
> > fine.
> 
> Greg, sorry, I don't understand your requirements and, because of this,
> we can't go ahead implementing them. Could you explain your position,
> please?
> 
> None of the SCST objects are Linux devices. None of them has entries in
> /dev, none of them needs to send any events to udev and none of them
> sends or receives data from DMA, hence has any DMA parameters or
> restrictions. So, how can them fit into the driver/bus/device model you
> are enforcing?
> 

Note that the entities in /sys/devices/... tree and not necessarily
physical devices bit rather interface abstractionss. Consider, for
example, /sys/class/input/*. None of the "devices" there talk directly
to hardware, do DMA or other things. Some of them don't even talk to
usrespace directly but rather through additional interfaces (evdev.
mousedev, ect). Still they are represented there and even have suspend
and resume methods (because even for logical devices it makes sense to
save and restore some state).

> For instance:
> 
>  - struct sgv_pool (/sys/kernel/scst_tgt/sgv/<cache>) is an SG vectors
> cache. Isn't it a nonsense to make it device?
> 
>  - struct scst_acg
> (/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/)
> is an access control group to define which initiators see which LUNs
> from target <target>. Same, isn't it a nonsense to make it device?
> 
>  - struct scst_acn
> (/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/initiators/<initiator_name>)
> is an entry in the access control group <group> to define which
> initiators should use group <group>. Again, isn't it a nonsense to make
> it device?
> 
> Etc.
> 
> How could they fit in the driver/bus/device model?

Maybe not all of them are. Some of them could probably be represented by
attributes of other devices. And some of them are, fitting into the
overall /sys/devices hierarchy and describing physical and logical
relations between them.

-- 
Dmitry
