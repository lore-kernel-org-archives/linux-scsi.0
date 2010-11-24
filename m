From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Wed, 24 Nov 2010 23:35:45 +0300
Message-ID: <4CED7721.6040209@vlnb.net>
References: <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com> <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com> <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com> <4CE2846C.6070501@vlnb.net> <4CE59482.3050002@gmail.com> <20101118214619.GA29097@kroah.com> <4CE6BB4A.5060606@gmail.com> <20101119202202.GB6323@core.coreip.homeip.net> <4CE6E323.8080703@gmail.com> <20101119211649.GA28606@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51343 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab0KXUhE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Nov 2010 15:37:04 -0500
In-Reply-To: <20101119211649.GA28606@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Richard Williams <richard@etechsoft.com>, Bart Van Assche <bvanassche@acm.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, Hannes Reinecke <hare@suse.de>, Andy Yan <ayan@marvell.com>, Andrew Morton <akpm@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>

Greg KH, on 11/20/2010 12:16 AM wrote:
>>>> None of the SCST objects are Linux devices. None of them has entries in
>>>> /dev, none of them needs to send any events to udev and none of them
>>>> sends or receives data from DMA, hence has any DMA parameters or
>>>> restrictions. So, how can them fit into the driver/bus/device model you
>>>> are enforcing?
>>>
>>> Note that the entities in /sys/devices/... tree and not necessarily
>>> physical devices bit rather interface abstractionss. Consider, for
>>> example, /sys/class/input/*. None of the "devices" there talk directly
>>> to hardware, do DMA or other things. Some of them don't even talk to
>>> usrespace directly but rather through additional interfaces (evdev.
>>> mousedev, ect). Still they are represented there and even have suspend
>>> and resume methods (because even for logical devices it makes sense to
>>> save and restore some state).
> 
> This is correct.
> 
>> SCST devices are not even logical devices. As I wrote, "devices" word is
>> misleading. SCST devices are converse of what Linux means under this
>> word. SCST devices are like NFS exports: a place where those events
>> generated and those requests received.
> 
> No, that's fine.

I'm surprised you would make NFS exports devices

>> Think of SCST device as if it sits on the opposite side of the PCI bus
>> of the corresponding SCSI device Linux sees in /sys/class and /sys/bus.
> 
> Again, that's fine, look at usb gadgets, it's the same thing.

USB gadgets are a good example, but not quite.

I'm objecting not the possibility to implement SCST objects as devices.
We are creating software, so all what hardware allows can be implemented.

I'm arguing usage of devices view for something which fundamentally not
devices.

USB gadgets are subset of what SCST allows. On the external side they
are tightly coupled to hardware, on the backend side they don't need any
management interface, because (at least for storage) all devices
configuration they have is static via module parameters. The only
attributes file_storage has are to change FUA and file path, which can
be placed anywhere, including /sys/module/g_file_storage/parameters.

So, for USB gadgets the config interface and place in /sys doesn't
matter much. I guess, making its LUNs as Linux devices were just part of
the ritual to get accepted into the kernel. On the USB gadgets
developers place I wouldn't mind too to go this way.

But SCST is a _big_, _complete_, _new_ Linux subsystem. Actually, USB
storage gadgets should be SCST targets to use full power of all possible
virtual and real backends SCST provides, hence stay inside SCST subtree.

For SCST it is very important that all its functionality concentrated in
one place and not confused with other client side devices Linux has.
Important for clearness, easy to use, easy to understand, flexibility,
maintainability, etc.

It's like as you created rules to keep and train dogs. Then you need to
keep and train cats as well. Would it be wise to keep cats in the same
place together with dogs and train them the same tricks using the same
rules as dogs?

>> > None of the SCST objects are Linux devices. None of them has entries in
>> > /dev, none of them needs to send any events to udev and none of them
>> > sends or receives data from DMA, hence has any DMA parameters or
>> > restrictions. So, how can them fit into the driver/bus/device model you
>> > are enforcing?
>
> That doesn't matter.  They are still "devices" that the kernel knows
> about and as such, fit into the device tree of everything in the kernel.

If you have such wide devices definition, why file systems have separate
/sys/fs namespace? Or ksm place in /sys/kernel/mm/ksm? Or hugepages in
/sys/kernel/mm/hugepages?

If NFS exports are devices, file systems must also be devices, correct?

Like /sys/fs/ext4/sda11. Isn't it a full analogy to NFS export
/home/user/shared_dir?

>> > Sorry, but we have an impression that you are judging without seeing the
>> > full picture. Isn't it a duty of a subsystem's maintainer to see full
>> > picture before deciding if it's good or bad?
> It's the duty of a subsystem's maintainer to enforce the correct model
> of the kernel, and that is what I am doing.
> 
> Again, this is the last email I'm writing on this topic, as none of the
> previous ones seem to be sinking in.

Well, if I don't agree with you it doesn't mean I'm not listening to
you. I do. Very carefully.

Thanks,
Vlad

