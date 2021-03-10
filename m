Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887E0C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB6D64FC9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhCJUCz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:02:55 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:2477 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbhCJUC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:02:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406549; x=1646942549;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cM7MJH9wQRrlDS9BQfLAhLtNNfNDOAlBf0x9t7V+xDg=;
  b=SS8Krr0mG30Gyhcpn8EaOSZP6oa/+JK95sIpjroGtAnVFADLV8pe9pBT
   yjAlXEbJQD0xBxst83xF/lhrSA6kdb6XpllZ3zowRrUCLXH6XaprzL3C7
   oji/CfVHQigBRzEPWXHoOg6M0UejJgxcvGkIRp+KcVXB5Mk2szljv9aU7
   Ehi1hOs8xYtRNS84Mv1D9873G2loqcOvR8g4CZ43mFIFMHKVqkZSEBHiU
   hJwTAcRvzVZ1Z1/iC2uUZTtktz7m7qf6poG2UCECtZt+ZxVGQZPKSWLYc
   IiFHS1XxmtCbFCfb3K1y6vNPC/jnBzna8BHt4ytNGzGxqxSLsdGqWR4iV
   w==;
IronPort-SDR: 3FKReZRUqnten88FlIE/ScvJJkojrAc+KMwWpcBWqF6lwHiYNlRPXji0RTZwgzWxPj/+wki2d9
 UhX1A2pLI3q5XIbL+pXIF7pesfEo2ZWdHKrTobZIJ6NuxdxRw9RrKjX+4wgG+KwxPqtc435S5b
 T2tzWODZT9zV+YbOFG/U3sO1YHBzWsSy/xjeMzjHS09e2PSP03rOVwVDXt+RzeFnDbqx5eVdOK
 UrVhddo6lsSPIkS8bUKT8Wj0W3vKyEumPcz41oFWds9Xy3y6PZtdLyZLT0oWBJwMdaoWitYL4W
 3B0=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="109505704"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:02:29 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:02:19 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:02:18 -0700
Subject: [PATCH V4 16/31] smartpqi: update event handler
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:02:18 -0600
Message-ID: <161540653855.19430.13536994298211248003.stgit@brunhilda>
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

Change the data type for event_id and additional_event_id.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    4 ++--
 drivers/scsi/smartpqi/smartpqi_init.c |    9 +++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index a579d772dce0..a18c1f9afb37 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1217,8 +1217,8 @@ struct pqi_io_request {
 struct pqi_event {
 	bool	pending;
 	u8	event_type;
-	__le16	event_id;
-	__le32	additional_event_id;
+	u16	event_id;
+	u32	additional_event_id;
 	__le32	ofa_bytes_requested;
 	__le16	ofa_cancel_reason;
 };
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 1000f56504e8..2e8c1c09c622 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3247,8 +3247,8 @@ static void pqi_acknowledge_event(struct pqi_ctrl_info *ctrl_info,
 	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH,
 		&request.header.iu_length);
 	request.event_type = event->event_type;
-	request.event_id = event->event_id;
-	request.additional_event_id = event->additional_event_id;
+	put_unaligned_le16(event->event_id, &request.event_id);
+	put_unaligned_le32(event->additional_event_id, &request.additional_event_id);
 
 	pqi_send_event_ack(ctrl_info, &request, sizeof(request));
 }
@@ -3512,8 +3512,9 @@ static int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 			event = &ctrl_info->events[event_index];
 			event->pending = true;
 			event->event_type = response->event_type;
-			event->event_id = response->event_id;
-			event->additional_event_id = response->additional_event_id;
+			event->event_id = get_unaligned_le16(&response->event_id);
+			event->additional_event_id =
+				get_unaligned_le32(&response->additional_event_id);
 			if (event->event_type == PQI_EVENT_TYPE_OFA)
 				pqi_ofa_capture_event_payload(event, response);
 		}

