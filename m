From: brking@us.ibm.com
Subject: [PATCH 05/15] ipr: Setup max_sectors based on device type
Date: Mon, 21 Feb 2005 15:08:57 -0600
Message-ID: <200502212108.j1LL8vvf014695@d01av04.pok.ibm.com>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56508 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262117AbVBUVI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:08:59 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL8w0X024504
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:58 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL8wew056826
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:58 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL8w7K014710
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The ipr family of adapters is capable of handling data transfer sizes of
16777215 bytes. Logical disk array devices under ipr are capable of only
256k transfer lengths. Patch sets max_sectors of the adapter to 32767 and
overrides max_sectors for the logical disk array devices in the
slave_configure routine.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |    6 ++++--
 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_max_sectors drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_max_sectors	2005-02-21 13:11:55.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:11:55.000000000 -0600
@@ -2833,8 +2833,10 @@ static int ipr_slave_configure(struct sc
 			sdev->type = TYPE_RAID;
 		if (ipr_is_af_dasd_device(res) || ipr_is_ioa_resource(res))
 			sdev->scsi_level = 4;
-		if (ipr_is_vset_device(res))
+		if (ipr_is_vset_device(res)) {
 			sdev->timeout = IPR_VSET_RW_TIMEOUT;
+			blk_queue_max_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
+		}
 		if (IPR_IS_DASD_DEVICE(res->cfgte.std_inq_data))
 			sdev->allow_restart = 1;
 		scsi_adjust_queue_depth(sdev, 0, res->qdepth);
@@ -3952,7 +3954,7 @@ static struct scsi_host_template driver_
 	.can_queue = IPR_MAX_COMMANDS,
 	.this_id = -1,
 	.sg_tablesize = IPR_MAX_SGLIST,
-	.max_sectors = IPR_MAX_SECTORS,
+	.max_sectors = IPR_IOA_MAX_SECTORS,
 	.cmd_per_lun = IPR_MAX_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = ipr_ioa_attrs,
diff -puN drivers/scsi/ipr.h~ipr_max_sectors drivers/scsi/ipr.h
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.h~ipr_max_sectors	2005-02-21 13:11:55.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h	2005-02-21 13:11:55.000000000 -0600
@@ -130,7 +130,8 @@
 #define IPR_MAX_PHYSICAL_DEVS				192
 
 #define IPR_MAX_SGLIST					64
-#define IPR_MAX_SECTORS					512
+#define IPR_IOA_MAX_SECTORS				32767
+#define IPR_VSET_MAX_SECTORS				512
 #define IPR_MAX_CDB_LEN					16
 
 #define IPR_DEFAULT_BUS_WIDTH				16
_
