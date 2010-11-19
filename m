From: Vladislav Bolkhovitin <vvvvvst@gmail.com>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 19 Nov 2010 23:50:43 +0300
Message-ID: <4CE6E323.8080703@gmail.com>
References: <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com> <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com> <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com> <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com> <4CE2846C.6070501@vlnb.net> <4CE59482.3050002@gmail.com> <20101118214619.GA29097@kroah.com> <4CE6BB4A.5060606@gmail.com> <20101119202202.GB6323@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53437 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab0KSUuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2010 15:50:19 -0500
In-Reply-To: <20101119202202.GB6323@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <greg@kroah.com>, Richard Williams <richard@etechsoft.com>, Bart Van Assche <bvanassche@acm.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, Hannes Reinecke <hare@suse.de>, Andy Yan <ayan@marvell.com>, Andrew Morton <akpm@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>

Dmitry Torokhov, on 11/19/2010 11:22 PM wrote:
>> None of the SCST objects are Linux devices. None of them has entries in
>> /dev, none of them needs to send any events to udev and none of them
>> sends or receives data from DMA, hence has any DMA parameters or
>> restrictions. So, how can them fit into the driver/bus/device model you
>> are enforcing?
> 
> Note that the entities in /sys/devices/... tree and not necessarily
> physical devices bit rather interface abstractionss. Consider, for
> example, /sys/class/input/*. None of the "devices" there talk directly
> to hardware, do DMA or other things. Some of them don't even talk to
> usrespace directly but rather through additional interfaces (evdev.
> mousedev, ect). Still they are represented there and even have suspend
> and resume methods (because even for logical devices it makes sense to
> save and restore some state).

But all of them still place from where to events received and where
requests from Linux sent, aren't them?

SCST devices are not even logical devices. As I wrote, "devices" word is
misleading. SCST devices are converse of what Linux means under this
word. SCST devices are like NFS exports: a place where those events
generated and those requests received.

Think of SCST device as if it sits on the opposite side of the PCI bus
of the corresponding SCSI device Linux sees in /sys/class and /sys/bus.

So, if we need Linux devices for SCST devices, we create them using
scst_local driver. And then, of course, all them have their place in
/sys/class/ and /sys/bus. Although more common use of them from remote
systems via iSCSI, Fibre Channel, InfiniBand, etc. The remote systems
create devices in /sys/class/ and /sys/bus (if they are Linux), we serve
them.

Vlad
