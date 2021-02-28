Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0672CC433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B01E264E51
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhB1F6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:58:01 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1300 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhB1F57 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:57:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614491878; x=1646027878;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l8ZQJQVzVcLtB2bnlud4aVbMuxVjQgazSjM/4AkOZDw=;
  b=KQ8i28/BPoCSBHmBq1rtpkxg8lGcstuIoksi4zpekfDyeFWDoAaZ0dGo
   cfMIFcGqP6GIerCUTGJn+OcjiCX+4jC9qdeLGouvlZKsPWnvnk2EuPyyv
   DhsjBkZ1yRIgH7jL6z7mj8v6BCelZZ9Fl3z6NdETK3yY/ey5P3UbcnJn+
   CzlqVvySeuAyRR1iAaBUcJgY7cpw9MD05mPwBjT5oa4fOEt9x5uJJSWIC
   PRhPbYnJ2kMljU0EQYF8NpHv8HIlK5vXIe44y71iAblzWqBtqprhL2aC1
   pBuyMBp+O0BAtPjCFpo+iIXJs852GRR5QsVplmDMAslMBnF+zw7DZBhjC
   A==;
IronPort-SDR: NHZGeW15SVOD4sZSSivrqcJXqOXkXX8rLmbiR6MaYFLskdOsSE2OTA/+UFt4a6RaCdHdqvTn/c
 UYstIGi39niQwjey+tGES4pBzKCGMQLm7bLC8XOr0iZTBuNg0vHDMQsofgj7Owugs70f/1xsyT
 15W7CThB2tmWrF0XV+ZiXnYlzQcSh56sBXORv9tUA8CSZh6Z2EkS+IZNuYg0dz9A3Uo9SsoSb8
 AawL2h11dFaiC593/Xirkf61R8DHWlLHD5jSgTxb9mkhniCI1KYA3xRFQp4/hLu0s7SwUvEuKs
 VnM=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="271564035"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:56:53 +0800
IronPort-SDR: pyLtltvTUpXwykIg4WMDXevL3rB95/VZYar67whe/Ud3BmgBkN90n6yAtQvruqt9Cy/KxWbrXm
 1cvOWMbFXjjZasnccAHbIA9rYONnv47+cZDO2ihfIB0ldwX8xGyHko/PaeqFJFVMuTuR+PajqA
 3O/hiiLNTodD7mI53Xkdy5aqknUywi5umbGA2Qof2a/H8P4Tp2NWQ1lSBZZRMd9UUAe1zZrqve
 M3dIjTwi6ZX7JUmg6XMzlhLVoj/34VYeB2PDpRyUqmPzV7J0MKcZ79IABU0KdvcYpvYidPLfTd
 ph9qZ74Ky6ur6esTaweiJFdP
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:38:12 -0800
IronPort-SDR: RMuplQuTJZnxihlQni4VkDUYLWYoFLxinoRryklOpe+xFKneo7dx3O7LgUm4Wi3qqM/KGItvt7
 t6C/w13XyVFNQh2eAuRyd9Cced6uRAwMGAG7YiMUnXKZGJeLQ0Ivg3mQmQ5mOB9H64sR3zgg2a
 qP1TxPMeJ/Ke/PhYMsAtEzQqS/IbYDMSkB0MlY+qJpcAYRKjZdDIixvaX3msqESVy6tI9XMvP9
 GZYJVPieMuEdF+cwUKNIkhSWsCBuzu5Y0m5t1I9YJUsvNq6RfX0XjpTbbhnRLbXzekme+MC9q0
 nQY=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:56:53 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 00/23] target: code cleanup
Date:   Sat, 27 Feb 2021 21:56:22 -0800
Message-Id: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

This removes unused macros, various memset, extra variable in the 
target/iblock for bio get and fixes type mismatch for the same.

The unused macros warning are found at compile time and they are
documented in each patch commit log. For memset removal, there are no
warnings.

First four patches are target_core_iblock.c cleanup. The next six
patches are removal of the unused macros followed by elevan patches to 
remove the memset for local array buffers. The last patch is for
removing the duplicate memset to initialize the buffer to 0xff.
 
I've tested this patch series with creating target bdev backend with
loop back transport, fio verification job seems to work fine.

Any feedback is welcome.

This is generated on today's linux-block for-next.

-ck

Chaitanya Kulkarni (23):
  target/iblock: remove an extra argument
  target/iblock: trim down line longer than 80 char
  target/iblock: fix the type of the logs_per_phys
  targe/pscsi: fix the warning in pscsi_complete_cmd
  target/sbc: get rid of the warning in cmp & write
  target/pscsi: remove unsed macro ISPRINT
  target/stat: remove unsed macro ISPRINT
  target/stat: remove unsed macro NONE
  target/stat: remove unsed macro
  target/iscsi: remove unsed macro TEXT_LEN
  target/iscsi: remove unsed macro PRINT_BUF
  target/iscsi: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/pr: remove the memset with declare-init
  target/pr: remove the memset with declare-init
  target/pr: remove the memset with declare-init
  target/core: don't duplicate memset 0xff

 drivers/target/iscsi/iscsi_target_configfs.c |  3 +-
 drivers/target/iscsi/iscsi_target_nego.c     |  1 -
 drivers/target/iscsi/iscsi_target_stat.c     |  1 -
 drivers/target/iscsi/iscsi_target_util.c     | 17 ---------
 drivers/target/target_core_configfs.c        | 25 ++++---------
 drivers/target/target_core_file.c            |  3 +-
 drivers/target/target_core_iblock.c          | 37 ++++++++++----------
 drivers/target/target_core_pr.c              | 36 +++++++------------
 drivers/target/target_core_pscsi.c           |  5 ++-
 drivers/target/target_core_sbc.c             |  4 +--
 drivers/target/target_core_stat.c            |  3 --
 11 files changed, 45 insertions(+), 90 deletions(-)

Test log for fio verification job with bdev backend with loop transport:-
# ./create_lio.sh 
+ targetcli clearconfig confirm=True
+ clear_dmesg
All configuration cleared
+ rmdir config/target/iscsi
+ rmdir config/target/loopback
+ modprobe -r iscsi_target_mod
+ modprobe -r tcm_loop
+ modprobe -r target_core_file
+ modprobe -r target_core_pscsi
+ modprobe -r target_core_iblock
+ modprobe -r target_core_user
+ modprobe -r target_core_mod
+ lsmod
+ grep target
++ nproc
+ make -j 64 M=drivers/target modules
+ TARGET=drivers/target
++ uname -r
+ TARGET_DEST=/lib/modules/5.11.0blk+/kernel/drivers/target/
+ TARGET_LOOPBACK=drivers/target/loopback
++ uname -r
+ TARGET_LOOPBACK_DEST=/lib/modules/5.11.0blk+/kernel/drivers/target/loopback
+ TARGET_ISCSI=drivers/target/iscsi/
++ uname -r
+ TARGET_ISCSI_DEST=/lib/modules/5.11.0blk+/kernel/drivers/target/iscsi
+ cp drivers/target/target_core_file.ko drivers/target/target_core_iblock.ko drivers/target/target_core_mod.ko drivers/target/target_core_pscsi.ko drivers/target/target_core_user.ko /lib/modules/5.11.0blk+/kernel/drivers/target//
+ cp drivers/target/loopback/tcm_loop.ko /lib/modules/5.11.0blk+/kernel/drivers/target/loopback/
+ cp drivers/target/iscsi//iscsi_target_mod.ko /lib/modules/5.11.0blk+/kernel/drivers/target/iscsi/
+ find /lib/modules/5.11.0blk+/kernel/drivers/target/ -name '*ko'
+ xargs ls -l
-rw-r--r--. 1 root root 3650814 Feb 27 18:32 /lib/modules/5.11.0blk+/kernel/drivers/target/iscsi/cxgbit/cxgbit.ko
-rw-r--r--. 1 root root 9502192 Feb 27 21:15 /lib/modules/5.11.0blk+/kernel/drivers/target/iscsi/iscsi_target_mod.ko
-rw-r--r--. 1 root root 9502192 Feb 27 21:02 /lib/modules/5.11.0blk+/kernel/drivers/target/loopback/iscsi_target_mod.ko
-rw-r--r--. 1 root root  610912 Feb 27 21:15 /lib/modules/5.11.0blk+/kernel/drivers/target/loopback/tcm_loop.ko
-rw-r--r--. 1 root root  554664 Feb 27 21:15 /lib/modules/5.11.0blk+/kernel/drivers/target/target_core_file.ko
-rw-r--r--. 1 root root  573760 Feb 27 21:15 /lib/modules/5.11.0blk+/kernel/drivers/target/target_core_iblock.ko
-rw-r--r--. 1 root root 9450112 Feb 27 21:15 /lib/modules/5.11.0blk+/kernel/drivers/target/target_core_mod.ko
-rw-r--r--. 1 root root  626880 Feb 27 21:15 /lib/modules/5.11.0blk+/kernel/drivers/target/target_core_pscsi.ko
-rw-r--r--. 1 root root 1044992 Feb 27 21:15 /lib/modules/5.11.0blk+/kernel/drivers/target/target_core_user.ko
-rw-r--r--. 1 root root 1808854 Feb 27 18:32 /lib/modules/5.11.0blk+/kernel/drivers/target/tcm_fc/tcm_fc.ko
+ modprobe target_core_file
+ modprobe target_core_pscsi
+ modprobe target_core_iblock
+ modprobe target_core_user
+ modprobe target_core_mod
+ lsmod
+ grep target_core
target_core_user       57344  0 
uio                    24576  1 target_core_user
target_core_iblock     28672  0 
target_core_pscsi      28672  0 
target_core_file       28672  0 
target_core_mod       450560  4 target_core_file,target_core_iblock,target_core_pscsi,target_core_user
+ tree config/target
config/target
├── core
│   └── alua
│       └── lu_gps
│           └── default_lu_gp
│               ├── lu_gp_id
│               └── members
├── dbroot
└── version

4 directories, 4 files
+ targetcli restoreconfig ./lio.json
Configuration restored, 2 recoverable errors:
Storage Object block/bdev: Cannot set attribute alua_support: [Errno 22] Invalid argument, skipped
Storage Object block/bdev: Cannot set attribute pgr_support: [Errno 22] Invalid argument, skipped
+ lsscsi
[0:0:0:0]    disk    ATA      QEMU HARDDISK    2.5+  /dev/sdc 
[0:0:1:0]    disk    ATA      QEMU HARDDISK    2.5+  /dev/sdd 
[1:0:0:0]    disk    ATA      QEMU HARDDISK    2.5+  /dev/sda 
[1:0:1:0]    disk    ATA      QEMU HARDDISK    2.5+  /dev/sdb 
[2:0:1:0]    disk    LIO-ORG  bdev             4.0   /dev/sde 
# 
# 
# 
# cat fio/verify.fio 
[write-and-verify]
rw=randwrite
bs=4k
direct=1
ioengine=libaio
iodepth=16
norandommap
randrepeat=0
verify=crc32c
size=500m
group_reporting
# lsblk | grep sde 
sde                 8:64   0    2G  0 disk 
# fio fio/verify.fio --filename=/dev/sde
write-and-verify: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=16
fio-3.8-5-g464b
Starting 1 process
Jobs: 1 (f=1): [V(1)][84.6%][r=81.2MiB/s,w=0KiB/s][r=20.8k,w=0 IOPS][eta 00m:02s]      
write-and-verify: (groupid=0, jobs=1): err= 0: pid=20096: Sat Feb 27 21:17:35 2021
   read: IOPS=21.3k, BW=83.3MiB/s (87.4MB/s)(316MiB/3796msec)
    slat (usec): min=9, max=348, avg=11.37, stdev= 4.64
    clat (usec): min=138, max=1946, avg=737.14, stdev=199.40
     lat (usec): min=208, max=2273, avg=748.62, stdev=202.00
    clat percentiles (usec):
     |  1.00th=[  490],  5.00th=[  502], 10.00th=[  519], 20.00th=[  701],
     | 30.00th=[  709], 40.00th=[  717], 50.00th=[  725], 60.00th=[  725],
     | 70.00th=[  725], 80.00th=[  734], 90.00th=[  750], 95.00th=[ 1352],
     | 99.00th=[ 1549], 99.50th=[ 1598], 99.90th=[ 1844], 99.95th=[ 1876],
     | 99.99th=[ 1926]
  write: IOPS=17.0k, BW=70.2MiB/s (73.6MB/s)(500MiB/7123msec)
    slat (usec): min=10, max=420, avg=13.99, stdev= 5.67
    clat (usec): min=103, max=2436, avg=875.65, stdev=233.59
     lat (usec): min=116, max=2508, avg=889.75, stdev=236.91
    clat percentiles (usec):
     |  1.00th=[  498],  5.00th=[  611], 10.00th=[  709], 20.00th=[  791],
     | 30.00th=[  807], 40.00th=[  816], 50.00th=[  824], 60.00th=[  832],
     | 70.00th=[  848], 80.00th=[  906], 90.00th=[  996], 95.00th=[ 1516],
     | 99.00th=[ 1795], 99.50th=[ 1876], 99.90th=[ 2073], 99.95th=[ 2147],
     | 99.99th=[ 2343]
   bw (  KiB/s): min=16864, max=90064, per=94.95%, avg=68247.93, stdev=15516.59, samples=15
   iops        : min= 4216, max=22516, avg=17061.93, stdev=3879.14, samples=15
  lat (usec)   : 250=0.01%, 500=2.09%, 750=40.08%, 1000=49.07%
  lat (msec)   : 2=8.63%, 4=0.13%
  cpu          : usr=5.50%, sys=26.40%, ctx=13071, majf=0, minf=1913
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=80978,128000,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=83.3MiB/s (87.4MB/s), 83.3MiB/s-83.3MiB/s (87.4MB/s-87.4MB/s), io=316MiB (332MB), run=3796-3796msec
  WRITE: bw=70.2MiB/s (73.6MB/s), 70.2MiB/s-70.2MiB/s (73.6MB/s-73.6MB/s), io=500MiB (524MB), run=7123-7123msec

Disk stats (read/write):
  sde: ios=78668/128000, merge=0/0, ticks=47413/92827, in_queue=140240, util=99.16%
# targetcli clearconfig confirm=True
All configuration cleared
#
-- 
2.22.1

