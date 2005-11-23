From: Matthew Wilcox <matthew@wil.cx>
Subject: [sym2] Re: Problem with 2.6.14 and up...
Date: Wed, 23 Nov 2005 06:43:27 -0700
Message-ID: <20051123134327.GS1598@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:14826 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750802AbVKWNna
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 08:43:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsanchez@todounix.homeip.net
Cc: linux-scsi@vger.kernel.org


Hi Jose, I was forwarded your bug report below.  It doesn't have quite
enough information in it for me to diagnose, but I have some suggestions
anyway ...

1. Can you send me your dmesg?  I want to see what devices these are and
   what transfer agreement they negotiate.
2. Can you try a later kernel?  If you have git, you can pull from
   git://git.kernel.org/pub/scm/linux/kernel/git/willy/sym2.git
   otherwise http://www.parisc-linux.org/~willy/sym2-2.2.2.diff applies
   to a 2.6.15-rc1 kernel.
3. Can you try an earlier kernel?  It'd be interesting to know if, say,
   2.6.8 worked.
4. Can you try the sym2 driver in 2.4.32?  You'll have to say Y to
   "SYM53C8XX Version 2 SCSI support".

----- Forwarded message from Andrew Morton <akpm@osdl.org> -----

> > Date: Mon, 21 Nov 2005 17:24:47 +0100
> > From: Jos? Luis S?nchez  <jsanchez@todounix.homeip.net>
> > To: linux-kernel@vger.kernel.org
> > Subject: Problem with 2.6.14 and up...
> > 
> > 
> > Hi,
> > 
> > >From 2.6.14 I have a nasty problem with my SCSI devices. First, see my HW:
> > 
> > ----------------------------------
> > 00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge 
> > (rev 03)
> > 00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge 
> > (rev 03)
> > 00:04.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
> > 00:04.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
> > 00:04.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
> > 00:04.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
> > 00:0a.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 26)
> > 00:0b.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone] (rev 
> > 64)
> > 00:0d.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 06)
> > 00:0d.1 Input device controller: Creative Labs SB Live! MIDI/Game Port (rev 
> > 06)
> > 01:00.0 VGA compatible controller: nVidia Corporation NV28 [GeForce4 Ti 4200 
> > AGP 8x] (rev a1)
> > ------------------------
> > 
> > I'm using the ncr53c8xx SCSI driver. When I run K3b, the program stalls a few 
> > minutes and this appears in the messages file:
> > 
> > sr0: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
> > Uniform CD-ROM driver Revision: 3.20
> > sr 0:0:1:0: Attached scsi CD-ROM sr0
> > sr1: scsi3-mmc drive: 24x/16x writer cd/rw xa/form2 cdda tray
> > sr 0:0:2:0: Attached scsi CD-ROM sr1
> > sd 0:0:0:0: Attached scsi generic sg0 type 0
> > sr 0:0:1:0: Attached scsi generic sg1 type 5
> > sr 0:0:2:0: Attached scsi generic sg2 type 5
> >  0:0:5:0: Attached scsi generic sg3 type 1
> > sr 0:0:2:0: phase change 2-1 12@01bbcf60 resid=6.
> > sr 0:0:2:0: ABORT operation started.
> > sr 0:0:2:0: ABORT operation timed-out.
> > sr 0:0:2:0: DEVICE RESET operation started.
> > sr 0:0:2:0: DEVICE RESET operation timed-out.
> > sr 0:0:2:0: BUS RESET operation started.
> > sym0: SCSI BUS reset detected.
> > sym0: SCSI BUS has been reset.
> > sr 0:0:2:0: BUS RESET operation complete.
> > sr 0:0:2:0: phase change 2-1 12@01bbcf60 resid=6.
> > Device not ready. Make sure there is a disc in the drive.
> > Device not ready. Make sure there is a disc in the drive.
> > sr 0:0:2:0: phase change 2-1 12@01bbcf60 resid=6.
> > sr 0:0:2:0: phase change 2-3 12@01bbcf60 resid=2.
> > sr 0:0:2:0: phase change 2-3 12@01bbcf60 resid=2.
> > sr 0:0:2:0: phase change 2-3 12@01bbcf60 resid=2.
> > ....
> > 
> > I'm very sure what the SCSI card, the cabling and the devices are OK, why 
> > don't have any problem with 2.4.32 kernel.
> > 
> > Ideas?
> > 
> > Jos? Luis
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----
