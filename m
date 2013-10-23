From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] libsas: fix usage of ata_tf_to_fis
Date: Tue, 22 Oct 2013 18:35:19 -0700
Message-ID: <20131023013456.18051.96678.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64361 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab3JWBfV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Oct 2013 21:35:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com
Cc: Praveen Murali <pmurali@logicube.com>, Dave Jiang <dave.jiang@intel.com>, Maciej Patelczyk <maciej.patelczyk@intel.com>, linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>, lindar_liu@usish.com, xjtuwjp@gmail.com, Xiangliang Yu <yuxiangl@marvell.com>, stable@vger.kernel.org

Since commit 110dd8f19df5 "[SCSI] libsas: fix scr_read/write users and
update the libata documentation" we have been passing pmp=1 and is_cmd=0
to ata_tf_to_fis().  Praveen reports that eSATA attached drives do not
discover correctly.  His investigation found that the BIOS was passing
pmp=0 while Linux was passing pmp=1 and failing to discover the drives.
Update libsas to follow the libata example of pulling the pmp setting
from the ata_link and correct is_cmd to be 1 since all tf's submitted
through ->qc_issue are commands.  Presumably libsas lldds do not care
about is_cmd as they have sideband mechanisms to perform link
management.

http://marc.info/?l=linux-scsi&m=138179681726990&w=2

Cc: xjtuwjp@gmail.com
Cc: lindar_liu@usish.com
Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: stable@vger.kernel.org
Reported-by: Praveen Murali <pmurali@logicube.com>
Tested-by: Praveen Murali <pmurali@logicube.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 161c98efade9..d0fb99d5da95 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -211,7 +211,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		qc->tf.nsect = 0;
 	}
 
-	ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8*)&task->ata_task.fis);
 	task->uldd_task = qc;
 	if (ata_is_atapi(qc->tf.protocol)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);

