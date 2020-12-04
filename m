Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB80C4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B45E422C9E
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgLDXDJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:09 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:4901 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLDXDI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607122987; x=1638658987;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yTJ/yR/sJyPKxTtb8oiP0CyUtZwvhCJcfxTURsmMWxU=;
  b=yNVhiyiA0faqCVQZq9O7Gd3xF7BgAISfNyazoQbxrLqq3fIVcwX4XEz2
   rL9i/UldGaBVbIGo1YGH3Jkx+bDpUtE++C/Q67ntUlhpos6JD9cWkIpor
   Izzf1DKJawblTo15nBT5EzN4l0NjGd50CS8t/EbeOT03oaIpM7kyNno5I
   8VHZwIGObByjOAvPp+kasPLIBEOZJv7vZLo/adw5KYHH9SJRur1Ro9KAT
   f6HRORlraXAxCVIVJxwz5rfHJ0enueAnafwThO++1EImwrcjU2tOd/Qtv
   2rL2P+cR27rSbHVx4Tik+dN6Vry9ymlG1wxYzi7qip/RtmRwwVerR3Kwd
   g==;
IronPort-SDR: 0r4jHZKo7FqxRfqziLbMpzadbIhIrIgloN7dJPE+FFrBTGnw0DOfGDbtVsyoqGQ6s1/GWM/h+J
 NzQ8TV6ghnBalcRVRn65CPYlBdTfnp8aJp7H0fEdQnLd5Px4kR8sNcUmxJGv0xrA5tx6G+KuBJ
 j60//BM7EVtsZ9atMl/u1aXSRT3s84xA1IL4dO8q2x1BpvEPRhR5JNGyp/5Bm3WSHmymyWXIX3
 mMwhsQlRy3Kypt5eFE4o1eAB5NjwH1O5FeyIwLNEJbfp/evRODqpZAPAlXuziH2rxUpKp/O7sk
 +4o=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="106273061"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:01:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:01:49 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:01:48 -0700
Subject: [PATCH 10/25] smartpqi: add stream detection
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:01:48 -0600
Message-ID: <160712290881.21372.8579870523469517845.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
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
index ddd2ed8f4283..25896e7dbd1b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5652,8 +5652,82 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
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
@@ -5699,11 +5773,12 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
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

