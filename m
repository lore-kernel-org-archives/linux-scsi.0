From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 17 Jul 2005 12:57:12 -0400
Message-ID: <20050717165712.GA7883@phunnypharm.org>
References: <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org> <20050716014225.GA9733@ime.usp.br> <20050716155637.GA22044@phunnypharm.org> <20050716164202.GA3846@ime.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:38542 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261328AbVGQQ5T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jul 2005 12:57:19 -0400
Content-Disposition: inline
In-Reply-To: <20050716164202.GA3846@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rog?rio Brito <rbrito@ime.usp.br>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, James.Bottomley@SteelEye.com, arjan@infradead.org

That's exactly what we were expecting. The hotplug scripts don't recognize
TYEP_RBC just yet, but that will be resolved soon.

James, I'm wondering is there anyway to make the scsi device model setup
correct mappings internally? The Linux1394 device modules all have
mappings so they get autoloaded. We never have to change the hotplug
scripts, just add new mappings in the modules (and the modutils-scripts
pull the info out).

On Sat, Jul 16, 2005 at 01:42:02PM -0300, Rog?rio Brito wrote:
> Hi, Ben, Stefan and co.
> 
> On Jul 16 2005, Ben Collins wrote:
> > From your last dmesg, it appears that things are in fact working.
> > 
> > Are you sure that you just don't need to do modprobe sd_mod?
> 
> You are right. I just modprobe'd sd_mod by hand and the device was
> recognized:
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> ieee1394: Initialized config rom entry `ip1394'
> ohci1394: $Rev: 1313 $ Ben Collins <bcollins@debian.org>
> PCI: Found IRQ 5 for device 0000:00:0a.0
> ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[5]  MMIO=[db800000-db8007ff]  Max Packet=[2048]
> ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011066645555ead]
> eth1394: $Rev: 1312 $ Ben Collins <bcollins@debian.org>
> eth1394: eth2: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
> eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
> eth1: link up, 10Mbps, half-duplex, lpa 0x0000
> ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0050c501e00010e8]
> ieee1394: Node changed: 0-00:1023 -> 0-01:1023
> SCSI subsystem initialized
> sbp2: $Rev: 1311 $ Ben Collins <bcollins@debian.org>
> scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>   Vendor: ST316002  Model: 1A                Rev: 3.06
>   Type:   Unknown                            ANSI SCSI revision: 06
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> SCSI device sda: drive cache: write back
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> SCSI device sda: drive cache: write back
>  sda: [mac] sda1 sda2 sda3 sda4
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> I had to load sd_mod by hand, though. The hotplug scripts didn't load it
> this time.
> 
> 
> Hope this helps, Rog?rio.
> 
> -- 
> Rog?rio Brito : rbrito@ime.usp.br : http://www.ime.usp.br/~rbrito
> Homepage of the algorithms package : http://algorithms.berlios.de
> Homepage on freshmeat:  http://freshmeat.net/projects/algorithms/

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
