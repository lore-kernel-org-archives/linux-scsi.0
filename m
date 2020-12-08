Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34105C19437
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00C3C23AC8
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgLHU1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:27:04 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:25043 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbgLHU1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:27:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607459222; x=1638995222;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dHxsdJkEHIL/x5CSc7nRAqGGh4jCicvIo/3Vunnm2mo=;
  b=ay395K+XgQoefXDGp/hnku3TJ8S1avGweAx3fGFR/BI5ymsVJDfwLV7v
   KkPus2o9cziY/8i3iDUDQvibhBsdScaGtCZ/2TRGDGu+06OceSEGqR9Yp
   Mi/r9aaeb1gF7s6ks4VLOMburq7Y80nfi4IckAZb29qDTXLEQ3NSUnUpl
   hQ8Ewnq0iNZ2LtivOYVaqmU3LrVXkST/ctlCUw3G4nrS8JtZB8d7ECnt2
   +puauh+C0nYtcXQhKetxSBJuRjK8l1gQG0zlb6hIsgemHjZpN2fKx57rh
   hp9aabvRFDdlOfM+N4hamTxbjPU9lZr5mVlDn2Z6x3ElXzdNou+r9ffot
   A==;
IronPort-SDR: OALPj5H79TWqFWXgYrPlxG6x6/n3gEbQQAuXiC/V2G4xvO1vTG1YCo8G9HEIvcoGI4OJqvSFwg
 tlUz+ONA87OmUQ/um+ckyBhLEUqIdrB+MwoXxVU4vVqg/XD1WUYIDYuK8J3UdtG6ctO7zX9j6c
 wqu/Yiw8UOHbIWPlcTyThDDIOHO2n2FUphkrv3JIAAbF5xkMgzAbK1Y59XjiKnfYH7gDv8dFb6
 3KvZmk7FP30yw0/S7EP6lloEsdrjLSpI+OeNoZD7Rfz4T6mHnVNXjvh+QqtkZSaarXzAsnwiW7
 4wU=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="102012093"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:37:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:37:33 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:37:33 -0700
Subject: [PATCH V2 10/25] smartpqi: add stream detection
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:37:33 -0600
Message-ID: <160745625333.13450.9220697238295309043.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    8 +++
 drivers/scsi/smartpqi/smartpqi_init.c |   87 +++++++++++++++++++++++++++++++--
 2 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index a5e271dd2742..343f06e44220 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1042,6 +1042,12 @@ struct pqi_scsi_dev_raid_map_data {
 
 #define RAID_CTLR_LUNID		"\0\0\0\0\0\0\0\0"
 
+#define NUM_STREAMS_PER_LUN	8
+
+struct pqi_stream_data {
+	u64	next_lba;
+	u32	last_accessed;
+};
 
 struct pqi_scsi_dev {
 	int	devtype;		/* as reported by INQUIRY commmand */
@@ -1097,6 +1103,7 @@ struct pqi_scsi_dev {
 	struct list_head add_list_entry;
 	struct list_head delete_list_entry;
 
+	struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
 	atomic_t scsi_cmds_outstanding;
 	atomic_t raid_bypass_cnt;
 };
@@ -1296,6 +1303,7 @@ struct pqi_ctrl_info {
 	u8		enable_r5_writes : 1;
 	u8		enable_r6_writes : 1;
 	u8		lv_drive_type_mix_valid : 1;
+	u8		enable_stream_detection : 1;
 
 	u8		ciss_report_log_flags;
 	u32		max_transfer_encrypted_sas_sata;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 92a0b37ae35c..0d1b3ce7989f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5715,8 +5715,82 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
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
@@ -5762,11 +5836,12 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
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

