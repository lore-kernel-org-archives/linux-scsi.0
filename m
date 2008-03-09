From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
Date: Sun, 09 Mar 2008 18:42:31 +0300
Message-ID: <47D40567.7070409@msgid.tls.msk.ru>
References: <47D3C8A1.6040409@msgid.tls.msk.ru>	 <20080309212916T.tomof@acm.org> <1205075315.3792.12.camel@localhost.localdomain> <47D402C6.3070505@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:20514 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbYCIPme (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Mar 2008 11:42:34 -0400
In-Reply-To: <47D402C6.3070505@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <tomof@acm.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Michael Tokarev wrote:
> James Bottomley wrote:
>> On Sun, 2008-03-09 at 21:29 +0900, FUJITA Tomonori wrote:
>>> On Sun, 09 Mar 2008 14:23:13 +0300
>>> Michael Tokarev <mjt@tls.msk.ru> wrote:
>>>
>>>> Just got quite.. bad situation on a production server
>>>> here.  The machine locked up hard several times in a
>>>> row (required hard reboot).  So I finally enabled watchdog
>>>> subsystem which helped.
>>>>
>>>> Now I see the following (over netconsole):
>>>>
>>>> DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:08:07.0
>>>> ------------[ cut here ]------------
>>>> kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
>>> Seems that you was out of swiommu space (and aic79xx can't handle it
>>> though it should). This happened because:
>>>
>>> a) you produced more I/Os than swiommu can handle.
>>>
>>> b) swiommu space leaks due to bugs.
>>>
>>> If you hit this problem due to a), the following boot option might
>>> help:
>>>
>>> swiotlb=65536
> 
> Running with this parameter now - no lockups so far.
> 
>> Actually, it's worse than this.  The aic79xx is a fully 64 bit capable
>> PCI card, it shouldn't be using the iommu at all.  However, it has three
>> DMA modes:  64 bit, 39 bit and 32 bit; with a corresponding resource
>> cost increasing with the number of bits.  It employs special APIs to
>> size the masks according to the memory, in aic79xx_osm_pci.c:
> []
>> Could you firstly tell me how much memory you have, and secondly
>> instrument this code with the patch below to see if we can work out what
>> it's doing?
> 
> The memory map is below (6Gb total).  The patch - kernel is being compiled
> right now.

And here's the result (without swiotlb=65536):

DEBUG: RETURNED REQUIRED MASK ffffffff
DEBUG: SET 32 BIT ADDRESSING

(which doesn't look like a good thing, provided this
machine has 6Gb of memory...)

It just crashed again, with the same message - in a few seconds after I
mounted the filesystem in question.  So back to swiotlb=65536 ;)

> Linux version 2.6.24-x86-64 (mjt@paltus.tls.msk.ru) (gcc version 4.2.3 
> 20071123 (prerelease) (Debian 4.2.2-4)) #2.6.24.2 SMP Mon Feb 18 
> 16:04:41 MSK 2008
> Command line: auto BOOT_IMAGE=linux-test ro root=100 swiotlb=65536 
> panic=30 elevator=deadline
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
>  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000cfffca00 (usable)
>  BIOS-e820: 00000000cfffca00 - 00000000d0000000 (ACPI data)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
> 
> 
> /mjt
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

