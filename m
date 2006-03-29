From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/6] ipr: Fixup device type check
Date: Wed, 29 Mar 2006 09:37:22 -0600
Message-ID: <200603291537.k2TFbMGA030817@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:14792 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751178AbWC2PhY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 10:37:24 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2TFbN5V008437
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:23 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2TFbNYX229100
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:23 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k2TFbNRB030849
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


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
