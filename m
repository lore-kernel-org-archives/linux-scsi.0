From: George Magklaras <george.magklaras@biotek.uio.no>
Subject: various megaraid2 drivers on 2.4.21-4.0.2ELsmp and low READ performance
Date: Wed, 14 Jan 2004 13:34:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4005376C.9030107@biotek.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.uio.no ([129.240.130.16]:25584 "EHLO pat.uio.no")
	by vger.kernel.org with ESMTP id S266312AbUANMe4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 07:34:56 -0500
Received: from mail-mx2.uio.no ([129.240.10.30])
	by pat.uio.no with esmtp (Exim 4.20)
	id 1AgkEZ-00035M-Fn
	for linux-scsi@vger.kernel.org; Wed, 14 Jan 2004 13:34:55 +0100
Received: from snipp.uio.no ([129.240.130.63])
	by mail-mx2.uio.no with esmtp (Exim 4.14)
	id 1AgkEW-0004k6-TF
	for linux-scsi@vger.kernel.org; Wed, 14 Jan 2004 13:34:52 +0100
Received: from dionisos.uio.no ([129.240.210.5] helo=biotek.uio.no)
	by snipp.uio.no with esmtp (Exim 2.12 #7)
	id 1AgkEW-0000RJ-00
	for linux-scsi@vger.kernel.org; Wed, 14 Jan 2004 13:34:52 +0100
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

I am facing some read performance issues with the following setup:

A Power Vault 220S driven by a Dell PowerEdge 2650 with Dual 2.4 Ghz
Xeon Proc, 533 FSB and 4 Gb of RAM. The 2650 uses a PERC 4 DC 128Mbyte 
adapter (Firmware 3.28 , BIOS Version 1.05). It ran the tests in 
MASS_STORAGE emulation mode, READ-POLICY=READAHEAD. Cache 
Policy=DIRECT-IO and Write Policy=WRBACK. The Stripe Size of the RAID0 
array is set to 64 K.

All physical disk of the logical drive appear to be in OPTIMAL state 
and all hardware diagnostics on the PowerEdge are giving me the green 
light. The SCSI cables have also been tested on another system.

In order to quickly test the I/O performance of the logical RAID0 
drive, I have performed a couple of dd operations:

testpenguin1# time dd if=/dev/zero of=/storage/hugetest bs=256k 
count=32768
32768+0 records in
32768+0 records out

real    1m18.096s
user    0m0.140s
sys     0m51.810s

-> 1m18 secs to write an 8Gigabyte file => approx. 105 Mbytes/sec for 
write. That's OK.

If you then do the following to read the file back from the RAID0 Drive:

testpenguin1# time dd if=/storage/hugetest of=/dev/null bs=256k
32768+0 records in
32768+0 records out

real    12m32.292s
user    0m0.210s
sys     0m53.180s

it takes an AMAZING 12m32secs => 752 secs to read 8Gigabytes. That is 
equivalent to 10.88 Mbyte/sec performance!

I found that interesting and I have used iozone to test the disk I/O 
performance of the system with the following drivers:

megaraid 2.00.5 (default for 2.4.21-4.0.2EL)
megaraid 2.10.1 (latest driver from the manufacturer)
For the second one, after downloading the 2.10.1 driver tarball from
ftp.lsi.com, I used the 2.4.21-4.0.2 sources and compiled a kernel
with the driver as a module ( I thought it would be a good idea to
stick with the RedHat kernel, which I configured with the hugemem
profile). The system came up properly, no warnings, so I made a large
1.1T ext3 partition on it to start testing.

I include some snapshots from the iozone test results below. Read
performance appears to be really,really bad. That is not the case for
Write performance. The only difference between the 2.00.5 and 2.10.1 
megaraid driver appears to be a better write performance. All read 
test operations remain at really low levels.

Also, there are no relevant messages that indicate a serious low-level 
SCSI problem in /var/log/messages (SCSI Resets) but that could be due 
to missing driver debug options?

The question I have is: Am I looking at a genuine driver performance 
issue or is there anything else that I need to tweak to bring the 
system where it should be, with regards to Read I/O performance on the 
Power Vault? I have contacted my manufacturer and they are 
investigating but I would appreciate your comments on what I might be 
missing here.

Thanks, iozone and dmesg output are provided below :

-- 
--
George B. Magklaras

Computer Systems Engineer/UNIX Systems Administrator
The Biotechnology Centre of Oslo

---------------------------------------------------------------------
Tested with Iozone  Version $Revision: 3.217 $ Compiled for 32 bit 
mode. Build: linux

Command line: ./iozone -Ra -f /storage/test33 -n 8G -g 32G
(for both tests)

Megaraid 2.00.5:
KB  reclen   write rewrite    read    reread    read   write    read 
rewrite    read   fwrite frewrite   fread  freread
  8388608      64   83773   84425    11256    11231    3940   70577 
14841 1065503    4420    83359    83732   11154    11241
          8388608     128   83511   84113    11220    11235    5624 
75610   10359  925634    4439    83140    82547   11161    11188
          8388608     256   83085   84010    11187    11233    5629 
77719    9928  720753    4838    82270    83339   11164    11222
          8388608     512   82517   83611    11195    11196    5967 
78886    9640  540268    4672    82711    83179   11143    11218
          8388608    1024   82064   83750    11205    11226    8963 
83757   11124  538612    6749    83335    83473   11160    11226
          8388608    2048   82564   83541    11221    11208   11054 
83533   12311  537501    8182    83203    83345   11131    11219
          8388608    4096   83126   83725    11193    11234   12660 
84619   12884  529143    9375    82559    83533   11150    11216
          8388608    8192   82829   83774    11211    11198   13064 
86063    9547  521906    9996    83046    83712   11188    11196
          8388608   16384   82343   83674    11210    11213   13404 
84588    9834  521705   10267    82201    83992   11140    11204

Megaraid 2.10.1:
KB  reclen   write rewrite    read    reread    read   write    read 
rewrite    read   fwrite frewrite   fread  freread
          8388608      64  115739  113020    11159    11173    3766 
60186   13769  557306    4320   110258   108458   10757    11190
          8388608     128  112327  107809    11210    11200    5758 
65393    9435  552948    4488   110314   108539   10759    11152
          8388608     256  109359  108386    11193    11209    5733 
65398    9120  419311    4568   110358   111158   10717    11196
          8388608     512  111514  110820    11213    11179    5921 
67979    8918  375517    4491    97478   112370   10747    11144
          8388608    1024  112294  110207    11191    11208    9085 
74596   10472  443377    6748   112507   108504   10796    11187
          8388608    2048  107187  107149    11223    11193   10744 
75413   11574  479670    8011   112151   109863   10757    11147
          8388608    4096  110636  108357    11217    11189   12591 
80681   11868  503356    8962   114342   110286   10782    11162
          8388608    8192  112507  108906    11231    11208   13257 
87364    9078  509937    9532   110810   110018   10794    11194
          8388608   16384  112006  108825    11152    11249   13485 
87345    9361  517188    9735   113948   108945   10756    11196



Here is the dmesg output for scsi0:

megaraid: v2.10.1 (Release Date: Wed Dec  3 15:34:42 EST 2003)
megaraid: found 0x1000:0x1960:bus 1:slot 6:func 0
scsi0:Found MegaRAID controller at 0xf2a7d000, IRQ:16
megaraid: [3.28:1.05] detected 1 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
scsi0 : LSI Logic MegaRAID 3.28 254 commands 16 targs 5 chans 7 luns
Starting timer : 0 0
blk: queue ee9e6218, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
scsi0: scanning scsi channel 0 for logical drives.
   Vendor: MegaRAID  Model: LD0 RAID0 19184R  Rev: 3.28
   Type:   Direct-Access                      ANSI SCSI revision: 02
Starting timer : 0 0
blk: queue ee9e6018, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
scsi0: scanning scsi channel 1 for logical drives.
scsi0: scanning scsi channel 2 for logical drives.
scsi0: scanning scsi channel 4 [P0] for physical devices.
   Vendor: DELL      Model: PV22XS            Rev: E.14
   Type:   Processor                          ANSI SCSI revision: 03
Starting timer : 0 0
blk: queue ee3eee18, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
scsi0: scanning scsi channel 5 [P1] for physical devices.
   Vendor: DELL      Model: PV22XS            Rev: E.14
   Type:   Processor                          ANSI SCSI revision: 03
Starting timer : 0 0
blk: queue ee3eec18, I/O limit 4294967295Mb (mask 0xffffffffffffffff)
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 2292088832 512-byte hdwr sectors (1173549 MB)
  sda: sda1
VFS: Can't find ext3 filesystem on dev sd(8,0).
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.






