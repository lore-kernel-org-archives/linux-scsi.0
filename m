From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.02 update
Date: Wed, 17 Mar 2004 17:15:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4058CDE9.3020902@pobox.com>
References: <0E3FA95632D6D047BA649F95DAB60E57040DB2A7@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21444 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262112AbUCQWPV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 17:15:21 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57040DB2A7@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, ak@suse.de, Alexander.Stohr@gmx.de, rddunlap@osdl.org

Moore, Eric Dean wrote:
> The wrappers are there because the system
> interface registers could be memory or IO mapped
> registers depending on the pci device.  The PIO 

Yes, I understand what the wrappers are doing :)  That's why I said it 
was mainly a style issue I was bringing up.  Depending on the hardware 
requirements and installed userbase, it may be better to make PortIO a 
compile-time option.  In general MMIO is preferred.


> wrappers could be removed, but I think its there 
> to be uniform with the other wrappers.  The PIO 
> wrappers there for firmware download which 

If it's directly wrapping a Linux API call, then the Linux API call 
should be used directly in the code.  Wrappers in general inhibit 
compiler optimization opportunities, and occasionally hide bugs.  They 
hinder long term maintainance, and slow down code reviews.

With every vendor-written driver inventing its own wrappers, the problem 
gets unscalable real quick.


> always using IO registers. Id would rather not
> remove the volatile since the registers could
> be memory mapped, and may break things when
> driver compiled with optimized kernel.

No, all that is needed is included in the read[bwl] and write[bwl] 
definitions.  'volatile' occasionally hides bugs, and good code is 
completely volatile-free:  always explicitly flush MMIO writes, and 
employ memory barriers, rather than depending on the compiler to do so.

The compiler does not have 100% of the knowledge necessary -- 
particularly for MMIO writes -- to presume whether a flush is needed or 
not.  Portable code _must_ follow a writel() call with the readl(), to 
guarantee that all PCI- and CPU-posted/delayed writes are flushed 
completely to the PCI device.

	Jeff




