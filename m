From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist
Date: Mon, 6 Jun 2016 17:05:13 +0200
Message-ID: <4c7c1ec8-06bf-e2f5-c971-de82eb69fdb4@redhat.com>
References: <1464702149-26573-1-git-send-email-emilne@redhat.com>
 <5755278E.8040002@suse.de> <1465222299.20724.114.camel@localhost.localdomain>
 <5755873E.5080303@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbcFFPFU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2016 11:05:20 -0400
In-Reply-To: <5755873E.5080303@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, emilne@redhat.com
Cc: linux-scsi@vger.kernel.org, John Snow <jsnow@redhat.com>



On 06/06/2016 16:22, Hannes Reinecke wrote:
> So either we dig into what went wrong with qemu 0.8, or we figure out
> from which qemu version things start to behave nicely, and blacklist
> earlier versions.
> 
> > > Either way, this patch is wrong.
> > 
> > If we can identify which versions work, we can update it.  Otherwise
> > I think we have to be conservative.
> 
> So far we just had this single report where the upstream kernel didn't
> work correctly with a (really old) version of qemu.
> Hardly justifying blacklisting qemu CD-ROM in general.

To further complicate the matter there are two QEMU MMC devices:

1) ATAPI
   - vendor "QEMU" / product name "QEMU CD-ROM" before QEMU 0.10.0
   - vendor "QEMU" / product name "QEMU DVD-ROM" since QEMU 0.10.0

2) native SCSI
   - vendor "QEMU" / product name "QEMU CD-ROM"

VPD in the SCSI CD-ROM probably has always worked, but I would blacklist
up to 0.11 inclusive just to be safe.  Those versions are dead anyway.

VPD in the ATAPI CD-ROM is newer, and that's where the bug was reported on:

> [    4.439488] ata2.00: ATAPI: QEMU CD-ROM, 0.8.2, max UDMA/100
> [    4.443649] ata2.00: configured for MWDMA2
> [    4.450267] scsi 1:0:0:0: CD-ROM            QEMU     QEMU CD-ROM      0.8. PQ: 0 ANSI: 5
> [    4.464317] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [    4.464319] ata2.00: BMDMA stat 0x5
> [    4.464339] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0 dma 16640 in
> [    4.464339]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
> [    4.464341] ata2.00: status: { DRDY DRQ }

For ATAPI, you have to blacklist all versions up to 2.2 inclusive.

This gives:

- QEMU / QEMU CD-ROM / 0.8.    (this is IDE and SCSI)
- QEMU / QEMU CD-ROM / 0.9.    (this is IDE and SCSI)
- QEMU / QEMU CD-ROM / 0.10    (this is SCSI only)
- QEMU / QEMU CD-ROM / 0.11    (this is SCSI only)
- QEMU / QEMU DVD-ROM / 0.8.   (this is IDE only)
- QEMU / QEMU DVD-ROM / 0.9.   (this is IDE only)
- QEMU / QEMU DVD-ROM / 0.10   (this is IDE only)
- QEMU / QEMU DVD-ROM / 0.11   (this is IDE only)
- QEMU / QEMU DVD-ROM / 0.12   (this is IDE only)
- QEMU / QEMU DVD-ROM / 0.13   (this is IDE only)
- QEMU / QEMU DVD-ROM / 0.14   (this is IDE only)
- QEMU / QEMU DVD-ROM / 0.15   (this is IDE only)
- QEMU / QEMU DVD-ROM / 1.0    (this is IDE only)
- QEMU / QEMU DVD-ROM / 1.1    (this is IDE only)
- QEMU / QEMU DVD-ROM / 1.2    (this is IDE only)
- QEMU / QEMU DVD-ROM / 1.3    (this is IDE only)
- QEMU / QEMU DVD-ROM / 1.4    (this is IDE only)
- QEMU / QEMU DVD-ROM / 1.5    (this is IDE only)
- QEMU / QEMU DVD-ROM / 1.6    (this is IDE only)
- QEMU / QEMU DVD-ROM / 1.7    (this is IDE only)
- QEMU / QEMU DVD-ROM / 2.0    (this is IDE only)
- QEMU / QEMU DVD-ROM / 2.1    (this is IDE only)
- QEMU / QEMU DVD-ROM / 2.2    (this is IDE only)

Thanks,

Paolo
