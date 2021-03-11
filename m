Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8824FC433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52FF864F8D
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhCKUQ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:16:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45759 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhCKUQm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:16:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493803; x=1647029803;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JeME5ogq/TA0HABQJgObAYrAfGX0h6kr3tl5N8CFAAU=;
  b=wdDpLhePGPFA/5auWCbYPW+a0W28EdFGVX8ScaTJyUuCowZ7DenZhARw
   h/z83JVAQoZWNK843FxbfzAuHrOs8miq20F1YNvTW9O3oKa+ibiO5W1vM
   t+s044zUYF07SnGAtlyxbGPcCnK+FrLmNAnHJxTF8LwmoQgUV2BYRKV3A
   xyt490hYoxj14pgQwNe2e/3UqvOXXkF0vjUUdmCjkWAIWEJ79LeDHCQSX
   2lHNDpN/VG2q65nLsHlizpciBU2KyI5Mi7yX4Ybw8lmR2SSY+LqXlP7Mo
   pUJnLuUoopx9OUXCjmpujVi/ovVFK0ITlo0PCXXUtSzjlA05wc4qD7OSl
   w==;
IronPort-SDR: moBCkWW9NH6VB/fPLCFnBDpAeBx6vcC5J5HXHa09aoj910I7Cz7H2AnAY3/IC0Q8MLsjEaKD+f
 WYc1RBpU5ZWt6GILmV8BCagSX3O4CzFzHgA5LGjXqDG7ABvRoeq9WEpQ1xUa+XBbV8Xot51iqX
 PqajusEB7XOmS/MXrOTJCvOrvLBF6PQTP4Mwo7yO2q6JqooVBIw0VyP2AU1NPCIn6eGVdnMuIW
 dadpRXFRbgpTaPozG0dh6jPzX8FXZ93/MtOwjVtzThxmHjZEG4j13vuUlH8k+l8PXYsYaplTF2
 OPk=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112406055"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:16:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:16:26 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:16:26 -0700
Subject: [PATCH V5 16/31] smartpqi: update event handler
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:16:26 -0600
Message-ID: <161549378628.25025.14338046567871170916.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
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
index a226b7e32e3d..4c0962879029 100644
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

