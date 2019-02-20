From: Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH] scsi: replace GFP_ATOMIC with GFP_KERNEL for sdev allocation
Date: Wed, 20 Feb 2019 19:48:47 +0100
Message-ID: <20190220184847.24640-1-bblock@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Benjamin Block <bblock@linux.ibm.com>, Steffen Maier <maier@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We had a test-report where, under memory pressure, adding LUNs to the
systems would fail (the tests add LUNs strictly in sequence):

[ 5525.853432] scsi 0:0:1:1088045124: Direct-Access     IBM      2107900          .148 PQ: 0 ANSI: 5
[ 5525.853826] scsi 0:0:1:1088045124: alua: supports implicit TPGS
[ 5525.853830] scsi 0:0:1:1088045124: alua: device naa.6005076303ffd32700000000000044da port group 0 rel port 43
[ 5525.853931] sd 0:0:1:1088045124: Attached scsi generic sg10 type 0
[ 5525.854075] sd 0:0:1:1088045124: [sdk] Disabling DIF Type 1 protection
[ 5525.855495] sd 0:0:1:1088045124: [sdk] 2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)
[ 5525.855606] sd 0:0:1:1088045124: [sdk] Write Protect is off
[ 5525.855609] sd 0:0:1:1088045124: [sdk] Mode Sense: ed 00 00 08
[ 5525.855795] sd 0:0:1:1088045124: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 5525.857838]  sdk: sdk1
[ 5525.859468] sd 0:0:1:1088045124: [sdk] Attached SCSI disk
[ 5525.865073] sd 0:0:1:1088045124: alua: transition timeout set to 60 seconds
[ 5525.865078] sd 0:0:1:1088045124: alua: port group 00 state A preferred supports tolusnA
[ 5526.015070] sd 0:0:1:1088045124: alua: port group 00 state A preferred supports tolusnA
[ 5526.015213] sd 0:0:1:1088045124: alua: port group 00 state A preferred supports tolusnA
[ 5526.587439] scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
[ 5526.588562] scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured

Looking at the code of scsi_alloc_sdev(), and all the calling contexts,
there seems to be no reason to use GFP_ATMOIC here. All the different
call-contexts use a mutex at some point, and nothing in between that
requires no sleeping, as far as I could see. Additionally, the code that
allocates the block queue for the device later (scsi_mq_alloc_queue())
already uses GFP_KERNEL.

So replace it, and give the allocation a bit of a better chance to succeed,
with more ways of reclaim.

Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index dd0d516f65e2..e49e6099b852 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -220,7 +220,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
-		       GFP_ATOMIC);
+		       GFP_KERNEL);
 	if (!sdev)
 		goto out;
 
-- 
2.20.1
