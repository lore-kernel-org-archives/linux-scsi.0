From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: aic7xxx: aic7892(B): BUG: soft lockup detected on CPU#0!
Date: Sat, 24 Mar 2007 04:44:34 +0100
Message-ID: <46049EA2.1040207@gmx.de>
References: <46029D72.3060403@gmx.de> <4602B576.6020602@gmx.de>	 <4602EED5.5070503@gmx.de> <46030A9A.2060604@gmx.de>	 <46032CC8.6030307@gmx.de>	 <1174625139.30030.31.camel@mulgrave.il.steeleye.com>	 <4603827C.4080701@gmx.de>  <46040047.3000104@gmx.de>	 <1174670587.30030.47.camel@mulgrave.il.steeleye.com>	 <46041B11.6000004@gmx.de> <46042383.7010704@gmx.de>	 <460475F5.1080805@gmx.de> <1174699032.13717.25.camel@mulgrave.il.steeleye.com>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60280 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750898AbXCXDog (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Mar 2007 23:44:36 -0400
In-Reply-To: <1174699032.13717.25.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sat, 2007-03-24 at 01:51 +0100, thomas schorpp wrote:
>>> no. so the pci layer reports wrong start:
>> nonsense. it succeeds, confused function return with the error flag:
>>
>> //      u_long  start;
>> //      u_long  start = 0xFFEFF000;
>>         u_long  start = 0x30000000;
>>         int     error;
>>
>>         struct resource* ret1;
>>         error = 0;
>> //      start = pci_resource_start(ahc->dev_softc, 1);
>>         if (start != 0) {
>>                 *bus_addr = start;
>>                 if ((ret1 = request_mem_region(start, 0x1000, "aic7xxx")) == 0)
> 
> You can't do this.  The pci_resource_start is getting the address of
> something called a Bus Address Register (BAR) it says in physical
> address space where the card is responding ... you can't simply set that
> to a random value.
> 
> The problem you seem to have is that your system is reporting a BAR
> beyond 32 bits (4GB) which the card physically can't use.  This could be
> because of a BIOS misconfiguration or because there's a bug in the PCI
> subsystem somewhere.
> 
> James

understood. waiting for LKML answers... meanwhile i found harder reason for 
a possible bounds problem with the driver code on x86_64:

if i do:

static int
ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
                                 u_long *bus_addr,
                                 uint8_t __iomem **maddr)
{
//      u_long  start;
        uint32_t start;

i get no free warning of "*nonexistant* resource" (it cant be nonexistant, 
cause it was definitely something mapped):

tom1:/usr/src/linux# dmesg |grep -i free
Freeing unused kernel memory: 208k freed

with u_long type start i get it:
Mar 24 03:41:47 localhost kernel: Trying to free nonexistent resource 
<00000000fffff000-00000000ffffffff>

investigating further...
