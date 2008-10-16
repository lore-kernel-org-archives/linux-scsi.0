From: "Mark Nelson" <mdnelson8@gmail.com>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Thu, 16 Oct 2008 22:18:54 +1100
Message-ID: <65a6ef750810160418x19724a65r6c7c4688de782db8@mail.gmail.com>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
	 <48BD2136.1020101@garzik.org>
	 <65a6ef750809020455q7b7ee6a8jc404b4970f660c50@mail.gmail.com>
	 <18621.11426.870514.781750@harpo.it.uu.se>
	 <65a6ef750809020521wfaca733r8253795860b95f4@mail.gmail.com>
	 <48BFBA5E.5050300@garzik.org>
	 <65a6ef750809040459h3ffe3183nf0b5a35d15ab86e4@mail.gmail.com>
	 <48BFE5FA.9090006@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48BFE5FA.9090006@garzik.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, alan@lxorguk.ukuu.org.uk
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 5, 2008 at 12:43 AM, Jeff Garzik <jeff@garzik.org> wrote:
> Mark Nelson wrote:
>>
>> On Thu, Sep 4, 2008 at 8:37 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>>
>>> Mark Nelson wrote:
>>>>
>>>> On Tue, Sep 2, 2008 at 10:08 PM, Mikael Pettersson <mikpe@it.uu.se>
>>>> wrote:
>>>>>
>>>>> Mark Nelson writes:
>>>>>  > On Tue, Sep 2, 2008 at 9:19 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>>>>  > > Mark Nelson wrote:
>>>>>  > >>
>>>>>  > >> Add an appropriate entry for the Promise PDC42819 controller. It
>>>>> has an
>>>>>  > >> AHCI mode and seems to work correctly with board_ahci.
>>>>>  > >>
>>>>>  > >> This chip is found on Promise's FastTrak TX2650 (2 port) and
>>>>> TX4650
>>>>> (4
>>>>>  > >> port)
>>>>>  > >> software-based RAID cards (for which there is a binary driver,
>>>>> t3sas) and
>>>>>  > >> can be found on some motherboards, for example the MSI K9A2
>>>>> Platinum,
>>>>>  > >> which calls the chip a Promise T3 controller.
>>>>>  > >>
>>>>>  > >> Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
>>>>>  > >> ---
>>>>>  > >> Apparently this chip also supports SAS disks, will these work
>>>>> with
>>>>> the
>>>>>  > >> ahci driver (I've only tested with normal desktop SATA disks)?
>>>>>  > >
>>>>>  > > ahci is definitely SATA-only, so I wonder how they modified AHCI
>>>>> to
>>>>> support
>>>>>  > > SAS transport...
>>>>>  >
>>>>>  > That is a good question. From my understanding the controller is a
>>>>> SAS
>>>>>  > controller that can drive SATA disks (as I guess all SAS controllers
>>>>> can
>>>>>  > do...). Could it be that the controller can be setup to act as an
>>>>> AHCI
>>>>>  > SATA controller or if the right registers are poked a SAS
>>>>> controller?
>>>>>
>>>>> Based on how the sata_promise-supported chips work I'd guess that they
>>>>> have dual programming interfaces with AHCI for JBOD SATA and a native
>>>>> one (perhaps just additional control registers) for SAS and raid.
>>>>>
>>>> That's interesting; and makes sense. I'm guessing that we won't end up
>>>> with an open source driver that can do SAS on these chips then... But
>>>> for now at least we can use them as SATA controllers and if Promise
>>>> wants to come to the table with specs or datasheets they can in the
>>>> future. I'm just happy to be able to use my eSATA ports (and perhaps
>>>> the possibility of getting my hard disk off the SB600, although I should
>>>> benchmark both controllers before jumping to any conclusions).
>>>
>>> FWIW, I'll poke my Promise contacts, but they have gone mostly silent in
>>> the
>>> past year, so don't get your hopes up...
>>
>> Thanks Jeff!
>>
>> No need for hope - we have ahci now :)
>
> Well, I still think this PCI ID addition leaves open the possibility that
> plugging in a SAS disk could hang the system or similar misbehavior.

I finally managed to get my hands on a SAS disk to try with the T3
controller (it's an IBM-branded SAS disk borrowed from a bimini).
With the patch that adds the PCI ID to the ahci driver nothing bad
happens to the system when the SAS disk is connected - it just
times out:

ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
ahci 0000:02:00.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl RAID mode
ahci 0000:02:00.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
PCI: Setting latency timer of device 0000:02:00.0 to 64
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
ata5: SATA max UDMA/133 abar m8192@0xfbefc000 port 0xfbefc100 irq 17
ata6: SATA max UDMA/133 abar m8192@0xfbefc000 port 0xfbefc180 irq 17
ata7: SATA max UDMA/133 abar m8192@0xfbefc000 port 0xfbefc200 irq 17
ata8: SATA max UDMA/133 abar m8192@0xfbefc000 port 0xfbefc280 irq 17
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: link online but device misclassified, retrying
ata5: reset failed (errno=-11), retrying in 10 secs
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: link online but device misclassified, retrying
ata5: reset failed (errno=-11), retrying in 10 secs
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: link online but device misclassified, retrying
ata5: reset failed (errno=-11), retrying in 35 secs
ata5: limiting SATA link speed to 1.5 Gbps
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata5: link online but device misclassified, device detection might fail
ata6: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)

And even with the SAS disk connected but out of action the T3
can still use my eSATA disk perfectly:

ata7: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata7: irq_stat 0x00000040, connection status changed
ata7: SError: { CommWake DevExch }
ata7: hard resetting link
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata7.00: ATA-7: HTS721060G9SA00, MC3IC10H, max UDMA/100
ata7.00: 117210240 sectors, multi 0: LBA48
ata7.00: configured for UDMA/100
ata7: EH complete
scsi 6:0:0:0: Direct-Access     ATA      HTS721060G9SA00  MC3I PQ: 0 ANSI: 5
sd 6:0:0:0: [sdb] 117210240 512-byte hardware sectors (60012 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 6:0:0:0: [sdb] 117210240 512-byte hardware sectors (60012 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1
sd 6:0:0:0: [sdb] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg3 type 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.


So, how about my patch then? :)

Mark.
