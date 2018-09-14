From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] scsi: core: drop excess unlikely() from BUG_ON()
Date: Fri, 14 Sep 2018 12:48:27 +0200
Message-ID: <1536922107-2649-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-scsi@vger.kernel.org

 include/asm-generic/bug.h defines BUG_ON(condition) as
do { if (unlikely(condition)) BUG(); } while (0).
So BUG_ON already provides unlikely() to the condition so there is no point
in having a unlikely(unlikely(condition)) - drop the excess unlikely()

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---
Found during code review

Patch was compile tested with: x86_64_defconfig (implies CONFIG_SCSI)
SCSI_LOWLEVE=y, SCSI_HISI_SAS=y, COMPILE_TEST=y
(with some unrelated sparse warnings and some pending coccinelle findings)

Patch is against 4.19-rc3 (localversion-next is next-20180913)

 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eb97d2d..0b4132f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1201,8 +1201,8 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 
 		count = blk_rq_map_integrity_sg(rq->q, rq->bio,
 						prot_sdb->table.sgl);
-		BUG_ON(unlikely(count > ivecs));
-		BUG_ON(unlikely(count > queue_max_integrity_segments(rq->q)));
+		BUG_ON(count > ivecs);
+		BUG_ON(count > queue_max_integrity_segments(rq->q));
 
 		cmd->prot_sdb = prot_sdb;
 		cmd->prot_sdb->table.nents = count;
-- 
2.1.4
