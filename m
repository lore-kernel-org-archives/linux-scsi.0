From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH2.5] ips 3/4: use pci_dma APIs and remove GFP abuse
Date: Mon, 18 Aug 2003 19:52:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F4166AB.9080609@pobox.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B037809@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:31677 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S275235AbTHRXwZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2003 19:52:25 -0400
In-Reply-To: <A3B9245C291EEF4785A24A1DBE8D852B037809@rtpexc01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Jeffery, David wrote:
>>-----Original Message-----
>>From: Jeff Garzik
>>Sent: Friday, August 15, 2003 5:10 PM
>>To: Jeffery, David
>>Cc: linux-scsi
>>Subject: Re: [PATCH2.5] ips 3/4: use pci_dma APIs and remove GFP abuse
>>
>>
>>David Jeffery wrote:
>>
>>>-#if !defined(__i386__) && !defined(__ia64__)
>>>-#error "This driver has only been tested on the x86/ia64 platforms"
>>>+#if !defined(__i386__) && !defined(__ia64__) && 
>>
>>!defined(__x86_64__)
>>
>>>+#error "This driver has only been tested on the 
>>
>>x86/ia64/x86_64 platforms"
>>
>>> #endif
>>
>>This should be removed completely.
>>
>>Under Linux, you limit the architectures that build your driver via 
>>Kconfig (or in 2.4, Config.in) dependencies.
>>
>>Further, Linux actively encourages that all PCI platforms at least 
>>attempt to build PCI drivers -- even if the company does not 
>>support the 
>>driver on that platform.  This leads to an increase in driver 
>>quality, 
>>as it increases the opportunities others have to point out bugs, and 
>>offer fixes.
> 
> 
> I need to fix up the Kconfig file.  How about I also downgrade that to
> a #warning like Andi suggested earlier?

Yeah, that's definitely an improvement, thanks.


>>> #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,

>>It's not wrong... but it's a bit nasty to be calling 
>>pci_alloc_consistent from the interrupt handler.  Typically, 
>>if you can, 
>>it would be better to have buffers waiting for you, and you 
>>simply map 
>>them here, using pci_map_single or pci_map_page or whatever.
> 
> 
> Normally, that is what happens.  A new, larger buffer will
> only be allocated in a few very rare cases.  No user should
> ever hit those allocations when using the ServeRAID tools.
> Only a few special commands like flashing firmware should
> ever trigger reallocation.
> 
> 
>>Also, as a tangent, I was thinking that it might be 
>>beneficial to move 
>>ips_next() to a tasklet.  Change all callers to call 
>>schedule_tasklet() 
>>instead.  That should allow more streamlined usage, IMO...
> 
> 
> Reworking ips_next is on my large list of Things To Do if I
> Had Time.

hehe :)

> The code still has plenty of warts and I wish I had more time to work
> on them. (Notice a theme about time? :)

Not an unique situation, either :)  Thanks,

	Jeff




