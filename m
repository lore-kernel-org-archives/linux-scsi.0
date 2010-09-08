From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/12] zfcp: Add zfcp private struct as SCSI device driver data
Date: Wed, 08 Sep 2010 14:39:51 +0200
Message-ID: <20100908124352.825446061@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:56557 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725Ab0IHMn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:57 -0400
Content-Disposition: inline; filename=701-zfcp-private-struct.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Add a new data structure zfcp_scsi_dev that holds zfcp private data
for each SCSI device. Use scsi_transport_reserve_device to let the
SCSI midlayer automatically allocate this with each SCSI device.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    3 +++
 drivers/s390/scsi/zfcp_def.h |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2010-09-08 08:49:26.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2010-09-08 08:49:26.000000000 +0200
@@ -159,6 +159,9 @@ static int __init zfcp_module_init(void)
 		fc_attach_transport(&zfcp_transport_functions);
 	if (!zfcp_data.scsi_transport_template)
 		goto out_transport;
+	scsi_transport_reserve_device(zfcp_data.scsi_transport_template,
+				      sizeof(struct zfcp_scsi_dev));
+
 
 	retval = misc_register(&zfcp_cfdc_misc);
 	if (retval) {
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2010-09-08 08:49:06.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2010-09-08 08:49:26.000000000 +0200
@@ -234,6 +234,45 @@ struct zfcp_unit {
 };
 
 /**
+ * struct zfcp_scsi_dev - zfcp data per SCSI device
+ * @status: zfcp internal status flags
+ * @lun_handle: handle from "open lun" for issuing FSF requests
+ * @erp_action: zfcp erp data for opening and recovering this LUN
+ * @erp_counter: zfcp erp counter for this LUN
+ * @latencies: FSF channel and fabric latencies
+ * @port: zfcp_port where this LUN belongs to
+ */
+struct zfcp_scsi_dev {
+	atomic_t		status;
+	u32			lun_handle;
+	struct zfcp_erp_action	erp_action;
+	atomic_t		erp_counter;
+	struct zfcp_latencies	latencies;
+	struct zfcp_port	*port;
+};
+
+/**
+ * sdev_to_zfcp - Access zfcp LUN data for SCSI device
+ * @sdev: scsi_device where to get the zfcp_scsi_dev pointer
+ */
+static inline struct zfcp_scsi_dev *sdev_to_zfcp(struct scsi_device *sdev)
+{
+	return scsi_transport_device_data(sdev);
+}
+
+/**
+ * zfcp_scsi_dev_lun - Return SCSI device LUN as 64 bit FCP LUN
+ * @sdev: SCSI device where to get the LUN from
+ */
+static inline u64 zfcp_scsi_dev_lun(struct scsi_device *sdev)
+{
+	u64 fcp_lun;
+
+	int_to_scsilun(sdev->lun, (struct scsi_lun *)&fcp_lun);
+	return fcp_lun;
+}
+
+/**
  * struct zfcp_fsf_req - basic FSF request structure
  * @list: list of FSF requests
  * @req_id: unique request ID

