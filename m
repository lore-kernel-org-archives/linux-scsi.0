From: Michael Clark <michael@metaparadigm.com>
Subject: Lockup with Linux dpt_i20 driver
Date: Wed, 07 Apr 2004 10:28:06 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40736736.4000307@metaparadigm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gort.metaparadigm.com ([203.117.131.12]:17353 "EHLO
	gort.metaparadigm.com") by vger.kernel.org with ESMTP
	id S263457AbUDGC2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 22:28:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: deanna_bonds@adaptec.com, mark_salyzyn@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Chua Kian Teck <kianteck.chua@petrafoods.com.sg>

Hi Deanna, Mark,

My customer is having some trouble with 'livelocks' using the
dpt_i20 driver with an AIC-7902 firmware 1.62 (it is the latest
firmware I can find on Adaptec site - it shipped with this)
setup with a single 3 disk RAID-5.

The problem livelock happens on every kernel we have tried
from Redhat 2.4.20-20.7smp, 2.4.19-aa and 2.4.23-aa (which has
same driver as in mainline I believe). SMP and highmem disabled
(have tried with and without).

The problem is a classical IO freeze livelock and more recently
we have been getting task traces from SysReq-T on the serial
port. It only happens on the Samba servers which have pretty
busy IO.

This is the most interesting part of the trace (the rest follows):

Proc;  scsi_eh_0
 >>EIP; dff94000 <END_OF_CODE+1d3e6d81/????>   <=====
Trace; c01d3c8e <adpt_i2o_post_wait+ee/1b0>
Trace; c01d322b <adpt_abort+ab/110>
Trace; c01cc000 <scsi_try_to_abort_command+40/50>
Trace; c01cc79c <scsi_unjam_host+35c/a20>
Trace; c01ccfa7 <scsi_error_handler+147/1a0>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c01cce60 <scsi_error_handler+0/1a0>

Relevent parts of dmesg:

Adaptec I2O RAID controller 0 irq=10
      BAR0 e0842000 - size= 100000
      BAR1 e0943000 - size= 1000000
dpti: If you have a lot of devices this could take a few minutes.
dpti0: Reading the hardware resource table.
TID 008  Vendor: ADAPTEC      Device: AIC-7902     Rev: 00000001
TID 009  Vendor: ADAPTEC      Device: AIC-7902     Rev: 00000001
TID 516  Vendor: SDR     G    Device: GEM318P      Rev: 1   0
TID 517  Vendor: HP      C    Device: C7438A       Rev: V303
TID 521  Vendor: ADAPTEC R    Device: RAID-5       Rev: 3B05D
scsi0 : Vendor: Adaptec  Model: 2010S            FW:3B05
   Vendor: ADAPTEC   Model: RAID-5            Rev: 3B05
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: SDR       Model: GEM318P           Rev: 1
   Type:   Processor                          ANSI SCSI revision: 02
   Vendor: HP        Model: C7438A            Rev: V303
   Type:   Sequential-Access                  ANSI SCSI revision: 03
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 143372288 512-byte hdwr sectors (73407 MB)
Partition check:
  sda: sda1 sda2 sda3
Attached scsi generic sg1 at scsi0, channel 0, id 8, lun 0,  type 3


Here is the ksymoops of SysReq-T captured while the machine is
livelocked (pingable but all processes blocked on VM IO).

ksymoops 2.4.4 on i686 2.4.23aa2.  Options used
      -V (default)
      -k /proc/ksyms (default)
      -l /proc/modules (default)
      -o /lib/modules/2.4.23aa2/ (default)
      -m /boot/System.map-2.4.23aa2 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

init          S C159C000  4140     1      0 26978               (NOTLB)
Using defaults from ksymoops -t elf32-i386 -a i386
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (112) [<c0106f03>] (60)
keventd       S DFFEC000  6132     2      1             3       (L-TLB)
Call Trace:         [<c0121dcd>] (88) [<c0105000>] (20) [<c0105000>] (08)
   [<c01055c6>] (08) [<c0121cb0>] (04)
ksoftirqd_CPU S DFFE6000  6488     3      1             4     2 (L-TLB)
Call Trace:         [<c0105000>] (08) [<c0119ffe>] (12) [<c01055c6>] (08)
   [<c0119f90>] (04)
kswapd        S DFFE4000  5232     4      1             5     3 (L-TLB)
Call Trace:         [<c012fe58>] (12) [<c0106eb6>] (36) [<c0110018>] (12)
   [<c0105000>] (04) [<c01055c6>] (08) [<c012fdc0>] (04)
bdflush       S DFFE2000  5124     5      1             6     4 (L-TLB)
Call Trace:         [<c0112dfd>] (44) [<c013ba2a>] (12) [<c0105000>] (04)
   [<c01055c6>] (08) [<c013b980>] (04)
kupdated      D DFFE0000  4936     6      1             9     5 (L-TLB)
Call Trace:         [<c0105c7d>] (24) [<c014abc3>] (20) [<c0105dd0>] (16)
   [<c013d130>] (12) [<c013b84e>] (12) [<c013bb58>] (148) [<c0106eb6>] (24)
   [<c0105000>] (20) [<c0105000>] (08) [<c01055c6>] (08) [<c013ba30>] (04)
scsi_eh_0     S DFF94000  6336     9      1            10     6 (L-TLB)
Call Trace:         [<c01d3c8e>] (84) [<c01d322b>] (72) [<c01cc000>] (12)
   [<c01cc79c>] (48) [<c01ccfa7>] (48) [<c01055c6>] (08) [<c01cce60>] (04)
kjournald     D C2340000  4768    10      1           124     9 (L-TLB)
Call Trace:         [<c01384f8>] (12) [<c019b5f3>] (48) [<c016c7e5>] (252)
   [<c0112b7e>] (08) [<c0112b8a>] (72) [<c016ebb6>] (24) [<c016ea80>] (24)
   [<c01055c6>] (08) [<c016eaa0>] (04)
mdrecoveryd   S C2BCC000  2640   124      1           131    10 (L-TLB)
Call Trace:         [<c2bd4296>] (32) [<c0106eb6>] (52) [<c01055c6>] (08)
   [<c2bd41c0>] (04)
kjournald     D C2468000   120   131      1           133   124 (L-TLB)
Call Trace:         [<c01384f8>] (12) [<c019b5f3>] (48) [<c016c7e5>] (52)
   [<c01a655c>] (200) [<c0112b7e>] (08) [<c0112b8a>] (72) [<c016ebb6>] (24)
   [<c016ea80>] (24) [<c01055c6>] (08) [<c016eaa0>] (04)
loop0         S C2A4A000     0   133      1           134   131 (L-TLB)
Call Trace:         [<c0105d2d>] (52) [<c0105ddb>] (12) [<c2a7d932>] (08)
   [<c2a7c9b0>] (40) [<c01055c6>] (08) [<c2a7c9b0>] (04)
loop1         S C2B72000     0   134      1           135   133 (L-TLB)
Call Trace:         [<c0105d2d>] (52) [<c0105ddb>] (12) [<c2a7d932>] (08)
   [<c2a7c9b0>] (40) [<c01055c6>] (08) [<c2a7c9b0>] (04)
loop2         S C2AF2000     0   135      1           521   134 (L-TLB)
Call Trace:         [<c0105d2d>] (52) [<c0105ddb>] (12) [<c2a7d932>] (08)
   [<c2a7c9b0>] (40) [<c01055c6>] (08) [<c2a7c9b0>] (04)
syslogd       D C2F70000     0   521      1           526   135 (NOTLB)
Call Trace:         [<c0112ecd>] (44) [<c016f01a>] (12) [<c016b46d>] (32)
   [<c016b4aa>] (12) [<c0169ac1>] (24) [<c0160d2f>] (16) [<c01e90f4>] (16)
   [<c0138a61>] (40) [<c0106f03>] (60)
klogd         S C2FAC000     0   526      1           614   521 (NOTLB)
Call Trace:         [<c011da54>] (20) [<c01ea99c>] (24) [<c0227798>] (76)
   [<c02280ab>] (64) [<c01e7b9f>] (28) [<c0111656>] (32) [<c0112b8a>] (24)
   [<c01e7db7>] (68) [<c01376a6>] (20) [<c013719d>] (20) [<c0119432>] (28)
   [<c0106f03>] (60)
apcupsd       S C2E66000     0   614      1  1053     724   526 (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (16) [<c0183485>] (44) [<c01376f2>] (52)
   [<c0106f03>] (60)
named         S C33B8000     0   724      1   725     749   614 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
named         S C3312000  5336   725    724   729               (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c014675d>] (32)
   [<c014695e>] (48) [<c0145c00>] (32) [<c0106f03>] (60)
named         S C3310000  4556   727    725           728       (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
named         S C3392000  2640   728    725           729   727 (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c011dbe8>] (24)
   [<c0119533>] (40) [<c0106f03>] (60)
named         S C2C0A000  4940   729    725                 728 (NOTLB)
Call Trace:         [<c011da54>] (20) [<c01e7fbf>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (60) [<c0137602>] (52) [<c0106f03>] (60)
sshd          S C30D0000  2640   749      1 20326     783   724 (NOTLB)
Call Trace:         [<c011da54>] (12) [<c0140723>] (32) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (112) [<c0106f03>] (60)
lpd           S C37D4000  5444   783      1           802   749 (NOTLB)
Call Trace:         [<c011da54>] (12) [<c0140723>] (32) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (16) [<c011f5d9>] (44) [<c0137602>] (52)
   [<c0106f03>] (60)
ntpd          S C378A000  2640   802      1           820   783 (NOTLB)
Call Trace:         [<c011da54>] (20) [<c01e7fbf>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (24) [<c01062b5>] (24) [<c01063ae>] (64)
   [<c0106f03>] (60)
gpm           S C371A000  5304   820      1           839   802 (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (16) [<c011f5d9>] (96) [<c0106f03>] (60)
crond         S C36EA000  5616   839      1 20333     887   820 (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c011dbe8>] (20)
   [<c011ec2a>] (44) [<c0106f03>] (60)
atd           S C3682000  5444   887      1           912   839 (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c011dbe8>] (20)
   [<c011ec2a>] (44) [<c0106f03>] (60)
cupsd         D C3600000  5120   912      1           971   887 (NOTLB)
Call Trace:         [<c01384f8>] (60) [<c016a73c>] (28) [<c0164db6>] (04)
   [<c0164e11>] (36) [<c016aba0>] (32) [<c01669bd>] (24) [<c0165104>] (08)
   [<c0165115>] (32) [<c0165217>] (44) [<c016705d>] (52) [<c0142ec2>] (40)
   [<c0142f98>] (56) [<c0106f03>] (60)
cyrus-master  S C3408000  2640   971      1 20316     975   912 (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (112) [<c0106f03>] (60)
postfix-maste S C3468000     0   975      1 20325    1015   971 (NOTLB)
Call Trace:         [<c011da54>] (20) [<c01ea99c>] (24) [<c0227798>] (76)
   [<c02280ab>] (64) [<c01e7b9f>] (28) [<c0130814>] (56) [<c01e8950>] (76)
   [<c0106b1d>] (36) [<c0106dc1>] (60) [<c014062d>] (12) [<c0119101>] (20)
   [<c01e898d>] (28) [<c01e90b1>] (56) [<c0106f03>] (60)
qmgr          D C3982000     0  1008    975          5659       (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c0160b88>] (104) [<c013ea9f>] (36) [<c0145190>] (12)
   [<c0145730>] (20) [<c014587a>] (08) [<c0145730>] (68) [<c0106f03>] (60)
sulogin       D C3E46000    16  1015      1          1017   975 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (16)
   [<c01246a3>] (48) [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40)
   [<c014a6ce>] (20) [<c014bdd4>] (12) [<c01419c1>] (36) [<c012827c>] (16)
   [<c0128140>] (36) [<c0141c9b>] (16) [<c013f206>] (48) [<c0157f0e>] (116)
   [<c016b475>] (28) [<c01652c3>] (12) [<c01242dc>] (24) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c0127eef>] (108) [<c0157c30>] (12) [<c013fa41>] (68)
   [<c013fccc>] (328) [<c0140e2e>] (20) [<c0105a20>] (28) [<c0106f03>] (60)
mingetty      S C39C6000     0  1017      1          1018  1015 (NOTLB)
Call Trace:         [<c011da54>] (44) [<c01855f9>] (104) [<c01819fc>] (20)
   [<c012639f>] (28) [<c01375b6>] (20) [<c013719d>] (20) [<c01263e9>] (28)
   [<c0106f03>] (60)
mingetty      S C3E2E000     0  1018      1          1019  1017 (NOTLB)
Call Trace:         [<c011da54>] (44) [<c01855f9>] (104) [<c01819fc>] (20)
   [<c012639f>] (28) [<c01375b6>] (20) [<c013719d>] (20) [<c01263e9>] (28)
   [<c0106f03>] (60)
mingetty      S C3E34000     0  1019      1          1020  1018 (NOTLB)
Call Trace:         [<c011da54>] (44) [<c01855f9>] (104) [<c01819fc>] (20)
   [<c012639f>] (28) [<c01375b6>] (20) [<c013719d>] (20) [<c01263e9>] (28)
   [<c0106f03>] (60)
mingetty      S C3E4A000     0  1020      1          1021  1019 (NOTLB)
Call Trace:         [<c011da54>] (44) [<c01855f9>] (104) [<c01819fc>] (20)
   [<c012639f>] (28) [<c01375b6>] (20) [<c013719d>] (20) [<c01263e9>] (28)
   [<c0106f03>] (60)
mingetty      S C3E02000    32  1021      1          1026  1020 (NOTLB)
Call Trace:         [<c011da54>] (44) [<c01855f9>] (104) [<c01819fc>] (20)
   [<c012639f>] (28) [<c01375b6>] (20) [<c013719d>] (20) [<c01263e9>] (28)
   [<c0106f03>] (60)
saslauthd     S C2A3C000     0  1026      1  1032    1033  1021 (NOTLB)
Call Trace:         [<c0147640>] (60) [<c01e7ec3>] (20) [<c014769c>] (28)
   [<c0147b39>] (32) [<c014a56d>] (60) [<c01488cc>] (64) [<c01448f8>] (28)
   [<c0144a71>] (36) [<c0106f03>] (60)
saslauthd     S C3D04000  4580  1029   1026          1030       (NOTLB)
Call Trace:         [<c0147640>] (60) [<c01e7ec3>] (20) [<c014769c>] (28)
   [<c0147b39>] (32) [<c014a56d>] (60) [<c01488cc>] (64) [<c01448f8>] (28)
   [<c0144a71>] (36) [<c0106f03>] (60)
saslauthd     S C3CFE000  4484  1030   1026          1031  1029 (NOTLB)
Call Trace:         [<c0147640>] (60) [<c01e7ec3>] (20) [<c014769c>] (28)
   [<c0147b39>] (32) [<c014a56d>] (60) [<c01488cc>] (64) [<c01448f8>] (28)
   [<c0144a71>] (36) [<c0106f03>] (60)
saslauthd     S C3CFA000  4620  1031   1026          1032  1030 (NOTLB)
Call Trace:         [<c011da54>] (44) [<c01ec736>] (84) [<c01ec840>] (36)
   [<c0227bee>] (36) [<c01e8673>] (32) [<c014a56d>] (64) [<c014892f>] (72)
   [<c01e9050>] (32) [<c0144a7d>] (20) [<c0106f03>] (60)
saslauthd     S C3CF2000  4572  1032   1026                1031 (NOTLB)
Call Trace:         [<c0147640>] (60) [<c01e7ec3>] (20) [<c014769c>] (28)
   [<c0147b39>] (32) [<c014a56d>] (60) [<c01488cc>] (64) [<c01448f8>] (28)
   [<c0144a71>] (36) [<c0106f03>] (60)
nmbd          D C480C000  4216  1033      1  1034    1036  1026 (NOTLB)
Call Trace:         [<c01384f8>] (60) [<c019b7a6>] (48) [<c0165918>] (80)
   [<c0165b70>] (32) [<c0141af9>] (28) [<c0165b99>] (24) [<c0141050>] (20)
   [<c0141e2a>] (28) [<c01420c7>] (44) [<c01465ee>] (28) [<c0136da6>] (56)
   [<c01370e4>] (24) [<c0106f03>] (60)
nmbd          S C4FFE000  6288  1034   1033                     (NOTLB)
Call Trace:         [<c01401db>] (64) [<c011f2d0>] (20) [<c01402c4>] (32)
   [<c01375b6>] (68) [<c0106f03>] (60)
smbd          D C4EDE000  5100  1036      1 20307    1037  1033 (NOTLB)
Call Trace:         [<c016a981>] (44) [<c01a6482>] (20) [<c016aba0>] (32)
   [<c0165171>] (64) [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40)
   [<c014a6ce>] (20) [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44)
   [<c0140e2e>] (20) [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40)
   [<c0106f03>] (60)
clamd         S C4E48000  5444  1037      1  1038    1040  1036 (NOTLB)
Call Trace:         [<c011da54>] (44) [<c01ec736>] (84) [<c01ec840>] (36)
   [<c0227bee>] (36) [<c01e8673>] (104) [<c014be17>] (12) [<c014062d>] (52)
   [<c01e9050>] (52) [<c0106f03>] (60)
clamd         S C4E1E000  5208  1038   1037  1039               (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c014675d>] (32)
   [<c014695e>] (48) [<c0145c00>] (32) [<c0106f03>] (60)
clamd         S C39C0000  4676  1039   1038                     (NOTLB)
Call Trace:         [<c011da54>] (20) [<c01ea99c>] (24) [<c0227798>] (76)
   [<c02280ab>] (32) [<c0165104>] (08) [<c0165115>] (24) [<c01e7b9f>] (28)
   [<c016b475>] (28) [<c01652c3>] (28) [<c01e8950>] (88) [<c0165b70>] (12)
   [<c0141050>] (20) [<c013ea9f>] (84) [<c01e898d>] (28) [<c01e90b1>] (56)
   [<c0106f03>] (60)
slapd         S C4C96000  4916  1040      1  1041    1046  1037 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C53AA000  5484  1041   1040  2114               (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c014675d>] (32)
   [<c014695e>] (48) [<c0145c00>] (32) [<c0106f03>] (60)
slapd         S C53A8000  2640  1042   1041          1044       (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C4DBA000     0  1044   1041          1045  1042 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C5D86000  2640  1045   1041          1069  1044 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
idled         S C63FA000  5072  1046      1          1050  1040 (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (32) [<c0136da6>] (60) [<c0137106>] (20)
   [<c0106f03>] (60)
amavisd       S C6988000  2640  1050      1  9721   26978  1046 (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (56) [<c0119b9b>] (56) [<c0106f03>] (60)
apcupsd       S C6DF6000  5432  1053    614  1054               (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c014675d>] (32)
   [<c014695e>] (48) [<c0145c00>] (32) [<c0106f03>] (60)
apcupsd       S C6DF2000  5936  1054   1053                     (NOTLB)
Call Trace:         [<c011da54>] (44) [<c02065cd>] (84) [<c0206715>] (28)
   [<c021ee4a>] (32) [<c01e8673>] (44) [<c01e7900>] (28) [<c022702c>] (28)
   [<c011f2d0>] (24) [<c011f5c3>] (44) [<c01e9050>] (52) [<c0106f03>] (60)
slapd         S C71CA000  4820  1069   1041          1086  1045 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C76BA000  4844  1086   1041          1098  1069 (NOTLB)
Call Trace:         [<c011da54>] (20) [<c01ea99c>] (24) [<c0227798>] (76)
   [<c02280ab>] (64) [<c01e7b9f>] (24) [<c0165115>] (60) [<c01e8950>] (80)
   [<c0106dc1>] (72) [<c01e7db7>] (16) [<c011f2d0>] (36) [<c01e898d>] (28)
   [<c01e90b1>] (56) [<c0106f03>] (60)
slapd         S C7686000  2640  1098   1041          1116  1086 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C761E000  4752  1116   1041          1134  1098 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C75D0000  4776  1134   1041          1146  1116 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C758E000  2640  1146   1041          1163  1134 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C758A000  2640  1163   1041          1175  1146 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C756C000     0  1175   1041          1193  1163 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C70FA000  4752  1193   1041          1200  1175 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C757E000   144  1200   1041          1215  1193 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C70EC000     0  1215   1041          1227  1200 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C70E2000     0  1227   1041          1234  1215 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C753C000  2640  1234   1041          1246  1227 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7532000  4772  1246   1041          1254  1234 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C752A000  4900  1254   1041          1261  1246 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7526000  2640  1261   1041          1273  1254 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C751C000  4752  1273   1041          1283  1261 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7516000  2640  1283   1041          1288  1273 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7514000  2640  1288   1041          1305  1283 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7506000  2640  1305   1041          1310  1288 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7504000  2640  1310   1041          1320  1305 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C74F8000  4820  1320   1041          1328  1310 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C74F2000  4876  1328   1041          1913  1320 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7B66000  2640  1913   1041          1920  1328 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7A38000  4876  1920   1041          1925  1913 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79C8000  4772  1925   1041          1930  1920 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79E4000     0  1930   1041          1937  1925 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79F2000   144  1937   1041          1942  1930 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79DC000     0  1942   1041          1949  1937 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79EA000   144  1949   1041          1954  1942 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79D6000     0  1954   1041          1961  1949 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7A04000   144  1961   1041          1966  1954 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79AE000  4808  1966   1041          1973  1961 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79FC000   144  1973   1041          1978  1966 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79FA000   144  1978   1041          1985  1973 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79EC000  1168  1985   1041          1990  1978 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79F4000   144  1990   1041          1997  1985 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79B6000   144  1997   1041          2002  1990 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79B4000   144  2002   1041          2012  1997 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7B36000   144  2012   1041          2017  2002 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7992000   144  2017   1041          2024  2012 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7B28000   144  2024   1041          2029  2017 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C798E000  2640  2029   1041          2050  2024 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C79C0000     0  2050   1041          2067  2029 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7B2C000   144  2067   1041          2088  2050 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7AFE000     0  2088   1041          2109  2067 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7988000  2640  2109   1041          2114  2088 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
slapd         S C7B00000     0  2114   1041                2109 (NOTLB)
Call Trace:         [<c010605b>] (32) [<c0106f03>] (60)
mingetty      D C39EA000     0 26978      1                1050 (NOTLB)
Call Trace:         [<c012748c>] (48) [<c0127d88>] (60) [<c012827c>] (16)
   [<c0128140>] (52) [<c01375b6>] (68) [<c0106f03>] (60)
smbd          D CDCEA000     0 30569   1036         17553       (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D D874E000     0 17553   1036         17554 30569 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (20)
   [<c0141050>] (44) [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40)
   [<c014a6ce>] (20) [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44)
   [<c0140e2e>] (20) [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40)
   [<c0106f03>] (60)
smbd          D D80EC000     0 17554   1036         18377 17553 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (16)
   [<c01eab6b>] (20) [<c02057b5>] (28) [<c01700d7>] (28) [<c0165208>] (44)
   [<c01652b8>] (12) [<c01281ab>] (28) [<c014a6ce>] (20) [<c014bdd4>] (12)
   [<c0127eef>] (60) [<c012827c>] (16) [<c0128140>] (52) [<c01375b6>] (40)
   [<c0137509>] (28) [<c0106f03>] (60)
imapd         S D517E000     0 18371    971         19261       (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (60) [<c01376f2>] (52) [<c0106f03>] (60)
smbd          D D4F6A000    32 18377   1036         18379 17554 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D D2F8E000     0 18379   1036         18386 18377 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D C7C4E000     0 18386   1036         19203 18379 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D DBB8A000     0 19203   1036         19204 18386 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (16)
   [<c01eab6b>] (20) [<c02057b5>] (28) [<c01700d7>] (28) [<c0165208>] (44)
   [<c01652b8>] (12) [<c01281ab>] (28) [<c014a6ce>] (20) [<c014bdd4>] (12)
   [<c0127eef>] (60) [<c012827c>] (16) [<c0128140>] (52) [<c01375b6>] (68)
   [<c0106f03>] (60)
smbd          D DF91A000    16 19204   1036         19211 19203 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D D8E10000     0 19211   1036         19266 19204 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
imapd         D C63B8000     0 19261    971         19264 18371 (NOTLB)
Call Trace:         [<c0105c7d>] (24) [<c0140e2e>] (20) [<c0105dd0>] (16)
   [<c014434e>] (48) [<c0106f03>] (60)
imapd         D D5A88000     0 19264    971         20987 19261 (NOTLB)
Call Trace:         [<c0105c7d>] (44) [<c0105dd0>] (16) [<c0161e47>] (12)
   [<c0128a09>] (40) [<c01700d7>] (24) [<c016a1ab>] (24) [<c016a2bd>] (20)
   [<c0166276>] (48) [<c0141fa8>] (20) [<c0141e02>] (28) [<c014212f>] (52)
   [<c0141050>] (24) [<c0136da6>] (56) [<c01370e4>] (24) [<c0106f03>] (60)
smbd          D C713A000     0 19266   1036         19277 19211 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D D06E2000     0 19277   1036         20099 19266 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D DEDF4000     0 20099   1036         20103 19277 (NOTLB)
Call Trace:         [<c01384f8>] (08) [<c0139308>] (52) [<c016a73c>] (40)
   [<c016bb89>] (28) [<c016aba0>] (32) [<c0161887>] (60) [<c01700d7>] (24)
   [<c016a1ab>] (24) [<c016a2bd>] (20) [<c0166276>] (48) [<c0141fa8>] (20)
   [<c0141e02>] (28) [<c014212f>] (48) [<c0145190>] (28) [<c0136da6>] (56)
   [<c01370e4>] (24) [<c0106f03>] (60)
smbd          D CE6E4000     0 20103   1036         20104 20099 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D D5DA4000     0 20104   1036         20116 20103 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D C68A2000     0 20116   1036         20986 20104 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D D42F2000     8 20986   1036         21817 20116 (NOTLB)
Call Trace:         [<c0105c7d>] (44) [<c0105dd0>] (16) [<c0161e47>] (52)
   [<c01700d7>] (24) [<c016a1ab>] (24) [<c016a2bd>] (20) [<c0166276>] (24)
   [<c0120cde>] (24) [<c0141fa8>] (20) [<c0141e02>] (28) [<c014212f>] (48)
   [<c0145190>] (28) [<c0136da6>] (56) [<c01370e4>] (24) [<c0106f03>] (60)
imapd         D CD57C000     4 20987    971         23479 19264 (NOTLB)
Call Trace:         [<c0105c7d>] (24) [<c0140e2e>] (20) [<c0105dd0>] (16)
   [<c014434e>] (48) [<c0106f03>] (60)
smbd          D CCB8A000     0 21817   1036         25143 20986 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
imapd         D CE4E0000     0 23479    971          2584 20987 (NOTLB)
Call Trace:         [<c0105c7d>] (24) [<c0140e2e>] (20) [<c0105dd0>] (16)
   [<c014434e>] (48) [<c0106f03>] (60)
   [<c0140e2e>] (20) [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40)
   [<c0106f03>] (60)
smbd          D D823E000    12   838   1036         25269 25143 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
imapd         D D6D36000     4  2584    971         20227 23479 (NOTLB)
Call Trace:         [<c0112ecd>] (44) [<c016f01a>] (12) [<c016b46d>] (32)
   [<c016b4aa>] (12) [<c0169ac1>] (24) [<c0160d2f>] (20) [<c01376f2>] (12)
   [<c0138a61>] (40) [<c0106f03>] (60)
smbd          D D7266000     0 25269   1036         15183   838 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbd          D CC8D6000     0 15183   1036         15185 25269 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (20)
   [<c0141050>] (44) [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40)
   [<c014a6ce>] (20) [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44)
   [<c0140e2e>] (20) [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40)
   [<c0106f03>] (60)
smbd          D D2390000     0 15185   1036         16020 15183 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (20)
   [<c0141050>] (44) [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40)
   [<c014a6ce>] (20) [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44)
   [<c0140e2e>] (20) [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40)
   [<c0106f03>] (60)
smbd          D C9C24000     0 16020   1036         18522 15185 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
pickup        D DB7C2000     0  5659    975         20324  1008 (NOTLB)
Call Trace:         [<c01384f8>] (04) [<c016297c>] (56) [<c016a73c>] (28)
   [<c0139588>] (40) [<c016aba0>] (32) [<c0165171>] (44) [<c0160801>] (20)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c0160b88>] (52) [<c016b475>] (52) [<c013ea9f>] (36)
   [<c0145190>] (12) [<c0145730>] (20) [<c014587a>] (08) [<c0145730>] (68)
   [<c0106f03>] (60)
amavisd       S C3B78000  4072  6496   1050          9721       (NOTLB)
Call Trace:         [<c011da54>] (20) [<c01e7fbf>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (112) [<c0106f03>] (60)
amavisd       S DC754000     4  9721   1050                6496 (NOTLB)
Call Trace:         [<c0147640>] (80) [<c014769c>] (28) [<c01479fb>] (48)
   [<c014862d>] (28) [<c0106f03>] (60)
smbd          D D223C000     0 12940   1036         17812 27637 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
sshd          S C3490000     0 17753    749 17754   20257       (NOTLB)
Call Trace:         [<c011da54>] (20) [<c01e7fbf>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (60) [<c01376f2>] (52) [<c0106f03>] (60)
bash          S C296A000     0 17754  17753 20318               (NOTLB)
Call Trace:         [<c0118f81>] (84) [<c0106f03>] (60)
smbd          D DE4C6000     0 17812   1036         20307 12940 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
imapd         S D6DA4000     0 17814    971         20300  2313 (NOTLB)
Call Trace:         [<c011dad3>] (20) [<c011da30>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (60) [<c01376f2>] (52) [<c0106f03>] (60)
sshd          S DB582000     0 20257    749 20258   20319 17753 (NOTLB)
Call Trace:         [<c011da54>] (20) [<c01e7fbf>] (24) [<c0145f80>] (28)
   [<c0145c00>] (32) [<c014640a>] (16) [<c0183485>] (96) [<c0106f03>  20257 20314               (NOTLB)
Call Trace:         [<c0118f81>] (84) [<c0106f03>] (60)
imapd         D D8BB6000   564 20300    971         20316 17814 (NOTLB)
Call Trace:         [<c0105c7d>] (24) [<c0140e2e>] (20) [<c0105dd0>] (16)
   [<c014434e>] (48) [<c0106f03>] (60)
smbd          D D954C000   144 20307   1036               17812 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (24) [<c0125fba>] (44) [<c0140e2e>] (20)
   [<c0141c9b>] (16) [<c0141ee4>] (20) [<c013ead4>] (40) [<c0106f03>] (60)
smbstatus     D D16F4000     0 20314  20258                     (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (24)
   [<c01700d7>] (40) [<c016a05f>] (28) [<c0165208>] (44) [<c01652b8>] (20)
   [<c0146d40>] (20) [<c014a6ce>] (20) [<c014bdd4>] (12) [<c0127eef>] (60)
   [<c012827c>] (16) [<c0128140>] (52) [<c01375b6>] (20) [<c0140e2e>] (28)
   [<c0137106>] (20) [<c0106f03>] (60)
cyrus-master  D CF4C2000   144 20316    971               20300 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c01419c1>] (36) [<c012827c>] (16) [<c0128140>] (36)
   [<c0141c9b>] (16) [<c013f206>] (48) [<c0157f0e>] (116) [<c016b475>] (28)
   [<c01652c3>] (36) [<c014a6ce>] (20) [<c014bdd4>] (12) [<c0127eef>] (108)
   [<c0157c30>] (12) [<c013fa41>] (68) [<c013fccc>] (328) [<c0140e2e>] (20)
   [<c0105a20>] (28) [<c0106f03>] (60)
bash          D DC376000     0 20317  17754         20318       (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (16) [<c01242dc>] (24)
   [<c014a6ce>] (20) [<c014bdd4>] (12) [<c0127eef>] (40) [<c0141a0e>] (20)
   [<c012827c>] (16) [<c0128140>] (12) [<c0136e8f>] (40) [<c013f2ec>] (36)
   [<c013f7f4>] (28) [<c013fc59>] (324) [<c0140e2e>] (20) [<c0105a20>] (28)
   [<c0106f03>] (60)
bash          D D66B0000     0 20318  17754               20317 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (40) [<c014a6ce>] (20)
   [<c014bdd4>] (12) [<c0127eef>] (40) [<c0141a0e>] (20) [<c012827c>] (16)
   [<c0128140>] (12) [<c0136e8f>] (40) [<c013f2ec>] (36) [<c013f7f4>] (28)
   [<c013fc59>] (324) [<c0140e2e>] (20) [<c0105a20>] (28) [<c0106f03>] (60)
sshd          D CBFC6000     0 20319    749         20326 20257 (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
   [<c01700d7>] (28) [<c0165208>] (44) [<c01652b8>] (12) [<c01281ab>] (28)
   [<c014a6ce>] (20) [<c014bdd4>] (12) [<c0127eef>] (60) [<c012827c>] (16)
   [<c0128140>] (52) [<c01375b6>] (68) [<c0106f03>] (60)
crond         D DA1F4000     0 20320    839 20321   20322       (NOTLB)
Call Trace:         [<c0112d8c>] (80) [<c01150d3>] (56) [<c01059e8>] (20)
   [<c0106f03>] (60)
crond         D DCE5C000    28 20321  20320                     (NOTLB)
Call Trace:         [<c016a981>] (64) [<c016aba0>] (32) [<c0165171>] (64)
Warning (Oops_read): Code line not seen, dumping what data is available

Proc;  init
 >>EIP; c159c000 <_end+12a3c8c/2893c8c>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c0106f03 <system_call+33/38>
Proc;  keventd
 >>EIP; dffec000 <END_OF_CODE+1d43ed81/????>   <=====
Trace; c0121dcd <context_thread+11d/1d0>
Trace; c0105000 <_stext+0/0>
Trace; c0105000 <_stext+0/0>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c0121cb0 <context_thread+0/1d0>
Proc;  ksoftirqd_CPU
 >>EIP; dffe6000 <END_OF_CODE+1d438d81/????>   <=====
Trace; c0105000 <_stext+0/0>
Trace; c0119ffe <ksoftirqd+6e/c0>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c0119f90 <ksoftirqd+0/c0>
Proc;  kswapd
 >>EIP; dffe4000 <END_OF_CODE+1d436d81/????>   <=====
Trace; c012fe58 <kswapd+98/d0>
Trace; c0106eb6 <ret_from_fork+6/20>
Trace; c0110018 <mtrr_del_page+78/1d0>
Trace; c0105000 <_stext+0/0>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c012fdc0 <kswapd+0/d0>
Proc;  bdflush
 >>EIP; dffe2000 <END_OF_CODE+1d434d81/????>   <=====
Trace; c0112dfd <interruptible_sleep_on+3d/60>
Trace; c013ba2a <bdflush+aa/b0>
Trace; c0105000 <_stext+0/0>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c013b980 <bdflush+0/b0>
Proc;  kupdated
 >>EIP; dffe0000 <END_OF_CODE+1d432d81/????>   <=====
Trace; c0105c7d <__down+5d/b0>
Trace; c014abc3 <sync_unlocked_inodes+163/190>
Trace; c0105dd0 <__down_failed+8/c>
Trace; c013d130 <.text.lock.super+19/59>
Trace; c013b84e <sync_old_buffers+e/70>
Trace; c013bb58 <kupdate+128/160>
Trace; c0106eb6 <ret_from_fork+6/20>
Trace; c0105000 <_stext+0/0>
Trace; c0105000 <_stext+0/0>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c013ba30 <kupdate+0/160>
Proc;  scsi_eh_0
 >>EIP; dff94000 <END_OF_CODE+1d3e6d81/????>   <=====
Trace; c01d3c8e <adpt_i2o_post_wait+ee/1b0>
Trace; c01d322b <adpt_abort+ab/110>
Trace; c01cc000 <scsi_try_to_abort_command+40/50>
Trace; c01cc79c <scsi_unjam_host+35c/a20>
Trace; c01ccfa7 <scsi_error_handler+147/1a0>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c01cce60 <scsi_error_handler+0/1a0>
Proc;  kjournald
 >>EIP; c2340000 <_end+2047c8c/2893c8c>   <=====
Trace; c01384f8 <__wait_on_buffer+78/a0>
Trace; c019b5f3 <__submit_bh+53/f0>
Trace; c016c7e5 <journal_commit_transaction+895/1044>
Trace; c0112b7e <do_schedule+21e/250>
Trace; c0112b8a <do_schedule+22a/250>
Trace; c016ebb6 <kjournald+116/1c0>
Trace; c016ea80 <commit_timeout+0/10>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c016eaa0 <kjournald+0/1c0>
Proc;  mdrecoveryd
 >>EIP; c2bcc000 <END_OF_CODE+1ed81/????>   <=====
Trace; c2bd4296 <END_OF_CODE+27017/????>
Trace; c0106eb6 <ret_from_fork+6/20>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c2bd41c0 <END_OF_CODE+26f41/????>
Proc;  kjournald
 >>EIP; c2468000 <_end+216fc8c/2893c8c>   <=====
Trace; c01384f8 <__wait_on_buffer+78/a0>
Trace; c019b5f3 <__submit_bh+53/f0>
Trace; c016c7e5 <journal_commit_transaction+895/1044>
Trace; c01a655c <e1000_alloc_rx_buffers+cc/100>
Trace; c0112b7e <do_schedule+21e/250>
Trace; c0112b8a <do_schedule+22a/250>
Trace; c016ebb6 <kjournald+116/1c0>
Trace; c016ea80 <commit_timeout+0/10>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c016eaa0 <kjournald+0/1c0>
Proc;  loop0
 >>EIP; c2a4a000 <_end+2751c8c/2893c8c>   <=====
Trace; c0105d2d <__down_interruptible+5d/c0>
Trace; c0105ddb <__down_failed_interruptible+7/c>
Trace; c2a7d932 <_end+27855be/2893c8c>
Trace; c2a7c9b0 <_end+278463c/2893c8c>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c2a7c9b0 <_end+278463c/2893c8c>
Proc;  loop1
 >>EIP; c2b72000 <_end+2879c8c/2893c8c>   <=====
Trace; c0105d2d <__down_interruptible+5d/c0>
Trace; c0105ddb <__down_failed_interruptible+7/c>
Trace; c2a7d932 <_end+27855be/2893c8c>
Trace; c2a7c9b0 <_end+278463c/2893c8c>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c2a7c9b0 <_end+278463c/2893c8c>
Proc;  loop2
 >>EIP; c2af2000 <_end+27f9c8c/2893c8c>   <=====
Trace; c0105d2d <__down_interruptible+5d/c0>
Trace; c0105ddb <__down_failed_interruptible+7/c>
Trace; c2a7d932 <_end+27855be/2893c8c>
Trace; c2a7c9b0 <_end+278463c/2893c8c>
Trace; c01055c6 <arch_kernel_thread+26/30>
Trace; c2a7c9b0 <_end+278463c/2893c8c>
Proc;  syslogd
 >>EIP; c2f70000 <END_OF_CODE+3c2d81/????>   <=====
Trace; c0112ecd <sleep_on+3d/60>
Trace; c016f01a <log_wait_commit+3a/50>
Trace; c016b46d <journal_stop+17d/190>
Trace; c016b4aa <journal_force_commit+2a/30>
Trace; c0169ac1 <ext3_force_commit+21/30>
Trace; c0160d2f <ext3_sync_file+7f/90>
Trace; c01e90f4 <sys_socketcall+154/200>
Trace; c0138a61 <sys_fsync+61/a0>
Trace; c0106f03 <system_call+33/38>
Proc;  klogd
 >>EIP; c2fac000 <END_OF_CODE+3fed81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01ea99c <alloc_skb+dc/1a0>
Trace; c0227798 <unix_wait_for_peer+a8/d0>
Trace; c02280ab <unix_dgram_sendmsg+2ab/360>
Trace; c01e7b9f <sock_sendmsg+6f/90>
Trace; c0111656 <do_page_fault+1b6/5b0>
Trace; c0112b8a <do_schedule+22a/250>
Trace; c01e7db7 <sock_write+a7/c0>
Trace; c01376a6 <sys_write+96/f0>
Trace; c013719d <filp_close+4d/60>
Trace; c0119432 <sys_time+12/60>
Trace; c0106f03 <system_call+33/38>
Proc;  apcupsd
 >>EIP; c2e66000 <END_OF_CODE+2b8d81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c0183485 <tty_ioctl+385/3a0>
Trace; c01376f2 <sys_write+e2/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  named
 >>EIP; c33b8000 <END_OF_CODE+80ad81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  named
 >>EIP; c3312000 <END_OF_CODE+764d81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c014675d <do_poll+dd/100>
Trace; c014695e <sys_poll+1de/2e0>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c0106f03 <system_call+33/38>
Proc;  named
 >>EIP; c3310000 <END_OF_CODE+762d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  named
 >>EIP; c3392000 <END_OF_CODE+7e4d81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c011dbe8 <sys_nanosleep+e8/1d2>
Trace; c0119533 <sys_gettimeofday+23/60>
Trace; c0106f03 <system_call+33/38>
Proc;  named
 >>EIP; c2c0a000 <END_OF_CODE+5cd81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01e7fbf <sock_poll+1f/30>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c0137602 <sys_read+e2/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  sshd
 >>EIP; c30d0000 <END_OF_CODE+522d81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c0140723 <pipe_poll+23/70>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c0106f03 <system_call+33/38>
Proc;  lpd
 >>EIP; c37d4000 <END_OF_CODE+c26d81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c0140723 <pipe_poll+23/70>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c011f5d9 <sys_rt_sigaction+69/90>
Trace; c0137602 <sys_read+e2/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  ntpd
 >>EIP; c378a000 <END_OF_CODE+bdcd81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01e7fbf <sock_poll+1f/30>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c01062b5 <restore_sigcontext+115/140>
Trace; c01063ae <sys_sigreturn+ce/100>
Trace; c0106f03 <system_call+33/38>
Proc;  gpm
 >>EIP; c371a000 <END_OF_CODE+b6cd81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c011f5d9 <sys_rt_sigaction+69/90>
Trace; c0106f03 <system_call+33/38>
Proc;  crond
 >>EIP; c36ea000 <END_OF_CODE+b3cd81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c011dbe8 <sys_nanosleep+e8/1d2>
Trace; c011ec2a <sys_rt_sigprocmask+3a/160>
Trace; c0106f03 <system_call+33/38>
Proc;  atd
 >>EIP; c3682000 <END_OF_CODE+ad4d81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c011dbe8 <sys_nanosleep+e8/1d2>
Trace; c011ec2a <sys_rt_sigprocmask+3a/160>
Trace; c0106f03 <system_call+33/38>
Proc;  cupsd
 >>EIP; c3600000 <END_OF_CODE+a52d81/????>   <=====
Trace; c01384f8 <__wait_on_buffer+78/a0>
Trace; c016a73c <do_get_write_access+4c/480>
Trace; c0164db6 <ext3_do_update_inode+2c6/350>
Trace; c0164e11 <ext3_do_update_inode+321/350>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c01669bd <ext3_orphan_add+8d/1c0>
Trace; c0165104 <ext3_mark_iloc_dirty+24/60>
Trace; c0165115 <ext3_mark_iloc_dirty+35/60>
Trace; c0165217 <ext3_mark_inode_dirty+27/40>
Trace; c016705d <ext3_unlink+15d/1c0>
Trace; c0142ec2 <vfs_unlink+142/190>
Trace; c0142f98 <sys_unlink+88/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  cyrus-master
 >>EIP; c3408000 <END_OF_CODE+85ad81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c0106f03 <system_call+33/38>
Proc;  postfix-maste
 >>EIP; c3468000 <END_OF_CODE+8bad81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01ea99c <alloc_skb+dc/1a0>
Trace; c0227798 <unix_wait_for_peer+a8/d0>
Trace; c02280ab <unix_dgram_sendmsg+2ab/360>
Trace; c01e7b9f <sock_sendmsg+6f/90>
Trace; c0130814 <__alloc_pages+74/2e0>
Trace; c01e8950 <sys_sendto+d0/f0>
Trace; c0106b1d <handle_signal+7d/100>
Trace; c0106dc1 <do_signal+221/270>
Trace; c014062d <pipe_write+1fd/260>
Trace; c0119101 <do_getitimer+a1/b0>
Trace; c01e898d <sys_send+1d/30>
Trace; c01e90b1 <sys_socketcall+111/200>
Trace; c0106f03 <system_call+33/38>
Proc;  qmgr
 >>EIP; c3982000 <END_OF_CODE+dd4d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c0160b88 <ext3_readdir+3e8/400>
Trace; c013ea9f <cp_new_stat64+ef/110>
Trace; c0145190 <vfs_readdir+60/90>
Trace; c0145730 <filldir64+0/100>
Trace; c014587a <sys_getdents64+4a/98>
Trace; c0145730 <filldir64+0/100>
Trace; c0106f03 <system_call+33/38>
Proc;  sulogin
 >>EIP; c3e46000 <END_OF_CODE+1298d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01246a3 <handle_mm_fault+b3/160>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c012827c <generic_file_read+8c/1b0>
Trace; c0128140 <file_read_actor+0/b0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c013f206 <open_exec+16/b0>
Trace; c0157f0e <load_elf_binary+2de/b70>
Trace; c016b475 <journal_stop+185/190>
Trace; c01652c3 <ext3_dirty_inode+93/d0>
Trace; c01242dc <do_no_page+3c/230>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c0127eef <__do_generic_file_read+49f/4b0>
Trace; c0157c30 <load_elf_binary+0/b70>
Trace; c013fa41 <search_binary_handler+71/180>
Trace; c013fccc <do_execve+17c/1e0>
Trace; c0140e2e <getname+5e/a0>
Trace; c0105a20 <sys_execve+30/60>
Trace; c0106f03 <system_call+33/38>
Proc;  mingetty
 >>EIP; c39c6000 <END_OF_CODE+e18d81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01855f9 <read_chan+3c9/700>
Trace; c01819fc <tty_read+ac/d0>
Trace; c012639f <do_munmap+26f/280>
Trace; c01375b6 <sys_read+96/f0>
Trace; c013719d <filp_close+4d/60>
Trace; c01263e9 <sys_munmap+39/60>
Trace; c0106f03 <system_call+33/38>
Proc;  mingetty
 >>EIP; c3e2e000 <END_OF_CODE+1280d81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01855f9 <read_chan+3c9/700>
Trace; c01819fc <tty_read+ac/d0>
Trace; c012639f <do_munmap+26f/280>
Trace; c01375b6 <sys_read+96/f0>
Trace; c013719d <filp_close+4d/60>
Trace; c01263e9 <sys_munmap+39/60>
Trace; c0106f03 <system_call+33/38>
Proc;  mingetty
 >>EIP; c3e34000 <END_OF_CODE+1286d81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01855f9 <read_chan+3c9/700>
Trace; c01819fc <tty_read+ac/d0>
Trace; c012639f <do_munmap+26f/280>
Trace; c01375b6 <sys_read+96/f0>
Trace; c013719d <filp_close+4d/60>
Trace; c01263e9 <sys_munmap+39/60>
Trace; c0106f03 <system_call+33/38>
Proc;  mingetty
 >>EIP; c3e4a000 <END_OF_CODE+129cd81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01855f9 <read_chan+3c9/700>
Trace; c01819fc <tty_read+ac/d0>
Trace; c012639f <do_munmap+26f/280>
Trace; c01375b6 <sys_read+96/f0>
Trace; c013719d <filp_close+4d/60>
Trace; c01263e9 <sys_munmap+39/60>
Trace; c0106f03 <system_call+33/38>
Proc;  mingetty
 >>EIP; c3e02000 <END_OF_CODE+1254d81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01855f9 <read_chan+3c9/700>
Trace; c01819fc <tty_read+ac/d0>
Trace; c012639f <do_munmap+26f/280>
Trace; c01375b6 <sys_read+96/f0>
Trace; c013719d <filp_close+4d/60>
Trace; c01263e9 <sys_munmap+39/60>
Trace; c0106f03 <system_call+33/38>
Proc;  saslauthd
 >>EIP; c2a3c000 <_end+2743c8c/2893c8c>   <=====
Trace; c0147640 <interruptible_sleep_on_locked+80/c0>
Trace; c01e7ec3 <sock_readv_writev+93/a0>
Trace; c014769c <locks_block_on+1c/30>
Trace; c0147b39 <posix_lock_file+b9/560>
Trace; c014a56d <destroy_inode+3d/50>
Trace; c01488cc <fcntl_setlk+fc/170>
Trace; c01448f8 <do_fcntl+158/210>
Trace; c0144a71 <sys_fcntl64+81/a0>
Trace; c0106f03 <system_call+33/38>
Proc;  saslauthd
 >>EIP; c3d04000 <END_OF_CODE+1156d81/????>   <=====
Trace; c0147640 <interruptible_sleep_on_locked+80/c0>
Trace; c01e7ec3 <sock_readv_writev+93/a0>
Trace; c014769c <locks_block_on+1c/30>
Trace; c0147b39 <posix_lock_file+b9/560>
Trace; c014a56d <destroy_inode+3d/50>
Trace; c01488cc <fcntl_setlk+fc/170>
Trace; c01448f8 <do_fcntl+158/210>
Trace; c0144a71 <sys_fcntl64+81/a0>
Trace; c0106f03 <system_call+33/38>
Proc;  saslauthd
 >>EIP; c3cfe000 <END_OF_CODE+1150d81/????>   <=====
Trace; c0147640 <interruptible_sleep_on_locked+80/c0>
Trace; c01e7ec3 <sock_readv_writev+93/a0>
Trace; c014769c <locks_block_on+1c/30>
Trace; c0147b39 <posix_lock_file+b9/560>
Trace; c014a56d <destroy_inode+3d/50>
Trace; c01488cc <fcntl_setlk+fc/170>
Trace; c01448f8 <do_fcntl+158/210>
Trace; c0144a71 <sys_fcntl64+81/a0>
Trace; c0106f03 <system_call+33/38>
Proc;  saslauthd
 >>EIP; c3cfa000 <END_OF_CODE+114cd81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01ec736 <wait_for_packet+f6/150>
Trace; c01ec840 <skb_recv_datagram+b0/d0>
Trace; c0227bee <unix_accept+4e/d0>
Trace; c01e8673 <sys_accept+63/f0>
Trace; c014a56d <destroy_inode+3d/50>
Trace; c014892f <fcntl_setlk+15f/170>
Trace; c01e9050 <sys_socketcall+b0/200>
Trace; c0144a7d <sys_fcntl64+8d/a0>
Trace; c0106f03 <system_call+33/38>
Proc;  saslauthd
 >>EIP; c3cf2000 <END_OF_CODE+1144d81/????>   <=====
Trace; c0147640 <interruptible_sleep_on_locked+80/c0>
Trace; c01e7ec3 <sock_readv_writev+93/a0>
Trace; c014769c <locks_block_on+1c/30>
Trace; c0147b39 <posix_lock_file+b9/560>
Trace; c014a56d <destroy_inode+3d/50>
Trace; c01488cc <fcntl_setlk+fc/170>
Trace; c01448f8 <do_fcntl+158/210>
Trace; c0144a71 <sys_fcntl64+81/a0>
Trace; c0106f03 <system_call+33/38>
Proc;  nmbd
 >>EIP; c480c000 <END_OF_CODE+1c5ed81/????>   <=====
Trace; c01384f8 <__wait_on_buffer+78/a0>
Trace; c019b7a6 <ll_rw_block+116/1f0>
Trace; c0165918 <ext3_find_entry+f8/350>
Trace; c0165b70 <ext3_lookup+0/a0>
Trace; c0141af9 <link_path_walk+8a9/8d0>
Trace; c0165b99 <ext3_lookup+29/a0>
Trace; c0141050 <cached_lookup+10/50>
Trace; c0141e2a <lookup_hash+6a/90>
Trace; c01420c7 <open_namei+e7/5d0>
Trace; c01465ee <sys_select+5fe/610>
Trace; c0136da6 <filp_open+36/60>
Trace; c01370e4 <sys_open+34/80>
Trace; c0106f03 <system_call+33/38>
Proc;  nmbd
 >>EIP; c4ffe000 <END_OF_CODE+2450d81/????>   <=====
Trace; c01401db <pipe_wait+8b/c0>
Trace; c011f2d0 <do_sigaction+c0/100>
Trace; c01402c4 <pipe_read+b4/220>
Trace; c01375b6 <sys_read+96/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; c4ede000 <END_OF_CODE+2330d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c01a6482 <e1000_clean_rx_irq+3c2/3d0>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  clamd
 >>EIP; c4e48000 <END_OF_CODE+229ad81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01ec736 <wait_for_packet+f6/150>
Trace; c01ec840 <skb_recv_datagram+b0/d0>
Trace; c0227bee <unix_accept+4e/d0>
Trace; c01e8673 <sys_accept+63/f0>
Trace; c014be17 <update_mctime+37/40>
Trace; c014062d <pipe_write+1fd/260>
Trace; c01e9050 <sys_socketcall+b0/200>
Trace; c0106f03 <system_call+33/38>
Proc;  clamd
 >>EIP; c4e1e000 <END_OF_CODE+2270d81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c014675d <do_poll+dd/100>
Trace; c014695e <sys_poll+1de/2e0>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c0106f03 <system_call+33/38>
Proc;  clamd
 >>EIP; c39c0000 <END_OF_CODE+e12d81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01ea99c <alloc_skb+dc/1a0>
Trace; c0227798 <unix_wait_for_peer+a8/d0>
Trace; c02280ab <unix_dgram_sendmsg+2ab/360>
Trace; c0165104 <ext3_mark_iloc_dirty+24/60>
Trace; c0165115 <ext3_mark_iloc_dirty+35/60>
Trace; c01e7b9f <sock_sendmsg+6f/90>
Trace; c016b475 <journal_stop+185/190>
Trace; c01652c3 <ext3_dirty_inode+93/d0>
Trace; c01e8950 <sys_sendto+d0/f0>
Trace; c0165b70 <ext3_lookup+0/a0>
Trace; c0141050 <cached_lookup+10/50>
Trace; c013ea9f <cp_new_stat64+ef/110>
Trace; c01e898d <sys_send+1d/30>
Trace; c01e90b1 <sys_socketcall+111/200>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c4c96000 <END_OF_CODE+20e8d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c53aa000 <END_OF_CODE+27fcd81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c014675d <do_poll+dd/100>
Trace; c014695e <sys_poll+1de/2e0>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c53a8000 <END_OF_CODE+27fad81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c4dba000 <END_OF_CODE+220cd81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c5d86000 <END_OF_CODE+31d8d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  idled
 >>EIP; c63fa000 <END_OF_CODE+384cd81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c0136da6 <filp_open+36/60>
Trace; c0137106 <sys_open+56/80>
Trace; c0106f03 <system_call+33/38>
Proc;  amavisd
 >>EIP; c6988000 <END_OF_CODE+3ddad81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c0119b9b <do_softirq+ab/130>
Trace; c0106f03 <system_call+33/38>
Proc;  apcupsd
 >>EIP; c6df6000 <END_OF_CODE+4248d81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c014675d <do_poll+dd/100>
Trace; c014695e <sys_poll+1de/2e0>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c0106f03 <system_call+33/38>
Proc;  apcupsd
 >>EIP; c6df2000 <END_OF_CODE+4244d81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c02065cd <wait_for_connect+ed/1a0>
Trace; c0206715 <tcp_accept+95/1c0>
Trace; c021ee4a <inet_accept+2a/140>
Trace; c01e8673 <sys_accept+63/f0>
Trace; c01e7900 <sock_map_file+90/100>
Trace; c022702c <unix_create+5c/70>
Trace; c011f2d0 <do_sigaction+c0/100>
Trace; c011f5c3 <sys_rt_sigaction+53/90>
Trace; c01e9050 <sys_socketcall+b0/200>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c71ca000 <END_OF_CODE+461cd81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c76ba000 <END_OF_CODE+4b0cd81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01ea99c <alloc_skb+dc/1a0>
Trace; c0227798 <unix_wait_for_peer+a8/d0>
Trace; c02280ab <unix_dgram_sendmsg+2ab/360>
Trace; c01e7b9f <sock_sendmsg+6f/90>
Trace; c0165115 <ext3_mark_iloc_dirty+35/60>
Trace; c01e8950 <sys_sendto+d0/f0>
Trace; c0106dc1 <do_signal+221/270>
Trace; c01e7db7 <sock_write+a7/c0>
Trace; c011f2d0 <do_sigaction+c0/100>
Trace; c01e898d <sys_send+1d/30>
Trace; c01e90b1 <sys_socketcall+111/200>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7686000 <END_OF_CODE+4ad8d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c761e000 <END_OF_CODE+4a70d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c75d0000 <END_OF_CODE+4a22d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c758e000 <END_OF_CODE+49e0d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c758a000 <END_OF_CODE+49dcd81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c756c000 <END_OF_CODE+49bed81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c70fa000 <END_OF_CODE+454cd81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c757e000 <END_OF_CODE+49d0d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c70ec000 <END_OF_CODE+453ed81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c70e2000 <END_OF_CODE+4534d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c753c000 <END_OF_CODE+498ed81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7532000 <END_OF_CODE+4984d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c752a000 <END_OF_CODE+497cd81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7526000 <END_OF_CODE+4978d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c751c000 <END_OF_CODE+496ed81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7516000 <END_OF_CODE+4968d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7514000 <END_OF_CODE+4966d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7506000 <END_OF_CODE+4958d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7504000 <END_OF_CODE+4956d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c74f8000 <END_OF_CODE+494ad81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c74f2000 <END_OF_CODE+4944d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7b66000 <END_OF_CODE+4fb8d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7a38000 <END_OF_CODE+4e8ad81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79c8000 <END_OF_CODE+4e1ad81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79e4000 <END_OF_CODE+4e36d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79f2000 <END_OF_CODE+4e44d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79dc000 <END_OF_CODE+4e2ed81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79ea000 <END_OF_CODE+4e3cd81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79d6000 <END_OF_CODE+4e28d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7a04000 <END_OF_CODE+4e56d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79ae000 <END_OF_CODE+4e00d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79fc000 <END_OF_CODE+4e4ed81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79fa000 <END_OF_CODE+4e4cd81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79ec000 <END_OF_CODE+4e3ed81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79f4000 <END_OF_CODE+4e46d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79b6000 <END_OF_CODE+4e08d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79b4000 <END_OF_CODE+4e06d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7b36000 <END_OF_CODE+4f88d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7992000 <END_OF_CODE+4de4d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7b28000 <END_OF_CODE+4f7ad81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c798e000 <END_OF_CODE+4de0d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c79c0000 <END_OF_CODE+4e12d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7b2c000 <END_OF_CODE+4f7ed81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7afe000 <END_OF_CODE+4f50d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7988000 <END_OF_CODE+4ddad81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  slapd
 >>EIP; c7b00000 <END_OF_CODE+4f52d81/????>   <=====
Trace; c010605b <sys_rt_sigsuspend+bb/e0>
Trace; c0106f03 <system_call+33/38>
Proc;  mingetty
 >>EIP; c39ea000 <END_OF_CODE+e3cd81/????>   <=====
Trace; c012748c <___wait_on_page+ac/d0>
Trace; c0127d88 <__do_generic_file_read+338/4b0>
Trace; c012827c <generic_file_read+8c/1b0>
Trace; c0128140 <file_read_actor+0/b0>
Trace; c01375b6 <sys_read+96/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; cdcea000 <END_OF_CODE+b13cd81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d874e000 <END_OF_CODE+15ba0d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c0141050 <cached_lookup+10/50>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d80ec000 <END_OF_CODE+1553ed81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01eab6b <kfree_skbmem+b/60>
Trace; c02057b5 <tcp_recvmsg+765/860>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c01281ab <file_read_actor+6b/b0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c0127eef <__do_generic_file_read+49f/4b0>
Trace; c012827c <generic_file_read+8c/1b0>
Trace; c0128140 <file_read_actor+0/b0>
Trace; c01375b6 <sys_read+96/f0>
Trace; c0137509 <sys_llseek+99/b0>
Trace; c0106f03 <system_call+33/38>
Proc;  imapd
 >>EIP; d517e000 <END_OF_CODE+125d0d81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c01376f2 <sys_write+e2/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d4f6a000 <END_OF_CODE+123bcd81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d2f8e000 <END_OF_CODE+103e0d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; c7c4e000 <END_OF_CODE+50a0d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; dbb8a000 <END_OF_CODE+18fdcd81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01eab6b <kfree_skbmem+b/60>
Trace; c02057b5 <tcp_recvmsg+765/860>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c01281ab <file_read_actor+6b/b0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c0127eef <__do_generic_file_read+49f/4b0>
Trace; c012827c <generic_file_read+8c/1b0>
Trace; c0128140 <file_read_actor+0/b0>
Trace; c01375b6 <sys_read+96/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; df91a000 <END_OF_CODE+1cd6cd81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d8e10000 <END_OF_CODE+16262d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  imapd
 >>EIP; c63b8000 <END_OF_CODE+380ad81/????>   <=====
Trace; c0105c7d <__down+5d/b0>
Trace; c0140e2e <getname+5e/a0>
Trace; c0105dd0 <__down_failed+8/c>
Trace; c014434e <.text.lock.namei+ff/221>
Trace; c0106f03 <system_call+33/38>
Proc;  imapd
 >>EIP; d5a88000 <END_OF_CODE+12edad81/????>   <=====
Trace; c0105c7d <__down+5d/b0>
Trace; c0105dd0 <__down_failed+8/c>
Trace; c0161e47 <.text.lock.ialloc+19/32>
Trace; c0128a09 <filemap_nopage+e9/210>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c016a1ab <start_this_handle+10b/150>
Trace; c016a2bd <journal_start+7d/a0>
Trace; c0166276 <ext3_create+86/110>
Trace; c0141fa8 <vfs_create+a8/e0>
Trace; c0141e02 <lookup_hash+42/90>
Trace; c014212f <open_namei+14f/5d0>
Trace; c0141050 <cached_lookup+10/50>
Trace; c0136da6 <filp_open+36/60>
Trace; c01370e4 <sys_open+34/80>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; c713a000 <END_OF_CODE+458cd81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d06e2000 <END_OF_CODE+db34d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; dedf4000 <END_OF_CODE+1c246d81/????>   <=====
Trace; c01384f8 <__wait_on_buffer+78/a0>
Trace; c0139308 <getblk+38/70>
Trace; c016a73c <do_get_write_access+4c/480>
Trace; c016bb89 <__journal_file_buffer+d9/1e0>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0161887 <ext3_new_inode+4c7/8d0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c016a1ab <start_this_handle+10b/150>
Trace; c016a2bd <journal_start+7d/a0>
Trace; c0166276 <ext3_create+86/110>
Trace; c0141fa8 <vfs_create+a8/e0>
Trace; c0141e02 <lookup_hash+42/90>
Trace; c014212f <open_namei+14f/5d0>
Trace; c0145190 <vfs_readdir+60/90>
Trace; c0136da6 <filp_open+36/60>
Trace; c01370e4 <sys_open+34/80>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; ce6e4000 <END_OF_CODE+bb36d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d5da4000 <END_OF_CODE+131f6d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; c68a2000 <END_OF_CODE+3cf4d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d42f2000 <END_OF_CODE+11744d81/????>   <=====
Trace; c0105c7d <__down+5d/b0>
Trace; c0105dd0 <__down_failed+8/c>
Trace; c0161e47 <.text.lock.ialloc+19/32>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c016a1ab <start_this_handle+10b/150>
Trace; c016a2bd <journal_start+7d/a0>
Trace; c0166276 <ext3_create+86/110>
Trace; c0120cde <in_group_p+1e/30>
Trace; c0141fa8 <vfs_create+a8/e0>
Trace; c0141e02 <lookup_hash+42/90>
Trace; c014212f <open_namei+14f/5d0>
Trace; c0145190 <vfs_readdir+60/90>
Trace; c0136da6 <filp_open+36/60>
Trace; c01370e4 <sys_open+34/80>
Trace; c0106f03 <system_call+33/38>
Proc;  imapd
 >>EIP; cd57c000 <END_OF_CODE+a9ced81/????>   <=====
Trace; c0105c7d <__down+5d/b0>
Trace; c0140e2e <getname+5e/a0>
Trace; c0105dd0 <__down_failed+8/c>
Trace; c014434e <.text.lock.namei+ff/221>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; ccb8a000 <END_OF_CODE+9fdcd81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  imapd
 >>EIP; ce4e0000 <END_OF_CODE+b932d81/????>   <=====
Trace; c0105c7d <__down+5d/b0>
Trace; c0140e2e <getname+5e/a0>
Trace; c0105dd0 <__down_failed+8/c>
Trace; c014434e <.text.lock.namei+ff/221>
Trace; c0106f03 <system_call+33/38>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d823e000 <END_OF_CODE+15690d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  imapd
 >>EIP; d6d36000 <END_OF_CODE+14188d81/????>   <=====
Trace; c0112ecd <sleep_on+3d/60>
Trace; c016f01a <log_wait_commit+3a/50>
Trace; c016b46d <journal_stop+17d/190>
Trace; c016b4aa <journal_force_commit+2a/30>
Trace; c0169ac1 <ext3_force_commit+21/30>
Trace; c0160d2f <ext3_sync_file+7f/90>
Trace; c01376f2 <sys_write+e2/f0>
Trace; c0138a61 <sys_fsync+61/a0>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d7266000 <END_OF_CODE+146b8d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; cc8d6000 <END_OF_CODE+9d28d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c0141050 <cached_lookup+10/50>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d2390000 <END_OF_CODE+f7e2d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c0141050 <cached_lookup+10/50>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; c9c24000 <END_OF_CODE+7076d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  pickup
 >>EIP; db7c2000 <END_OF_CODE+18c14d81/????>   <=====
Trace; c01384f8 <__wait_on_buffer+78/a0>
Trace; c016297c <ext3_get_block_handle+9c/290>
Trace; c016a73c <do_get_write_access+4c/480>
Trace; c0139588 <bread+18/90>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c0160801 <ext3_readdir+61/400>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c0160b88 <ext3_readdir+3e8/400>
Trace; c016b475 <journal_stop+185/190>
Trace; c013ea9f <cp_new_stat64+ef/110>
Trace; c0145190 <vfs_readdir+60/90>
Trace; c0145730 <filldir64+0/100>
Trace; c014587a <sys_getdents64+4a/98>
Trace; c0145730 <filldir64+0/100>
Trace; c0106f03 <system_call+33/38>
Proc;  amavisd
 >>EIP; c3b78000 <END_OF_CODE+fcad81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01e7fbf <sock_poll+1f/30>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c0106f03 <system_call+33/38>
Proc;  amavisd
 >>EIP; dc754000 <END_OF_CODE+19ba6d81/????>   <=====
Trace; c0147640 <interruptible_sleep_on_locked+80/c0>
Trace; c014769c <locks_block_on+1c/30>
Trace; c01479fb <flock_lock_file+cb/150>
Trace; c014862d <sys_flock+8d/a0>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d223c000 <END_OF_CODE+f68ed81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  sshd
 >>EIP; c3490000 <END_OF_CODE+8e2d81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01e7fbf <sock_poll+1f/30>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c01376f2 <sys_write+e2/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  bash
 >>EIP; c296a000 <_end+2671c8c/2893c8c>   <=====
Trace; c0118f81 <sys_wait4+3a1/3d0>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; de4c6000 <END_OF_CODE+1b918d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  imapd
 >>EIP; d6da4000 <END_OF_CODE+141f6d81/????>   <=====
Trace; c011dad3 <schedule_timeout+93/b0>
Trace; c011da30 <process_timeout+0/10>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c01376f2 <sys_write+e2/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  sshd
 >>EIP; db582000 <END_OF_CODE+189d4d81/????>   <=====
Trace; c011da54 <schedule_timeout+14/b0>
Trace; c01e7fbf <sock_poll+1f/30>
Trace; c0145f80 <do_select+1e0/220>
Trace; c0145c00 <__pollwait+0/c0>
Trace; c014640a <sys_select+41a/610>
Trace; c0183485 <tty_ioctl+385/3a0>
Trace; c0106f03 <system_call+33/38>
Proc;  [<c0145c00>]
 >>EIP; 00000032 Before first symbol   <=====
Trace; c0118f81 <sys_wait4+3a1/3d0>
Trace; c0106f03 <system_call+33/38>
Proc;  imapd
 >>EIP; d8bb6000 <END_OF_CODE+16008d81/????>   <=====
Trace; c0105c7d <__down+5d/b0>
Trace; c0140e2e <getname+5e/a0>
Trace; c0105dd0 <__down_failed+8/c>
Trace; c014434e <.text.lock.namei+ff/221>
Trace; c0106f03 <system_call+33/38>
Proc;  smbd
 >>EIP; d954c000 <END_OF_CODE+1699ed81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c0125fba <unmap_fixup+8a/160>
Trace; c0140e2e <getname+5e/a0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c0141ee4 <__user_walk+24/40>
Trace; c013ead4 <sys_stat64+14/70>
Trace; c0106f03 <system_call+33/38>
Proc;  smbstatus
 >>EIP; d16f4000 <END_OF_CODE+eb46d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c016a05f <get_transaction+bf/100>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c0146d40 <locks_alloc_lock+10/20>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c0127eef <__do_generic_file_read+49f/4b0>
Trace; c012827c <generic_file_read+8c/1b0>
Trace; c0128140 <file_read_actor+0/b0>
Trace; c01375b6 <sys_read+96/f0>
Trace; c0140e2e <getname+5e/a0>
Trace; c0137106 <sys_open+56/80>
Trace; c0106f03 <system_call+33/38>
Proc;  cyrus-master
 >>EIP; cf4c2000 <END_OF_CODE+c914d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c01419c1 <link_path_walk+771/8d0>
Trace; c012827c <generic_file_read+8c/1b0>
Trace; c0128140 <file_read_actor+0/b0>
Trace; c0141c9b <path_lookup+1b/30>
Trace; c013f206 <open_exec+16/b0>
Trace; c0157f0e <load_elf_binary+2de/b70>
Trace; c016b475 <journal_stop+185/190>
Trace; c01652c3 <ext3_dirty_inode+93/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c0127eef <__do_generic_file_read+49f/4b0>
Trace; c0157c30 <load_elf_binary+0/b70>
Trace; c013fa41 <search_binary_handler+71/180>
Trace; c013fccc <do_execve+17c/1e0>
Trace; c0140e2e <getname+5e/a0>
Trace; c0105a20 <sys_execve+30/60>
Trace; c0106f03 <system_call+33/38>
Proc;  bash
 >>EIP; dc376000 <END_OF_CODE+197c8d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c01242dc <do_no_page+3c/230>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c0127eef <__do_generic_file_read+49f/4b0>
Trace; c0141a0e <link_path_walk+7be/8d0>
Trace; c012827c <generic_file_read+8c/1b0>
Trace; c0128140 <file_read_actor+0/b0>
Trace; c0136e8f <dentry_open+bf/190>
Trace; c013f2ec <kernel_read+4c/60>
Trace; c013f7f4 <prepare_binprm+114/120>
Trace; c013fc59 <do_execve+109/1e0>
Trace; c0140e2e <getname+5e/a0>
Trace; c0105a20 <sys_execve+30/60>
Trace; c0106f03 <system_call+33/38>
Proc;  bash
 >>EIP; d66b0000 <END_OF_CODE+13b02d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c0127eef <__do_generic_file_read+49f/4b0>
Trace; c0141a0e <link_path_walk+7be/8d0>
Trace; c012827c <generic_file_read+8c/1b0>
Trace; c0128140 <file_read_actor+0/b0>
Trace; c0136e8f <dentry_open+bf/190>
Trace; c013f2ec <kernel_read+4c/60>
Trace; c013f7f4 <prepare_binprm+114/120>
Trace; c013fc59 <do_execve+109/1e0>
Trace; c0140e2e <getname+5e/a0>
Trace; c0105a20 <sys_execve+30/60>
Trace; c0106f03 <system_call+33/38>
Proc;  sshd
 >>EIP; cbfc6000 <END_OF_CODE+9418d81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>
Trace; c01700d7 <__jbd_kmalloc+27/80>
Trace; c0165208 <ext3_mark_inode_dirty+18/40>
Trace; c01652b8 <ext3_dirty_inode+88/d0>
Trace; c01281ab <file_read_actor+6b/b0>
Trace; c014a6ce <__mark_inode_dirty+2e/90>
Trace; c014bdd4 <update_atime+54/60>
Trace; c0127eef <__do_generic_file_read+49f/4b0>
Trace; c012827c <generic_file_read+8c/1b0>
Trace; c0128140 <file_read_actor+0/b0>
Trace; c01375b6 <sys_read+96/f0>
Trace; c0106f03 <system_call+33/38>
Proc;  crond
 >>EIP; da1f4000 <END_OF_CODE+17646d81/????>   <=====
Trace; c0112d8c <wait_for_completion+8c/c0>
Trace; c01150d3 <do_fork+673/780>
Trace; c01059e8 <sys_vfork+18/20>
Trace; c0106f03 <system_call+33/38>
Proc;  crond
 >>EIP; dce5c000 <END_OF_CODE+1a2aed81/????>   <=====
Trace; c016a981 <do_get_write_access+291/480>
Trace; c016aba0 <journal_get_write_access+30/50>
Trace; c0165171 <ext3_reserve_inode_write+31/b0>


2 warnings issued.  Results may not be reliable.
