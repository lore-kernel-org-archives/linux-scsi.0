From: "Dimitrios P. Bouras" <dbouras@hol.gr>
Subject: aix7xxx driver 5.2.4/5.2.0 vs. 6.2.5 with onboard aic7896/97 Ultra2 controller
Date: Tue, 07 May 2002 17:28:10 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CD7E47A.10809@hol.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all,

I have recently switched from kernel version 2.2.20 to 2.4.18. The
problem I've had is with the new aic7xxx driver. In short, it seems
to have the same (possibly reasonable but, in effect, undesirable)
behavior as the SCSI-BIOS for the onboard aic7896/97 Ultra2 controller
on my Gigabyte GA-6BXDU motherboard: it fails to enable the full 80
mb/s transfer rate on my 2 hard-drives, as well as 20 mb/s and 10 mb/s
on my cdrom and cd recorder respectively. The old driver works like a
charm. Similarly the older Adaptec BIOS detected all four devices
correctly, but I had to upgrade when I installed a Coppermine processor.
I am currently forced to use the old driver under 2.4.18, but would like
to resolve this problem.

Driver initialization output messages follow.

-----------------------------
The old aic7xxx driver says:
-----------------------------

SCSI subsystem driver Revision: 1.00
(scsi0) <Adaptec AIC-7896/7 Ultra2 SCSI host adapter> found at PCI 0/12/0
(scsi0) Wide Channel A, SCSI ID=7, 32/255 SCBs
(scsi0) Downloading sequencer code... 393 instructions downloaded
(scsi1) <Adaptec AIC-7896/7 Ultra2 SCSI host adapter> found at PCI 0/12/1
(scsi1) Wide Channel B, SCSI ID=7, 32/255 SCBs
(scsi1) Downloading sequencer code... 393 instructions downloaded
scsi0 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.4/5.2.0
        <Adaptec AIC-7896/7 Ultra2 SCSI host adapter>
scsi1 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.4/5.2.0
        <Adaptec AIC-7896/7 Ultra2 SCSI host adapter>
   Vendor: SEAGATE   Model: ST39175LW         Rev: 0001
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: IBM       Model: DPSS-309170N      Rev: S96H
   Type:   Direct-Access                      ANSI SCSI revision: 03
   Vendor: PLEXTOR   Model: CD-ROM PX-40TS    Rev: 1.00
   Type:   CD-ROM                             ANSI SCSI revision: 02
   Vendor: PLEXTOR   Model: CD-R   PX-R820T   Rev: 1.03
   Type:   CD-ROM                             ANSI SCSI revision: 02
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 3, lun 0
(scsi0:0:0:0) Synchronous at 80.0 Mbyte/sec, offset 15.
SCSI device sda: 17783240 512-byte hdwr sectors (9105 MB)
  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
(scsi0:0:3:0) Synchronous at 80.0 Mbyte/sec, offset 63.
SCSI device sdb: 17916240 512-byte hdwr sectors (9173 MB)
  sdb: sdb1 sdb2
Attached scsi CD-ROM sr0 at scsi1, channel 0, id 3, lun 0
Attached scsi CD-ROM sr1 at scsi1, channel 0, id 4, lun 0
(scsi1:0:3:0) Synchronous at 20.0 Mbyte/sec, offset 15.
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.12
(scsi1:0:4:0) Synchronous at 10.0 Mbyte/sec, offset 8.
sr1: scsi3-mmc drive: 20x/20x writer cd/rw xa/form2 cdda tray

------------------------------------------------
The new aic7xxx driver says (verbose messages):
------------------------------------------------

<6>SCSI subsystem driver Revision: 1.00
<6>PCI: Found IRQ 11 for device 00:0c.0
<6>PCI: Sharing IRQ 11 with 00:0c.1
<4>ahc_pci:0:12:0: Reading SEEPROM...done.
<4>ahc_pci:0:12:0: Manual LVD Termination
<4>ahc_pci:0:12:0: BIOS eeprom is present
<4>ahc_pci:0:12:0: Secondary High byte termination Enabled
<4>ahc_pci:0:12:0: Secondary Low byte termination Enabled
<4>ahc_pci:0:12:0: Primary Low Byte termination Enabled
<4>ahc_pci:0:12:0: Primary High Byte termination Enabled
<4>ahc_pci:0:12:0: Downloading Sequencer Program... 416 instructions downloaded
<6>PCI: Found IRQ 11 for device 00:0c.1
<6>PCI: Sharing IRQ 11 with 00:0c.0
<4>ahc_pci:0:12:1: Reading SEEPROM...done.
<4>ahc_pci:0:12:1: Manual LVD Termination
<4>ahc_pci:0:12:1: BIOS eeprom is present
<4>ahc_pci:0:12:1: Secondary High byte termination Enabled
<4>ahc_pci:0:12:1: Secondary Low byte termination Enabled
<4>ahc_pci:0:12:1: Primary Low Byte termination Enabled
<4>ahc_pci:0:12:1: Primary High Byte termination Enabled
<4>ahc_pci:0:12:1: Downloading Sequencer Program... 416 instructions downloaded
<6>scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.5
<4>        <Adaptec aic7896/97 Ultra2 SCSI adapter>
<4>        aic7896/97: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
<4>
<6>scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.5
<4>        <Adaptec aic7896/97 Ultra2 SCSI adapter>
<4>        aic7896/97: Ultra2 Wide Channel B, SCSI Id=7, 32/253 SCBs
<4>
<4>  Vendor: SEAGATE   Model: ST39175LW         Rev: 0001
<4>  Type:   Direct-Access                      ANSI SCSI revision: 02
<4>  Vendor: IBM       Model: DPSS-309170N      Rev: S96H
<4>  Type:   Direct-Access                      ANSI SCSI revision: 03
<4>(scsi0:A:0): 3.300MB/s transfers
<4>scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
<4>(scsi0:A:3): 3.300MB/s transfers
<4>scsi0:A:3:0: Tagged Queuing enabled.  Depth 253
<4>  Vendor: PLEXTOR   Model: CD-ROM PX-40TS    Rev: 1.00
<4>  Type:   CD-ROM                             ANSI SCSI revision: 02
<4>  Vendor: PLEXTOR   Model: CD-R   PX-R820T   Rev: 1.03
<4>  Type:   CD-ROM                             ANSI SCSI revision: 02
<4>Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
<4>Attached scsi disk sdb at scsi0, channel 0, id 3, lun 0
<4>(scsi0:A:0:0): Sending WDTR 1
<4>(scsi0:A:0:0): Received WDTR 1 filtered to 1
<4>(scsi0:A:0): 6.600MB/s transfers (16bit)
<4>scsi0: target 0 using 16bit transfers
<4>(scsi0:A:0:0): Sending SDTR period 2b, offset 7f
<4>(scsi0:A:0:0): Received SDTR period 2b, offset f
<4>     Filtered to period 2b, offset f
<4>(scsi0:A:0): 11.626MB/s transfers (5.813MHz, offset 15, 16bit)
<4>scsi0: target 0 synchronous at 5.7MHz, offset = 0xf
<4>(scsi0:A:0:0): Sending WDTR 1
<4>(scsi0:A:0:0): Received WDTR 1 filtered to 1
<4>(scsi0:A:0): 6.600MB/s transfers (16bit)
<4>scsi0: target 0 using asynchronous transfers
<4>(scsi0:A:0:0): Sending SDTR period 2b, offset f
<4>(scsi0:A:0:0): Received SDTR period 2b, offset f
<4>     Filtered to period 2b, offset f
<4>(scsi0:A:0): 11.626MB/s transfers (5.813MHz, offset 15, 16bit)
<4>scsi0: target 0 synchronous at 5.7MHz, offset = 0xf
<4>SCSI device sda: 17783240 512-byte hdwr sectors (9105 MB)
<6>Partition check:
<6> sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
<4>(scsi0:A:3:0): Sending PPR bus_width 1, period 2b, offset 7f, ppr_options 0
<4>(scsi0:A:3:0): Received PPR width 1, period 2b, offset 3f,options 0
<4>     Filtered to width 1, period 2b, offset 3f, options 0
<4>(scsi0:A:3): 6.600MB/s transfers (16bit)
<4>scsi0: target 3 using 16bit transfers
<4>(scsi0:A:3): 11.626MB/s transfers (5.813MHz, offset 63, 16bit)
<4>scsi0: target 3 synchronous at 5.7MHz, offset = 0x3f
<4>(scsi0:A:3:0): Sending PPR bus_width 1, period 2b, offset 3f, ppr_options 0
<4>(scsi0:A:3:0): Received PPR width 1, period 2b, offset 3f,options 0
<4>     Filtered to width 1, period 2b, offset 3f, options 0
<4>SCSI device sdb: 17916240 512-byte hdwr sectors (9173 MB)
<6> sdb: sdb1 sdb2
<4>Attached scsi CD-ROM sr0 at scsi1, channel 0, id 3, lun 0
<4>Attached scsi CD-ROM sr1 at scsi1, channel 0, id 4, lun 0
<4>(scsi1:A:3:0): Sending SDTR period 2b, offset 7f
<4>(scsi1:A:3:0): Received SDTR period 2b, offset f
<4>     Filtered to period 2b, offset f
<4>(scsi1:A:3): 5.813MB/s transfers (5.813MHz, offset 15)
<4>scsi1: target 3 synchronous at 5.7MHz, offset = 0xf
<4>(scsi1:A:3:0): Sending SDTR period 2b, offset f
<4>(scsi1:A:3:0): Received SDTR period 2b, offset f
<4>     Filtered to period 2b, offset f
<4>(scsi1:A:3:0): Sending SDTR period 2b, offset f
<4>(scsi1:A:3:0): Received SDTR period 2b, offset f
<4>     Filtered to period 2b, offset f
<4>sr0: scsi-1 drive
<6>Uniform CD-ROM driver Revision: 3.12
<4>(scsi1:A:4:0): Sending SDTR period 2b, offset 7f
<4>(scsi1:A:4:0): Received SDTR period 32, offset 8
<4>     Filtered to period 32, offset 8
<4>(scsi1:A:4): 5.000MB/s transfers (5.000MHz, offset 8)
<4>scsi1: target 4 synchronous at 5.0MHz, offset = 0x8
<4>(scsi1:A:4:0): Sending SDTR period 32, offset 8
<4>(scsi1:A:4:0): Received SDTR period 32, offset 8
<4>     Filtered to period 32, offset 8
<4>sr1: scsi3-mmc drive: 20x/20x writer cd/rw xa/form2 cdda tray


I can't make sense of the termination config detected by the new
driver, and I suspect that this is at least part of the problem.
The onboard controller is 2-channel, ch-A with 2 LVD drives attached,
and ch-B with the 2 SE devices (cd-rom, cd-rec). I have tried to
force the termination using the "aic7xxx=override_term:0x2C" option
which corresponds to the same setting as that programmed via the BIOS,
but to no avail.

Any help is greatly appreciated.
With best regards from (cloudy but warm today at ~27C) Athens,

Dimitri

-- 
+-------------------------+-------------------------------------------+
| Dimitrios P. Bouras     | Voice: +30 10 895-6380 or +30 10 895-3552 |
| 27 El. Venizelou St.    | E-Mail: dbouras@hol.gr, d.bouras@ieee.org |
| GR-16673 Athens, GREECE |    Web: http://users.hol.gr/~dbouras      |
+-------------------------+-------------------------------------------+
     "There is hopeful symbolism in the fact that flags do not wave
      in a vacuum."                             -- Arthur C. Clarke

