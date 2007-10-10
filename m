From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: HP M820e CDRW - nsp32 driver.
Date: Wed, 10 Oct 2007 09:56:04 -0600
Message-ID: <20071010155604.GB2730@parisc-linux.org>
References: <20071008230334.GB12327@turki.gavron.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44657 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbXJJP4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2007 11:56:06 -0400
Content-Disposition: inline
In-Reply-To: <20071008230334.GB12327@turki.gavron.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-pcmcia@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 08, 2007 at 07:03:34PM -0400, cga2000 wrote:
> Would anyone know how I could get this external CDRW to work with a linux
> 2.6.20 kernel?
> 
> The cardctl [info|status|config] commands seem to give me the expected
> output but a "cdrecord -scanbus" informs me that "no target could be
> found".
> 
> Boot messages suggests there is an IRQ conflict:

They do suggest that, but after looking into it, it seems like a small
mistake in the driver that won't actually affect operation.

> ________________________________________________________________________________
> pccard: CardBus card inserted into slot 1
> SCSI subsystem initialized
> nsp32: loading...
> es1968: clocking to 48000
> PCI: Enabling device 0000:06:00.0 (0000 -> 0003)
> ACPI: PCI Interrupt 0000:06:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
> PCI: Setting latency timer of device 0000:06:00.0 to 64
> nsp32: No EEPROM detected: 0x0
> nsp32: term power on
> scsi0 : NinjaSCSI-32Bi/UDE: irq 11, io 0x3000+0x80
> cs: IO port probe 0x100-0x3af: clean.
> cs: IO port probe 0x3e0-0x4ff: clean.
> cs: IO port probe 0x820-0x8ff: clean.
> cs: IO port probe 0xc00-0xcf7: clean.
> cs: IO port probe 0xa00-0xaff: clean.
> cs: IO port probe 0x100-0x3af: clean.
> cs: IO port probe 0x3e0-0x4ff: clean.
> cs: IO port probe 0x820-0x8ff: clean.
> cs: IO port probe 0xc00-0xcf7: clean.
> cs: IO port probe 0xa00-0xaff: clean.
> cs: memory probe 0xa0000000-0xa0ffffff: clean.
> pcmcia: registering new device pcmcia0.0
> pcmcia: request for exclusive IRQ could not be fulfilled.
> pcmcia: the driver needs updating to supported shared IRQ lines.
>   ASIC rev 1,<6>eth0: Megahertz 3CCFEM556 at io 0x300, irq 3, hw_addr 00:00:86:53:8D:F7.
>  64K FIFO split 1:1 Rx:Tx, autoselect MII interface.
> pcmcia: registering new device pcmcia0.1
> pcmcia: request for exclusive IRQ could not be fulfilled.
> pcmcia: the driver needs updating to supported shared IRQ lines.
> 0.1: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> scsi 0:0:4:0: CD-ROM            hp       CD-Writer+ M820  1.23 PQ: 0 ANSI: 2
> nsp32: irq: 11 mmio: d8806000+0x1000 slot: 0000:06:00.0 model: KME SCSI CardBus card
> nsp32: Bus Reset
> nsp32: Host Reset
> nsp32: term power on
> sr 0:0:4:0: scsi: Device offlined - not ready after error recovery

This procedure does suggest some kind of interrupt problem though.
IRQ 11 makes sense; it's shared with yenta.  I don't know why you're not
seeing the nsp32 interrupt handler run though.

> sr 0:0:4:0: rejecting I/O to offline device
> sr 0:0:4:0: rejecting I/O to offline device
> sr0: scsi3-mmc drive: 0x/0x caddy
> sr 0:0:4:0: Attached scsi CD-ROM sr0
> sr 0:0:4:0: Attached scsi generic sg0 type 5
> ________________________________________________________________________________
> 
> Here's the output of "lspci" in case it helps:
> 
> ________________________________________________________________________________
> 00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
> 00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03)
> 00:04.0 CardBus bridge: Texas Instruments PCI1225 (rev 01)
> 00:04.1 CardBus bridge: Texas Instruments PCI1225 (rev 01)
> 00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
> 00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
> 00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
> 00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
> 00:08.0 Multimedia audio controller: ESS Technology ES1978 Maestro 2E (rev 10)
> 01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility P/M AGP 2x (rev 64)
> 06:00.0 SCSI storage controller: Workbit Corporation NinjaSCSI-32 KME (rev 01)
> ________________________________________________________________________________
> 
> And this is the output of "cat /proc/interrupts"
> 
> ________________________________________________________________________________
>            CPU0
>   0:    1298388    XT-PIC-XT        timer
>   1:      14705    XT-PIC-XT        i8042
>   2:          0    XT-PIC-XT        cascade
>   3:     203621    XT-PIC-XT        pcmcia0.0
>   5:    1470504    XT-PIC-XT        uhci_hcd:usb1, ESS Maestro
>   6:          5    XT-PIC-XT        floppy
>   7:        136    XT-PIC-XT        parport0
>   9:       6986    XT-PIC-XT        acpi
>  11:         34    XT-PIC-XT        yenta, yenta, nsp32
>  12:        577    XT-PIC-XT        i8042
>  14:      17562    XT-PIC-XT        ide0
>  15:      45023    XT-PIC-XT        ide1
> NMI:          0
> ERR:          0
> ________________________________________________________________________________
> 
> I spent most of the day searching for clues as to what might be the problem but
> I didn't find anything that looked like a solution.
> 
> Is there something wrong with my kernel configuration?
> 
> Do I need to upgrade the nsp32 driver as suggested by the output of "dmesg"?
> 
> I rely entirely on this external CD burner to back up my system so any help
> or pointers would be highly appreciated.
> 
> If [OT] please direct me to a mailing list or forum where I might be able to
> find help with this.
> 
> Apologies for the verbose post.
> 
> Thanks,
> cga
> 
> 
> 
> 
> 
> 
> _______________________________________________
> Linux PCMCIA reimplementation list
> http://lists.infradead.org/mailman/listinfo/linux-pcmcia

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
