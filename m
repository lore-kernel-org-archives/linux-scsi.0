From: Kevin George <kevin-linux-scsi@raindrop.net>
Subject: advansys adp940 on ppc (2.4.20)
Date: Fri, 3 Oct 2003 03:42:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031003104213.GA32141@coders.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-228-100-127.client.attbi.com ([12.228.100.127]:19474 "HELO
	granite.coders.net") by vger.kernel.org with SMTP id S263704AbTJCKmP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2003 06:42:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

(I tried to send this to bfrey at turbolinux.com.cn and linux at
advansys.com first, but both of those addresses bounce.  If anyone has
any suggestions, please let me know.  I am not subscribed to the list,
so please cc me.)

From: Kevin George <kevin at raindrop.net>
To: <bfrey at turbolinux.com.cn>
Subject: advansys adp940 on ppc (2.4.20)

Hi,

I've recently started using an old Advansys card in a powermac clone,
and am experiencing an odd problem..  Accessing stuff on the advansys
scsi bus is very slow - like 30k a second or less.  But if I play an mp3 while
accessing the disk, it starts going at least 1mb/sec.  The soundcard
uses dma.  I was thinking maybe there is some sort of dma
setup/completion problem and the soundcard makes advansys dma start working
right?  I don't know.  It also seems to help to access data on the other
controller while trying to use the advansys controller, but not as much
as playing sound does.

Any suggestions?

I've included output from various things below, hoping some of it will
be useful.


Thanks,
Kevin

hdparm -t output while playing an mp3:

/dev/scsi/host1/bus0/target2/lun0/disc:
 Timing buffered disk reads:   12 MB in  3.56 seconds =   3.37 MB/sec
[again]
/dev/scsi/host1/bus0/target2/lun0/disc:
 Timing buffered disk reads:   10 MB in  3.03 seconds =   3.30 MB/sec

hdparm -t output:
/dev/scsi/host1/bus0/target2/lun0/disc:
 Timing buffered disk reads:    2 MB in 88.55 seconds =  23.13 kB/sec

hdparm -t output when running find /usr (/usr is on a different scsi
controller):
/dev/scsi/host1/bus0/target2/lun0/disc:
 Timing buffered disk reads:    6 MB in  4.25 seconds =   1.41 MB/sec
 
lspci -v:
00:0b.0 Host bridge: Apple Computer Inc. Bandit PowerPC host bridge (rev 03)
        Flags: bus master, medium devsel, latency 32, IRQ 22

00:0d.0 VGA compatible controller: ATI Technologies Inc 3D Rage I/II 215GT [Mach64 GT] (rev 41) (prog-if 00 [VGA])
        Flags: bus master, stepping, medium devsel, latency 32, IRQ 23
        Memory at 84000000 (32-bit, non-prefetchable) [size=16M]
        I/O ports at 0400 [disabled] [size=256]
        Memory at f3020000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at <unassigned> [disabled] [size=128K]

00:0e.0 Ethernet controller: Lite-On Communications Inc LNE100TX (rev 20)
        Subsystem: Kingston Technologies: Unknown device f002
        Flags: bus master, medium devsel, latency 32, IRQ 24
        I/O ports at 0800 [size=256]
        Memory at 85058000 (32-bit, non-prefetchable) [size=256]
        Expansion ROM at 85000000 [disabled] [size=256K]

00:0f.0 Display controller: Integrated Micro Solutions Inc. IMS9128 [Twin turbo 128] (rev 01)
        Flags: bus master, medium devsel, latency 32, IRQ 25
        Memory at 82000000 (32-bit, prefetchable) [size=16M]
        Expansion ROM at 85040000 [disabled] [size=64K]

00:10.0 Class ff00: Apple Computer Inc. Grand Central I/O (rev 02)
        Flags: bus master, medium devsel, latency 32, IRQ 22
        Memory at f3000000 (32-bit, non-prefetchable) [size=128K]

00:11.0 SCSI storage controller: Advanced System Products, Inc ASC1200 [(abp940) Fast SCSI-II]
        Flags: bus master, medium devsel, latency 0, IRQ 30
        I/O ports at 0c00 [size=64]
        Expansion ROM at 85050000 [disabled] [size=32K]

/proc/interrupts:
           CPU0       
  2:          0   PMAC-PIC  Edge      MACE-txdma
  3:          3   PMAC-PIC  Edge      MACE-rxdma
  4:          0   PMAC-PIC  Edge      SCC-txdma
  5:          0   PMAC-PIC  Edge      SCC-rxdma
  6:          0   PMAC-PIC  Edge      SCC-txdma
  7:          0   PMAC-PIC  Edge      SCC-rxdma
  8:      13595   PMAC-PIC  Edge      Built-in Sound out
  9:          0   PMAC-PIC  Edge      Built-in Sound in
 12:      42826   PMAC-PIC  Edge      53C94
 14:          3   PMAC-PIC  Edge      MACE
 15:         10   PMAC-PIC  Edge      SCC
 16:         10   PMAC-PIC  Edge      SCC
 17:          3   PMAC-PIC  Edge      Built-in Sound misc
 18:      39559   PMAC-PIC  Edge      ADB
 19:          0   PMAC-PIC  Edge      SWIM3
 24:     589538   PMAC-PIC  Level     eth0
 30:      12541   PMAC-PIC  Edge      advansys
BAD:          0

/proc/scsi/scsi: (advansys is scsi1)
Attached devices: 
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SEAGATE  Model: ST39140N         Rev: 1487
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: DEC      Model: DSP3210S         Rev: SD36
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: MATSHITA Model: CD-ROM CR-508    Rev: XS03
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: YAMAHA   Model: CRW4416S         Rev: 1.0j
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 02 Lun: 00
  Vendor: CONNER   Model: CFP2105S LKM2.14 Rev: 2B4B
  Type:   Direct-Access                    ANSI SCSI revision: 02

/proc/scsi/advansys/1:
AdvanSys SCSI 3.3G: PCI: IO 0xC00-0xC0F, IRQ 0x1E

Device Information for AdvanSys SCSI Host 1:
Target IDs Detected: 2, 7, (7=Host Adapter)
Host: scsi1 Channel: 00 Id: 02 Lun: 00
  Vendor: CONNER   Model: CFP2105S LKM2.14 Rev: 2B4B
  Type:   Direct-Access                    ANSI SCSI revision: 02

EEPROM Settings for AdvanSys SCSI Host 1:
 Serial Number Signature Not Present.
 Host SCSI ID: 7, Host Queue Size: 240, Device Queue Size: 32
 cntl 0xdf, no_scam 0x0
 Target ID:            0 1 2 3 4 5 6 7
 Disconnects:          Y Y Y Y Y Y Y Y
 Command Queuing:      Y Y Y Y Y Y Y Y
 Start Motor:          Y Y Y Y Y Y Y Y
 Synchronous Transfer: Y Y Y Y Y Y Y Y

Linux Driver Configuration and Information for AdvanSys SCSI Host 1:
 host_busy 0, last_reset 0, max_id 8, max_lun 8, max_channel 0
 unique_id 0, can_queue 240, this_id 7, sg_tablesize 255, cmd_per_lun 1
 unchecked_isa_dma 0, use_clustering 1, loaded_as_module 1
 flags 0x8, last_reset 0x0, jiffies 0x24683b, asc_n_io_port 0x10
 io_port 0xc00, n_io_port 0x10
 queue_depth: 2:32

Linux Driver Statistics for AdvanSys SCSI Host 1:
 queuecommand 12374, reset 0, biosparam 1, interrupt 12378
 callback 12374, done 12374, build_error 0, build_noreq 0, build_nosg 0
 exe_noerror 12374, exe_busy 5039, exe_error 0, exe_unknown 0
 cont_cnt 9138, cont_xfer 15178.5 kb avg_xfer 1.6 kb
 sg_cnt 8275, sg_elem 67513, sg_xfer 245348.0 kb
 avg_num_elem 8.1, avg_elem_size 3.6 kb, avg_xfer_size 29.6 kb
 Active and Waiting Request Queues (Time Unit: 100 HZ):
 target 2
   active: cnt [cur 0, max 32, tot 12368], time [min 0, max 1576, avg 108.9]
   waiting: cnt [cur 0, max 2, tot 5039], time [min 0, max 228, avg 8.3]

Asc Library Configuration and Statistics for AdvanSys SCSI Host 1:
 chip_version 9, lib_version 0x118, lib_serial_no 123, mcode_date 0x12c3
 mcode_version 0x50d, err_code 0
 Total Command Pending: 0
 Command Queuing: 2:Y
 Command Queue Pending: 2:0
 Command Queue Limit: 2:30
 Command Queue Full: 2:Y-30
 Synchronous Transfer: 2:Y
  2: Transfer Period Factor: 25 (10.0 Mhz), REQ/ACK Offset: 15

/proc/cpuinfo:
cpu             : 604e
clock           : 190MHz
revision        : 2.2 (pvr 0009 0202)
bogomips        : 399.76
machine         : Power Macintosh
motherboard     : AAPL,7300 MacRISC
detected as     : 16 (Unknown PowerSurge)
pmac flags      : 00000000
memory          : 384MB
pmac-generation : OldWorld




----- End forwarded message -----
