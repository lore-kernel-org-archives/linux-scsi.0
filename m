From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b2).
Date: Thu, 29 May 2003 10:26:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ED61888.6040407@pobox.com>
References: <20030519225728.GA17279@praka.local.home> <20030521173215.GA25137@praka.local.home> <20030521222635.GB21124@krispykreme> <20030529061913.GA27199@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14002 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262257AbTE2ONL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 10:13:11 -0400
In-Reply-To: <20030529061913.GA27199@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@san.rr.com>
Cc: linux-scsi@vger.kernel.org

Andrew Vasquez wrote:
> On Thu, 22 May 2003, Anton Blanchard wrote:
> 
> 
>>>+#if MEMORY_MAPPED_IO
>>>+	/* Get memory mapped I/O address */
>>>+	pci_read_config_dword(ha->pdev, PCI_BASE_ADDRESS_1, &mmapbase);
>>
>>You really want to be using pci_resource_start(ha->pdev, 1) so it will
>>work on architectures like ppc64 and sparc64.
>>
> 
> 
> You're correct -- code updated in my tree.
> 
> 
>>>+	mmapbase &= PCI_BASE_ADDRESS_MEM_MASK;
>>>+
>>>+	/* Find proper memory chunk for memory map I/O reg */
>>>+	base = mmapbase & PAGE_MASK;
>>>+	page_offset = mmapbase - base;
>>
>>Is that correct?
>>
> 
> 
> The 'mmapbase &= PCI_BASE_ADDRESS_MEM_MASK' does appear to be
> incorrect, yet, I just have one question.

s/incorrect/obsolete/

This masking is a harmless remnant of ancient 2.2.x days, when we read 
the PCI information straight out of the PCI config registers.  This 
masking is no longer needed when a driver is converted to using 
pci_resource_start (as it should be :))


   it seems several drivers
> (i.e. sym53c8xx_2, aic7xxx) ensure the memory-mapped resource begins
> on a page boundary before passing it onto ioremap().  Yet, in the code
> for __ioremap(), (arch/i386/mm/ioremap.c) there is this small comment:
> 
> 	/*
> 	 * NOTE! We need to allow non-page-aligned mappings too: we
> 	 * will obviously have to convert them into an offset in a
> 	 * page-aligned mapping, but the caller shouldn't need to know
> 	 * that small detail.
> 	 *
> 	 */
> 
> Is it safe to assume *all* platforms will handle this case internally,
> or should drivers perform the pre-process?

They better.  It is expected that you can pass the bus address returned 
from pci_resource_start directly to ioremap (after ensuring availability 
by calling pci_request_regions).

	Jeff



