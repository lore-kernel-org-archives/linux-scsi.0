Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545A8C4332E
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2452264FB3
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbhCJUCZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:02:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:2448 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbhCJUCQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:02:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406536; x=1646942536;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SXZ2P3HjiolxXZv7rEHyHy5DOvst7KXNbT3ZmA2NAd4=;
  b=JcaKuAVcVAQluZ5pW5wIEUgI7JtCALmW5p3BJ6aUou27AWCNDcA/Cye5
   4T8ektZun7wEPaX6vaoczIDrTiz3WzFof2DmcF6n5q03q7QxHLamv4Jw9
   JvRrUjFeD0VwhnRYc9lSLrmucnHjRV98QsTA7rxRVJFvZYkrzZgMEZvmP
   UKS7j8c3wjqHifdS3FevNlSJzIGUz7rF4sOildet7Klz+ydhuVbISBog1
   4sbrxUhbtTzdhBa19MUno7THRUGOzLmRxzopHanofIPbiq6uZl+rgk4zO
   /V50dOuCWLuBDYfn/GAO8J0ziTrWLiiA+XL6Ylx5iJClZu1KIl8nhyhi9
   g==;
IronPort-SDR: ADXuJWoNmU9CPKqhwdvGfSo6YfhXoH7qi+h0YZElbSPGJrEimWM6+McGxk+GWK9mHU0OMD5lYZ
 dWR51I3aS+b3G2K5IrgrjLMJI5QBZjgJpZy/JkrhSumzZ86Q64ysEXQ4+sgAp+BdNsPR0RB1kW
 wnLwclg6QGspEkx1bNaYaQl+rrOHqyr1+3rNDdKbrQ5eosNKe+TMsLP1EZmboH+rRrfD89MzfT
 ct6Y6WwB02WDwSq94lzYvlINBe2Jf8M9LHK0f+au+edT8JKP8nG8qsX7sh6pIYA2GKWP0/Q+yA
 l/k=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="109505683"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:02:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:02:07 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:02:06 -0700
Subject: [PATCH V4 14/31] smartpqi: remove timeouts from internal cmds
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:02:06 -0600
Message-ID: <161540652686.19430.10560002533756103262.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Remove timeouts for driver initiated commands.
 * Responses to internal requests can take longer
   than hard coded timeout values and the driver
   will still have an outstanding request that may
   complete in the future with no context.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    5 +
 drivers/scsi/smartpqi/smartpqi_init.c |  141 ++++++++++-----------------------
 2 files changed, 46 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 976bfd8c5192..8e5e2543c7cf 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -130,9 +130,12 @@ struct pqi_iu_header {
 				/* of this header */
 	__le16	response_queue_id;	/* specifies the OQ where the */
 					/* response IU is to be delivered */
-	u8	work_area[2];	/* reserved for driver use */
+	u16	driver_flags;	/* reserved for driver use */
 };
 
+/* manifest constants for pqi_iu_header.driver_flags */
+#define PQI_DRIVER_NONBLOCKABLE_REQUEST		0x1
+
 /*
  * According to the PQI spec, the IU header is only the first 4 bytes of our
  * pqi_iu_header structure.
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d605ef1b9968..176c0d1ac913 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -62,7 +62,7 @@ static void pqi_start_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_io_request *io_request);
 static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_iu_header *request, unsigned int flags,
-	struct pqi_raid_error_info *error_info, unsigned long timeout_msecs);
+	struct pqi_raid_error_info *error_info);
 static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd, u32 aio_handle, u8 *cdb,
 	unsigned int cdb_length, struct pqi_queue_group *queue_group,
@@ -274,33 +274,15 @@ static inline void pqi_ctrl_unblock_requests(struct pqi_ctrl_info *ctrl_info)
 	scsi_unblock_requests(ctrl_info->scsi_host);
 }
 
-static unsigned long pqi_wait_if_ctrl_blocked(struct pqi_ctrl_info *ctrl_info,
-	unsigned long timeout_msecs)
+static void pqi_wait_if_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
 {
-	unsigned long remaining_msecs;
-
 	if (!pqi_ctrl_blocked(ctrl_info))
-		return timeout_msecs;
+		return;
 
 	atomic_inc(&ctrl_info->num_blocked_threads);
-
-	if (timeout_msecs == NO_TIMEOUT) {
-		wait_event(ctrl_info->block_requests_wait,
-			!pqi_ctrl_blocked(ctrl_info));
-		remaining_msecs = timeout_msecs;
-	} else {
-		unsigned long remaining_jiffies;
-
-		remaining_jiffies =
-			wait_event_timeout(ctrl_info->block_requests_wait,
-				!pqi_ctrl_blocked(ctrl_info),
-				msecs_to_jiffies(timeout_msecs));
-		remaining_msecs = jiffies_to_msecs(remaining_jiffies);
-	}
-
+	wait_event(ctrl_info->block_requests_wait,
+		!pqi_ctrl_blocked(ctrl_info));
 	atomic_dec(&ctrl_info->num_blocked_threads);
-
-	return remaining_msecs;
 }
 
 static inline void pqi_ctrl_wait_until_quiesced(struct pqi_ctrl_info *ctrl_info)
@@ -511,6 +493,7 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
 		put_unaligned_be32(cdb_length, &cdb[6]);
 		break;
 	case SA_FLUSH_CACHE:
+		request->header.driver_flags = PQI_DRIVER_NONBLOCKABLE_REQUEST;
 		request->data_direction = SOP_WRITE_FLAG;
 		cdb[0] = BMIC_WRITE;
 		cdb[6] = BMIC_FLUSH_CACHE;
@@ -605,7 +588,7 @@ static void pqi_free_io_request(struct pqi_io_request *io_request)
 
 static int pqi_send_scsi_raid_request(struct pqi_ctrl_info *ctrl_info, u8 cmd,
 	u8 *scsi3addr, void *buffer, size_t buffer_length, u16 vpd_page,
-	struct pqi_raid_error_info *error_info,	unsigned long timeout_msecs)
+	struct pqi_raid_error_info *error_info)
 {
 	int rc;
 	struct pqi_raid_path_request request;
@@ -616,8 +599,7 @@ static int pqi_send_scsi_raid_request(struct pqi_ctrl_info *ctrl_info, u8 cmd,
 	if (rc)
 		return rc;
 
-	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0,
-		error_info, timeout_msecs);
+	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, error_info);
 
 	pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1, dir);
 
@@ -630,7 +612,7 @@ static inline int pqi_send_ctrl_raid_request(struct pqi_ctrl_info *ctrl_info,
 	u8 cmd, void *buffer, size_t buffer_length)
 {
 	return pqi_send_scsi_raid_request(ctrl_info, cmd, RAID_CTLR_LUNID,
-		buffer, buffer_length, 0, NULL, NO_TIMEOUT);
+		buffer, buffer_length, 0, NULL);
 }
 
 static inline int pqi_send_ctrl_raid_with_error(struct pqi_ctrl_info *ctrl_info,
@@ -638,7 +620,7 @@ static inline int pqi_send_ctrl_raid_with_error(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_raid_error_info *error_info)
 {
 	return pqi_send_scsi_raid_request(ctrl_info, cmd, RAID_CTLR_LUNID,
-		buffer, buffer_length, 0, error_info, NO_TIMEOUT);
+		buffer, buffer_length, 0, error_info);
 }
 
 static inline int pqi_identify_controller(struct pqi_ctrl_info *ctrl_info,
@@ -660,7 +642,7 @@ static inline int pqi_scsi_inquiry(struct pqi_ctrl_info *ctrl_info,
 	u8 *scsi3addr, u16 vpd_page, void *buffer, size_t buffer_length)
 {
 	return pqi_send_scsi_raid_request(ctrl_info, INQUIRY, scsi3addr,
-		buffer, buffer_length, vpd_page, NULL, NO_TIMEOUT);
+		buffer, buffer_length, vpd_page, NULL);
 }
 
 static int pqi_identify_physical_device(struct pqi_ctrl_info *ctrl_info,
@@ -682,8 +664,7 @@ static int pqi_identify_physical_device(struct pqi_ctrl_info *ctrl_info,
 	request.cdb[2] = (u8)bmic_device_index;
 	request.cdb[9] = (u8)(bmic_device_index >> 8);
 
-	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		0, NULL, NO_TIMEOUT);
+	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 
 	pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1, dir);
 
@@ -740,7 +721,7 @@ static int pqi_get_advanced_raid_bypass_config(struct pqi_ctrl_info *ctrl_info)
 	request.cdb[2] = BMIC_SENSE_FEATURE_IO_PAGE;
 	request.cdb[3] = BMIC_SENSE_FEATURE_IO_PAGE_AIO_SUBPAGE;
 
-	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL, NO_TIMEOUT);
+	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 
 	pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1, dir);
 
@@ -1270,9 +1251,7 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 		return -ENOMEM;
 
 	rc = pqi_send_scsi_raid_request(ctrl_info, CISS_GET_RAID_MAP,
-		device->scsi3addr, raid_map, sizeof(*raid_map),
-		0, NULL, NO_TIMEOUT);
-
+		device->scsi3addr, raid_map, sizeof(*raid_map), 0, NULL);
 	if (rc)
 		goto error;
 
@@ -1287,8 +1266,7 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 			return -ENOMEM;
 
 		rc = pqi_send_scsi_raid_request(ctrl_info, CISS_GET_RAID_MAP,
-			device->scsi3addr, raid_map, raid_map_size,
-			0, NULL, NO_TIMEOUT);
+			device->scsi3addr, raid_map, raid_map_size, 0, NULL);
 		if (rc)
 			goto error;
 
@@ -3375,7 +3353,7 @@ static void pqi_event_worker(struct work_struct *work)
 	ctrl_info = container_of(work, struct pqi_ctrl_info, event_work);
 
 	pqi_ctrl_busy(ctrl_info);
-	pqi_wait_if_ctrl_blocked(ctrl_info, NO_TIMEOUT);
+	pqi_wait_if_ctrl_blocked(ctrl_info);
 	if (pqi_ctrl_offline(ctrl_info))
 		goto out;
 
@@ -4219,59 +4197,40 @@ static int pqi_process_raid_io_error_synchronous(
 	return rc;
 }
 
+static inline bool pqi_is_blockable_request(struct pqi_iu_header *request)
+{
+	return (request->driver_flags & PQI_DRIVER_NONBLOCKABLE_REQUEST) == 0;
+}
+
 static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_iu_header *request, unsigned int flags,
-	struct pqi_raid_error_info *error_info, unsigned long timeout_msecs)
+	struct pqi_raid_error_info *error_info)
 {
 	int rc = 0;
 	struct pqi_io_request *io_request;
-	unsigned long start_jiffies;
-	unsigned long msecs_blocked;
 	size_t iu_length;
 	DECLARE_COMPLETION_ONSTACK(wait);
 
-	/*
-	 * Note that specifying PQI_SYNC_FLAGS_INTERRUPTABLE and a timeout value
-	 * are mutually exclusive.
-	 */
-
 	if (flags & PQI_SYNC_FLAGS_INTERRUPTABLE) {
 		if (down_interruptible(&ctrl_info->sync_request_sem))
 			return -ERESTARTSYS;
 	} else {
-		if (timeout_msecs == NO_TIMEOUT) {
-			down(&ctrl_info->sync_request_sem);
-		} else {
-			start_jiffies = jiffies;
-			if (down_timeout(&ctrl_info->sync_request_sem,
-				msecs_to_jiffies(timeout_msecs)))
-				return -ETIMEDOUT;
-			msecs_blocked =
-				jiffies_to_msecs(jiffies - start_jiffies);
-			if (msecs_blocked >= timeout_msecs) {
-				rc = -ETIMEDOUT;
-				goto out;
-			}
-			timeout_msecs -= msecs_blocked;
-		}
+		down(&ctrl_info->sync_request_sem);
 	}
 
 	pqi_ctrl_busy(ctrl_info);
-	timeout_msecs = pqi_wait_if_ctrl_blocked(ctrl_info, timeout_msecs);
-	if (timeout_msecs == 0) {
-		pqi_ctrl_unbusy(ctrl_info);
-		rc = -ETIMEDOUT;
-		goto out;
-	}
+	/*
+	 * Wait for other admin queue updates such as;
+	 * config table changes, OFA memory updates, ...
+	 */
+	if (pqi_is_blockable_request(request))
+		pqi_wait_if_ctrl_blocked(ctrl_info);
 
 	if (pqi_ctrl_offline(ctrl_info)) {
-		pqi_ctrl_unbusy(ctrl_info);
 		rc = -ENXIO;
 		goto out;
 	}
 
-	atomic_inc(&ctrl_info->sync_cmds_outstanding);
-
 	io_request = pqi_alloc_io_request(ctrl_info);
 
 	put_unaligned_le16(io_request->index,
@@ -4291,18 +4250,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
 		io_request);
 
-	pqi_ctrl_unbusy(ctrl_info);
-
-	if (timeout_msecs == NO_TIMEOUT) {
-		pqi_wait_for_completion_io(ctrl_info, &wait);
-	} else {
-		if (!wait_for_completion_io_timeout(&wait,
-			msecs_to_jiffies(timeout_msecs))) {
-			dev_warn(&ctrl_info->pci_dev->dev,
-				"command timed out\n");
-			rc = -ETIMEDOUT;
-		}
-	}
+	pqi_wait_for_completion_io(ctrl_info, &wait);
 
 	if (error_info) {
 		if (io_request->error_info)
@@ -4315,8 +4263,8 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 
 	pqi_free_io_request(io_request);
 
-	atomic_dec(&ctrl_info->sync_cmds_outstanding);
 out:
+	pqi_ctrl_unbusy(ctrl_info);
 	up(&ctrl_info->sync_request_sem);
 
 	return rc;
@@ -4353,8 +4301,7 @@ static int pqi_submit_admin_request_synchronous(
 	rc = pqi_poll_for_admin_response(ctrl_info, response);
 
 	if (rc == 0)
-		rc = pqi_validate_admin_response(response,
-			request->function_code);
+		rc = pqi_validate_admin_response(response, request->function_code);
 
 	return rc;
 }
@@ -4723,8 +4670,7 @@ static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 	if (rc)
 		goto out;
 
-	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		0, NULL, NO_TIMEOUT);
+	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 
 	pqi_pci_unmap(ctrl_info->pci_dev,
 		request.data.report_event_configuration.sg_descriptors, 1,
@@ -4759,8 +4705,7 @@ static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 	if (rc)
 		goto out;
 
-	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0,
-		NULL, NO_TIMEOUT);
+	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 
 	pqi_pci_unmap(ctrl_info->pci_dev,
 		request.data.report_event_configuration.sg_descriptors, 1,
@@ -6516,7 +6461,7 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 		put_unaligned_le32(iocommand.Request.Timeout, &request.timeout);
 
 	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		PQI_SYNC_FLAGS_INTERRUPTABLE, &pqi_error_info, NO_TIMEOUT);
+		PQI_SYNC_FLAGS_INTERRUPTABLE, &pqi_error_info);
 
 	if (iocommand.buf_size > 0)
 		pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1,
@@ -7376,8 +7321,7 @@ static int pqi_config_table_update(struct pqi_ctrl_info *ctrl_info,
 	put_unaligned_le16(last_section,
 		&request.data.config_table_update.last_section);
 
-	return pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		0, NULL, NO_TIMEOUT);
+	return pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 }
 
 static int pqi_enable_firmware_features(struct pqi_ctrl_info *ctrl_info,
@@ -8522,8 +8466,7 @@ static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info)
 
 	}
 
-	return pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
-		0, NULL, NO_TIMEOUT);
+	return pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 }
 
 static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info)
@@ -9277,7 +9220,7 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_iu_header,
 		response_queue_id) != 0x4);
 	BUILD_BUG_ON(offsetof(struct pqi_iu_header,
-		work_area) != 0x6);
+		driver_flags) != 0x6);
 	BUILD_BUG_ON(sizeof(struct pqi_iu_header) != 0x8);
 
 	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info,
@@ -9375,7 +9318,7 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
 		header.iu_length) != 2);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		header.work_area) != 6);
+		header.driver_flags) != 6);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
 		request_id) != 8);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
@@ -9431,7 +9374,7 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
 		header.iu_length) != 2);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		header.work_area) != 6);
+		header.driver_flags) != 6);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
 		request_id) != 8);
 	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
@@ -9455,7 +9398,7 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
 		header.response_queue_id) != 4);
 	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		header.work_area) != 6);
+		header.driver_flags) != 6);
 	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
 		request_id) != 8);
 	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
@@ -9484,7 +9427,7 @@ static void __attribute__((unused)) verify_structures(void)
 	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
 		header.response_queue_id) != 4);
 	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		header.work_area) != 6);
+		header.driver_flags) != 6);
 	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
 		request_id) != 8);
 	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,

