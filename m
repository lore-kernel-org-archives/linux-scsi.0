From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: aic7xxx: aic7892(B): BUG: soft lockup detected on CPU#0!
Date: Fri, 23 Mar 2007 19:23:13 +0100
Message-ID: <46041B11.6000004@gmx.de>
References: <46029D72.3060403@gmx.de> <4602B576.6020602@gmx.de>	 <4602EED5.5070503@gmx.de> <46030A9A.2060604@gmx.de>	 <46032CC8.6030307@gmx.de>	 <1174625139.30030.31.camel@mulgrave.il.steeleye.com>	 <4603827C.4080701@gmx.de>  <46040047.3000104@gmx.de> <1174670587.30030.47.camel@mulgrave.il.steeleye.com>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49130 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753286AbXCWSXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Mar 2007 14:23:16 -0400
In-Reply-To: <1174670587.30030.47.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2007-03-23 at 17:28 +0100, thomas schorpp wrote:
>>> i agree for this to be a 32bit dma busmaster chip,
>>> since pci_resource_flags and lspci say 64bit mem resource type
>>>
>>> aic7xxx: pci_resource_start fffff000 *maddr 20000 mem64 4
>>>

static int
ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
                                 u_long *bus_addr,
                                 uint8_t __iomem **maddr)
{
//      u_long  start;
        u_long  len;
        int     error;
        uint64_t start;
...
        printk(KERN_WARNING "aic7xxx: pci_resource_start 0x%llx mem64 0x%lx\n", start, pci_resource_flags(ahc->dev_softc, 1) & PCI_BASE_ADDRESS_MEM_TYPE_64 ); //schorpp
        return (error);

aic7xxx: pci_resource_start 0xffffff000 mem64 0x4
-----------------------------------------------^

just to doublecheck the situation, posted lspci already.

will check next, if 

       len = pci_resource_len(ahc->dev_softc, 1);
        if (start != 0) {
                *bus_addr = start;
//              if (request_mem_region(start, 0x1000, "aic7xxx") == 0)
                if (request_mem_region(start, len, "aic7xxx") == 0)

succeeds.

>>> we've a bug in the x86_64 linux pci config, BIOS is ok, the hardware 
>>> worked fine in a winxp_x64 test setup a few months ago.
>>>
>>> will ask LKML.
>>>
>>> y
>>> tom
>> sorry, wrong according to http://download.adaptec.com/pdfs/aic7892.pdf.
>>
>> "66 MHz, 64-bit, PCI interface that
>> supports zero wait-state memory;
>> also operates on 33 MHz, 32-bit
>> PCI busses"
>>
>> this chip is capable of 64bit addressing, as pci_resource_nnnn (checking this) on x86_64 platform 
>> and lspci on x86_64 *and* AMDK7 configured kernels reports, even on PCI/32, right?
>> or is it impossible to do multiplexed 64bit mem addressing on PCI/32?
> 
> It can only do 37 bit addressing ... only the aic79xx can do the full 64
> bits, so I suspect it should never get a 64 bit BAR, since it wouldn't
> be able to decode the full 32 bits.  I can fix the mmio check not to
> hang, but the card won't actually work mmio until whatever's assigning
> the BAR above 32 bits is fixed (that could either be a kernel PCI bug or
> a BIOS bug).
> 

ok, i trust in that. adaptor bios and mainboard bios *are* out, winxp_x64 driver handled all.
so agree on kernel pci hal issue.
but what for         const uint64_t   mask_39bit = 0x7FFFFFFFFFULL;
then?

>>
>> can adaptec.inc pls comment? since the aha19160 card is still in production state, 
>> i assume they want to have a linux x86_64 dma capable driver. so far it is not, 
>> or can other users having this card pls confirm my pci system broken?
> 
> James
> 
> 

y
tom

