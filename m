From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH 0/1] aacraid: Host adapter Adaptec 6405 constantly resets under high io load
Date: Thu, 27 Jun 2019 19:14:07 +0300
Message-ID: <20190627161408.10295-1-khorenko@virtuozzo.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Prasad B Munirathnam <prasad.munirathnam@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Problem description:
====================
A node with Adaptec 6405 controller, latest BIOS V5.3-0[19204]
A lot of disks attached to the controller.
Simple test: running mkfs.ext4 on many disks on the same controller in
parallel
(mkfs is not important here, any serious io load triggers controller aborts)

Results:
* no problems (controller resets) with kernels prior to
  395e5df79a95 ("scsi: aacraid: Remove reference to Series-9")

* latest ms kernel v5.2-rc6-15-g249155c20f9b - mkfs processes are in D state,
  lot of complains in logs like:

  [  654.894633] aacraid: Host adapter abort request.
  aacraid: Outstanding commands on (0,1,43,0):
  [  699.441034] aacraid: Host adapter abort request.
  aacraid: Outstanding commands on (0,1,40,0):
  [  699.442950] aacraid: Host adapter reset request. SCSI hang ?
  [  714.457428] aacraid: Host adapter reset request. SCSI hang ?
  ...
  [  759.514759] aacraid: Host adapter reset request. SCSI hang ?
  [  759.514869] aacraid 0000:03:00.0: outstanding cmd: midlevel-0
  [  759.514870] aacraid 0000:03:00.0: outstanding cmd: lowlevel-0
  [  759.514872] aacraid 0000:03:00.0: outstanding cmd: error handler-498
  [  759.514873] aacraid 0000:03:00.0: outstanding cmd: firmware-471
  [  759.514875] aacraid 0000:03:00.0: outstanding cmd: kernel-60
  [  759.514912] aacraid 0000:03:00.0: Controller reset type is 3
  [  759.515013] aacraid 0000:03:00.0: Issuing IOP reset
  [  850.296705] aacraid 0000:03:00.0: IOP reset succeeded

Same complains on Ubuntu kernel 4.15.0-50-generic:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1777586

Controller:
===========
03:00.0 RAID bus controller: Adaptec Series 6 - 6G SAS/PCIe 2 (rev 01)
         Subsystem: Adaptec Series 6 - ASR-6405 - 4 internal 6G SAS ports

Test:
=====
# cat dev.list
/dev/sdq1
/dev/sde1
/dev/sds1
/dev/sdb1
/dev/sdk1
/dev/sdaj1
/dev/sdaf1
/dev/sdd1
/dev/sdac1
/dev/sdai1
/dev/sdz1
/dev/sdj1
/dev/sdy1
/dev/sdn1
/dev/sdae1
/dev/sdg1
/dev/sdi1
/dev/sdc1
/dev/sdf1
/dev/sdl1
/dev/sda1
/dev/sdab1
/dev/sdr1
/dev/sdo1
/dev/sdah1
/dev/sdm1
/dev/sdt1
/dev/sdp1
/dev/sdad1
/dev/sdh1

===========================================
# cat run_mkfs.sh
#!/bin/bash

while read i; do
   mkfs.ext4 $i -q -E lazy_itable_init=1 -O uninit_bg -m 0 &
done

=================================
# cat dev.list | ./run_mkfs.sh

The issue is 100% reproducible.

i've bisected to the culprit patch, it's
395e5df79a95 ("scsi: aacraid: Remove reference to Series-9")

it changes arc ctrl checks for Series-6 controllers
and i've checked that resurrection of original logic in arc ctrl checks
eliminates controller hangs/resets.


Konstantin Khorenko (1):
  scsi: aacraid: resurrect correct arc ctrl checks for Series-6

 drivers/scsi/aacraid/aacraid.h  | 11 -----------
 drivers/scsi/aacraid/comminit.c | 14 ++++++++++----
 drivers/scsi/aacraid/commsup.c  |  4 +++-
 drivers/scsi/aacraid/linit.c    |  7 +++++--
 4 files changed, 18 insertions(+), 18 deletions(-)

-- 
2.15.1
