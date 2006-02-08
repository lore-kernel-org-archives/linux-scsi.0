From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 9/22] lpfc 8.1.2 :  Add module parameter to limit number of
 outstanding commands per lpfc HBA
Date: Wed, 08 Feb 2006 10:42:00 -0500
Message-ID: <43EA1148.9090507@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38541 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030445AbWBHPmD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:42:03 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Fg2rf011871
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:42:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Add module parameter to limit number of outstanding commands per lpfc HBA


Signed-off-by: James Smart <James.Smart@emulex.com>

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

