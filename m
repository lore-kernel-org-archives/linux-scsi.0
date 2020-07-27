Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53734C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AA6E2074F
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgG0TBv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:01:51 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46966 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgG0TBu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 15:01:50 -0400
IronPort-SDR: 5K/4ulH65MVllY/URDBcD24nitCdwxuF0bozNlXs6+EIwzLzqZvJrdUdcaS3zhFYsoQO6RWfvw
 UtPZjdKbq7nXYS/SXDihiMYihQ76g3eiUb/N6N0NDCQO6jfRFkDLUUeXSMT2gMsCIs8NoO/ohc
 BnrS/v+qO3x8UuTTzlhuyISWoGYboKqMd/InyW1LNNAcG+aagqT4Bdpj5j/sX+zlN4wfomuOHA
 brSJ2b0du0jmLB31SpJjjbAGDK6T9dM100PuAxrgXy20cuSdlFad/8JvJCdL9gC14TYHCiNWai
 waU=
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="89294021"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jul 2020 12:01:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 12:01:32 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 27 Jul 2020 12:01:32 -0700
Subject: [PATCH 3/4] hpsa: increase ctlr eh timeout
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 27 Jul 2020 14:01:33 -0500
Message-ID: <159587649303.27787.8370512556225680281.stgit@brunhilda>
In-Reply-To: <159587636236.27787.16970342225988726638.stgit@brunhilda>
References: <159587636236.27787.16970342225988726638.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Increase the timeout value for commands sent to
the controller device.

- controller can become slow to respond to INQUIRIES
  resulting in the SML off-lining the controller
  device.
- when large RAID volumes are created along with
  I/O stress, the controller can be slow to respond
  to INQUIRIES.
  - set/sense config along with device resets
    can delay controller responses.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9b1edc541ed0..9286e60b8cc4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2134,6 +2134,7 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
 }
 
 /* configure scsi device based on internal per-device structure */
+#define CTLR_TIMEOUT (120 * HZ)
 static int hpsa_slave_configure(struct scsi_device *sdev)
 {
 	struct hpsa_scsi_dev_t *sd;
@@ -2144,17 +2145,21 @@ static int hpsa_slave_configure(struct scsi_device *sdev)
 
 	if (sd) {
 		sd->was_removed = 0;
+		queue_depth = sd->queue_depth != 0 ?
+				sd->queue_depth : sdev->host->can_queue;
 		if (sd->external) {
 			queue_depth = EXTERNAL_QD;
 			sdev->eh_timeout = HPSA_EH_PTRAID_TIMEOUT;
 			blk_queue_rq_timeout(sdev->request_queue,
 						HPSA_EH_PTRAID_TIMEOUT);
-		} else {
-			queue_depth = sd->queue_depth != 0 ?
-					sd->queue_depth : sdev->host->can_queue;
 		}
-	} else
+		if (is_hba_lunid(sd->scsi3addr)) {
+			sdev->eh_timeout = CTLR_TIMEOUT;
+			blk_queue_rq_timeout(sdev->request_queue, CTLR_TIMEOUT);
+		}
+	} else {
 		queue_depth = sdev->host->can_queue;
+	}
 
 	scsi_change_queue_depth(sdev, queue_depth);
 

