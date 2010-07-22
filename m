From: Danilo Godec <danilo.godec@agenda.si>
Subject: pm8001 bug - pcieport error when loading 'pm8001' driver / no backplane
 drives seen
Date: Thu, 22 Jul 2010 13:54:00 +0200
Message-ID: <4C483158.9060405@agenda.si>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040903050603060304030908"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from router.agenda.si ([89.212.65.33]:54445 "EHLO relay.agenda.si"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260Ab0GVMCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2010 08:02:11 -0400
Received: from [172.16.0.214] (barbie.agenda.si [172.16.0.214])
	by relay.agenda.si (Postfix) with ESMTP id CC17B2427E
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2010 13:54:00 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040903050603060304030908
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[1.] One line summary of the problem:
pcieport error when loading 'pm8001' driver / no backplane drives seen

[2.] Full description of the problem/report:
I have a ATTOTech ExpresSAS H608 SAS HBA, whichj is recognized by the
'pm8001' driver. However - whenever the driver is loaded, the following
errors apear in the 'dmesg':

[  343.186180] pm8001 0000:02:00.0: pm8001: driver version 0.1.36
[  343.186193] pm8001 0000:02:00.0: PCI INT A -> GSI 24 (level, low) ->
IRQ 24
[  343.186197] pm8001 0000:02:00.0: setting latency timer to 64
[  344.101922] pcieport 0000:00:03.0: AER: Uncorrected (Non-Fatal) error
received: id=0018
[  344.101930] pcieport 0000:00:03.0: PCIe Bus Error:
severity=Uncorrected (Non-Fatal), type=Transaction Layer,
id=0018(Requester ID)
[  344.101933] pcieport 0000:00:03.0:   device [8086:340a] error
status/mask=00004000/00100000
[  344.101935] pcieport 0000:00:03.0:    [14] Completion Timeout     (First)
[  344.101939] pcieport 0000:00:03.0: broadcast error_detected message
[  344.101999] scsi7 : pm8001
[  344.102290] pm8001 0000:02:00.0: irq 85 for MSI/MSI-X
[  344.144803] mpi_sata_completion 1903:sata IO status 0x16
[  345.140556] mpi_sata_completion 1903:sata IO status 0x16
[  346.138716] mpi_sata_completion 1903:sata IO status 0x16
[  347.136840] mpi_sata_completion 1903:sata IO status 0x16
[  348.134943] mpi_sata_completion 1903:sata IO status 0x16
[  349.134321] mpi_sata_completion 1903:sata IO status 0x16
[  350.131123] mpi_sata_completion 1903:sata IO status 0x16
[  351.129287] mpi_sata_completion 1903:sata IO status 0x16
[  352.127377] mpi_sata_completion 1903:sata IO status 0x16
[  353.125496] mpi_sata_completion 1903:sata IO status 0x16
[  354.124929] mpi_sata_completion 1903:sata IO status 0x16
[  355.121732] mpi_sata_completion 1903:sata IO status 0x16
[  356.119851] mpi_sata_completion 1903:sata IO status 0x16
[  357.117964] mpi_sata_completion 1903:sata IO status 0x16
[  358.116080] mpi_sata_completion 1903:sata IO status 0x16
[  359.115442] mpi_sata_completion 1903:sata IO status 0x16
[  360.112309] mpi_sata_completion 1903:sata IO status 0x16
[  361.110422] mpi_sata_completion 1903:sata IO status 0x16
[  362.108537] mpi_sata_completion 1903:sata IO status 0x16
[  363.106652] mpi_sata_completion 1903:sata IO status 0x16
[  364.163122] scsi 7:0:0:0: Enclosure         INTEL    SR2612UR        
R105 PQ: 0 ANSI: 5
[  364.164101] ses 7:0:0:0: Attached Enclosure device
[  364.164169] ses 7:0:0:0: Attached scsi generic sg1 type 13
[  364.185106] pcieport 0000:00:03.0: broadcast mmio_enabled message
[  364.185108] pcieport 0000:00:03.0: broadcast resume message
[  364.185113] pcieport 0000:00:03.0: AER driver successfully recovered

There are also 6 drives connected to the SAS backplane, which is
connected to the HBA via a SAS expander and a MiniSAS cable - but none
of the drives is recognized. There is also one SATA drive connected to
on-board integrated SATA controller, which is used to boot the system.

# lsscsi
[0:0:0:0]    disk    ATA      WDC WD6400AAKS-6 01.0  /dev/sda
[10:0:0:0]   enclosu INTEL    SR2612UR         R105  -

[3.] Keywords:
SCSI SAS HBA backplane

[4.] Kernel information

[4.1.] Kernel version:
Linux sanlin1 2.6.34-12-default #1 SMP 2010-06-29 02:39:08 +0200 x86_64
x86_64 x86_64 GNU/Linux

[4.2.] Kernel .config file:
OpenSuSE 11.3 default kernel

[5.] Most recent kernel version which did not have the bug:
unknown

[6.] Output of Oops..
n/a

[7.] A small shell script or example program which triggers the problem
(if possible):
n/a

[8.] Environment

[8.1.] Software (add the output of the ver_linux script here)
Linux sanlin1 2.6.34-12-default #1 SMP 2010-06-29 02:39:08 +0200 x86_64
x86_64 x86_64 GNU/Linux

Gnu C                  4.5
Gnu make               3.81
binutils               11.3
2.20.0.20100122
util-linux             2.17.2
mount                  support
module-init-tools      3.12-pre3
e2fsprogs              1.41.11
PPP                    2.4.5
Linux C Library        2.11.2
Dynamic linker (ldd)   2.11.2
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.14.1
Sh-utils               7.1
wireless-tools         30
Modules Loaded         pm8001 libsas scsi_transport_sas raid456
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx
raid10 raid0 edd mperf fuse loop dm_mod ses enclosure iTCO_wdt igb
iTCO_vendor_support sg ioatdma i2c_i801 dca button pcspkr joydev ext4
jbd2 crc16 usbhid uhci_hcd sd_mod ehci_hcd usbcore fan processor aacraid
ahci libata scsi_mod thermal thermal_sys

[8.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
stepping        : 5
cpu MHz         : 2261.107
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4522.21
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
stepping        : 5
cpu MHz         : 2261.107
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 1
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4522.31
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
stepping        : 5
cpu MHz         : 2261.107
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 2
cpu cores       : 4
apicid          : 4
initial apicid  : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4522.31
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
stepping        : 5
cpu MHz         : 2261.107
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 3
cpu cores       : 4
apicid          : 6
initial apicid  : 6
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4522.31
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

processor       : 4
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
stepping        : 5
cpu MHz         : 2261.107
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4522.29
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

processor       : 5
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
stepping        : 5
cpu MHz         : 2261.107
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 1
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4522.31
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

processor       : 6
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
stepping        : 5
cpu MHz         : 2261.107
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 2
cpu cores       : 4
apicid          : 5
initial apicid  : 5
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4522.31
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

processor       : 7
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
stepping        : 5
cpu MHz         : 2261.107
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 3
cpu cores       : 4
apicid          : 7
initial apicid  : 7
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 4522.31
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

[8.3.] Module information (from /proc/modules):
pm8001 86423 0 - Live 0xffffffffa02d6000
libsas 59063 1 pm8001, Live 0xffffffffa02c5000
scsi_transport_sas 38584 2 pm8001,libsas, Live 0xffffffffa023f000
raid456 74639 0 - Live 0xffffffffa0286000
async_raid6_recov 7485 1 raid456, Live 0xffffffffa0151000
async_pq 5165 2 raid456,async_raid6_recov, Live 0xffffffffa0138000
raid6_pq 80705 2 async_raid6_recov,async_pq, Live 0xffffffffa0218000
async_xor 4306 3 raid456,async_raid6_recov,async_pq, Live 0xffffffffa012d000
xor 5306 1 async_xor, Live 0xffffffffa00e7000
async_memcpy 2138 2 raid456,async_raid6_recov, Live 0xffffffffa00b5000
async_tx 3242 5
raid456,async_raid6_recov,async_pq,async_xor,async_memcpy, Live
0xffffffffa0059000
raid10 23646 0 - Live 0xffffffffa00cf000
raid0 7134 0 - Live 0xffffffffa0049000
edd 10176 0 - Live 0xffffffffa0007000
mperf 1523 0 - Live 0xffffffffa0013000
fuse 74905 1 - Live 0xffffffffa0091000
loop 17791 0 - Live 0xffffffffa0052000
dm_mod 85539 0 - Live 0xffffffffa02f8000
ses 7593 0 - Live 0xffffffffa041c000
enclosure 9385 1 ses, Live 0xffffffffa0413000
iTCO_wdt 12106 0 - Live 0xffffffffa02c0000
igb 113227 0 - Live 0xffffffffa029b000
iTCO_vendor_support 3150 1 iTCO_wdt, Live 0xffffffffa0283000
sg 32904 0 - Live 0xffffffffa0273000
ioatdma 63305 24 - Live 0xffffffffa025b000
i2c_i801 11881 0 - Live 0xffffffffa0252000
dca 7221 2 igb,ioatdma, Live 0xffffffffa024a000
button 6925 0 - Live 0xffffffffa023b000
pcspkr 2222 0 - Live 0xffffffffa0235000
joydev 11686 0 - Live 0xffffffffa022d000
ext4 393372 1 - Live 0xffffffffa01b5000
jbd2 93271 1 ext4, Live 0xffffffffa0192000
crc16 1715 1 ext4, Live 0xffffffffa018c000
usbhid 51657 0 - Live 0xffffffffa0177000
uhci_hcd 29440 0 - Live 0xffffffffa0169000
sd_mod 41042 3 - Live 0xffffffffa0157000
ehci_hcd 59214 0 - Live 0xffffffffa0140000
usbcore 230249 4 usbhid,uhci_hcd,ehci_hcd, Live 0xffffffffa00f2000
fan 4527 0 - Live 0xffffffffa00eb000
processor 45237 8 - Live 0xffffffffa00d6000
aacraid 83864 0 - Live 0xffffffffa00b8000
ahci 42680 2 - Live 0xffffffffa00a5000
libata 211010 2 libsas,ahci, Live 0xffffffffa005b000
scsi_mod 190568 8
pm8001,libsas,scsi_transport_sas,ses,sg,sd_mod,aacraid,libata, Live
0xffffffffa0018000
thermal 20593 0 - Live 0xffffffffa000b000
thermal_sys 17942 3 fan,processor,thermal, Live 0xffffffffa0000000


[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  02f8-02ff : serial
  03c0-03df : vesafb
  03f8-03ff : serial
  0400-047f : 0000:00:1f.0
    0400-047f : pnp 00:07
      0400-0403 : ACPI PM1a_EVT_BLK
      0404-0405 : ACPI PM1a_CNT_BLK
      0408-040b : ACPI PM_TMR
      0410-0415 : ACPI CPU throttle
      0420-042f : ACPI GPE0_BLK
      0450-0450 : ACPI PM2_CNT_BLK
  0500-053f : 0000:00:1f.0
  0600-061f : pnp 00:07
  0800-081f : pnp 00:07
  0880-0883 : pnp 00:07
  0ca2-0ca3 : pnp 00:07
  0ca4-0ca5 : pnp 00:07
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-1fff : PCI Bus 0000:01
    1000-101f : 0000:01:00.1
    1020-103f : 0000:01:00.0
  2000-201f : 0000:00:1f.3
    2000-201f : i801_smbus
  2020-203f : 0000:00:1f.2
    2020-203f : ahci
  2040-205f : 0000:00:1d.2
    2040-205f : uhci_hcd
  2060-207f : 0000:00:1d.1
    2060-207f : uhci_hcd
  2080-209f : 0000:00:1d.0
    2080-209f : uhci_hcd
  20a0-20bf : 0000:00:1a.2
    20a0-20bf : uhci_hcd
  20c0-20df : 0000:00:1a.1
    20c0-20df : uhci_hcd
  20e0-20ff : 0000:00:1a.0
    20e0-20ff : uhci_hcd
  2100-2107 : 0000:00:1f.2
    2100-2107 : ahci
  2108-210f : 0000:00:1f.2
    2108-210f : ahci
  2110-2113 : 0000:00:1f.2
    2110-2113 : ahci
  2114-2117 : 0000:00:1f.2
    2114-2117 : ahci
  3000-3fff : PCI Bus 0000:07
  4000-4fff : PCI Bus 0000:08
  5000-5fff : PCI Bus 0000:09

00000000-0000ffff : reserved
00010000-000977ff : System RAM
00097800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c4000-000cbfff : PCI Bus 0000:00
000e0000-000fffff : reserved
00100000-1fffffff : System RAM
  01000000-01463539 : Kernel code
  0146353a-01b1bfaf : Kernel data
  01c06000-01d9a337 : Kernel bss
8c49f000-8c56ffff : ACPI Non-volatile Storage
8c570000-8c61ffff : ACPI Tables
8c620000-8da1ffff : ACPI Non-volatile Storage
8da20000-8f601fff : ACPI Tables
8f602000-8f64efff : reserved
8f64f000-8f6e6fff : ACPI Tables
8f6e7000-8f6f0fff : ACPI Non-volatile Storage
8f6f1000-8f6f1fff : ACPI Tables
8f6f2000-8f7cefff : ACPI Non-volatile Storage
8f7cf000-8f7fffff : ACPI Tables
8f800000-8fffffff : reserved
a0000000-afffffff : PCI MMCONFIG 0000 [bus 00-ff]
  a0000000-afffffff : reserved
b0000000-fdffffff : PCI Bus 0000:00
  b0000000-b0ffffff : PCI Bus 0000:08
    b0000000-b0ffffff : 0000:08:00.0
      b0000000-b07effff : vesafb
  b1000000-b18fffff : PCI Bus 0000:08
    b1000000-b17fffff : 0000:08:00.0
    b1800000-b1803fff : 0000:08:00.0
    b1810000-b181ffff : 0000:08:00.0
  b1900000-b19fffff : PCI Bus 0000:02
    b1900000-b190ffff : 0000:02:00.0
      b1900000-b190ffff : pm8001
    b1910000-b191ffff : 0000:02:00.0
      b1910000-b191ffff : pm8001
    b1920000-b192ffff : 0000:02:00.0
      b1920000-b192ffff : pm8001
    b1930000-b193ffff : 0000:02:00.0
      b1930000-b193ffff : pm8001
  b1a00000-b1afffff : PCI Bus 0000:01
    b1a00000-b1a1ffff : 0000:01:00.1
      b1a00000-b1a1ffff : igb
    b1a20000-b1a3ffff : 0000:01:00.0
      b1a20000-b1a3ffff : igb
    b1a40000-b1a43fff : 0000:01:00.1
      b1a40000-b1a43fff : igb
    b1a44000-b1a47fff : 0000:01:00.0
      b1a44000-b1a47fff : igb
  b1b00000-b1b03fff : 0000:00:16.0
    b1b00000-b1b03fff : ioatdma
  b1b04000-b1b07fff : 0000:00:16.1
    b1b04000-b1b07fff : ioatdma
  b1b08000-b1b0bfff : 0000:00:16.2
    b1b08000-b1b0bfff : ioatdma
  b1b0c000-b1b0ffff : 0000:00:16.3
    b1b0c000-b1b0ffff : ioatdma
  b1b10000-b1b13fff : 0000:00:16.4
    b1b10000-b1b13fff : ioatdma
  b1b14000-b1b17fff : 0000:00:16.5
    b1b14000-b1b17fff : ioatdma
  b1b18000-b1b1bfff : 0000:00:16.6
    b1b18000-b1b1bfff : ioatdma
  b1b1c000-b1b1ffff : 0000:00:16.7
    b1b1c000-b1b1ffff : ioatdma
  b1b20000-b1b207ff : 0000:00:1f.2
    b1b20000-b1b207ff : ahci
  b1b21000-b1b213ff : 0000:00:1d.7
    b1b21000-b1b213ff : ehci_hcd
  b1b22000-b1b223ff : 0000:00:1a.7
    b1b22000-b1b223ff : ehci_hcd
  b1b23000-b1b230ff : 0000:00:1f.3
  b1b24000-b1b24fff : 0000:00:13.0
  b1c00000-b1cfffff : PCI Bus 0000:02
    b1c00000-b1cfffff : 0000:02:00.0
  b1d00000-b1efffff : PCI Bus 0000:07
  b1f00000-b20fffff : PCI Bus 0000:07
  b2100000-b22fffff : PCI Bus 0000:09
  b2300000-b24fffff : PCI Bus 0000:09
  fc000000-fcffffff : reserved
fe900000-fe90001f : pnp 00:07
fea00000-fea0001f : pnp 00:07
fec00000-fec003ff : IOAPIC 0
fec90000-fec903ff : IOAPIC 1
fed00000-fed003ff : HPET 0
fed1b000-fed1bfff : pnp 00:07
fed1c000-fed1ffff : reserved
fed40000-fedfffff : PCI Bus 0000:00
fee00000-feefffff : pnp 00:07
  fee00000-fee00fff : Local APIC
ff800000-ffffffff : reserved

[8.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation 5520 I/O Hub to ESI Port (rev 22)
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 11
    Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
        Address: 00000020  Data: 0000
        Masking: 00000000  Pending: 00000000
    Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag+ RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported-
            RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1,
Latency L0 <512ns, L1 <4us
            ClockPM- Surprise+ LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
        RootCtl: ErrCorrectable+ ErrNon-Fatal+ ErrFatal+ PMEIntEna-
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
        DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis+ ARIFwd-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [150 v1] Access Control Services
        ACSCap:    SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
UpstreamFwd+ EgressCtrl- DirectTrans-
        ACSCtl:    SrcValid- TransBlk- ReqRedir- CmpltRedir-
UpstreamFwd- EgressCtrl- DirectTrans-
    Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0
Len=00c <?>

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 1 (rev 22) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    I/O behind bridge: 00001000-00001fff
    Memory behind bridge: b1a00000-b1afffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Subsystem: Intel Corporation Device 34de
    Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
        Address: fee00378  Data: 0000
        Masking: 00000002  Pending: 00000000
    Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag+ RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
            RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 256 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #1, Speed 5GT/s, Width x4, ASPM unknown, Latency
L0 <512ns, L1 <64us
            ClockPM- Surprise+ LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
        DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [150 v1] Access Control Services
        ACSCap:    SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
UpstreamFwd+ EgressCtrl- DirectTrans-
        ACSCtl:    SrcValid- TransBlk- ReqRedir- CmpltRedir-
UpstreamFwd- EgressCtrl- DirectTrans-
    Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0
Len=00c <?>
    Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 3 (rev 22) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR+ <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: b1900000-b19fffff
    Prefetchable memory behind bridge: 00000000b1c00000-00000000b1cfffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Subsystem: Intel Corporation Device 34de
    Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
        Address: fee00398  Data: 0000
        Masking: 00000002  Pending: 00000000
    Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag+ RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
            RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 256 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #3, Speed 5GT/s, Width x8, ASPM unknown, Latency
L0 <512ns, L1 <64us
            ClockPM- Surprise+ LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
        DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
        AERCap:    First Error Pointer: 0e, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [150 v1] Access Control Services
        ACSCap:    SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
UpstreamFwd+ EgressCtrl- DirectTrans-
        ACSCtl:    SrcValid- TransBlk- ReqRedir- CmpltRedir-
UpstreamFwd- EgressCtrl- DirectTrans-
    Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0
Len=00c <?>
    Kernel driver in use: pcieport

00:05.0 PCI bridge: Intel Corporation 5520/X58 I/O Hub PCI Express Root
Port 5 (rev 22) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Subsystem: Intel Corporation Device 34de
    Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
        Address: fee003b8  Data: 0000
        Masking: 00000002  Pending: 00000000
    Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag+ RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
            RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 256 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #5, Speed 5GT/s, Width x8, ASPM unknown, Latency
L0 <512ns, L1 <64us
            ClockPM- Surprise+ LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
        DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [150 v1] Access Control Services
        ACSCap:    SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
UpstreamFwd+ EgressCtrl- DirectTrans-
        ACSCtl:    SrcValid- TransBlk- ReqRedir- CmpltRedir-
UpstreamFwd- EgressCtrl- DirectTrans-
    Kernel driver in use: pcieport

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 7 (rev 22) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Subsystem: Intel Corporation Device 34de
    Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
        Address: fee003d8  Data: 0000
        Masking: 00000002  Pending: 00000000
    Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag+ RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
            RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 256 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #7, Speed 5GT/s, Width x8, ASPM unknown, Latency
L0 <512ns, L1 <64us
            ClockPM- Surprise+ LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
        DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [150 v1] Access Control Services
        ACSCap:    SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
UpstreamFwd+ EgressCtrl- DirectTrans-
        ACSCtl:    SrcValid- TransBlk- ReqRedir- CmpltRedir-
UpstreamFwd- EgressCtrl- DirectTrans-
    Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0
Len=00c <?>
    Kernel driver in use: pcieport

00:09.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 9 (rev 22) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Subsystem: Intel Corporation Device 34de
    Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
        Address: fee003f8  Data: 0000
        Masking: 00000002  Pending: 00000000
    Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag+ RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
            RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 256 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #9, Speed 5GT/s, Width x4, ASPM unknown, Latency
L0 <512ns, L1 <64us
            ClockPM- Surprise+ LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
        DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [150 v1] Access Control Services
        ACSCap:    SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
UpstreamFwd+ EgressCtrl- DirectTrans-
        ACSCtl:    SrcValid- TransBlk- ReqRedir- CmpltRedir-
UpstreamFwd- EgressCtrl- DirectTrans-
    Kernel driver in use: pcieport

00:0a.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 10 (rev 22) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Subsystem: Intel Corporation Device 34de
    Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
        Address: fee00418  Data: 0000
        Masking: 00000002  Pending: 00000000
    Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag+ RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
            RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 256 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #10, Speed 5GT/s, Width x4, ASPM unknown,
Latency L0 <512ns, L1 <64us
            ClockPM- Surprise+ LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
        DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [150 v1] Access Control Services
        ACSCap:    SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
UpstreamFwd+ EgressCtrl- DirectTrans-
        ACSCtl:    SrcValid- TransBlk- ReqRedir- CmpltRedir-
UpstreamFwd- EgressCtrl- DirectTrans-
    Kernel driver in use: pcieport

00:10.0 PIC: Intel Corporation 5520/5500/X58 Physical and Link Layer
Registers Port 0 (rev 22) (prog-if 00 [8259])
    Subsystem: Device 0086:00de
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Capabilities: [50] Vendor Specific Information: Len=ff <?>

00:10.1 PIC: Intel Corporation 5520/5500/X58 Routing and Protocol Layer
Registers Port 0 (rev 22) (prog-if 00 [8259])
    Subsystem: Device 0086:00de
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:11.0 PIC: Intel Corporation 5520/5500 Physical and Link Layer
Registers Port 1 (rev 22) (prog-if 00 [8259])
    Subsystem: Device 0086:00de
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Capabilities: [50] Vendor Specific Information: Len=ff <?>

00:11.1 PIC: Intel Corporation 5520/5500 Routing & Protocol Layer
Register Port 1 (rev 22) (prog-if 00 [8259])
    Subsystem: Device 0086:00de
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:13.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt
Controller (rev 22) (prog-if 20 [IO(X)-APIC])
    Subsystem: Device 0086:00de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Region 0: Memory at b1b24000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [6c] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management
Registers (rev 22) (prog-if 00 [8259])
    Subsystem: Device 0086:00de
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s, Latency
L0 unlimited, L1 unlimited
            ClockPM- Surprise+ LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB

00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch
Pad Registers (rev 22) (prog-if 00 [8259])
    Subsystem: Device 0086:00de
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s, Latency
L0 unlimited, L1 unlimited
            ClockPM- Surprise+ LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB

00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and
RAS Registers (rev 22) (prog-if 00 [8259])
    Subsystem: Device 0086:00de
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s, Latency
L0 unlimited, L1 unlimited
            ClockPM- Surprise+ LLActRep+ BwNot+
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB

00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
(rev 22) (prog-if 00 [8259])
    Subsystem: Device 0086:00de
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:15.0 PIC: Intel Corporation 5520/5500/X58 Trusted Execution
Technology Registers (rev 22) (prog-if 20 [IO(X)-APIC])
    Subsystem: Device 0086:00de
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:16.0 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 43
    Region 0: Memory at b1b00000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
        Vector table: BAR=0 offset=00002000
        PBA: BAR=0 offset=00003000
    Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ioatdma

00:16.1 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin B routed to IRQ 44
    Region 0: Memory at b1b04000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
        Vector table: BAR=0 offset=00002000
        PBA: BAR=0 offset=00003000
    Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ioatdma

00:16.2 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin C routed to IRQ 45
    Region 0: Memory at b1b08000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
        Vector table: BAR=0 offset=00002000
        PBA: BAR=0 offset=00003000
    Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ioatdma

00:16.3 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin D routed to IRQ 46
    Region 0: Memory at b1b0c000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
        Vector table: BAR=0 offset=00002000
        PBA: BAR=0 offset=00003000
    Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ioatdma

00:16.4 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 43
    Region 0: Memory at b1b10000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
        Vector table: BAR=0 offset=00002000
        PBA: BAR=0 offset=00003000
    Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ioatdma

00:16.5 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin B routed to IRQ 44
    Region 0: Memory at b1b14000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
        Vector table: BAR=0 offset=00002000
        PBA: BAR=0 offset=00003000
    Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ioatdma

00:16.6 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin C routed to IRQ 45
    Region 0: Memory at b1b18000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
        Vector table: BAR=0 offset=00002000
        PBA: BAR=0 offset=00003000
    Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ioatdma

00:16.7 System peripheral: Intel Corporation 5520/5500/X58 Chipset
QuickData Technology Device (rev 22)
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin D routed to IRQ 46
    Region 0: Memory at b1b1c000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
        Vector table: BAR=0 offset=00002000
        PBA: BAR=0 offset=00003000
    Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [e0] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ioatdma

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #4 (prog-if 00 [UHCI])
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 19
    Region 4: I/O ports at 20e0 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #5 (prog-if 00 [UHCI])
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 19
    Region 4: I/O ports at 20c0 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #6 (prog-if 00 [UHCI])
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 19
    Region 4: I/O ports at 20a0 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #2 (prog-if 20 [EHCI])
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 19
    Region 0: Memory at b1b22000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Debug port: BAR=1 offset=00a0
    Capabilities: [98] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: ehci_hcd

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express
Root Port 1 (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
    I/O behind bridge: 00003000-00003fff
    Memory behind bridge: b1d00000-b1efffff
    Prefetchable memory behind bridge: 00000000b1f00000-00000000b20fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
        LnkCap:    Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1,
Latency L0 <1us, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
            Slot #1, PowerLimit 25.000W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable+ ErrNon-Fatal+ ErrFatal+ PMEIntEna+
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee00438  Data: 0000
    Capabilities: [90] Subsystem: Intel Corporation Device 34de
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [180 v1] Root Complex Link
        Desc:    PortNumber=01 ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c000
    Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express
Root Port 5 (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
    I/O behind bridge: 00004000-00004fff
    Memory behind bridge: b1000000-b18fffff
    Prefetchable memory behind bridge: 00000000b0000000-00000000b0ffffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
        LnkCap:    Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
            Slot #5, PowerLimit 10.000W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
            Changed: MRL- PresDet+ LinkState+
        RootCtl: ErrCorrectable+ ErrNon-Fatal+ ErrFatal+ PMEIntEna+
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee00458  Data: 0000
    Capabilities: [90] Subsystem: Intel Corporation Device 34de
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [180 v1] Root Complex Link
        Desc:    PortNumber=05 ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c000
    Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express
Root Port 6 (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
    I/O behind bridge: 00005000-00005fff
    Memory behind bridge: b2100000-b22fffff
    Prefetchable memory behind bridge: 00000000b2300000-00000000b24fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
        LnkCap:    Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
            Slot #6, PowerLimit 10.000W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable+ ErrNon-Fatal+ ErrFatal+ PMEIntEna+
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee00478  Data: 0000
    Capabilities: [90] Subsystem: Intel Corporation Device 34de
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [180 v1] Root Complex Link
        Desc:    PortNumber=06 ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c000
    Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #1 (prog-if 00 [UHCI])
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 16
    Region 4: I/O ports at 2080 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #2 (prog-if 00 [UHCI])
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 16
    Region 4: I/O ports at 2060 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #3 (prog-if 00 [UHCI])
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 16
    Region 4: I/O ports at 2040 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #1 (prog-if 20 [EHCI])
    Subsystem: Intel Corporation Device 34de
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 16
    Region 0: Memory at b1b21000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Debug port: BAR=1 offset=00a0
    Capabilities: [98] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if
01 [Subtractive decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=32
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn+
    Capabilities: [50] Subsystem: Intel Corporation Device 34de

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface
Controller
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
AHCI Controller (prog-if 01 [AHCI 1.0])
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 58
    Region 0: I/O ports at 2108 [size=8]
    Region 1: I/O ports at 2114 [size=4]
    Region 2: I/O ports at 2100 [size=8]
    Region 3: I/O ports at 2110 [size=4]
    Region 4: I/O ports at 2020 [size=32]
    Region 5: Memory at b1b20000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
        Address: fee004b8  Data: 0000
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
    Capabilities: [b0] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin B routed to IRQ 18
    Region 0: Memory at b1b23000 (64-bit, non-prefetchable) [size=256]
    Region 4: I/O ports at 2000 [size=32]
    Kernel driver in use: i801_smbus

01:00.0 Ethernet controller: Intel Corporation 82575EB Gigabit Network
Connection (rev 02)
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin B routed to IRQ 40
    Region 0: Memory at b1a20000 (32-bit, non-prefetchable) [size=128K]
    Region 2: I/O ports at 1020 [size=32]
    Region 3: Memory at b1a44000 (32-bit, non-prefetchable) [size=16K]
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [60] MSI-X: Enable+ Count=10 Masked-
        Vector table: BAR=3 offset=00000000
        PBA: BAR=3 offset=00002000
    Capabilities: [a0] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 256 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1,
Latency L0 <4us, L1 <64us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
        DevCtl2: Completion Timeout: 4s to 13s, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [140 v1] Device Serial Number 00-15-17-ff-ff-d3-de-c9
    Kernel driver in use: igb

01:00.1 Ethernet controller: Intel Corporation 82575EB Gigabit Network
Connection (rev 02)
    Subsystem: Intel Corporation Device 34de
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 28
    Region 0: Memory at b1a00000 (32-bit, non-prefetchable) [size=128K]
    Region 2: I/O ports at 1000 [size=32]
    Region 3: Memory at b1a40000 (32-bit, non-prefetchable) [size=16K]
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [60] MSI-X: Enable+ Count=10 Masked-
        Vector table: BAR=3 offset=00000000
        PBA: BAR=3 offset=00002000
    Capabilities: [a0] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 256 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1,
Latency L0 <4us, L1 <64us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
        DevCtl2: Completion Timeout: 4s to 13s, TimeoutDis-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [140 v1] Device Serial Number 00-15-17-ff-ff-d3-de-c9
    Kernel driver in use: igb

02:00.0 Serial Attached SCSI controller: Atto Technology Device 0042
    Subsystem: Atto Technology Device 0043
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 24
    Region 0: Memory at b1900000 (64-bit, non-prefetchable) [size=64K]
    Region 2: Memory at b1910000 (64-bit, non-prefetchable) [size=64K]
    Region 4: Memory at b1930000 (32-bit, non-prefetchable) [size=64K]
    Region 5: Memory at b1920000 (32-bit, non-prefetchable) [size=64K]
    Expansion ROM at b1c00000 [disabled] [size=1M]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [70] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <1us,
L1 <8us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 256 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency
L0 <512ns, L1 <64us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB
    Capabilities: [ac] MSI-X: Enable+ Count=16 Masked-
        Vector table: BAR=0 offset=00002000
        PBA: BAR=0 offset=00004000
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr+
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
    Kernel driver in use: pm8001

08:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200e
[Pilot] ServerEngines (SEP1) (rev 02) (prog-if 00 [VGA controller])
    Subsystem: Intel Corporation Device 0101
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 11
    Region 0: Memory at b0000000 (32-bit, prefetchable) [size=16M]
    Region 1: Memory at b1800000 (32-bit, non-prefetchable) [size=16K]
    Region 2: Memory at b1000000 (32-bit, non-prefetchable) [size=8M]
    Expansion ROM at b1810000 [disabled] [size=64K]
    Capabilities: [dc] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [e4] Express (v1) Legacy Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <1us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency
L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [54] MSI: Enable- Count=1/1 Maskable- 64bit-
        Address: 00000000  Data: 0000

[8.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD6400AAKS-6 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi10 Channel: 00 Id: 00 Lun: 00
  Vendor: INTEL    Model: SR2612UR         Rev: R105
  Type:   Enclosure                        ANSI  SCSI revision: 05


[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

[X.] Other notes, patches, fixes, workarounds:
ATTOTech provide their own driver sources (esas2hba) - there are no
'pcieport' errors with it, also the SATA drives on the backplane are
visible / usable - but the whole system is unstable and randomly locks
up when the drives are in heavy use.



 Best regards, Danilo Godec


--------------040903050603060304030908
Content-Type: text/x-vcard; charset=utf-8;
 name="danilo_godec.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="danilo_godec.vcf"

YmVnaW46dmNhcmQNCmZuOkRhbmlsbyBHb2RlYw0KbjpHb2RlYztEYW5pbG8NCm9yZzpBZ2Vu
ZGEgT3BlblN5c3RlbXMNCmFkcjo7O1BvaG9yc2tlZ2EgYmF0YWxqb25hIDQ5O01hcmlib3I7
OzIwMDA7U2xvdmVuaWENCmVtYWlsO2ludGVybmV0OmRhbmlsby5nb2RlY0BhZ2VuZGEuc2kN
CnVybDpodHRwOi8vd3d3LmFnZW5kYS5zaS8NCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K

--------------040903050603060304030908--
