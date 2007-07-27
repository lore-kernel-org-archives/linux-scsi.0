From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/21] advansys: Convert to pci_register_driver interface
Date: Fri, 27 Jul 2007 09:48:34 -0400
Message-ID: <46A9F7B2.3090604@garzik.org>
References: <11854705774041-git-send-email-matthew@wil.cx> <46A8F689.108@garzik.org> <20070726204915.GS19275@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57815 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577AbXG0Nsh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 09:48:37 -0400
In-Reply-To: <20070726204915.GS19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jul 26, 2007 at 03:31:21PM -0400, Jeff Garzik wrote:
>> 2) you dropped the check for pci_resource_start() returning zero (look 
>> for 'iop == 0' in original code)
> 
> That's not actually something that could happen through that path.

Er, huh?  It's a value returned from the PCI device.  Of course it can 
happen on that path.  That's the first time you look at the PCI BAR values.


>> 3) what happened to PCI BAR #1 ?  shouldn't you move that call here too? 
>>  it gets ioremapped (look at 'pci_memory_address' in old code, right 
>> next to pci_resource_start call)
> 
> That'll move later, once I'm on the iomap path.  We don't have the
> structure to stash the result in at this point.

If you follow other PCI drivers, you should check it in pci_driver::probe().


>> 4) it is often wise to add sanity checks that ensure that PCI BAR #0 == 
>> IORESOURCE_IO and PCI BAR #1 == IORESOURCE_MEM
> 
> Why is that?  There's no danger of advansys producing any more cards ;-)

Granted it is far less important than checking pci_resource_start()==0 
and pci_resource_len()==0 -- which happens often enough to care about 
it.  Firmware or kernel PCI allocation routines or even PCI quirks can 
affect this.

Generally this is not about new cards but about misconfiguration, or 
even protection from users trying to see if adding a PCI ID works for them.

But overall, it's sane to check that the resource is memory before 
passing it to ioremap, so that you catch the error at the correct time.

This is standard stuff that all PCI drivers should do.


>> 5) call pci_set_drvdata(pdev, NULL) as with other PCI drivers
> 
> Why?

So that you don't leave a dangling pointer to an object that has already 
been destroyed.

Again, this is standard PCI driver practice.


>> 7) bug: don't unregister, if pci_register_driver() failed during init
> 
> I assumed that pci_unregister_driver handled that, for the same reason that
> kfree(NULL) works.  Otherwise I have to keep track of that in the driver
> somewhere.

Well either verify your assumption or keep track of it :)


>>> +	for (i = 0; i < asc_board_count; i++) {
>>> +		struct Scsi_Host *host = asc_host[i];
>>> +		if (!host)
>>> +			continue;
>>> +		scsi_remove_host(host);
>>> +		advansys_release(host);
>>> +		asc_host[i] = NULL;
>> this last line of code is rather pointless, isn't it?
> 
> No ... see advansys_interrupt.  Yes, that needs to be cleaned up *too*,
> but I can't fix everything at once.  Eventually, the asc_host array will
> disappear.

Look at scsi_module.c:  it is sane practice to have two loops for code 
like this:  the first loop calls scsi_remove_host() for all hosts, and 
the second loop does the rest of the cleanup.  IMO this is more 
conservative, as you know the SCSI layer will not be passing anything to 
any port on your card, when you start shutting it down.  Makes it harder 
to trigger races and bugs.

Of course, when everything is converted to EISA/PCI hotplug API, you 
cannot do this anymore.

But I find it sane practice for older buses, especially.

	Jeff




