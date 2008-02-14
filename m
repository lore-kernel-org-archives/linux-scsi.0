From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: "mount: could not find filesystem" - aacraid? (was: Re: 2.6.26-git0: IDE oops during boot)
Date: Thu, 14 Feb 2008 13:07:41 +0100
Message-ID: <200802141307.42169.bzolnier@gmail.com>
References: <20080206105334.GA3664@elf.ucw.cz> <47B40DF2.10009@linux.vnet.ibm.com> <200802141301.35032.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200802141301.35032.bzolnier@gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, ananth@in.ibm.com, Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org, aacraid@adaptec.com
List-Id: linux-scsi@vger.kernel.org

On Thursday 14 February 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Thursday 14 February 2008, Kamalesh Babulal wrote:
> > Bartlomiej Zolnierkiewicz wrote:
> > > Hi,
> > > 
> > > On Tuesday 12 February 2008, Kamalesh Babulal wrote:
> > >> Bartlomiej Zolnierkiewicz wrote:
> > >>> Hi,
> > >>>
> > >>> On Monday 11 February 2008, Kamalesh Babulal wrote:
> > >>>> Nish Aravamudan wrote:
> > >>>>> On 2/7/08, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > >>>>>> On Thursday 07 February 2008, Kamalesh Babulal wrote:
> > >>>>>>> Bartlomiej Zolnierkiewicz wrote:
> > >>>>>>>> Hi,
> > >>>>>>>>
> > >>>>>>>> On Wednesday 06 February 2008, Pavel Machek wrote:
> > >>>>>>>>> On Wed 2008-02-06 11:53:34, Pavel Machek wrote:
> > >>>>>>>>>> Hi!
> > >>>>>>>>>>
> > >>>>>>>>>> Trying to boot 2.6.25-git0 (few days old), I get
> > >>>>>>>>>>
> > >>>>>>>>>> BUG: unable to handle kernel paging request at ffff..ffb0
> > >>>>>>>>>> IP at init_irq+0x42e
> > >>>>>>>> init_irq? hmm...
> > >>>>>>>>
> > >>>>>>>>>> Call trace:
> > >>>>>>>>>> ide_device_add_all
> > >>>>>>>> this comes from ide-generic
> > >>>>>>>> (Generic IDE host driver)
> > >>>>>>>>
> > >>>>>>>>>> ide_generic_init
> > >>>>>>>>>> kernel_init
> > >>>>>>>>>> child_rip
> > >>>>>>>>>> vgacon_cursor
> > >>>>>>>>>> kernel_init
> > >>>>>>>>>> child_rip
> > >>>>>>>>>>
> > >>>>>>>>>> Excerpt from config:
> > >>>>>>>>>>
> > >>>>>>>>>> CONFIG_IDE=y
> > >>>>>>>>>> CONFIG_BLK_DEV_IDE=y
> > >>>>>>>>> Disabling CONFIG_IDE made my machine boot, as it was using libata
> > >>>>>>>>> anyway.
> > >>>>>>>> Kamalesh/Pavel:
> > >>>>>>>>
> > >>>>>>>> Could you try latest git and see if the OOPS is still there?
> > >>>>>>>>
> > >>>>>>>> [ Yeah, I'm unable to reproduce it. :( ]
> > >>>>>>>>
> > >>>>>>>> Thanks,
> > >>>>>>>> Bart
> > >>>>>>> Hi Bart,
> > >>>>>>>
> > >>>>>>> The panic is reproducible with the 2.6.24-git16 kernel, the call trace is
> > >>>>>>> similar to the previous one
> > >>>>>> Thanks, I again reviewed ide-probe.c changes but nothing seems wrong...
> > >>>>>>
> > >>>>>> Could you please bisect it down to the guilty commit?
> > >>>>> Kamalesh, were you able to bisect this down? I just got hit by the
> > >>>>> same panic on a 4-way x86_64, with 2.6.24-git22.
> > >>>>>
> > >>>>> Thanks,
> > >>>>> Nish
> > >>>> Hi Nish,
> > >>>>
> > >>>> I tried bisecting and the guilty patch seems to be 
> > >>>>
> > >>>> 36501650ec45b1db308c3b51886044863be2d762 is first bad commit
> > >>>> commit 36501650ec45b1db308c3b51886044863be2d762
> > >>>> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > >>>> Date:   Fri Feb 1 23:09:31 2008 +0100
> > >>>>
> > >>>>     ide: keep pointer to struct device instead of struct pci_dev in ide_hwif_t
> > >>>>
> > >>>>
> > >>>> the gdb output, also points to the changes made by the guilty patch
> > >>>>
> > >>>> (gdb) p ide_device_add_all
> > >>>> $1 = {int (u8 *, const struct ide_port_info *)} 0xffffffff804176ac <ide_device_add_all>
> > >>>> (gdb) p/x 0xffffffff804176ac+0xb60
> > >>>> $2 = 0xffffffff8041820c
> > >>>> (gdb) l *0xffffffff8041820c
> > >>>> 0xffffffff8041820c is in ide_device_add_all (drivers/ide/ide-probe.c:1249).
> > >>>> 1244                    goto out;
> > >>>> 1245            }
> > >>>> 1246
> > >>>> 1247            sg_init_table(hwif->sg_table, hwif->sg_max_nents);
> > >>>> 1248
> > >>>> 1249            if (init_irq(hwif) == 0)
> > >>>> 1250                    goto done;
> > >>>> 1251
> > >>>> 1252            old_irq = hwif->irq;
> > >>>> 1253            /*
> > >>>> (gdb) 
> > >>>>
> > >>>>
> > >>>> (gdb) p init_irq
> > >>>> $1 = {int (ide_hwif_t *)} 0xffffffff8041721f <init_irq>
> > >>>> (gdb) p/x 0xffffffff8041721f+0x1a4
> > >>>> $2 = 0xffffffff804173c3
> > >>>> (gdb) l *0xffffffff804173c3
> > >>>> 0xffffffff804173c3 is in init_irq (include/asm/pci.h:101).
> > >>>> 96      /* Returns the node based on pci bus */
> > >>>> 97      static inline int __pcibus_to_node(struct pci_bus *bus)
> > >>>> 98      {
> > >>>> 99              struct pci_sysdata *sd = bus->sysdata;
> > >>>> 100
> > >>>> 101             return sd->node;
> > >>>> 102     }
> > >>>> 103
> > >>>> 104     static inline cpumask_t __pcibus_to_cpumask(struct pci_bus *bus)
> > >>>> 105     {
> > >>>> (gdb) 
> > >>> Thanks for the detailed analysis and sorry for the bug.
> > >>>
> > >>> I think that this may has been just fixed by Andi's recent hwif_to_node()
> > >>> fix (patch below, it is in Linus' tree already), could please verify this?
> > >>>
> > >>> commit 1f07e988290fc45932f5028c9e2a862c37a57336
> > >>> Author: Andi Kleen <andi@firstfloor.org>
> > >>> Date:   Mon Feb 11 01:35:20 2008 +0100
> > >>>
> > >>>     Prevent IDE boot ops on NUMA system
> > >>>     
> > >>>     Without this patch a Opteron test system here oopses at boot with
> > >>>     current git.
> > >>>     
> > >>>     Calling to_pci_dev() on a NULL pointer gives a negative value so the
> > >>>     following NULL pointer check never triggers and then an illegal address
> > >>>     is referenced.  Check the unadjusted original device pointer for NULL
> > >>>     instead.
> > >>>     
> > >>>     Signed-off-by: Andi Kleen <ak@suse.de>
> > >>>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > >>>
> > >>> diff --git a/include/linux/ide.h b/include/linux/ide.h
> > >>> index 23fad89..a3b69c1 100644
> > >>> --- a/include/linux/ide.h
> > >>> +++ b/include/linux/ide.h
> > >>> @@ -1295,7 +1295,7 @@ static inline void ide_dump_identify(u8 *id)
> > >>>  static inline int hwif_to_node(ide_hwif_t *hwif)
> > >>>  {
> > >>>  	struct pci_dev *dev = to_pci_dev(hwif->dev);
> > >>> -	return dev ? pcibus_to_node(dev->bus) : -1;
> > >>> +	return hwif->dev ? pcibus_to_node(dev->bus) : -1;
> > >>>  }
> > >>>
> > >>>  static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
> > >> Hi Bart,
> > >> Thanks !! the patch solves the kernel panic but when after applying the patch,kernel is not
> > >> able to mount the filesystem and panics, am i not sure what is likely causing the panic.
> > > 
> > > Is
> > > 
> > > - the commit 36501650ec45b1db308c3b51886044863be2d762 with Andi's fix applied
> > > 
> > > or
> > > 
> > > - the commit f6fb786d6dcdd7d730e4fba620b071796f487e1b
> > >   (the one before commit 36501650ec45b1db308c3b51886044863be2d762)
> > > 
> > > working for you?
> > 
> > No, the commit before the commit 36501650ec45b1db308c3b51886044863be2d762 did not either work, i
> > get the same kernel panic.
> > 
> > > 
> > >> Creating root device.
> > >> Mounting root filesystem.
> > >> mount: could not  find filesystem
> > >> Kernel panic - not syncing: Attempted to kill init!
> > > 
> > > Is IDE actually used for the boot device?
> > > 
> > > [ Please send a dmesg output from the working system. ]
> 
> Hmm, it is not (from dmesg):
> 
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> Probing IDE interface ide0...
> hda: HL-DT-STCD-RW/DVD DRIVE GCC-4244N, ATAPI CD/DVD-ROM drive
> Probing IDE interface ide1...
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> hda: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
> Uniform CD-ROM driver Revision: 3.20
> 
> [...]
> 
> Adaptec aacraid driver 1.1-5[2449]-ms
> ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level, low) -> IRQ 25
> AAC0: kernel 5.2-0[11835] Jan  9 2007
> AAC0: monitor 5.2-0[11835]
> AAC0: bios 5.2-0[11835]
> AAC0: serial 1625D1
> AAC0: 64bit support enabled.
> AAC0: 64 Bit DAC enabled
> scsi0 : ServeRAID
> scsi 0:0:0:0: Direct-Access     IBM      x366             V1.0 PQ: 0 ANSI: 2
> scsi 0:1:0:0: Direct-Access     IBM-ESXS ST973401SS       B519 PQ: 0 ANSI: 5
> scsi 0:1:1:0: Direct-Access     IBM-ESXS ST973401SS       B519 PQ: 0 ANSI: 5
> scsi 0:1:2:0: Direct-Access     IBM-ESXS ST973401SS       B519 PQ: 0 ANSI: 5
> scsi 0:3:0:0: Enclosure         IBM      SAS SES-2 DEVICE 0.09 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 429459456 512-byte hardware sectors (219883 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> sd 0:0:0:0: [sda] 429459456 512-byte hardware sectors (219883 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
>  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> sd 0:0:0:0: [sda] Attached SCSI removable disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> scsi 0:1:0:0: Attached scsi generic sg1 type 0
> scsi 0:1:1:0: Attached scsi generic sg2 type 0
> scsi 0:1:2:0: Attached scsi generic sg3 type 0
> scsi 0:3:0:0: Attached scsi generic sg4 type 13
> 
> [...]
> 
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> 
> [...]
> 
> EXT3 FS on sda1, internal journal
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sda2, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> 
> I worry that another git-bisect session will be needed unless SCSI
> developers are already aware of the problem source.

Yinghai Lu noticed that it may be actually a SES problem:

http://lkml.org/lkml/2008/2/14/88

[ I overlooked the above mail, sorry ]
