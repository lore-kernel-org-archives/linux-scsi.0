From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ANNOUNCE][RELEASE]: megaraid unified driver version 2.20.0.B
 1
Date: Fri, 16 Apr 2004 15:17:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40803154.3070707@pobox.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC53D@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:19667 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263606AbUDPTRz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 15:17:55 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC53D@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'Matt_Domsch@dell.com'" <Matt_Domsch@dell.com>, "'paul@kungfoocoder.org'" <paul@kungfoocoder.org>, "'James.Bottomley@SteelEye.com'" <James.Bottomley@SteelEye.com>, "'arjanv@redhat.com'" <arjanv@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

Mukker, Atul wrote:
>>megaraid_clib.c:
>>  - why do you need the scb pool managment code at all?  You 
>>can dynamically
>>    allocate scbs in ->queuecommand
> 
> Will do. Please see the follow up question below

If there is a static maximum of scbs for megaraid hardware, dynamically 
allocating scbs in ->queuecommand is a waste of time.

In my drivers, I pre-allocate driver-specific per-request structures -- 
just like the SCSI layer does ;-)

If you follow this -- faster -- approach, make sure you don't waste a 
lot of memory with pre-allocated scb's you'll rarely use.


>>  - can you explain the need for all the mraid_pci_blk_pool?  
>>I.e. why the
>>    generic dma pool routines don't work for megaraid
> 
> We did not want to use pci_alloc_consistent because it would give one page
> even if we need 16 bytes (and we need a lot of these). Also, the
> pci_poo_create and pci_pool_alloc would fail on some setups - maybe because
> the driver requires lots of small chunks of DMAable buffers. So we decided
> to write wrapper functions over pci_alloc_consistent..

Would prefer to identify the root cause of pci_pool_xxx failure, since 
that is the proper API to use.

	Jeff



