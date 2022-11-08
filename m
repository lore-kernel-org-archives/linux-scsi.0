Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8D7C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 19:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiKHTTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 14:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKHTSw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 14:18:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E0F178A2
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 11:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667935127; x=1699471127;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mOqVfqEwjV9T7kspO4kNPrB5r81DutsnVZPvTpy62o0=;
  b=t+HU/ChlxSPozPrDKEQXvpS98f4q6+Umz2DmTq/ZQ3dlWZsQlhN4CHnk
   pg6mSXc83qQgKteQLPhmv3aCkDqylu07WmKxLu3Ekk30cNfKKlQ7wD0kA
   NtJNsk1Nc/i4ITC5eCVcdrfa88ZL2Ui6S2J48VRn2AJJM3uTyBcMVnGJy
   wqUyegurP2X2Bt0u7MXtUWI+h0Df04Sp/HuDQow1JXIB34o185YZgOaLy
   IinQg+h7lQbc/2JFJHW+qzkG5lloOtNrfV7e33AFKN1Y4zyUQ4F/CZ/4A
   2tIyZyRelxtB8QGD0PA/pN39y3ws0+c4m1V8BhwSqlLYcd/Wj6r7yl0Si
   g==;
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="188154079"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Nov 2022 12:18:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 8 Nov 2022 12:18:46 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 8 Nov 2022 12:18:46 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 2A8JLcA8322579;
        Tue, 8 Nov 2022 13:21:38 -0600
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 2A8JLcVk322578;
        Tue, 8 Nov 2022 13:21:38 -0600
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH 1/8] smartpqi: convert to host_tagset
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Nov 2022 13:21:38 -0600
Message-ID: <166793529811.322537.3294617845448383948.stgit@brunhilda>
In-Reply-To: <166793527478.322537.6742384652975581503.stgit@brunhilda>
References: <166793527478.322537.6742384652975581503.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add support for host_tagset.

Also move the reserved command slots to the end of the pool to
eliminate an addition operation for every SCSI request.

This patch was originally authored by Hannes Reinecke here:
Link: https://lore.kernel.org/linux-block/20191126131009.71726-8-hare@suse.de/

But we NAKed this patch because we wanted to fully test multipath
failover operations.

Suggested-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>
Reviewed-by: Mike McGowen <Mike.McGowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    3 -
 drivers/scsi/smartpqi/smartpqi_init.c |   68 +++++++++++++++++++++------------
 2 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index e550b12e525a..8cdf4d2476dd 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1307,7 +1307,6 @@ struct pqi_ctrl_info {
 	dma_addr_t	error_buffer_dma_handle;
 	size_t		sg_chain_buffer_length;
 	unsigned int	num_queue_groups;
-	u16		max_hw_queue_index;
 	u16		num_elements_per_iq;
 	u16		num_elements_per_oq;
 	u16		max_inbound_iu_length_per_firmware;
@@ -1369,8 +1368,6 @@ struct pqi_ctrl_info {
 	u64		sas_address;
 
 	struct pqi_io_request *io_request_pool;
-	u16		next_io_request_slot;
-
 	struct pqi_event events[PQI_NUM_SUPPORTED_EVENTS];
 	struct work_struct event_work;
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b971fbe3b3a1..651dca535b3b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -678,23 +678,36 @@ static inline void pqi_reinit_io_request(struct pqi_io_request *io_request)
 	io_request->raid_bypass = false;
 }
 
-static struct pqi_io_request *pqi_alloc_io_request(
-	struct pqi_ctrl_info *ctrl_info)
+static inline struct pqi_io_request *pqi_alloc_io_request(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
 {
 	struct pqi_io_request *io_request;
-	u16 i = ctrl_info->next_io_request_slot;	/* benignly racy */
+	u16 i;
 
-	while (1) {
+	if (scmd) { /* SML I/O request */
+		u32 blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+
+		i = blk_mq_unique_tag_to_tag(blk_tag);
 		io_request = &ctrl_info->io_request_pool[i];
-		if (atomic_inc_return(&io_request->refcount) == 1)
-			break;
-		atomic_dec(&io_request->refcount);
-		i = (i + 1) % ctrl_info->max_io_slots;
+		if (atomic_inc_return(&io_request->refcount) > 1) {
+			atomic_dec(&io_request->refcount);
+			return NULL;
+		}
+	} else { /* IOCTL or driver internal request */
+		/*
+		 * benignly racy - may have to wait for an open slot.
+		 * command slot range is scsi_ml_can_queue -
+		 *         [scsi_ml_can_queue + (PQI_RESERVED_IO_SLOTS - 1)]
+		 */
+		i = 0;
+		while (1) {
+			io_request = &ctrl_info->io_request_pool[ctrl_info->scsi_ml_can_queue + i];
+			if (atomic_inc_return(&io_request->refcount) == 1)
+				break;
+			atomic_dec(&io_request->refcount);
+			i = (i + 1) % PQI_RESERVED_IO_SLOTS;
+		}
 	}
 
-	/* benignly racy */
-	ctrl_info->next_io_request_slot = (i + 1) % ctrl_info->max_io_slots;
-
 	pqi_reinit_io_request(io_request);
 
 	return io_request;
@@ -4586,7 +4599,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 		goto out;
 	}
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, NULL);
 
 	put_unaligned_le16(io_request->index,
 		&(((struct pqi_raid_path_request *)request)->request_id));
@@ -5233,7 +5246,6 @@ static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 	}
 
 	ctrl_info->num_queue_groups = num_queue_groups;
-	ctrl_info->max_hw_queue_index = num_queue_groups - 1;
 
 	/*
 	 * Make sure that the max. inbound IU length is an even multiple
@@ -5567,7 +5579,9 @@ static inline int pqi_raid_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 {
 	struct pqi_io_request *io_request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	return pqi_raid_submit_scsi_cmd_with_io_request(ctrl_info, io_request,
 		device, scmd, queue_group);
@@ -5671,7 +5685,9 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device;
 
 	device = scmd->device->hostdata;
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
 	io_request->io_complete_callback = pqi_aio_io_complete;
 	io_request->scmd = scmd;
 	io_request->raid_bypass = raid_bypass;
@@ -5743,7 +5759,10 @@ static  int pqi_aio_submit_r1_write_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_io_request *io_request;
 	struct pqi_aio_r1_path_request *r1_request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	io_request->io_complete_callback = pqi_aio_io_complete;
 	io_request->scmd = scmd;
 	io_request->raid_bypass = true;
@@ -5801,7 +5820,9 @@ static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_io_request *io_request;
 	struct pqi_aio_r56_path_request *r56_request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
 	io_request->io_complete_callback = pqi_aio_io_complete;
 	io_request->scmd = scmd;
 	io_request->raid_bypass = true;
@@ -5860,13 +5881,10 @@ static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
 static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd)
 {
-	u16 hw_queue;
-
-	hw_queue = blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(scsi_cmd_to_rq(scmd)));
-	if (hw_queue > ctrl_info->max_hw_queue_index)
-		hw_queue = 0;
-
-	return hw_queue;
+	/*
+	 * We are setting host_tagset = 1 during init.
+	 */
+	return blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(scsi_cmd_to_rq(scmd)));
 }
 
 static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
@@ -6268,7 +6286,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd
 	struct pqi_scsi_dev *device;
 
 	device = scmd->device->hostdata;
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, NULL);
 	io_request->io_complete_callback = pqi_lun_reset_complete;
 	io_request->context = &wait;
 

