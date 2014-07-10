From: Keith Busch <keith.busch@intel.com>
Subject: Re: [RFC PATCH] Let device drivers disable msi on shutdown
Date: Thu, 10 Jul 2014 12:53:48 -0600 (MDT)
Message-ID: <alpine.LRH.2.03.1407101241010.4703@AMR>
References: <1403628537-16367-1-git-send-email-keith.busch@intel.com> <20140710183840.GA12663@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140710183840.GA12663@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Keith Busch <keith.busch@intel.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 10 Jul 2014, Bjorn Helgaas wrote:
> [+cc LKML, Greg KH for driver core async shutdown question]
> On Tue, Jun 24, 2014 at 10:48:57AM -0600, Keith Busch wrote:
>> To provide context why I want to do this asynchronously, NVM-Express has
>> one PCI device per controller, of which there could be dozens in a system,
>> and each one may take many seconds (I've heard over ten in some cases)
>> to safely shutdown.
>
> I don't see anything in device_shutdown() that would wait for this
> sort of asynchronous shutdown to complete.  So how do we know it's
> finished before we turn off the power, reset, kexec, etc.?
>
> If we need to do asynchronous shutdown, it seems like we need some
> sort of driver core infrastructure to manage that.

Yes, good point! To address that, I did submit this patch:

http://lists.infradead.org/pipermail/linux-nvme/2014-May/000827.html

I need to fix the EXPORT_SYMBOL_GPL usage for a v2, but before that, I
wan't to know the reason the driver can't use MSIx in an async shutdown
shutdown, and came to the patch mentioned above.

I'd originally had the async shutdown use legacy interrupts, but I
know some NVMe devices do not support legacy, so can't use my original
proposal. If I can't rely on MSI/MSI-x being enabled in an async shutdown,
then I have to add polling, which I suppose we can live with.
