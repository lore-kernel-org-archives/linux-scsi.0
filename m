From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Wed, 01 Aug 2007 18:23:21 +0900
Message-ID: <46B05109.4080007@gmail.com>
References: <20070705194909.337398431@intel.com>	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com>	 <1185891382.2750.8.camel@laptopd505.fenrus.org>	 <46AF4B05.4010700@gmail.com> <1185898532.2766.2.camel@laptopd505.fenrus.org> <46AF7F7E.6060300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46AF7F7E.6060300@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Arjan van de Ven wrote:
>>> They were hardware problems.  I don't think any amount of proper
>>> implementation can fix them.  I have one DVD RAM somewhere in my pile of
>>> hardware which locks up solidly if any link PS mode is used and had a
>> and the AHCI ALPM code decides to use power savings on this device? if
>> so, please give us the idents so that we can add it to the blacklist as
>> the first entry... (or can buy it to check it in detail first)
> 
> Yeap, lemme check.
> 
> It's "TSSTcorpCD/DVDW SH-S183A" with firmware revision "SB01".  Wanna
> check ID capability bits but 'hdparm -I /dev/sr0' is still broken and
> it's already past 3 am here.  I'll report back tomorrow.

Oops, that was the wrong one.  Locking up one was HL-DT-STDVD-RAM
GSA-H30N and it correctly reports that it doesn't support IPM.  Here
are some test results.

Controller is ICH9.

00:1f.2 SATA controller [Class 0106]: Intel Corporation Unknown device [8086:2922] (rev 02)

====

1. HL-DT-STDVD-RAM GSA-H30N

  ATAPI CD-ROM, with removable media
	  Model Number:       HL-DT-STDVD-RAM GSA-H30N
	  Serial Number:
	  Firmware Revision:  1.00
  Standards:
	  Likely used CD-ROM ATAPI-1
  Configuration:
	  DRQ response: 50us.
	  Packet size: 12 bytes
  Capabilities:
	  LBA, IORDY(can be disabled)
	  DMA: sdma0 sdma1 sdma2 mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
	       Cycle time: min=120ns recommended=120ns
	  PIO: pio0 pio1 pio2 pio3 pio4
	       Cycle time: no flow control=120ns  IORDY flow control=120

This device doesn't claim to support HIPM nor DIPM.

  # echo min_power > link_power_management_policy
  [  752.761751] ata1.00: Unable to set Link PM policy
  [  784.510218] ata1.00: exception Emask 0x50 SAct 0x0 SErr 0xd0800 action 0x6 frozen
  [  784.530266] ata1.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
  [  784.530270]          res 40/00:03:00:00:20/00:00:00:00:00/a0 Emask 0x54 (ATA bus error)
  [  784.571175] ata1: hard resetting port
  [  790.489486] ata1: port is slow to respond, please be patient (Status 0x80)
  [  794.594247] ata1: COMRESET failed (errno=-16)
  [  794.611174] ata1: hard resetting port
  [  800.541562] ata1: port is slow to respond, please be patient (Status 0x80)
  [  804.646316] ata1: COMRESET failed (errno=-16)
  [  804.663284] ata1: hard resetting port
  [  810.593623] ata1: port is slow to respond, please be patient (Status 0x80)
  [  839.654644] ata1: COMRESET failed (errno=-16)
  [  839.672576] ata1: limiting SATA link speed to 1.5 Gbps
  [  839.691024] ata1: hard resetting port
  [  844.726659] ata1: COMRESET failed (errno=-16)
  [  844.744064] ata1: reset failed, giving up
  [  844.761614] ata1.00: disabled
  [  844.761639] ata1: EH complete

The device doesn't respond till power is physically removed and
restored.  It seems something in ahci_disable_alpm() path upsets the
device.

2. TSSTcorpCD/DVDW SH-S183A

  ATAPI CD-ROM, with removable media
	  Model Number:       TSSTcorpCD/DVDW SH-S183A                
	  Serial Number:      
	  Firmware Revision:  SB01    
  Standards:
	  Likely used CD-ROM ATAPI-1
  Configuration:
	  DRQ response: 50us.
	  Packet size: 12 bytes
  Capabilities:
	  LBA, IORDY(can be disabled)
	  DMA: mdma0 mdma1 mdma2 udma0 udma1 *udma2 
	       Cycle time: min=120ns recommended=120ns
	  PIO: pio0 pio1 pio2 pio3 pio4 
	       Cycle time: no flow control=120ns  IORDY flow control=120ns
  Commands/features:
	  Enabled Supported:
	     *    SATA-I signaling speed (1.5Gb/s)
	     *    Host-initiated interface power management
	     *    Phy event counters
		  Device-initiated interface power management
		  unknown 78[5]
	     *    Software settings preservation

This one claims to support HIPS.

  # echo min_power > link_power_management_policy
  [ 1301.917248] ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2
  [ 1301.938338] ata1.00: irq_stat 0x40000001
  [ 1301.956955] ata1.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
  [ 1301.956959]          res 51/20:03:00:00:00/00:00:00:00:00/a0 Emask 0x10 (ATA bus error)
  [ 1304.189565] ata1: soft resetting port
  [ 1304.207745] ata1: SATA link down (SStatus 611 SControl 300)
  [ 1304.228076] ata1: failed to recover some devices, retrying in 5 secs
  [ 1309.245599] ata1: hard resetting port
  [ 1314.773227] ata1: port is slow to respond, please be patient (Status 0x80)
  [ 1319.269677] ata1: COMRESET failed (errno=-16)
  [ 1319.289639] ata1: hard resetting port
  [ 1319.781285] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  [ 1320.115569] ata1.00: configured for UDMA/33
  [ 1320.134780] ata1: EH complete

And hotplug works fine after EH is done with itself.  Dunno why.

3. PLEXTOR DVDR   PX-716A

  ATAPI CD-ROM, with removable media
	  Model Number:       PLEXTOR DVDR   PX-716A                  
	  Serial Number:      127377
	  Firmware Revision:  1.09    
  Standards:
	  Likely used CD-ROM ATAPI-1
  Configuration:
	  DRQ response: 50us.
	  Packet size: 12 bytes
  Capabilities:
	  LBA, IORDY(can be disabled)
	  DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 *udma4 
	       Cycle time: min=120ns recommended=120ns
	  PIO: pio0 pio1 pio2 pio3 pio4 
	       Cycle time: no flow control=120ns  IORDY flow control=120ns
  HW reset results:
	  CBLID- below Vih
	  Device num = 0

  # echo min_power > link_power_management_policy
  [ 2102.655765] ata1.00: Unable to set Link PM policy
  [ 2104.505926] ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2
  [ 2104.527256] ata1.00: irq_stat 0x40000001
  [ 2104.545868] ata1.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
  [ 2104.545870]          res 51/24:03:00:00:20/00:00:00:00:00/a0 Emask 0x10 (ATA bus error)
  [ 2106.810252] ata1: soft resetting port
  [ 2106.828106] ata1: SATA link down (SStatus 611 SControl 300)
  [ 2106.847957] ata1: failed to recover some devices, retrying in 5 secs
  [ 2111.870285] ata1: hard resetting port
  [ 2117.401917] ata1: port is slow to respond, please be patient (Status 0x80)
  [ 2121.902365] ata1: COMRESET failed (errno=-16)
  [ 2121.920313] ata1: hard resetting port
  [ 2122.413973] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  [ 2122.795507] ata1.00: configured for UDMA/66
  [ 2122.813234] ata1: EH complete

4. Harddisks

All the harddisks I have behave themselves.  Impressive.

====

In all cases, hotplug works well even after ALPM is configured.  Have
no idea why.  It might be that PARTIAL/SLUMBER mode didn't kick in or
ICH9 has some magic feature to detect PHY status changes even in PS
mode (wishful thinking).

Will repeat the test with ICH7 when I get some time.  Anyone up for
testing JMB and VIA?

With some massging to ahci_disable_alpm(), I think it can be fairly
safe on this chipset at least.

-- 
tejun
