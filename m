From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 09/19] sd, sr: Convert two assignments into warning statements
Date: Wed, 23 Aug 2017 14:39:59 -0700
Message-ID: <20170823214009.15015-10-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45883 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdHWVm1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:42:27 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>

Before scsi_prep_fn() calls the ULP .init_command() callback
function it stores the SCSI command pointer in request.special.
This means that the SCpnt = rq->special assignments in the sd
and sr drivers assign a pointer to itself. Hence convert these
two assignment statements into warning statements.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 2 +-
 drivers/scsi/sr.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bea36adeee17..a88639fbedb3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1013,7 +1013,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	ret = scsi_init_io(SCpnt);
 	if (ret != BLKPREP_OK)
 		goto out;
-	SCpnt = rq->special;
+	WARN_ON_ONCE(SCpnt != rq->special);
 
 	/* from here on until we're complete, any goto out
 	 * is used for a killable error condition */
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a8f630213a1a..9be34d37c356 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -393,7 +393,7 @@ static int sr_init_command(struct scsi_cmnd *SCpnt)
 	ret = scsi_init_io(SCpnt);
 	if (ret != BLKPREP_OK)
 		goto out;
-	SCpnt = rq->special;
+	WARN_ON_ONCE(SCpnt != rq->special);
 	cd = scsi_cd(rq->rq_disk);
 
 	/* from here on until we're complete, any goto out
-- 
2.14.0
