From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Wed, 1 Aug 2007 09:31:36 -0700
Message-ID: <20070801093136.e927e0d6.kristen.c.accardi@intel.com>
References: <20070705194909.337398431@intel.com>
	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	<46AE12B6.6090408@garzik.org>
	<46AED656.8070407@gmail.com>
	<1185891382.2750.8.camel@laptopd505.fenrus.org>
	<46AF4B05.4010700@gmail.com>
	<1185898532.2766.2.camel@laptopd505.fenrus.org>
	<46AF7F7E.6060300@gmail.com>
	<46B05109.4080007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2513 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbXHAQeb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Aug 2007 12:34:31 -0400
In-Reply-To: <46B05109.4080007@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk

On Wed, 01 Aug 2007 18:23:21 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Tejun Heo wrote:
> > Arjan van de Ven wrote:
> >>> They were hardware problems.  I don't think any amount of proper
> >>> implementation can fix them.  I have one DVD RAM somewhere in my pile of
> >>> hardware which locks up solidly if any link PS mode is used and had a
> >> and the AHCI ALPM code decides to use power savings on this device? if
> >> so, please give us the idents so that we can add it to the blacklist as
> >> the first entry... (or can buy it to check it in detail first)
> > 
> > Yeap, lemme check.
> > 
> > It's "TSSTcorpCD/DVDW SH-S183A" with firmware revision "SB01".  Wanna
> > check ID capability bits but 'hdparm -I /dev/sr0' is still broken and
> > it's already past 3 am here.  I'll report back tomorrow.
> 
> Oops, that was the wrong one.  Locking up one was HL-DT-STDVD-RAM
> GSA-H30N and it correctly reports that it doesn't support IPM.  Here
> are some test results.
> 
> Controller is ICH9.
> 
> 00:1f.2 SATA controller [Class 0106]: Intel Corporation Unknown device [8086:2922] (rev 02)
> 
> ====
> 
> 1. HL-DT-STDVD-RAM GSA-H30N
> 
>   ATAPI CD-ROM, with removable media
> 	  Model Number:       HL-DT-STDVD-RAM GSA-H30N
> 	  Serial Number:
> 	  Firmware Revision:  1.00
>   Standards:
> 	  Likely used CD-ROM ATAPI-1
>   Configuration:
> 	  DRQ response: 50us.
> 	  Packet size: 12 bytes
>   Capabilities:
> 	  LBA, IORDY(can be disabled)
> 	  DMA: sdma0 sdma1 sdma2 mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
> 	       Cycle time: min=120ns recommended=120ns
> 	  PIO: pio0 pio1 pio2 pio3 pio4
> 	       Cycle time: no flow control=120ns  IORDY flow control=120
> 
> This device doesn't claim to support HIPM nor DIPM.

Are you sure you are using the latest version of the patch?  This seems
like a bug, if the device doesn't support HIPM or DIPM it shouldn't attempt
to use ALPM.  There was a check for this put into the patch on about the 
second or third version - maybe I'm not doing it right.
 
(from the patch located here:
http://www.kernel.org/pub/linux/kernel/people/kristen/patches/SATA/alpm/libata-enable-pm

if (ata_id_has_hipm(dev->id) || ata_id_has_dipm(dev->id))
+		dev->flags |= ATA_DFLAG_IPM;
+
<snip>
> 
> 2. TSSTcorpCD/DVDW SH-S183A
> 
>   ATAPI CD-ROM, with removable media
> 	  Model Number:       TSSTcorpCD/DVDW SH-S183A                
> 	  Serial Number:      
> 	  Firmware Revision:  SB01    
>   Standards:
> 	  Likely used CD-ROM ATAPI-1
>   Configuration:
> 	  DRQ response: 50us.
> 	  Packet size: 12 bytes
>   Capabilities:
> 	  LBA, IORDY(can be disabled)
> 	  DMA: mdma0 mdma1 mdma2 udma0 udma1 *udma2 
> 	       Cycle time: min=120ns recommended=120ns
> 	  PIO: pio0 pio1 pio2 pio3 pio4 
> 	       Cycle time: no flow control=120ns  IORDY flow control=120ns
>   Commands/features:
> 	  Enabled Supported:
> 	     *    SATA-I signaling speed (1.5Gb/s)
> 	     *    Host-initiated interface power management
> 	     *    Phy event counters
> 		  Device-initiated interface power management
> 		  unknown 78[5]
> 	     *    Software settings preservation
> 
> This one claims to support HIPS.
> 
>   # echo min_power > link_power_management_policy
>   [ 1301.917248] ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2
>   [ 1301.938338] ata1.00: irq_stat 0x40000001
>   [ 1301.956955] ata1.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
>   [ 1301.956959]          res 51/20:03:00:00:00/00:00:00:00:00/a0 Emask 0x10 (ATA bus error)
>   [ 1304.189565] ata1: soft resetting port
>   [ 1304.207745] ata1: SATA link down (SStatus 611 SControl 300)
>   [ 1304.228076] ata1: failed to recover some devices, retrying in 5 secs
>   [ 1309.245599] ata1: hard resetting port
>   [ 1314.773227] ata1: port is slow to respond, please be patient (Status 0x80)
>   [ 1319.269677] ata1: COMRESET failed (errno=-16)
>   [ 1319.289639] ata1: hard resetting port
>   [ 1319.781285] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>   [ 1320.115569] ata1.00: configured for UDMA/33
>   [ 1320.134780] ata1: EH complete
> 
> And hotplug works fine after EH is done with itself.  Dunno why.

It works because after EH you've reset the port, and when you reset the
port you turn off ipm (note the value of SControl).  I left this the way
it was without attempting to renable link pm after a reset because I figured
if there was something bad happening and we needed to reset we should leave
ipm off.

As far as the failure you are seeing goes - this may not actually be a
hardware problem but just a case of us not understanding which bits we
need to clear out of the Interrupt status register once we enable
ALPM. The value of SErr indicates that this device has gotten PhyRdy - 
which is normal for power state changes, and the interrupt status indicates 
that a d2h FIS was received which is also normal - the TFES bit seems to be 
set - it may be that we need to modify the interrupt code to not only ignore 
PhyRdy when ALPM is enabled, but also clear out bit 0 - this is definitely 
something we can try.  But, meanwhile, please make sure you are testing 
with the latest version of the patches.

> 
> 3. PLEXTOR DVDR   PX-716A
> 
>   ATAPI CD-ROM, with removable media
> 	  Model Number:       PLEXTOR DVDR   PX-716A                  
> 	  Serial Number:      127377
> 	  Firmware Revision:  1.09    
>   Standards:
> 	  Likely used CD-ROM ATAPI-1
>   Configuration:
> 	  DRQ response: 50us.
> 	  Packet size: 12 bytes
>   Capabilities:
> 	  LBA, IORDY(can be disabled)
> 	  DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 *udma4 
> 	       Cycle time: min=120ns recommended=120ns
> 	  PIO: pio0 pio1 pio2 pio3 pio4 
> 	       Cycle time: no flow control=120ns  IORDY flow control=120ns
>   HW reset results:
> 	  CBLID- below Vih
> 	  Device num = 0
> 
>   # echo min_power > link_power_management_policy
>   [ 2102.655765] ata1.00: Unable to set Link PM policy
>   [ 2104.505926] ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2
>   [ 2104.527256] ata1.00: irq_stat 0x40000001
>   [ 2104.545868] ata1.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
>   [ 2104.545870]          res 51/24:03:00:00:20/00:00:00:00:00/a0 Emask 0x10 (ATA bus error)
>   [ 2106.810252] ata1: soft resetting port
>   [ 2106.828106] ata1: SATA link down (SStatus 611 SControl 300)
>   [ 2106.847957] ata1: failed to recover some devices, retrying in 5 secs
>   [ 2111.870285] ata1: hard resetting port
>   [ 2117.401917] ata1: port is slow to respond, please be patient (Status 0x80)
>   [ 2121.902365] ata1: COMRESET failed (errno=-16)
>   [ 2121.920313] ata1: hard resetting port
>   [ 2122.413973] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>   [ 2122.795507] ata1.00: configured for UDMA/66
>   [ 2122.813234] ata1: EH complete

this looks like the same issue as above.


> 
> 4. Harddisks
> 
> All the harddisks I have behave themselves.  Impressive.
> 
> ====
> 
> In all cases, hotplug works well even after ALPM is configured.  Have
> no idea why.  It might be that PARTIAL/SLUMBER mode didn't kick in or
> ICH9 has some magic feature to detect PHY status changes even in PS
> mode (wishful thinking).

Make sure you are using the latest version of the patches - and that
the devices are not resetting themselves for some reason.  I don't see
how hotplug can work if we are indeed ignoring PhyRdy.

> With some massging to ahci_disable_alpm(), I think it can be fairly
> safe on this chipset at least.

Not sure what part of disable_alpm you think is broken here - I see
the issue to be more likely in the interrupt handler.  I'll 
regenerate the patches today against the latest kernel and you
should rerun your tests just to make sure we aren't trying to fix
something that's already been fixed.

Thanks,
Kristen
