From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: fails to initialize after a  kexec operation
Date: Tue, 24 Apr 2007 09:21:35 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0188AF97@otce2k301.adaptec.com>
References: <20070424084444.GC22742@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:40443 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161759AbXDXNVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2007 09:21:38 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070424084444.GC22742@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Kexec Mailing List <kexec@lists.infradead.org>, Judith Lebzelter <judith@linux-foundation.org>, linux-scsi@vger.kernel.org

The system BIOS sets up the card's PCI configuration and there is code
in the kernel that is capable of picking up some of the BIOS'
information from the BIOS Data Space (not sure if it is actively
collected in your configuration, you need a kernel flag to pick this
up). On kexec this BIOS Data Space information is missing (?) and if
there was any reconfiguration of the PCI space going on (I think only
the Linux BIOS project does this), kexec will inherit it. This issue
strikes me as a corrupted PCI configuration inherited in the kexec case,
such corrupted PCI configurations could be a motherboard specific issue
and can be related to the BIOS' initial setup for the initial kernel. At
least that is my thought process in questioning the motherboard BIOS or
hardware.

Another possibility is that after you have patched over the interrupt
routing issues (a PCI configuration problem), the card has a foreign
array, and the reset and reconfiguration is taking arrays offline. Add
'aacraid.commit=1' to force the foreign arrays to be accepted by the
card.

Could you please check if this issue is specific to your motherboard
model. Could you please check if there is an updated motherboard BIOS
available for it. Could you please check if this issue is specific to
the GB product release cycle? Given the information you have collected,
I would still try the safe flags since there is an interrupt routing
issue.

Another possibility is the reset did not hit your card, the card is not
working correctly or the reset is not working correctly. This feature
was added to the Firmware at the end of 2004, so B11835 certainly would
have it, but that Firmware appears to be an interim test release of the
GB product, and the latest Firmware release to IBM should be B11847 (I
could be mistaken).

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Vivek Goyal
> Sent: Tuesday, April 24, 2007 4:45 AM
> To: Salyzyn, Mark
> Cc: James Bottomley; Kexec Mailing List; Judith Lebzelter; 
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] aacraid: fails to initialize after a 
> kexec operation
> 
> 
> On Mon, Apr 23, 2007 at 01:20:32PM -0400, Salyzyn, Mark wrote:
> > That is a failure to route the interrupts and is possibly 
> an issue with
> > the kernel and the hardware, and not the driver directly 
> (since there is
> > an expectation that request_irq will connect the interrupt to the
> > interrupt service routine). Judith reported success in the past with
> > this patch on her hardware, perhaps the motherboard on your 
> system has
> > some odd BIOS setup of the hardware that is giving acpi or 
> the apic some
> > headaches? Can you check out success or failure on other 
> motherboards?
> > Please try the suggestions from the driver (safe flags)?
> > 
> > Sincerely -- Mark Salyzyn
> > 
> 
> Hi Mark,
> 
> We don't even go through BIOS in kexec and kdump. So BIOS 
> should not be an
> issue.
> 
> Looks like you sent some message to controller and then waiting for an
> interrupt from the controller as an indication of completion 
> of command. In
> this case you never seem to get an interrupt hence timeout.
> 
> To bypass this problem, I am now booting my second kernel 
> with "irqpoll"
> command line option. This will make sure that aacraid 
> interrupt handler
> gets invoked even if there is an interrupt routing issue.
> 
> This option does help in progressing the things but it ends 
> up corrupting
> something or other on the disk. In three attempts I get three types of
> errors.
> 
> In first attempt I get continuous stream of following messages once
> root file system has been mounted.
> 
> =============================================
> sda1: rw=0, want=9261304112, limit=41945652
> attempt to access beyond end of device
> sda1: rw=0, want=9261304112, limit=41945652
> attempt to access beyond end of device
> sda1: rw=0, want=9261304112, limit=41945652
> attempt to access beyond end of device
> sda1: rw=0, want=9261304112, limit=41945652
> attempt to access beyond end of device
> sda1: rw=0, want=9261304112, limit=41945652
> attempt to access beyond end of device
> ============================================
> 
> In second attempt, it mounted the file system but it found some issue
> with "resize" inode and asked me to run fsck manually. Which in turn 
> deleted whole lot of inodes.
> 
> In third attemt it panics later when it finds ext3 to be corrupted.
> 
> =========================================
> Creating block device nodes.
> Trying to resume from LABEL=SWAP-sda3
> No suspend signature on swap, not resuming.
> Creating root device.
> Mounting root filesystem.
> EXT3-fs: Magic mismatch, very weird !
> mount: error mouKernel panic - not syncing: Attempted to kill init!
> nting /dev/root
> =================================================== 
> 
> Following are relevant aacraid initiliazation messages on 
> serial console.
> 
> ===================================================================
> Adaptec aacraid driver (1.1-5[2437]-mh4)
> ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level, low) -> IRQ 25
> AAC0: kernel 5.2-0[11835] Jan  9 2007
> AAC0: monitor 5.2-0[11835]
> AAC0: bios 5.2-0[11835]
> AAC0: serial 1625d1
> AAC0: 64bit support enabled.
> AAC0: 64 Bit DAC enabled
> scsi0 : ServeRAID
> scsi 0:0:0:0: Direct-Access     IBM      x366             
> V1.0 PQ: 0 ANSI: 2
> scsi 0:1:0:0: Direct-Access     IBM-ESXS ST973401SS       
> B519 PQ: 0 ANSI: 5
> scsi 0:1:1:0: Direct-Access     IBM-ESXS ST973401SS       
> B519 PQ: 0 ANSI: 5
> scsi 0:1:2:0: Direct-Access     IBM-ESXS ST973401SS       
> B519 PQ: 0 ANSI: 5
> scsi 0:3:0:0: Enclosure         IBM      SAS SES-2 DEVICE 
> 0.09 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 429459456 512-byte hardware sectors (219883 MB)
> sd 0:0:0:0: [sda] Assuming Write Enabled
> sd 0:0:0:0: [sda] Assuming drive cache: write through
> sd 0:0:0:0: [sda] 429459456 512-byte hardware sectors (219883 MB)
> sd 0:0:0:0: [sda] Assuming Write Enabled
> sd 0:0:0:0: [sda] Assuming drive cache: write through
>  sda: sda1 sda2 sda3 sda4 < sda5 >
> sd 0:0:0:0: [sda] Attached SCSI removable disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> scsi 0:1:0:0: Attached scsi generic sg1 type 0
> scsi 0:1:1:0: Attached scsi generic sg2 type 0
> scsi 0:1:2:0: Attached scsi generic sg3 type 0
> scsi 0:3:0:0: Attached scsi generic sg4 type 13
> ================================================
> 
> I am not sure why this reset leaves file system in corrupted state and
> is there a better way to handle this? Link syncing the 
> existing commands
> before restarting it.
> 
> Should one keep a dedicated partition on the disk and not 
> mount it in first
> kernel. Mount this partition only in second kernel to save 
> the dump. I shall
> have to test such configuration.
> 
> Thanks
> Vivek
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
