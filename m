Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F839C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22CDC64F8F
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhCKUQ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:16:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:4027 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhCKUQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:16:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493777; x=1647029777;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZhzhXhObdKsG25Mz3sWMf9QGdIAyLeM2Ls4xMCV2RTQ=;
  b=XjiItQ9RLahThE55863ypt95+/Rj3FQjxWUDv+pq1VMYdhMycL+oFcHt
   sgYHUenhEbgirY5KtD5p2r58PEx6kn684MUm/guD3fjugGr2Gq+vZqNgI
   F00KgdhCXKDJIYBb6T4UmtGp3MC6Sy55WZ1aq8zdRLtIcFinR+QO2CxVk
   GWzfJowcwYoW+UaplTxdYCtViKaGtSkjFwiVW4gr94EneBsp3nhmozYuu
   6TMUB9fCnAQF7e91QHjZ/WUnUIBljcyM95zxZ9yJWmXHVGpFrSGggZxvf
   BENIn71ndhoJzxIY0D/s+Dw7JoiXsYF4Z5ad9XLuPNef26mXYjtugSlSn
   A==;
IronPort-SDR: aqosMgQyEDK5f/6xn2ucNGKLR4qWaB7MKFdSBkWOz+V4AxNIXJdcEZN/SlERHNsdIaxehfKljE
 Ff3SJs16iw1xEIN7IAjT0ebp7Yhh68s5LwHfxwe4A0l2SNWhPtUtXfYQL9OdkYifwCcpGch9ej
 ELlDgg9s8ixUeMbZfbgfhOf8XeHN2oBM+C+0fZMavFExNOCSp5Ut0XB+uiiYLTuUe8VmOQCp/L
 FfObB4cYBzmlKZIaDwvB1H8YVK5nMo6HqZwRZhGwcbA8X9Gz+Qzx30k4a3XEPVYXoVCEsp9MEF
 1e0=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="106859180"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:16:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:15:57 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:15:57 -0700
Subject: [PATCH V5 11/31] smartpqi: add stream detection
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:15:56 -0600
Message-ID: <161549375693.25025.2962141451773219796.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
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
index 143bb7b64095..27bd3d9a3810 100644
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

