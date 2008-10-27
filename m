From: Matthias Kaehlcke <mkaehlcke@e2s.net>
Subject: Re: [ep93xx] Oops when inserting USB storage in 2.6.27
Date: Mon, 27 Oct 2008 17:22:06 +0100
Message-ID: <4905EAAE.20603@e2s.net>
References: <490173D1.80308@e2s.net>	 <1224887446.3307.43.camel@localhost.localdomain> <4905A794.7000806@e2s.net> <1225117156.5146.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------020109040408050302050305"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:31186 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJ0QYe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 12:24:34 -0400
In-Reply-To: <1225117156.5146.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, kernel@wantstofly.org

--------------020109040408050302050305
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

hi,

James Bottomley wrote:
> On Mon, 2008-10-27 at 12:35 +0100, Matthias Kaehlcke wrote:
>>
>> James Bottomley wrote:
>>> On Fri, 2008-10-24 at 09:05 +0200, Matthias Kaehlcke wrote:
>>>>
>>>> inserting a Verbatim 4GB USB stick in a ep9307 based device running 
>>>> kernel 2.6.27 results in the following Oops:
>>>>
>>>> [42949395.050000] usb 1-3: new full speed USB device using ep93xx-ohci
>>>> and address 2
>>>> [42949395.250000] usb 1-3: configuration #1 chosen from 1 choice
>>>> [42949395.260000] scsi0 : SCSI emulation for USB Mass Storage devices
>>>> [42949395.270000] usb 1-3: New USB device found, idVendor=13fe,
>>>> idProduct=1f23
>>>> [42949395.280000] usb 1-3: New USB device strings: Mfr=1, Product=2,
>>>> SerialNumber=3
>>>> [42949395.280000] usb 1-3: Product: STORE N GO
>>>> [42949395.300000] usb 1-3: Manufacturer: Verbatim
>>>> [42949395.310000] usb 1-3: SerialNumber: 078813D90478
>>>> [42949400.280000] Unable to handle kernel NULL pointer dereference at
>>>> virtual address 00000003
>>>> [42949400.280000] pgd = c0648000
>>>> [42949400.300000] [00000003] *pgd=c0647031, *pte=00000000, *ppte=00000000
>>>> [42949400.300000] Internal error: Oops: 13 [#1] PREEMPT
>>>> [42949400.300000] Modules linked in:
>>>> [42949400.300000] CPU: 0    Not tainted  (2.6.27 #3)
>>>> [42949400.300000] PC is at scsi_calculate_bounce_limit+0x3c/0x44
>>> Best guess is this line:
>>>
>>> 	if (host_dev && host_dev->dma_mask)
>>> 		bounce_limit = *host_dev->dma_mask;
>>>
>>> I'd guess host_dev->dma_mask contains 0x3 ... could this be some sort of
>>> ARM setup problem?
>> thanks for having a look!
>>
>> i could figure out the difference between 2.6.26.3 and 2.6.27 that 
>> triggers the Oops:
>>
>> diff -u linux-2.6.26.3/include/asm-arm/pci.h 
>> linux-2.6.27/arch/arm/include/asm/pci.h
>>
>> ...
>> @@ -30,7 +30,7 @@
>>    * The networking and block device layers use this boolean for bounce
>>    * buffer decisions.
>>    */
>> -#define PCI_DMA_BUS_IS_PHYS     (0)
>> +#define PCI_DMA_BUS_IS_PHYS     (1)
>>
>>   /*
>>    * Whether pci_unmap_{single,page} is a nop depends upon the
>> ...
>>
>> this change affects the following piece of code in 
>> scsi_calculate_bounce_limit():
>>
>> if (!PCI_DMA_BUS_IS_PHYS)
>>    return BLK_BOUNCE_ANY;
>>
>> host_dev = scsi_get_device(shost);
>> if (host_dev && host_dev->dma_mask)
>>    bounce_limit = *host_dev->dma_mask;
>>
>>
>> host_dev->dma_mask is 0xffffffff and we try to dereference the pointer
> 
> So the host_dev is some type of arm platform device?  If so, it's got
> it's dma_mask set up wrongly.  it's a pointer in struct device and is
> supposed to point to the real u64 quantity located within the actual
> enclosing device.

thanks a lot for the pointer, i think i fixed the problem:

--- linux-2.6.27.org/arch/arm/mach-ep93xx/core.c        2008-10-10 
00:13:53.000000000 +0200
+++ linux-2.6.27/arch/arm/mach-ep93xx/core.c    2008-10-27 
17:00:42.000000000 +0100
@@ -26,6 +26,7 @@
  #include <linux/serial_core.h>
  #include <linux/device.h>
  #include <linux/mm.h>
+#include <linux/dma-mapping.h>
  #include <linux/time.h>
  #include <linux/timex.h>
  #include <linux/delay.h>
@@ -450,12 +451,14 @@
         },
  };

+static u64 ep93xx_ohci_dmamask = DMA_BIT_MASK(32);
+
  static struct platform_device ep93xx_ohci_device = {
         .name           = "ep93xx-ohci",
         .id             = -1,
         .dev            = {
-               .dma_mask               = (void *)0xffffffff,
-               .coherent_dma_mask      = 0xffffffff,
+               .dma_mask               = &ep93xx_ohci_dmamask,
+               .coherent_dma_mask      = DMA_BIT_MASK(32),
         },
         .num_resources  = ARRAY_SIZE(ep93xx_ohci_resources),
         .resource       = ep93xx_ohci_resources,


i'm going to submit this patch to mainline if there are no objections

(apologizes to the scsi ppl for spamming your list with an issue that 
turns out not to be directly related to scsi)

--------------020109040408050302050305
Content-Type: text/x-vcard; charset="utf-8"; name="mkaehlcke.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="mkaehlcke.vcf"

begin:vcard
fn:Matthias Kaehlcke
n:Kaehlcke;Matthias
org:Electronic Engineering Solutions;Dept. de Software
adr:;;C/ Sant Ferran, 10-16 bajos;Barcelona;;08031;Spain
email;internet:mkaehlcke@e2s.net
title:Ingeniero de Firmware
tel;work:93 407 30 80
tel;fax:93 433 56 71
x-mozilla-html:FALSE
url:http://www.e2s.net
version:2.1
end:vcard


--------------020109040408050302050305--
