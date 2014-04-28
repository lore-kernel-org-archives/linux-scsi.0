From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: 3.2.57 regression: isci driver broken: Unable to reset I T nexus?
Date: Mon, 28 Apr 2014 19:22:18 +0200
Message-ID: <201404281922.19399.linux@rainbow-software.org>
References: <201404281303.24977.linux@rainbow-software.org> <57283945f737477b90e5ae31b9403799@fmsmsx156.amr.corp.intel.com> <1398703903.97992.10.camel@djiang5-desk1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:39692 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaD1TJr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2014 15:09:47 -0400
In-Reply-To: <1398703903.97992.10.camel@djiang5-desk1.amr.corp.intel.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel@=?utf-8?q?vger=2Ekernel=2Eorg=11?=

On Monday 28 April 2014 18:51:44 Jiang, Dave wrote:
> On Mon, 2014-04-28 at 16:28 +0000, Ondrej Zary wrote:
> > On Monday 28 April 2014 17:50:29 Jiang, Dave wrote:
> > > On Mon, 2014-04-28 at 13:03 +0200, Ondrej Zary wrote:
> > > > Hello,
> > > > just upgraded a server running 3.2.54-2 to 3.2.57-3 (Debian Wheezy)
> > > > and it does not boot anymore because of isci driver breakage.
> > >
> > > I would not run anything less than 3.8 for the isci controller. 3.2 is
> > > VERY old for that particular driver and likely very unstable. The
> > > product version of that driver plus libsas started with 3.8. Also I'm
> > > concerned that you aren't using the platform OEM parameters. You need
> > > to turn your OROM or EFI driver on for the SAS controller.
> >
> > It's a Cisco UCS C22 M3 server with a crappy LSI fakeraid that cannot
> > even be disabled. It was a pain to make it boot properly - had to use
> > dmraid. But it has been working fine since then (2012). Until now.
>
> Yes but just because it has been working doesn't mean it is a good idea
> to run unstable code.... You need the driver updates and the libsas
> updates for it to function properly. Does this fail on 3.14? If it is
> that patch I have a feeling it may be interacting badly with whatever is
> was in 3.2 libsas that may not be a problem with latest kernels.... It
> is odd to see all those hard resets however.... Did you have them when
> it was working for you?

Didn't know that it was unstable - it worked with no problems, better than 
some products marked as stable :)
3.13 works fine - I've installed it from wheezy-backports to work-around the 
bug.

The log from working 3.2.54 is below (at the end) - there's one reset for each 
port.


> > I guess that it could be caused by the following commit but haven't
> > tested it: commit 584ec12265192bf49dfa270d517380f6723a6956
> > Author: Dan Williams <dan.j.williams@intel.com>
> > Date:   Thu Feb 6 12:23:01 2014 -0800
> >
> > > > A (partial) log transcription:
> > > > sas: DOING DISCOVERY on port 0, pid:5
> > > > sas: Enter sas_scsi_recover_host
> > > > ata1: sas eh calling libata port error handler
> > > > sas: sas_ata_hard_reset: Unable to reset I T nexus?
> > > > sas: sas_ata_hard_reset: Found ATA device.
> > > > sas: sas_ata_hard_reset: Unable to soft reset
> > > > sas: sas_ata_hard_reset: Found ATA device.
> > > > ata1: reset failed (errno=-11), retrying in 10 secs
> > > > sas: sas_ata_hard_reset: Unable to reset I T nexus?
> > > > sas: sas_ata_hard_reset: Found ATA device.
> > > > sas: sas_ata_hard_reset: Unable to soft reset
> > > > sas: sas_ata_hard_reset: Found ATA device.
> > > > ata1: reset failed (errno=-11), retrying in 35 secs
> > > > ata1: reset failed, giving up
> > > > sas: --- Exit sas_scsi_recover_host
> > > > sas: DONE DISCOVERY on port 0, pid: 5, result:0
> > > > sas: phy-0:1 added to port-0:1, phy_mask:0x2 (5fcfffff00000002)
> > > > sas: DOING DISCOVERY on port 1, pid:5
> > > > sas: Enter sas_scsi_recover_host
> > > > ata1: sas eh calling libata port error handler
> > > > sas: sas_ata_hard_reset: Unable to reset I T nexus?
> > > > sas: sas_ata_hard_reset: Found ATA device.
> > > > sas: sas_ata_hard_reset: Unable to soft reset
> > > > sas: sas_ata_hard_reset: Found ATA device.
> > > > ata2: reset failed (errno=-11), retrying in 10 secs
> > > > sas: sas_ata_hard_reset: Unable to reset I T nexus?
> > > > sas: sas_ata_hard_reset: Found ATA device.
> > > > sas: sas_ata_hard_reset: Unable to soft reset
> > > > sas: sas_ata_hard_reset: Found ATA device.
> > > > ata2: reset failed (errno=-11), retrying in 35 secs
> > > > ata2: reset failed, giving up
> > > >
> > > >
> > > > It should look like this (v3.2.54-2):
> > > > isci: Intel(R) C600 SAS Controller Driver - version 1.0.0
> > > > isci 0000:03:00.0: driver configured for rev: 6 silicon
> > > > isci 0000:03:00.0: firmware: agent loaded isci/isci_firmware.bin into
> > > > memory isci 0000:03:00.0: OEM SAS parameters (version: 1.3) loaded
> > > > (firmware) isci 0000:03:00.0: setting latency timer to 64
> > > > scsi0 : isci
> > > > scsi1 : isci
> > > > isci 0000:03:00.0: irq 81 for MSI/MSI-X
> > > > isci 0000:03:00.0: irq 82 for MSI/MSI-X
> > > > isci 0000:03:00.0: irq 83 for MSI/MSI-X
> > > > isci 0000:03:00.0: irq 84 for MSI/MSI-X
> > > > sas: phy-0:0 added to port-0:0, phy_mask:0x1 (5fcfffff00000001)
> > > > sas: DOING DISCOVERY on port 0, pid:5
> > > > sas: Enter sas_scsi_recover_host
> > > > ata1: sas eh calling libata port error handler
> > > > sas: sas_ata_hard_reset: Found ATA device.
> > > > ata1.00: ATA-8: ST9500620NS, CC02, max UDMA/133
> > > > ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> > > > ata1.00: configured for UDMA/133
> > > > sas: --- Exit sas_scsi_recover_host
> > > > scsi 0:0:0:0: Direct-Access     ATA      ST9500620NS      CC02 PQ: 0
> > > > ANSI: 5 sas: DONE DISCOVERY on port 0, pid:5, result:0
> > > > sas: phy-0:1 added to port-0:1, phy_mask:0x2 (5fcfffff00000002)
> > > > sas: DOING DISCOVERY on port 1, pid:5
> > > > sas: Enter sas_scsi_recover_host
> > > > ata1: sas eh calling libata port error handler
> > > > ata2: sas eh calling libata port error handler
> > > > sas: sas_ata_hard_reset: Found ATA device.
> > > > ata2.00: ATA-8: ST9500620NS, CC02, max UDMA/133
> > > > ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> > > > ata2.00: configured for UDMA/133
> > > > sas: --- Exit sas_scsi_recover_host
> > > > scsi 0:0:1:0: Direct-Access     ATA      ST9500620NS      CC02 PQ: 0
> > > > ANSI: 5 sas: DONE DISCOVERY on port 1, pid:5, result:0


-- 
Ondrej Zary
