From: Rajat Jain <rajat.noida.india@gmail.com>
Subject: Re: Incorrect driver getting loaded for Qlogic FC-HBA
Date: Tue, 26 Jul 2005 13:16:02 +0900
Message-ID: <b115cb5f050725211615cfab78@mail.gmail.com>
References: <b115cb5f0507241902653b6f72@mail.gmail.com>
	 <20050726000600.GB23858@kroah.com>
Reply-To: Rajat Jain <rajat.noida.india@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.202]:8902 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261626AbVGZEQD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 00:16:03 -0400
Received: by wproxy.gmail.com with SMTP id i1so1106106wra
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2005 21:16:02 -0700 (PDT)
In-Reply-To: <20050726000600.GB23858@kroah.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: kernelnewbies@nl.linux.org, linux-scsi@vger.kernel.org, linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org

On 7/26/05, Greg KH <greg@kroah.com> wrote:
> On Mon, Jul 25, 2005 at 11:02:39AM +0900, Rajat Jain wrote:
> > I'm using Kernel 2.6.9 and am having a Qlogic QLE2362 FC-HBA in my
> > system. I selected all the Qlogic SCSI drivers while buiding the
> > kernel. Now the problem is that every time I reboot, I have to
> > MANUALLY modprobe the qla2322.ko module in the kernel and only then my
> > HBA works. By default, the kernel loads qla2300.ko, which is not the
> > correct driver for the card, and hence the HBA does not work. Here is
> > the lspci output:
> 
> "by default" the kernel does not load any modules.  That's up to the
> hotplug system, or some other package.
> 
> thanks,
> 
> greg k-h
> 

Thanks. I just checked .. that is right. So let me put it this way.
When ever I hot-plug my HBA into the system, the driver "qla2300" gets
loaded. Where as the correct driver is "qla2322". This evident from
the output of "modules.pcimap" file and "lspci". The PCI device number
of HBA is 2322. and in modules.pcimap file, qla2322 is supposed to be
loaded when this HBA is hot-plugged. But module qla2300 is getting
loaded.

Any pointers on where could the problem be? Or how should I approach
this problem?

Thanks a lot.

Rajat

PS: For reference I am attaching the modules.pcimap file and lspci
output here again:

-----------------------------------------------------------------
0d:07.1 Fibre Channel: QLogic Corp.: Unknown device 2322 (rev 03)
       Subsystem: QLogic Corp.: Unknown device 0118
       Flags: bus master, 66Mhz, medium devsel, latency 128, IRQ 185
       I/O ports at 6400 [size=256]
       Memory at d0401000 (64-bit, non-prefetchable) [size=4K]
       Capabilities: [44] Power Management version 2
       Capabilities: [4c] PCI-X non-bridge device.
       Capabilities: [54] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
-------------------------------------------------------------------

Here is the relevant extract from modules.pcimap:
-------------------------------------------------------------------
#module  vendor     device     subvendor  subdevice  class  
class_mask driver_data
qla2300  0x00001077 0x00002300 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
qla2300  0x00001077 0x00002312 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
qla2322  0x00001077 0x00002322 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
-------------------------------------------------------------------
