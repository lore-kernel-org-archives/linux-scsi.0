From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: Broken pci_block_user_cfg_access interface
Date: Tue, 30 Aug 2011 11:30:35 -0500
Message-ID: <4E5D102B.5010402@linux.vnet.ibm.com>
References: <20110829150552.GA6851@redhat.com> <4E5BB358.3060705@siemens.com> <4E5BDEAB.5000405@siemens.com> <20110829191858.GA9415@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20110829191858.GA9415@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/29/2011 02:18 PM, Michael S. Tsirkin wrote:
> On Mon, Aug 29, 2011 at 08:47:07PM +0200, Jan Kiszka wrote:
>> On 2011-08-29 17:42, Jan Kiszka wrote:
>>> I still don't get what prevents converting ipr to allow plain mutex
>>> synchronization. My vision is:
>>>  - push reset-on-error of ipr into workqueue (or threaded IRQ?)
>>
>> I'm starting to like your proposal: I had a look at ipr, but it turned
>> out to be anything but trivial to convert that driver. It runs its
>> complete state machine under spin_lock_irq, and the functions calling
>> pci_block/unblock_user_cfg_access are deep inside this thing. I have no
>> hardware to test whatever change, and I feel a bit uncomfortable asking
>> Brian to redesign his driver that massively.
>>
>> So back to your idea: I would generalize pci_block_user_cfg_access to
>> pci_block_cfg_access. It should fail when some other site already holds
>> the access lock, but it should remain non-blocking - for the sake of ipr.
> 
> It would be easy to have blocking and non-blocking variants.
> 
> But
> - I have no idea whether supporting sysfs config/reset access
>   while ipr is active makes any sense - I know we need it for uio.

I really don't think it makes sense. Ideally, I really think the driver
should be able to override the PCI layer reset interface in sysfs. If a driver
is loaded, the driver owns all the state of that device and resetting it without
informing the driver is just nasty. Additionally, many devices may have
much more complex logic to performing a reset than what PCI defines. With
ipr, for example, it needs to get a shutdown command issued to it prior to the
reset if at all possible so that the firmware quiesces any I/O it is performing.
It also needs additional communication prior to resetting the chip to ensure
the firmware is not modifying its persistent error log on the adapter's flash,
since resetting the card while the flash segment is being updated will cause
the adapter to lose the persistent error log. Post reset, ipr has a bunch
of work to do to get the firmware back up and running to a state where it
can handle I/O again.

Different ipr chips also have different requirements as to what
reset mechanisms defined by PCI actually work. Some chips require BIST to be
run via PCI config space, while others require a PCI warm reset, otherwise
the card ends up in an unusable state.

So, here is my proposal to resolve this particular issue. Add a reset function
to the pci_driver struct which would allow drivers to override the default reset
action. Drivers that can tolerate the existing reset mechanism can simply point
to a generic PCI function to perform the reset. Drivers which can't handle their
device getting reset, will simply not have a reset function defined. In this case,
anyone attempting to issue a reset via sysfs will get an error. If a driver
is not loaded, then we can perform the default reset method and fix any device
specific oddities with quirks.

I like keeping pci_block_user_cfg_access a non blocking interface. If it can
return a failure due to some other caller, it should be easy enough to modify
the ipr driver to wait for access to get unblocked before resetting the adapter.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
