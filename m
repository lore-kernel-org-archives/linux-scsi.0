From: Fabien Salvi <fabien@cri74.org>
Subject: Pb with external RAID controller in lk 2.4
Date: Tue, 21 May 2002 19:28:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CEA83AE.1DCAB7BC@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Lorraine Suschetet <lorraine@ext.cri74.org>

Hello, I have problem when using the lk 2.4

My system :
- A bi-pentium II 450 processor with 1 GB RAM
- Symbios/LSILogic SCSI card NCR 53c895
- external Mylex DAC960SX RAID Controller (Ultra2 scsi) in a Siemens
enclosure


1) With kernel 2.2 (exactly 2.2.19, but it's the same through 2.2.9 to
2.2.19), I have no problems, my disks are visible without problems :

May 17 16:22:28 node01 kernel: sym53c8xx: at PCI bus 2, device 8,
function 0
May 17 16:22:28 node01 kernel: sym53c8xx: 53c876 detected with Symbios
NVRAM
May 17 16:22:28 node01 kernel: sym53c8xx: at PCI bus 2, device 8,
function 1
May 17 16:22:28 node01 kernel: sym53c8xx: 53c876 detected with Symbios
NVRAM
May 17 16:22:28 node01 kernel: sym53c8xx: at PCI bus 2, device 1,
function 0
May 17 16:22:28 node01 kernel: sym53c8xx: 53c895 detected with Symbios
NVRAM
May 17 16:22:28 node01 kernel: sym53c876-0: rev 0x14 on pci bus 2 device
8 function 0 irq 15
May 17 16:22:28 node01 kernel: sym53c876-0: Symbios format NVRAM, ID 7,
Fast-20, Parity Checking
May 17 16:22:28 node01 kernel: sym53c876-0: on-chip RAM at 0xf4202000
May 17 16:22:28 node01 kernel: sym53c876-0: restart (scsi reset).
May 17 16:22:28 node01 kernel: sym53c876-0: Downloading SCSI SCRIPTS.
May 17 16:22:28 node01 kernel: sym53c876-1: rev 0x14 on pci bus 2 device
8 function 1 irq 5
May 17 16:22:28 node01 kernel: sym53c876-1: Symbios format NVRAM, ID 7,
Fast-20, Parity Checking
May 17 16:22:28 node01 kernel: sym53c876-1: on-chip RAM at 0xf4203000
May 17 16:22:28 node01 kernel: sym53c876-1: restart (scsi reset).
May 17 16:22:28 node01 kernel: sym53c876-1: Downloading SCSI SCRIPTS.
May 17 16:22:28 node01 kernel: sym53c895-2: rev 0x1 on pci bus 2 device
1 function 0 irq 10
May 17 16:22:28 node01 kernel: sym53c895-2: Symbios format NVRAM, ID 7,
Fast-40, Parity Checking
May 17 16:22:28 node01 kernel: sym53c895-2: on-chip RAM at 0xf4201000
May 17 16:22:28 node01 kernel: sym53c895-2: restart (scsi reset).
May 17 16:22:28 node01 kernel: sym53c895-2: Downloading SCSI SCRIPTS.
May 17 16:22:28 node01 kernel: ncr53c8xx: at PCI bus 2, device 8,
function 0
May 17 16:22:28 node01 kernel: ncr53c8xx: IO region 0x2400[0..127] is in
use
May 17 16:22:28 node01 kernel: ncr53c8xx: at PCI bus 2, device 8,
function 1
May 17 16:22:28 node01 kernel: ncr53c8xx: IO region 0x2800[0..127] is in
use
May 17 16:22:28 node01 kernel: ncr53c8xx: at PCI bus 2, device 1,
function 0
May 17 16:22:28 node01 kernel: ncr53c8xx: IO region 0x2000[0..127] is in
use
May 17 16:22:28 node01 kernel: scsi0 : sym53c8xx-1.7.1-20000726
May 17 16:22:28 node01 kernel: scsi1 : sym53c8xx-1.7.1-20000726
May 17 16:22:28 node01 kernel: scsi2 : sym53c8xx-1.7.1-20000726
May 17 16:22:28 node01 kernel: scsi : 3 hosts.
May 17 16:22:28 node01 kernel:   Vendor: MYLEX     Model: DAC960SX 
8680T1  Rev: 1339
May 17 16:22:28 node01 kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02
May 17 16:22:28 node01 kernel: Detected scsi disk sda at scsi0, channel
0, id 0, lun 0
May 17 16:22:28 node01 kernel:   Vendor: MYLEX     Model: DAC960SX 
8680T1  Rev: 1339
May 17 16:22:28 node01 kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02
May 17 16:22:28 node01 kernel: Detected scsi disk sdb at scsi0, channel
0, id 0, lun 1
May 17 16:22:28 node01 kernel: sym53c876-0-<0,0>: tagged command queue
depth set to 8
May 17 16:22:28 node01 kernel: sym53c876-0-<0,1>: tagged command queue
depth set to 8
May 17 16:22:28 node01 kernel:   Vendor: NEC       Model: CD-ROM
DRIVE:466  Rev: 1.17
May 17 16:22:28 node01 kernel:   Type:  
CD-ROM                             ANSI SCSI revision: 02
May 17 16:22:28 node01 kernel: Detected scsi CD-ROM sr0 at scsi2,
channel 0, id 5, lun 0
May 17 16:22:28 node01 kernel:   Vendor: SIEMENS   Model: STM/L
S1          Rev: 4.1b
May 17 16:22:28 node01 kernel:   Type:  
Processor                          ANSI SCSI revision: 02
May 17 16:22:28 node01 kernel: Detected scsi generic sg3 at scsi2,
channel 0, id 8, lun 0
May 17 16:22:28 node01 kernel: scsi : detected 4 SCSI generics 1 SCSI
cdrom 2 SCSI disks total.
May 17 16:22:28 node01 kernel: sym53c895-2-<5,*>: FAST-20 SCSI 20.0 MB/s
(50 ns, offset 16)
May 17 16:22:28 node01 kernel: sr0: scsi3-mmc drive: 17x/40x cd/rw
xa/form2 cdda tray
May 17 16:22:28 node01 kernel: Uniform CD-ROM driver Revision: 3.11
May 17 16:22:28 node01 kernel: sym53c876-0-<0,*>: FAST-20 SCSI 20.0 MB/s
(50 ns, offset 16)
May 17 16:22:28 node01 kernel: SCSI device sda: hdwr sector= 512 bytes.
Sectors= 17776640 [8680 MB] [8.7 GB]
May 17 16:22:28 node01 kernel: SCSI device sdb: hdwr sector= 512 bytes.
Sectors= 17776640 [8680 MB] [8.7 GB]

It founds the real 2 disks exporting from the RAID controller (in fact
2*2 disks in RAID 1)


2) with 2.4.18 kernel, I've got this :
May 17 16:19:36 node01 kernel: sym0: <875> rev 0x14 on pci bus 2 device
8 function 0 irq 15
May 17 16:19:36 node01 kernel: sym0: Symbios NVRAM, ID 7, Fast-20, HVD,
parity checking
May 17 16:19:36 node01 kernel: sym0: open drain IRQ line driver, using
on-chip SRAM
May 17 16:19:36 node01 kernel: sym0: using LOAD/STORE-based firmware.
May 17 16:19:36 node01 kernel: sym0: SCSI BUS has been reset.
May 17 16:19:36 node01 kernel: sym1: <875> rev 0x14 on pci bus 2 device
8 function 1 irq 5
May 17 16:19:36 node01 kernel: sym1: Symbios NVRAM, ID 7, Fast-20, HVD,
parity checking
May 17 16:19:36 node01 kernel: sym1: open drain IRQ line driver, using
on-chip SRAM
May 17 16:19:36 node01 kernel: sym1: using LOAD/STORE-based firmware.
May 17 16:19:36 node01 kernel: sym1: SCSI BUS has been reset.
May 17 16:19:36 node01 kernel: sym2: <895> rev 0x1 on pci bus 2 device 1
function 0 irq 10
May 17 16:19:36 node01 kernel: sym2: Symbios NVRAM, ID 7, Fast-40, LVD,
parity checking
May 17 16:19:36 node01 kernel: sym2: open drain IRQ line driver, using
on-chip SRAM
May 17 16:19:36 node01 kernel: sym2: using LOAD/STORE-based firmware.
May 17 16:19:36 node01 kernel: sym2: SCSI BUS has been reset.
May 17 16:19:36 node01 kernel: scsi0 : sym-2.1.17a
May 17 16:19:36 node01 kernel: scsi1 : sym-2.1.17a
May 17 16:19:36 node01 kernel: scsi2 : sym-2.1.17a
May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX 
8680T1  Rev: 1339
May 17 16:19:36 node01 kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02
May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX 
8680T1  Rev: 1339
May 17 16:19:36 node01 kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02
May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX 
8680T1  Rev: 1339
May 17 16:19:36 node01 kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02
May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX 
8680T1  Rev: 1339
May 17 16:19:36 node01 kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02
May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX 
8680T1  Rev: 1339
May 17 16:19:36 node01 kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02
May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX 
8680T1  Rev: 1339
May 17 16:19:36 node01 kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02
May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX 
8680T1  Rev: 1339
May 17 16:19:36 node01 kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02
May 17 16:19:36 node01 kernel:   Vendor: MYLEX     Model: DAC960SX 
8680T1  Rev: 1339
May 17 16:19:36 node01 kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02
May 17 16:19:36 node01 kernel: sym0:0:0: tagged command queuing enabled,
command queue depth 16.
May 17 16:19:36 node01 kernel: sym0:0:1: tagged command queuing enabled,
command queue depth 16.
May 17 16:19:36 node01 kernel: sym0:0:2: tagged command queuing enabled,
command queue depth 16.
May 17 16:19:36 node01 kernel: sym0:0:3: tagged command queuing enabled,
command queue depth 16.
May 17 16:19:36 node01 kernel: sym0:0:4: tagged command queuing enabled,
command queue depth 16.
May 17 16:19:36 node01 kernel: sym0:0:5: tagged command queuing enabled,
command queue depth 16.
May 17 16:19:36 node01 kernel: sym0:0:6: tagged command queuing enabled,
command queue depth 16.
May 17 16:19:36 node01 kernel: sym0:0:7: tagged command queuing enabled,
command queue depth 16.
May 17 16:19:36 node01 kernel:   Vendor: NEC       Model: CD-ROM
DRIVE:466  Rev: 1.17
May 17 16:19:36 node01 kernel:   Type:  
CD-ROM                             ANSI SCSI revision: 02
May 17 16:19:36 node01 kernel:   Vendor: SIEMENS   Model: STM/L
S1          Rev: 4.1b
May 17 16:19:36 node01 kernel:   Type:  
Processor                          ANSI SCSI revision: 02
May 17 16:19:36 node01 kernel: Attached scsi disk sda at scsi0, channel
0, id 0, lun 0
May 17 16:19:36 node01 kernel: Attached scsi disk sdb at scsi0, channel
0, id 0, lun 1
May 17 16:19:36 node01 kernel: Attached scsi disk sdc at scsi0, channel
0, id 0, lun 2
May 17 16:19:36 node01 kernel: Attached scsi disk sdd at scsi0, channel
0, id 0, lun 3
May 17 16:19:36 node01 kernel: Attached scsi disk sde at scsi0, channel
0, id 0, lun 4
May 17 16:19:36 node01 kernel: Attached scsi disk sdf at scsi0, channel
0, id 0, lun 5
May 17 16:19:36 node01 kernel: Attached scsi disk sdg at scsi0, channel
0, id 0, lun 6
May 17 16:19:36 node01 kernel: Attached scsi disk sdh at scsi0, channel
0, id 0, lun 7
May 17 16:19:36 node01 kernel: Attached scsi CD-ROM sr0 at scsi2,
channel 0, id 5, lun 0
May 17 16:19:36 node01 kernel: sym2:5: FAST-20 SCSI 20.0 MB/s ST (50.0
ns, offset 16)
May 17 16:19:36 node01 kernel: sr0: scsi3-mmc drive: 17x/40x cd/rw
xa/form2 cdda tray
May 17 16:19:36 node01 kernel: Uniform CD-ROM driver Revision: 3.12
May 17 16:19:36 node01 kernel: sym0:0: FAST-20 SCSI 20.0 MB/s ST (50.0
ns, offset 16)
May 17 16:19:36 node01 kernel: SCSI device sda: 17776640 512-byte hdwr
sectors (9102 MB)
May 17 16:19:36 node01 kernel: Partition check:
May 17 16:19:36 node01 kernel:  sda: sda1 sda2 sda3 sda4
May 17 16:19:36 node01 kernel: SCSI device sdb: 17776640 512-byte hdwr
sectors (9102 MB)
May 17 16:19:36 node01 kernel:  sdb: sdb1

Like you can see, it founds 8 disks !
I tried to increase max_scsi_luns to 64 to see if it will find as many
disks as luns, but it does not go after lun7 ==> 8 disks


There are 3 drivers in linux kernel 2.4.18 that supports may SCSI HBA
(sym53c8xx,sym53c8xx_2 and ncr53c8xx) but I have always the same
results...

Infortunately, I can't make tests with other cards, because I don't have
them !
(scsi hvd connectors). 


Well, I don't know why the lk founds as many disks...

What do you think about it ?
Do you have any idea ?

Thanks in advance for your help !

-------------
Fabien SALVI      Centre de Ressources Informatiques
                  Archamps, France -- http://www.cri74.org
                  PingOO GNU/linux distribution : http://www.pingoo.org
