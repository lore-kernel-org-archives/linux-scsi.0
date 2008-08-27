From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Kernel Level Generic Target Mode control path
Date: Wed, 27 Aug 2008 15:13:39 -0700
Message-ID: <1219875219.13470.380.camel@haakon2.linux-iscsi.org>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu>
	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>
	 <48B59556.7050108@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:37436 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752690AbYH0WNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2008 18:13:42 -0400
In-Reply-To: <48B59556.7050108@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>, Greg KH <greg@kroah.com>

On Wed, 2008-08-27 at 21:56 +0400, Vladislav Bolkhovitin wrote:
> >> Our userspace tools will also be able to support both kernel space and 
> >> userspace targets with little trouble so distros that have stgt will not 
> >> notice any differences.
> > 
> > So this is one of the items that I mentioned to Vlad as being a
> > potential stumbling block..  I stated that I have no problem dumping the
> > LIO IOCTL in favor of something better, and having to break backwards
> > compat with LIO userspace tools (well, until I have to emulate the
> > backwards compat wrt target-ctl ;-)) is something I am ready to deal
> > with.
> > 
> > So I definately see your point here, having the exist CLI logic in place
> > into distros is something that we are going to have to deal with (even
> > if the core behind them is completely different).  
> > 
> > I should also mention that virtually all of the configuration logic done
> > from the LIO-Core and LIO-Target IOCTLs today is intended (minus a bug
> > or two :-) to be done without having to shutdown/stop anything other
> > than the referenced object for the target-ctl operation.  Obviously, I
> > really want to keep the same functionality with the CLI interface the
> > LIO pieces are ported to.
> > 
> > I will be sure to take a look at the STGT control interface and see how
> > I can fit the current functionality in.  I believe SCST uses an IOCTL
> > today as well, which would put them in a similar situation.
> 
> I, personally, don't like an interface, like tgtadm, which tries to do 
> all non-trivial configuration work from a single command line tool, 
> because of the following 3 reasons:
> 
> 1. It's a lot of effort to write and maintain such a tool, because it 
> needs to be extensible to work with new modules and modes. For instance, 
> iptables tool is 86K lines long. The whole netfilter code for all 
> network protocols in the kernel is less that 50K lines long. Do we want 
> such a code bloat (170% of code to configure) and dedicated team of 
> maintainers to solve a fundamentally simple configuration task?
> 

Hrrmmm, yes I could see the same type of problem with the amount of
modularity requires for having plugins registering their own sets of
parameters for their control path code..

> 2. It assumes the stateless type of configuration, when each call 
> configures exactly one thing without any side effects on already 
> configured or future entries.
>  This approach is good for cases like 
> iptables, but for SCSI targets it's possible that several configuration 
> steps require to be done in an atomic manner, like adding an iSCSI 
> target and configuring its parameters.
> 

Well, the ability for an admin to force an LIO-Core related action, say
removing an HBA and all associated storage object with lots of exported
LUNs and running I/O, or an LIO-Target related action, say removing an
entire iSCSI Target Node with targetname=) at any time..  This obviously
require precision interaction between Target Fabric I/O Paths <-> Target
Core and Target Core <-> Control Interface to Admin.

That control interface needs to be protected in object contexts.  In
LIO-Core this is on a per HBA (be it physical or virtual) context.  With
LIO-Target this is on a iSCSI Target Node by targetname -> Target Portal
Group Tag context.  Obviously doing this from an IOCTL is the only real
choice I had when this code started in 2001, but I wonder how configfs
would work for something like this.

In any event, I will keep in mind that I might have to disable some of
my control path during the LIO-Target <-> SCST Core migration until we
can get resolved on the shutdown control path side..

> 3. It's hard to read 5+ parameters in one command line, so it's a lot 
> easier to make a mistake there.

No, I completely agree.  But I honestly think the actual target CLI
interface and parameters to admin need to do alot of pre-execution
script logic in userspace to reference different interested objects,
without the admin have to provide all of stuff.  I do this today to
determine the major/minor for lvm_uuid= (from lvs -v), md_uuid= (from
mdadm -D) and udev_path= (from /dev/disk)..

Same goes for real SCSI devices that we are exporting directly from
drivers/scsi.  We want to use EVPD Unit Serial or Device Identificaton
where ever able to reference said storage object.

> So, I believe, a configuration interface should be rather /proc or /sys 
> interface based. I don't think we should care much about backward 
> compatibility with tgtadm, because the existing interface doesn't reach 
> the state of being widely used.

I would definately vote against proc here for the fancy stuff I
mentioned above.  I have experience enabled core-iscsi to use sysfs for
RO data, but nothing along the lines of what would be required for a
generic target mode RW control path.  Does anyone with sysfs experience
have any comments on thing..?

>  As I already mentioned, only ibmvscsi at 
> the moment uses it, hardware for which is pretty rare.
> 

I am sure we could get some time this hardware if we wanted.. :-)

> Thus, I would suggest that before making the further move we should also 
> consider configuration interfaces of SCST and LIO and choose the best 
> things from all 3.
> 

So, Ming mentioned configfs for this...  /me reads about configfs

--nab


