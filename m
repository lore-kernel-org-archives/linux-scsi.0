From: "pg@atlavia.it" <pg@atlavia.it>
Subject: megaraid Error 40005 on cluster
Date: Thu, 19 May 2005 14:11:43 +0000
Message-ID: <151.92.176.3.1249009224.1116511903@webmail.atlavia.it>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fe-6c.inet.it ([213.92.5.112]:34549 "EHLO fe-6c.inet.it")
	by vger.kernel.org with ESMTP id S262506AbVESOLp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2005 10:11:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I exerienced the following error on a RedHat cluster configuration with Dell hardware (Perc 3/DC controller and PowerVault 220 disk array).
When the error occurs the cluster manager shutdown the cluster node, but the filesystem is corruped and the other node cannot mount it until a manual fsck.

Any idea?


SCSI and system configuration
--------------------------------

Redhat AS 2.1 + Cluster Manager
DELL PowerEdge 2650 with PERC 3/DC
DELL PowerVault 220s - cluster configuration


# uname -a
Linux myHost 2.4.9-e.40smp #1 SMP Thu Apr 8 16:53:29 EDT 2004 i686 unknown

# cat /etc/modules.conf
options scsi_mod max_scsi_luns=255 
alias scsi_hostadapter aacraid
alias scsi_hostadapter1 megaraid_2009
....

# cat /proc/scsi/scsi 
Attached devices: 
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: PERCRAID Mirror  Rev: V1.0
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: MegaRAID Model: LD 0 RAID1   34G Rev: 1.92
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 01 Lun: 00
  Vendor: MegaRAID Model: LD 1 RAID5   69G Rev: 1.92
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 04 Id: 07 Lun: 00
  Vendor: DELL     Model: PERC 3/DC        Rev: 1.92
  Type:   Processor                        ANSI SCSI revision: 02
Host: scsi1 Channel: 04 Id: 15 Lun: 00
  Vendor: DELL     Model: PV22XS           Rev: E.14
  Type:   Processor                        ANSI SCSI revision: 03

# cat /proc/scsi/megaraid/1 
LSI Logic MegaRAID 1.92 254 commands 16 targs 5 chans 7 luns

# cat /proc/megaraid/hba1/config 
v2.00.9 (Release Date: Thu Sep  4 17:49:42 EDT 2003)
PERC 3/DC
Controller Type: 438/466/467/471/493/518/520/531/532
Controller Supports 40 Logical Drives
Controller capable of 64-bit memory addressing
Controller using 64-bit memory addressing
Base = f9030000, Irq = 16, Logical Drives = 2, Channels = 2
Version =1.92:3.31, DRAM = 128Mb
Controller Queue Depth = 254, Driver Queue Depth = 126
support_ext_cdb    = 1
support_random_del = 1
boot_ldrv_enabled  = 1
boot_ldrv          = 0
boot_pdrv_enabled  = 0
boot_pdrv_ch       = 0
boot_pdrv_tgt      = 0
quiescent          = 0
has_cluster        = 1

Module Parameters:
max_cmd_per_lun    = 63
max_sectors_per_io = 128

# cat /proc/megaraid/hba1/diskdrives-ch0 
Channel: 0 Id: 0 State: Online.
  Vendor: FUJITSU   Model: MAP3367NC         Rev: 5605
  Type:   Direct-Access                      ANSI SCSI revision: 03
Channel: 0 Id: 1 State: Online.
  Vendor: FUJITSU   Model: MAP3367NC         Rev: 5605
  Type:   Direct-Access                      ANSI SCSI revision: 03
Channel: 0 Id: 2 State: Hot spare.
  Vendor: FUJITSU   Model: MAP3367NC         Rev: 5605
  Type:   Direct-Access                      ANSI SCSI revision: 03
Channel: 0 Id: 3 State: Online.
  Vendor: FUJITSU   Model: MAP3367NC         Rev: 5605
  Type:   Direct-Access                      ANSI SCSI revision: 03
Channel: 0 Id: 4 State: Online.
  Vendor: FUJITSU   Model: MAP3367NC         Rev: 5605
  Type:   Direct-Access                      ANSI SCSI revision: 03
Channel: 0 Id: 5 State: Online.
  Vendor: FUJITSU   Model: MAP3367NC         Rev: 5605
  Type:   Direct-Access                      ANSI SCSI revision: 03

# cat /proc/megaraid/hba1/raiddrives-0-9
Logical drive: 0:, state: optimal
Span depth:  1, RAID level:  1, Stripe size: 64, Row size:  2
Read Policy: No read ahead, Write Policy: Write thru, Cache Policy: Direct IO

Logical drive: 1:, state: optimal
Span depth:  1, RAID level:  5, Stripe size: 64, Row size:  3
Read Policy: No read ahead, Write Policy: Write thru, Cache Policy: Direct IO

------------------------------------
Error report
------------------------------------

May 13 05:31:27 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:27 clu2a kernel:  I/O error: dev 08:21, sector 2290456
May 13 05:31:27 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:27 clu2a kernel:  I/O error: dev 08:21, sector 2290464
May 13 05:31:27 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:27 clu2a kernel:  I/O error: dev 08:21, sector 11488
May 13 05:31:27 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:27 clu2a kernel:  I/O error: dev 08:21, sector 11496
May 13 05:31:27 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:27 clu2a kernel:  I/O error: dev 08:21, sector 11504
May 13 05:31:27 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:27 clu2a kernel:  I/O error: dev 08:21, sector 528528
May 13 05:31:27 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:27 clu2a kernel:  I/O error: dev 08:21, sector 2283712
May 13 05:31:27 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:27 clu2a kernel:  I/O error: dev 08:21, sector 2283720
May 13 05:31:28 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:28 clu2a kernel:  I/O error: dev 08:21, sector 2283728
May 13 05:31:28 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:28 clu2a kernel:  I/O error: dev 08:21, sector 2283736
May 13 05:31:28 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:28 clu2a kernel:  I/O error: dev 08:21, sector 2281160
May 13 05:31:28 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:28 clu2a kernel:  I/O error: dev 08:21, sector 2281168
May 13 05:31:28 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:28 clu2a kernel:  I/O error: dev 08:21, sector 2281176
May 13 05:31:28 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:28 clu2a kernel:  I/O error: dev 08:21, sector 2281184
May 13 05:31:28 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:28 clu2a kernel:  I/O error: dev 08:22, sector 1052480
May 13 05:31:28 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:28 clu2a kernel:  I/O error: dev 08:22, sector 2363240
May 13 05:31:28 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:29 clu2a kernel:  I/O error: dev 08:22, sector 266776
May 13 05:31:29 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:29 clu2a kernel:  I/O error: dev 08:22, sector 266776
May 13 05:31:29 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:29 clu2a kernel:  I/O error: dev 08:22, sector 3673920
May 13 05:31:29 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:29 clu2a kernel:  I/O error: dev 08:22, sector 3670072
May 13 05:31:29 clu2a kernel: EXT3-fs error (device sd(8,34)): ext3_get_inode_loc: unable to read inode block - inode=216936, block=458759
May 13 05:31:29 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:29 clu2a kernel:  I/O error: dev 08:22, sector 0
May 13 05:31:29 clu2a kernel: EXT3-fs error (device sd(8,34)) in ext3_reserve_inode_write: IO failure
May 13 05:31:29 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:29 clu2a kernel:  I/O error: dev 08:22, sector 0
May 13 05:31:29 clu2a kernel: EXT3-fs error (device sd(8,34)) in ext3_new_inode: IO failure
May 13 05:31:29 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:29 clu2a kernel:  I/O error: dev 08:22, sector 0
May 13 05:31:29 clu2a kernel: SCSI disk error : host 1 channel 0 id 0 lun 0 return code = 40005
May 13 05:31:29 clu2a kernel:  I/O error: dev 08:11, sector 8
May 13 05:31:29 clu2a kernel: SCSI disk error : host 1 channel 0 id 0 lun 0 return code = 40005
May 13 05:31:29 clu2a kernel:  I/O error: dev 08:11, sector 8
May 13 05:31:29 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:29 clu2a kernel:  I/O error: dev 08:21, sector 3670080
May 13 05:31:29 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:30 clu2a kernel:  I/O error: dev 08:22, sector 2359352
May 13 05:31:30 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:30 clu2a kernel:  I/O error: dev 08:21, sector 3670064
May 13 05:31:30 clu2a kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 40005
May 13 05:31:30 clu2a kernel:  I/O error: dev 08:21, sector 3674152
[...]

