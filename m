From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 9/22] lpfc 8.1.2: Add module parameter to limit number of outstanding commands per lpfc HBA
Date: Tue, 28 Feb 2006 19:25:21 -0500
Message-ID: <20060301002521.GA15445@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:44966 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964848AbWCAAZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:23 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PLjf015451
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:22 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PLvV015450
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add module parameter to limit number of outstanding commands per lpfc HBA

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -520,6 +520,16 @@ LPFC_ATTR_R(lun_queue_depth, 30, 1, 128,
 	    "Max number of FCP commands we can queue to a specific LUN");
 
 /*
+# hba_queue_depth:  This parameter is used to limit the number of outstanding
+# commands per lpfc HBA. Value range is [32,8192]. If this parameter
+# value is greater than the maximum number of exchanges supported by the HBA,
+# then maximum number of exchanges supported by the HBA is used to determine
+# the hba_queue_depth.
+*/
+LPFC_ATTR_R(hba_queue_depth, 8192, 32, 8192,
+	    "Max number of FCP commands we can queue to a lpfc HBA");
+
+/*
 # Some disk devices have a "select ID" or "select Target" capability.
 # From a protocol standpoint "select ID" usually means select the
 # Fibre channel "ALPA".  In the FC-AL Profile there is an "informative
@@ -649,6 +659,7 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_lpfc_drvr_version,
 	&class_device_attr_lpfc_log_verbose,
 	&class_device_attr_lpfc_lun_queue_depth,
+	&class_device_attr_lpfc_hba_queue_depth,
 	&class_device_attr_lpfc_nodev_tmo,
 	&class_device_attr_lpfc_fcp_class,
 	&class_device_attr_lpfc_use_adisc,
@@ -1411,5 +1422,9 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	default:
 		phba->cfg_hba_queue_depth = LPFC_DFT_HBA_Q_DEPTH;
 	}
+
+	if (phba->cfg_hba_queue_depth > lpfc_hba_queue_depth)
+		lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
+
 	return;
 }
