From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Kernel Level Generic Target Mode control path
Date: Thu, 28 Aug 2008 21:52:08 +0400
Message-ID: <48B6E5C8.2000306@vlnb.net>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu>	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>	 <48B59556.7050108@vlnb.net> <1219875219.13470.380.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:51415 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752043AbYH1Rvh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 13:51:37 -0400
In-Reply-To: <1219875219.13470.380.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>, Greg KH <greg@kroah.com>

Nicholas A. Bellinger wrote:
> On Wed, 2008-08-27 at 21:56 +0400, Vladislav Bolkhovitin wrote:
>>>> Our userspace tools will also be able to support both kernel space and 
>>>> userspace targets with little trouble so distros that have stgt will not 
>>>> notice any differences.
>>> So this is one of the items that I mentioned to Vlad as being a
>>> potential stumbling block..  I stated that I have no problem dumping the
>>> LIO IOCTL in favor of something better, and having to break backwards
>>> compat with LIO userspace tools (well, until I have to emulate the
>>> backwards compat wrt target-ctl ;-)) is something I am ready to deal
>>> with.
>>>
>>> So I definately see your point here, having the exist CLI logic in place
>>> into distros is something that we are going to have to deal with (even
>>> if the core behind them is completely different).  
>>>
>>> I should also mention that virtually all of the configuration logic done
>>> from the LIO-Core and LIO-Target IOCTLs today is intended (minus a bug
>>> or two :-) to be done without having to shutdown/stop anything other
>>> than the referenced object for the target-ctl operation.  Obviously, I
>>> really want to keep the same functionality with the CLI interface the
>>> LIO pieces are ported to.
>>>
>>> I will be sure to take a look at the STGT control interface and see how
>>> I can fit the current functionality in.  I believe SCST uses an IOCTL
>>> today as well, which would put them in a similar situation.
>> I, personally, don't like an interface, like tgtadm, which tries to do 
>> all non-trivial configuration work from a single command line tool, 
>> because of the following 3 reasons:
>>
>> 1. It's a lot of effort to write and maintain such a tool, because it 
>> needs to be extensible to work with new modules and modes. For instance, 
>> iptables tool is 86K lines long. The whole netfilter code for all 
>> network protocols in the kernel is less that 50K lines long. Do we want 
>> such a code bloat (170% of code to configure) and dedicated team of 
>> maintainers to solve a fundamentally simple configuration task?
> 
> Hrrmmm, yes I could see the same type of problem with the amount of
> modularity requires for having plugins registering their own sets of
> parameters for their control path code..

I should add in this context that in the UNIX world the choice between a 
huge application, capable of doing all possible kinds of work, and a set 
of small utilities, doing exactly one simple thing each, was done 
decades ago in favor of the set of small utilities: find, grep, sort, 
etc. And I believe now nobody would claim that it was a wrong choice.

>> 2. It assumes the stateless type of configuration, when each call 
>> configures exactly one thing without any side effects on already 
>> configured or future entries.
>>  This approach is good for cases like 
>> iptables, but for SCSI targets it's possible that several configuration 
>> steps require to be done in an atomic manner, like adding an iSCSI 
>> target and configuring its parameters.
> 
> Well, the ability for an admin to force an LIO-Core related action, say
> removing an HBA and all associated storage object with lots of exported
> LUNs and running I/O, or an LIO-Target related action, say removing an
> entire iSCSI Target Node with targetname=) at any time..  This obviously
> require precision interaction between Target Fabric I/O Paths <-> Target
> Core and Target Core <-> Control Interface to Admin.
> 
> That control interface needs to be protected in object contexts.  In
> LIO-Core this is on a per HBA (be it physical or virtual) context.  With
> LIO-Target this is on a iSCSI Target Node by targetname -> Target Portal
> Group Tag context.  Obviously doing this from an IOCTL is the only real
> choice I had when this code started in 2001, but I wonder how configfs
> would work for something like this.

My favorite configuration interface would have 2 levels.

1. The lowest level would be /proc, /sys, etc. based and allow to 
configure exactly one parameter or set of related parameters with 
corresponding subparameters necessary to provide required atomicity, if 
needed. For instance, this is how a new virtual read-only SBC device 
with 4K block size is added in SCST vdisk handler:

# echo "open disk_4K /disk_4K 4096 READ_ONLY" >/proc/scst/vdisk/vdisk

2. The higher level interface(s) would allow people to not bother with 
low level commands, but use regular text config file(s). See scstadmin 
utility for example. It allows to do all necessary configuration of SCST 
core from /etc/scst.conf file. Such interface must have an important 
property: it must be able to detect changes in the config file and apply 
them to the running system. That property would allow to have system 
configuration always persistent: if one needs to change something, he 
would edit the config file and rerun the corresponding utility 
(scstadmin in this example; it really can do that, though with some 
limitations). Although this interface level would completely belong to 
user space, we in kernel need to provide for it a convenient interface.

Target drivers and backstorage device handlers, who need advanced 
configuration, would have own low and high level interfaces, as needed. 
For instance, an iSCSI target must not start serving clients until all 
its targets fully configured. Otherwise, initiators can get rejected for 
not yet configured target and erroneously consider it dead. In 
iSCSI-SCST the user space part of the target doesn't start accepting 
connection until it finishes reading /etc/iscsi-scst.conf file.

>> 3. It's hard to read 5+ parameters in one command line, so it's a lot 
>> easier to make a mistake there.
> 
> No, I completely agree.  But I honestly think the actual target CLI
> interface and parameters to admin need to do alot of pre-execution
> script logic in userspace to reference different interested objects,
> without the admin have to provide all of stuff.  I do this today to
> determine the major/minor for lvm_uuid= (from lvs -v), md_uuid= (from
> mdadm -D) and udev_path= (from /dev/disk)..
> 
> Same goes for real SCSI devices that we are exporting directly from
> drivers/scsi.  We want to use EVPD Unit Serial or Device Identificaton
> where ever able to reference said storage object.

Yes, this is why we need the high level interface. Otherwise for complex 
targets the configuration task quickly grows up to a nightmare.

>> So, I believe, a configuration interface should be rather /proc or /sys 
>> interface based. I don't think we should care much about backward 
>> compatibility with tgtadm, because the existing interface doesn't reach 
>> the state of being widely used.
> 
> I would definately vote against proc here for the fancy stuff I
> mentioned above.  I have experience enabled core-iscsi to use sysfs for
> RO data, but nothing along the lines of what would be required for a
> generic target mode RW control path.  Does anyone with sysfs experience
> have any comments on thing..?

Sysfs as well as configfs have one big disadvantage. They limit each 
file to only 4KB. This would force us for to create a subdirectory for 
each device and for each connected initiator. I don't like seeing 
thousands subdirectories. Additionally, such layout is a lot less 
convenient for parsing for the high level configuration tool, which 
needs to find out the difference between the current configuration and 
content of the corresponding config file.

Currently, with procfs SCST can list in /proc/scst/sessions virtually 
unlimited amount of connected initiators in a simple for parsing manner. 
It was done using seq interface well and simply. Neither sysfs, nor 
configfs support seq interface. This would introduce significant effort 
in both kernel and user spaces.

Debugfs supports seq interface, but, because of the name, I doubt we can 
use it ;)

Thus, looks like we'd better stay with /proc. After all, networking and 
VM widely use /proc for internal configuration. Why SCSI target is worse?

>>  As I already mentioned, only ibmvscsi at 
>> the moment uses it, hardware for which is pretty rare.
>>
> 
> I am sure we could get some time this hardware if we wanted.. :-)
> 
>> Thus, I would suggest that before making the further move we should also 
>> consider configuration interfaces of SCST and LIO and choose the best 
>> things from all 3.
>>
> 
> So, Ming mentioned configfs for this...  /me reads about configfs
> 
> --nab
> 
> 
> 

