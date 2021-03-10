Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD10C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9729864FBB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhCJUCX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:02:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25945 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhCJUBy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:01:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406513; x=1646942513;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ttnmdutUrG/R31/QVZk+pdRxcBu1tU9cohdx6BX08S8=;
  b=Oec8dCLu5/aStdwUqVN2v5zJToGlIu+tQJbariunTyLUz0EGYry3DxDT
   vgepbCZeVmhw/0WVuZgXh7jiP478FUA34FZW4/qikoQQP5Ohf4kssUBKk
   wDrhKCCqGyGMGZmYRQ1cxLSwBOzDAIy6qMkFMJ2HO01iw55QML5EVvuvk
   uu4/2DrU4sRgIqC60e/5qDlNXdlgH1xdcxJdDIFQimk11I/VvQgyXfnxm
   +AFGMOpK+VVKujw3BXFORpl8NAYXxpmxxCOFi8Md+JvfIw9lULEkeV1G5
   4ELZFus7y7qnZHnajdvQhResCapx2UBsEDcPU6QlbfzLyX8fAy94HIt/a
   Q==;
IronPort-SDR: PE1q6UZ2i6E6yUH45wMpOw5xn0W20i0mKADIdLLpWgEfrxwJAG1gGB1JIGUmCy7xXA7H4uUH/J
 M3GgKOfMoVCQFZdLVQB28h/V2yrbgqff3rLwKW9hgwRGRbAhIpSUsGZWzXF9svr/YUvsBrK1GJ
 TBsCsWVDWOqsSnY9lM2C5aYl6k1F4Y2OtC5tGCQLj9oRFWtaFHXCxipyEDbubk6X+b2q770Ad7
 PQogwZeMQ5lhgjla7Dca2P6WbltQeZOOoWdbfZR8HtwRYFVCVhiJygzenDIHUHRpfy8BRzbaOB
 Gwc=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="112731747"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:01:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:01:50 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:01:49 -0700
Subject: [PATCH V4 11/31] smartpqi: add stream detection
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:01:49 -0600
Message-ID: <161540650939.19430.10433163236914945375.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Enhance performance by adding sequential stream detection.
  for R5/R6 sequential write requests.
  * Reduce stripe lock contention with full-stripe write
    operations.
    * There is one common stripe lock for each RAID volume
      that can be set by either the RAID engine or the AIO engine.
      * The AIO path has I/O request sizes well below the
        stripe size resulting in many Read-Modify-Write operations.
      * Sending the request to the RAID engine allows for coalescing
        requests into full stripe operations resulting in reduced
        Read-Modify-Write operations.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    9 +++
 drivers/scsi/smartpqi/smartpqi_init.c |   87 +++++++++++++++++++++++++++++++--
 2 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 6639432f3dab..976bfd8c5192 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1043,6 +1043,13 @@ struct pqi_scsi_dev_raid_map_data {
 
 #define RAID_CTLR_LUNID		"\0\0\0\0\0\0\0\0"
 
+#define NUM_STREAMS_PER_LUN	8
+
+struct pqi_stream_data {
+	u64	next_lba;
+	u32	last_accessed;
+};
+
 struct pqi_scsi_dev {
 	int	devtype;		/* as reported by INQUIRY commmand */
 	u8	device_type;		/* as reported by */
@@ -1097,6 +1104,7 @@ struct pqi_scsi_dev {
 	struct list_head add_list_entry;
 	struct list_head delete_list_entry;
 
+	struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
 	atomic_t scsi_cmds_outstanding;
 	atomic_t raid_bypass_cnt;
 };
@@ -1296,6 +1304,7 @@ struct pqi_ctrl_info {
 	u8		enable_r5_writes : 1;
 	u8		enable_r6_writes : 1;
 	u8		lv_drive_type_mix_valid : 1;
+	u8		enable_stream_detection : 1;
 
 	u8		ciss_report_log_flags;
 	u32		max_transfer_encrypted_sas_sata;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 73c5a8adb8ad..c2f366c614d7 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5688,8 +5688,82 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 	atomic_dec(&device->scsi_cmds_outstanding);
 }
 
-static int pqi_scsi_queue_command(struct Scsi_Host *shost,
+static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd)
+{
+	u32 oldest_jiffies;
+	u8 lru_index;
+	int i;
+	int rc;
+	struct pqi_scsi_dev *device;
+	struct pqi_stream_data *pqi_stream_data;
+	struct pqi_scsi_dev_raid_map_data rmd;
+
+	if (!ctrl_info->enable_stream_detection)
+		return false;
+
+	rc = pqi_get_aio_lba_and_block_count(scmd, &rmd);
+	if (rc)
+		return false;
+
+	/* Check writes only. */
+	if (!rmd.is_write)
+		return false;
+
+	device = scmd->device->hostdata;
+
+	/* Check for RAID 5/6 streams. */
+	if (device->raid_level != SA_RAID_5 && device->raid_level != SA_RAID_6)
+		return false;
+
+	/*
+	 * If controller does not support AIO RAID{5,6} writes, need to send
+	 * requests down non-AIO path.
+	 */
+	if ((device->raid_level == SA_RAID_5 && !ctrl_info->enable_r5_writes) ||
+		(device->raid_level == SA_RAID_6 && !ctrl_info->enable_r6_writes))
+		return true;
+
+	lru_index = 0;
+	oldest_jiffies = INT_MAX;
+	for (i = 0; i < NUM_STREAMS_PER_LUN; i++) {
+		pqi_stream_data = &device->stream_data[i];
+		/*
+		 * Check for adjacent request or request is within
+		 * the previous request.
+		 */
+		if ((pqi_stream_data->next_lba &&
+			rmd.first_block >= pqi_stream_data->next_lba) &&
+			rmd.first_block <= pqi_stream_data->next_lba +
+				rmd.block_cnt) {
+			pqi_stream_data->next_lba = rmd.first_block +
+				rmd.block_cnt;
+			pqi_stream_data->last_accessed = jiffies;
+			return true;
+		}
+
+		/* unused entry */
+		if (pqi_stream_data->last_accessed == 0) {
+			lru_index = i;
+			break;
+		}
+
+		/* Find entry with oldest last accessed time. */
+		if (pqi_stream_data->last_accessed <= oldest_jiffies) {
+			oldest_jiffies = pqi_stream_data->last_accessed;
+			lru_index = i;
+		}
+	}
+
+	/* Set LRU entry. */
+	pqi_stream_data = &device->stream_data[lru_index];
+	pqi_stream_data->last_accessed = jiffies;
+	pqi_stream_data->next_lba = rmd.first_block + rmd.block_cnt;
+
+	return false;
+}
+
+static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 {
 	int rc;
 	struct pqi_ctrl_info *ctrl_info;
@@ -5736,11 +5810,12 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
 		raid_bypassed = false;
 		if (device->raid_bypass_enabled &&
 			!blk_rq_is_passthrough(scmd->request)) {
-			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device,
-				scmd, queue_group);
-			if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
-				raid_bypassed = true;
-				atomic_inc(&device->raid_bypass_cnt);
+			if (!pqi_is_parity_write_stream(ctrl_info, scmd)) {
+				rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
+				if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
+					raid_bypassed = true;
+					atomic_inc(&device->raid_bypass_cnt);
+				}
 			}
 		}
 		if (!raid_bypassed)

