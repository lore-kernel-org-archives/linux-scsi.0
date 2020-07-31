Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B734C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ACD222B3F
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgGaVBf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:01:35 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16543 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgGaVBf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 17:01:35 -0400
IronPort-SDR: 5V3Z5pz1y+gwTJom54dN8vz8FNEKA0qOZH11N1hpSDjAms9zlkAEPdJX1rHuCdAbaKH3hfDfEu
 7IMjtQ1coPh8f+cCkeTIHRr0ENw3joJiVB4z+TyrU35pCNWo9hYWanFCPtKCnaPnj7cZPME6Vf
 4EGgA/zlo2zWvtKBK6BpfpVTWgL/dBBTGj7D1LHF2XeNFmZkwXgljKqlGXCZ9PrS2rT3g9YqAz
 KZ9T3D6hAYTkHJnGtzzohUlFx3ETSAWXJoC5rcmal3LxV4f2SlAl/62SzxGzNN8LoRynZJy4qN
 YL0=
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="90019812"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2020 14:01:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 14:01:32 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 31 Jul 2020 14:01:31 -0700
Subject: [PATCH 4/7] smartpqi: avoid crashing kernel for controller issues
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 31 Jul 2020 16:01:33 -0500
Message-ID: <159622929306.30579.16523318707596752828.stgit@brunhilda>
In-Reply-To: <159622890296.30579.6820363566594432069.stgit@brunhilda>
References: <159622890296.30579.6820363566594432069.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

- Eliminate kernel panics when getting invalid responses
  from controller.
  - Take controller offline instead of causing
    kernel panics.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Prasad Munirathnam <Prasad.Munirathnam@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    2 -
 drivers/scsi/smartpqi/smartpqi_init.c |  101 ++++++++++++++++++++++-----------
 2 files changed, 68 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index c2382eedbbc3..631306d347db 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -359,7 +359,7 @@ struct pqi_event_response {
 	struct pqi_iu_header header;
 	u8	event_type;
 	u8	reserved2 : 7;
-	u8	request_acknowlege : 1;
+	u8	request_acknowledge : 1;
 	__le16	event_id;
 	__le32	additional_event_id;
 	union {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 92bc8ae2a1af..d6a92de555c8 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -542,8 +542,7 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
 		put_unaligned_be16(cdb_length, &cdb[7]);
 		break;
 	default:
-		dev_err(&ctrl_info->pci_dev->dev, "unknown command 0x%c\n",
-			cmd);
+		dev_err(&ctrl_info->pci_dev->dev, "unknown command 0x%c\n", cmd);
 		break;
 	}
 
@@ -2461,7 +2460,6 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 		offload_to_mirror =
 			(offload_to_mirror >= layout_map_count - 1) ?
 				0 : offload_to_mirror + 1;
-		WARN_ON(offload_to_mirror >= layout_map_count);
 		device->offload_to_mirror = offload_to_mirror;
 		/*
 		 * Avoid direct use of device->offload_to_mirror within this
@@ -2914,10 +2912,14 @@ static int pqi_interpret_task_management_response(
 	return rc;
 }
 
-static unsigned int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_queue_group *queue_group)
+static inline void pqi_invalid_response(struct pqi_ctrl_info *ctrl_info)
+{
+	pqi_take_ctrl_offline(ctrl_info);
+}
+
+static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue_group *queue_group)
 {
-	unsigned int num_responses;
+	int num_responses;
 	pqi_index_t oq_pi;
 	pqi_index_t oq_ci;
 	struct pqi_io_request *io_request;
@@ -2929,6 +2931,13 @@ static unsigned int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info,
 
 	while (1) {
 		oq_pi = readl(queue_group->oq_pi);
+		if (oq_pi >= ctrl_info->num_elements_per_oq) {
+			pqi_invalid_response(ctrl_info);
+			dev_err(&ctrl_info->pci_dev->dev,
+				"I/O interrupt: producer index (%u) out of range (0-%u): consumer index: %u\n",
+				oq_pi, ctrl_info->num_elements_per_oq - 1, oq_ci);
+			return -1;
+		}
 		if (oq_pi == oq_ci)
 			break;
 
@@ -2937,10 +2946,22 @@ static unsigned int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info,
 			(oq_ci * PQI_OPERATIONAL_OQ_ELEMENT_LENGTH);
 
 		request_id = get_unaligned_le16(&response->request_id);
-		WARN_ON(request_id >= ctrl_info->max_io_slots);
+		if (request_id >= ctrl_info->max_io_slots) {
+			pqi_invalid_response(ctrl_info);
+			dev_err(&ctrl_info->pci_dev->dev,
+				"request ID in response (%u) out of range (0-%u): producer index: %u  consumer index: %u\n",
+				request_id, ctrl_info->max_io_slots - 1, oq_pi, oq_ci);
+			return -1;
+		}
 
 		io_request = &ctrl_info->io_request_pool[request_id];
-		WARN_ON(atomic_read(&io_request->refcount) == 0);
+		if (atomic_read(&io_request->refcount) == 0) {
+			pqi_invalid_response(ctrl_info);
+			dev_err(&ctrl_info->pci_dev->dev,
+				"request ID in response (%u) does not match an outstanding I/O request: producer index: %u  consumer index: %u\n",
+				request_id, oq_pi, oq_ci);
+			return -1;
+		}
 
 		switch (response->header.iu_type) {
 		case PQI_RESPONSE_IU_RAID_PATH_IO_SUCCESS:
@@ -2970,24 +2991,22 @@ static unsigned int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info,
 			io_request->error_info = ctrl_info->error_buffer +
 				(get_unaligned_le16(&response->error_index) *
 				PQI_ERROR_BUFFER_ELEMENT_LENGTH);
-			pqi_process_io_error(response->header.iu_type,
-				io_request);
+			pqi_process_io_error(response->header.iu_type, io_request);
 			break;
 		default:
+			pqi_invalid_response(ctrl_info);
 			dev_err(&ctrl_info->pci_dev->dev,
-				"unexpected IU type: 0x%x\n",
-				response->header.iu_type);
-			break;
+				"unexpected IU type: 0x%x: producer index: %u  consumer index: %u\n",
+				response->header.iu_type, oq_pi, oq_ci);
+			return -1;
 		}
 
-		io_request->io_complete_callback(io_request,
-			io_request->context);
+		io_request->io_complete_callback(io_request, io_request->context);
 
 		/*
 		 * Note that the I/O request structure CANNOT BE TOUCHED after
 		 * returning from the I/O completion callback!
 		 */
-
 		oq_ci = (oq_ci + 1) % ctrl_info->num_elements_per_oq;
 	}
 
@@ -3300,9 +3319,9 @@ static void pqi_ofa_capture_event_payload(struct pqi_event *event,
 	}
 }
 
-static unsigned int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
+static int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 {
-	unsigned int num_events;
+	int num_events;
 	pqi_index_t oq_pi;
 	pqi_index_t oq_ci;
 	struct pqi_event_queue *event_queue;
@@ -3316,26 +3335,31 @@ static unsigned int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 
 	while (1) {
 		oq_pi = readl(event_queue->oq_pi);
+		if (oq_pi >= PQI_NUM_EVENT_QUEUE_ELEMENTS) {
+			pqi_invalid_response(ctrl_info);
+			dev_err(&ctrl_info->pci_dev->dev,
+				"event interrupt: producer index (%u) out of range (0-%u): consumer index: %u\n",
+				oq_pi, PQI_NUM_EVENT_QUEUE_ELEMENTS - 1, oq_ci);
+			return -1;
+		}
+
 		if (oq_pi == oq_ci)
 			break;
 
 		num_events++;
-		response = event_queue->oq_element_array +
-			(oq_ci * PQI_EVENT_OQ_ELEMENT_LENGTH);
+		response = event_queue->oq_element_array + (oq_ci * PQI_EVENT_OQ_ELEMENT_LENGTH);
 
 		event_index =
 			pqi_event_type_to_event_index(response->event_type);
 
-		if (event_index >= 0) {
-			if (response->request_acknowlege) {
-				event = &ctrl_info->events[event_index];
-				event->pending = true;
-				event->event_type = response->event_type;
-				event->event_id = response->event_id;
-				event->additional_event_id =
-					response->additional_event_id;
+		if (event_index >= 0 && response->request_acknowledge) {
+			event = &ctrl_info->events[event_index];
+			event->pending = true;
+			event->event_type = response->event_type;
+			event->event_id = response->event_id;
+			event->additional_event_id = response->additional_event_id;
+			if (event->event_type == PQI_EVENT_TYPE_OFA)
 				pqi_ofa_capture_event_payload(event, response);
-			}
 		}
 
 		oq_ci = (oq_ci + 1) % PQI_NUM_EVENT_QUEUE_ELEMENTS;
@@ -3450,7 +3474,8 @@ static irqreturn_t pqi_irq_handler(int irq, void *data)
 {
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_queue_group *queue_group;
-	unsigned int num_responses_handled;
+	int num_io_responses_handled;
+	int num_events_handled;
 
 	queue_group = data;
 	ctrl_info = queue_group->ctrl_info;
@@ -3458,17 +3483,25 @@ static irqreturn_t pqi_irq_handler(int irq, void *data)
 	if (!pqi_is_valid_irq(ctrl_info))
 		return IRQ_NONE;
 
-	num_responses_handled = pqi_process_io_intr(ctrl_info, queue_group);
+	num_io_responses_handled = pqi_process_io_intr(ctrl_info, queue_group);
+	if (num_io_responses_handled < 0)
+		goto out;
 
-	if (irq == ctrl_info->event_irq)
-		num_responses_handled += pqi_process_event_intr(ctrl_info);
+	if (irq == ctrl_info->event_irq) {
+		num_events_handled = pqi_process_event_intr(ctrl_info);
+		if (num_events_handled < 0)
+			goto out;
+	} else {
+		num_events_handled = 0;
+	}
 
-	if (num_responses_handled)
+	if (num_io_responses_handled + num_events_handled > 0)
 		atomic_inc(&ctrl_info->num_interrupts);
 
 	pqi_start_io(ctrl_info, queue_group, RAID_PATH, NULL);
 	pqi_start_io(ctrl_info, queue_group, AIO_PATH, NULL);
 
+out:
 	return IRQ_HANDLED;
 }
 

