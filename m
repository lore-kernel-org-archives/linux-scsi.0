From: James Smart <james.smart@emulex.com>
Subject: [PATCH] lpfc: Removed obsolete fcp_eq_count and fcp_wq_count driver
 attributes
Date: Fri, 2 Aug 2013 15:32:27 -0400
Message-ID: <1375471947.6339.4.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:57674 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab3HBTcx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Aug 2013 15:32:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Removed obsolete fcp_eq_count and fcp_wq_count driver attributes.

The patches were cut against scsi.git, branch "misc", plus the lpfc 8.3.41 patch set
posted a couple of weeks ago.

-- james


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    2 --
 lpfc_attr.c |   23 -----------------------
 lpfc_init.c |    7 -------
 3 files changed, 32 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-08-02 14:14:38.269047324 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-08-02 15:08:03.112120297 -0400
@@ -4121,25 +4121,6 @@ LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Messa
 	    "MSI-X (2), if possible");
 
 /*
-# lpfc_fcp_wq_count: Set the number of fast-path FCP work queues
-# This parameter is ignored and will eventually be depricated
-#
-# Value range is [1,7]. Default value is 4.
-*/
-LPFC_ATTR_R(fcp_wq_count, LPFC_FCP_IO_CHAN_DEF, LPFC_FCP_IO_CHAN_MIN,
-	    LPFC_FCP_IO_CHAN_MAX,
-	    "Set the number of fast-path FCP work queues, if possible");
-
-/*
-# lpfc_fcp_eq_count: Set the number of FCP EQ/CQ/WQ IO channels
-#
-# Value range is [1,7]. Default value is 4.
-*/
-LPFC_ATTR_R(fcp_eq_count, LPFC_FCP_IO_CHAN_DEF, LPFC_FCP_IO_CHAN_MIN,
-	    LPFC_FCP_IO_CHAN_MAX,
-	    "Set the number of fast-path FCP event queues, if possible");
-
-/*
 # lpfc_fcp_io_channel: Set the number of FCP EQ/CQ/WQ IO channels
 #
 # Value range is [1,7]. Default value is 4.
@@ -4317,8 +4298,6 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_use_msi,
 	&dev_attr_lpfc_fcp_imax,
 	&dev_attr_lpfc_fcp_cpu_map,
-	&dev_attr_lpfc_fcp_wq_count,
-	&dev_attr_lpfc_fcp_eq_count,
 	&dev_attr_lpfc_fcp_io_channel,
 	&dev_attr_lpfc_enable_bg,
 	&dev_attr_lpfc_soft_wwnn,
@@ -5301,8 +5280,6 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_use_msi_init(phba, lpfc_use_msi);
 	lpfc_fcp_imax_init(phba, lpfc_fcp_imax);
 	lpfc_fcp_cpu_map_init(phba, lpfc_fcp_cpu_map);
-	lpfc_fcp_wq_count_init(phba, lpfc_fcp_wq_count);
-	lpfc_fcp_eq_count_init(phba, lpfc_fcp_eq_count);
 	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
 	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
 	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2013-08-02 14:14:38.305047324 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2013-08-02 15:09:36.199122417 -0400
@@ -711,8 +711,6 @@ struct lpfc_hba {
 	uint32_t cfg_use_msi;
 	uint32_t cfg_fcp_imax;
 	uint32_t cfg_fcp_cpu_map;
-	uint32_t cfg_fcp_wq_count;
-	uint32_t cfg_fcp_eq_count;
 	uint32_t cfg_fcp_io_channel;
 	uint32_t cfg_total_seg_cnt;
 	uint32_t cfg_sg_seg_cnt;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-08-02 14:14:38.086047320 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-08-02 15:08:13.576120536 -0400
@@ -4913,9 +4913,6 @@ lpfc_sli4_driver_resource_setup(struct l
 	lpfc_get_cfgparam(phba);
 	phba->max_vpi = LPFC_MAX_VPI;
 
-	/* Eventually cfg_fcp_eq_count / cfg_fcp_wq_count will be depricated */
-	phba->cfg_fcp_io_channel = phba->cfg_fcp_eq_count;
-
 	/* This will be set to correct value after the read_config mbox */
 	phba->max_vports = 0;
 
@@ -6873,11 +6870,7 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 		cfg_fcp_io_channel = phba->sli4_hba.max_cfg_param.max_eq;
 	}
 
-	/* Eventually cfg_fcp_eq_count / cfg_fcp_wq_count will be depricated */
-
 	/* The actual number of FCP event queues adopted */
-	phba->cfg_fcp_eq_count = cfg_fcp_io_channel;
-	phba->cfg_fcp_wq_count = cfg_fcp_io_channel;
 	phba->cfg_fcp_io_channel = cfg_fcp_io_channel;
 
 	/* Get EQ depth from module parameter, fake the default for now */


