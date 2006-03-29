From: Brian King <brking@us.ibm.com>
Subject: [PATCH 06/10] ipr: Fixup device type check
Date: Wed, 29 Mar 2006 08:38:25 -0600
Message-ID: <200603291438.k2TEcPDf010568@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:20710 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751101AbWC2Oi1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 09:38:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, brking@us.ibm.com


Fixup a check used by the ipr driver to determine if a given
device is a SCSI disk. Due to the addition of support for
attaching SATA devices, this check needs to be more robust.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/ipr.c |    4 ++--
 libata-dev-bjking1/drivers/scsi/ipr.h |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_fixup_is_dasd_check drivers/scsi/ipr.h
--- libata-dev/drivers/scsi/ipr.h~ipr_fixup_is_dasd_check	2006-02-14 09:53:17.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.h	2006-02-14 09:53:17.000000000 -0600
@@ -1305,6 +1305,22 @@ static inline int ipr_is_gscsi(struct ip
 }
 
 /**
+ * ipr_is_scsi_disk - Determine if a resource is a SCSI disk
+ * @res:	resource entry struct
+ *
+ * Return value:
+ * 	1 if SCSI disk / 0 if not SCSI disk
+ **/
+static inline int ipr_is_scsi_disk(struct ipr_resource_entry *res)
+{
+	if (ipr_is_af_dasd_device(res) ||
+	    (ipr_is_gscsi(res) && IPR_IS_DASD_DEVICE(res->cfgte.std_inq_data)))
+		return 1;
+	else
+		return 0;
+}
+
+/**
  * ipr_is_naca_model - Determine if a resource is using NACA queueing model
  * @res:	resource entry struct
  *
diff -puN drivers/scsi/ipr.c~ipr_fixup_is_dasd_check drivers/scsi/ipr.c
--- libata-dev/drivers/scsi/ipr.c~ipr_fixup_is_dasd_check	2006-02-14 09:53:17.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.c	2006-02-14 09:53:17.000000000 -0600
@@ -3214,7 +3214,7 @@ static int ipr_slave_configure(struct sc
 			sdev->timeout = IPR_VSET_RW_TIMEOUT;
 			blk_queue_max_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
 		}
-		if (IPR_IS_DASD_DEVICE(res->cfgte.std_inq_data))
+		if (ipr_is_vset_device(res) || ipr_is_scsi_disk(res))
 			sdev->allow_restart = 1;
 		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 	}
@@ -4540,7 +4540,7 @@ static int ipr_set_supported_devs(struct
 	ipr_cmd->job_step = ipr_ioa_reset_done;
 
 	list_for_each_entry_continue(res, &ioa_cfg->used_res_q, queue) {
-		if (!IPR_IS_DASD_DEVICE(res->cfgte.std_inq_data))
+		if (!ipr_is_scsi_disk(res))
 			continue;
 
 		ipr_cmd->u.res = res;
_
