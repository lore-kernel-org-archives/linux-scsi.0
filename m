From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: aic7xxx: aic7892(B): BUG: soft lockup detected on CPU#0!
Date: Thu, 29 Mar 2007 22:13:32 +0200
Message-ID: <460C1DEC.4020109@gmx.de>
References: <46029D72.3060403@gmx.de> <4602B576.6020602@gmx.de>	 <4602EED5.5070503@gmx.de> <46030A9A.2060604@gmx.de>	 <46032CC8.6030307@gmx.de>	 <1174625139.30030.31.camel@mulgrave.il.steeleye.com>	 <4603827C.4080701@gmx.de>  <46040047.3000104@gmx.de>	 <1174670587.30030.47.camel@mulgrave.il.steeleye.com>	 <46041B11.6000004@gmx.de> <46042383.7010704@gmx.de>	 <460475F5.1080805@gmx.de> <1174699032.13717.25.camel@mulgrave.il.steeleye.com> <46049EA2.1040207@gmx.de> <4604A397.6000402@gmx.de> <4608BF16.3000100@gmx.de>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41206 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030658AbXC2UNf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Mar 2007 16:13:35 -0400
In-Reply-To: <4608BF16.3000100@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: 415864@bugs.debian.org

thomas schorpp wrote:
> thomas schorpp wrote:
>> thomas schorpp wrote:
>>> James Bottomley wrote:
>>>> On Sat, 2007-03-24 at 01:51 +0100, thomas schorpp wrote:
>>>>>> no. so the pci layer reports wrong start:
>>>>> nonsense. it succeeds, confused function return with the error flag:
>>>>>
>>>>> //      u_long  start;
>>>>> //      u_long  start = 0xFFEFF000;
>>>>>         u_long  start = 0x30000000;
>>>>>         int     error;
>>>>>
>>>>>         struct resource* ret1;
>>>>>         error = 0;
>>>>> //      start = pci_resource_start(ahc->dev_softc, 1);
>>>>>         if (start != 0) {
>>>>>                 *bus_addr = start;
>>>>>                 if ((ret1 = request_mem_region(start, 0x1000, 
>>>>> "aic7xxx")) == 0)
>>>>
>>>> You can't do this.  The pci_resource_start is getting the address of
>>>> something called a Bus Address Register (BAR) it says in physical
>>>> address space where the card is responding ... you can't simply set 
>>>> that
>>>> to a random value.
>>>>
>>>> The problem you seem to have is that your system is reporting a BAR
>>>> beyond 32 bits (4GB) which the card physically can't use.  This 
>>>> could be
>>>> because of a BIOS misconfiguration or because there's a bug in the PCI
>>>> subsystem somewhere.
>>>>
>>>> James
>>>
>>> understood. waiting for LKML answers... meanwhile i found harder 
>>> reason for a possible bounds problem with the driver code on x86_64:
>>>
>>> if i do:
>>>
>>> static int
>>> ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
>>>                                 u_long *bus_addr,
>>>                                 uint8_t __iomem **maddr)
>>> {
>>> //      u_long  start;
>>>        uint32_t start;
>>>
>>> i get no free warning of "*nonexistant* resource" (it cant be 
>>> nonexistant, cause it was definitely something mapped):
>>>
>>> tom1:/usr/src/linux# dmesg |grep -i free
>>> Freeing unused kernel memory: 208k freed
>>>
>>> with u_long type start i get it:
>>> Mar 24 03:41:47 localhost kernel: Trying to free nonexistent resource 
>>> <00000000fffff000-00000000ffffffff>
>>>
>>> investigating further...
>>> -
>>
>> hmm well i dont get the free warning cause
>>                        
>> release_mem_region(ahc->platform_data->mem_busaddr,
>>                                           0x1000);
>> isnt called, the hack fails
>>        error = ahc_linux_pci_reserve_mem_region(ahc, &base, &maddr);
>>        if (error == 0) {
>>
>> ok, so no bounds issue in the driver.
>>
> 
> LKML people are ignoring my report, i take this as agreement to a mb 
> bios issue.
> will test the card with a latest debian kernel x86_64 netinstall cd on 
> some other amd64 machine, but i need to find some in my reach here.
> i need more confirmation before working in the linux pci hal.
> 

no other amd64 machines in reach.

here's my "fix". seems to be a h/w bug of the adaptec 19160 hba card, 
it is just faking 64bit BAR from the register read, doesn't care on i386 arch 
due to incomplete error handling ;) , but on x86_64 arch. since here and on 
LKML is no public interest in a real fix, I do no further investigation. 

Users, *DON'T try this at home, it may break real 64bit BAR cards* (if there're any for PCI32)! 

drivers/pci/probe.c
static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
{
[...]

                if ((l & (PCI_BASE_ADDRESS_SPACE | PCI_BASE_ADDRESS_MEM_TYPE_MASK))
                    == (PCI_BASE_ADDRESS_SPACE_MEMORY | PCI_BASE_ADDRESS_MEM_TYPE_64)) {
                        u32 szhi, lhi;
                        pci_read_config_dword(dev, reg+4, &lhi);
lhi = 0; //schorpp
                        pci_write_config_dword(dev, reg+4, ~0);
                        pci_read_config_dword(dev, reg+4, &szhi);
                        pci_write_config_dword(dev, reg+4, lhi); 		//kill the wrong read 0x0F
                        szhi = pci_size(lhi, szhi, 0xffffffff);
                        next++;
printk(KERN_ERR "PCI: 64-bit check REG for device %s l %lx%lx sz %lx%lx start %llx end %llx flags $
        pci_name(dev), lhi, l, szhi, sz, res->start, res->end, res->flags);

#if BITS_PER_LONG == 64 	//the cause, more checks for buggy h/w needed or platform dep. bug somewhere deeper
                        res->start |= ((unsigned long) lhi) << 32;
                        res->end = res->start + sz;
printk(KERN_ERR "PCI: 64-bit BAR check 1 for device %s l %lx%lx sz %lx%lx start %llx end %llx flag$
        pci_name(dev), lhi, l, szhi, sz, res->start, res->end, res->flags);
[...]

hba fine again:

tom1:/usr/src/linux# lspci -vvv -s 00:06.0
00:06.0 SCSI storage controller: Adaptec AIC-7892B U160/m (rev 02)
        Subsystem: Adaptec 19160 Ultra160 SCSI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (10000ns min, 6250ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        BIST result: 00
        Region 0: I/O ports at d800 [disabled] [size=256]
        Region 1: Memory at 30000000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at fbee0000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

tom1:/usr/src/linux# uname -a
Linux tom1 2.6.20.4 #30 PREEMPT Thu Mar 29 21:07:10 CEST 2007 x86_64 GNU/Linux

@debian-maintainers: Your decision if close 415864 or not. but if no one else complains why not.

y
tom


