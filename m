From: Matthias Kaehlcke <mkaehlcke@e2s.net>
Subject: Re: [ep93xx] Oops when inserting USB storage in 2.6.27
Date: Mon, 27 Oct 2008 12:35:48 +0100
Message-ID: <4905A794.7000806@e2s.net>
References: <490173D1.80308@e2s.net> <1224887446.3307.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------090601090009060602010301"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:52475 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYJ0LiL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 07:38:11 -0400
In-Reply-To: <1224887446.3307.43.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, kernel@wantstofly.org

--------------090601090009060602010301
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

hi,

James Bottomley wrote:
> On Fri, 2008-10-24 at 09:05 +0200, Matthias Kaehlcke wrote:
>> hi,
>>
>> inserting a Verbatim 4GB USB stick in a ep9307 based device running 
>> kernel 2.6.27 results in the following Oops:
>>
>> [42949395.050000] usb 1-3: new full speed USB device using ep93xx-ohci
>> and address 2
>> [42949395.250000] usb 1-3: configuration #1 chosen from 1 choice
>> [42949395.260000] scsi0 : SCSI emulation for USB Mass Storage devices
>> [42949395.270000] usb 1-3: New USB device found, idVendor=13fe,
>> idProduct=1f23
>> [42949395.280000] usb 1-3: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [42949395.280000] usb 1-3: Product: STORE N GO
>> [42949395.300000] usb 1-3: Manufacturer: Verbatim
>> [42949395.310000] usb 1-3: SerialNumber: 078813D90478
>> [42949400.280000] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000003
>> [42949400.280000] pgd = c0648000
>> [42949400.300000] [00000003] *pgd=c0647031, *pte=00000000, *ppte=00000000
>> [42949400.300000] Internal error: Oops: 13 [#1] PREEMPT
>> [42949400.300000] Modules linked in:
>> [42949400.300000] CPU: 0    Not tainted  (2.6.27 #3)
>> [42949400.300000] PC is at scsi_calculate_bounce_limit+0x3c/0x44
> 
> Best guess is this line:
> 
> 	if (host_dev && host_dev->dma_mask)
> 		bounce_limit = *host_dev->dma_mask;
> 
> I'd guess host_dev->dma_mask contains 0x3 ... could this be some sort of
> ARM setup problem?

thanks for having a look!

i could figure out the difference between 2.6.26.3 and 2.6.27 that 
triggers the Oops:

diff -u linux-2.6.26.3/include/asm-arm/pci.h 
linux-2.6.27/arch/arm/include/asm/pci.h

...
@@ -30,7 +30,7 @@
   * The networking and block device layers use this boolean for bounce
   * buffer decisions.
   */
-#define PCI_DMA_BUS_IS_PHYS     (0)
+#define PCI_DMA_BUS_IS_PHYS     (1)

  /*
   * Whether pci_unmap_{single,page} is a nop depends upon the
...

this change affects the following piece of code in 
scsi_calculate_bounce_limit():

if (!PCI_DMA_BUS_IS_PHYS)
   return BLK_BOUNCE_ANY;

host_dev = scsi_get_device(shost);
if (host_dev && host_dev->dma_mask)
   bounce_limit = *host_dev->dma_mask;


host_dev->dma_mask is 0xffffffff and we try to dereference the pointer

what i don't know is what is the correct fix for the problem, i suppose 
there was a good reason to change PCI_DMA_BUS_IS_PHYS ...


--------------090601090009060602010301
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


--------------090601090009060602010301--
