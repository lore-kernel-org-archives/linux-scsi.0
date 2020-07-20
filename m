Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1465DC433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 21:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E10D2208E4
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 21:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGTVxF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 17:53:05 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:18961 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgGTVxF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 17:53:05 -0400
IronPort-SDR: 5+I1Vj0XtYa786FC6mVR6qUBRqMfDxxe+0jh2o55K+CV5t+Vww5ls0Nwbcp/Zo6DD+Pz1tLAuo
 xuqSJQu3V0oryNtkcW9jr4wNzY0B7OwO4Ltb/lQF5Gw0g+q7FtZzIU++S15Xq+IhprbvmHh8v/
 NEkqxy0YqtovtvW19o+gK4d1FREwfNzXHUUw7UwI5zhVeW0gq9Ydti4AuGgeoKDHbLb4GiTRui
 08rZHf/lpDMp5qm2rncDbj+6sVDj8GN8WNtqCe8eOO7ngAuHBJ78905/eJfsJmPAka3qQrEejH
 QiI=
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="19897266"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2020 14:53:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 14:53:03 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 20 Jul 2020 14:53:03 -0700
Subject: [PATCH 3/4] hpsa: increase ctlr eh timeout
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 20 Jul 2020 16:53:03 -0500
Message-ID: <159528198335.24772.7963614374905470122.stgit@brunhilda>
In-Reply-To: <159528193513.24772.2142294136346611232.stgit@brunhilda>
References: <159528193513.24772.2142294136346611232.stgit@brunhilda>
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
 drivers/scsi/hpsa.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9b1edc541ed0..bd96bb6d0e0a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2134,6 +2134,7 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
 }
 
 /* configure scsi device based on internal per-device structure */
+#define CTLR_TIMEOUT (120 * HZ)
 static int hpsa_slave_configure(struct scsi_device *sdev)
 {
 	struct hpsa_scsi_dev_t *sd;
@@ -2149,6 +2150,9 @@ static int hpsa_slave_configure(struct scsi_device *sdev)
 			sdev->eh_timeout = HPSA_EH_PTRAID_TIMEOUT;
 			blk_queue_rq_timeout(sdev->request_queue,
 						HPSA_EH_PTRAID_TIMEOUT);
+		} else if (is_hba_lunid(sd->scsi3addr)) {
+			sdev->eh_timeout = CTLR_TIMEOUT;
+			blk_queue_rq_timeout(sdev->request_queue, CTLR_TIMEOUT);
 		} else {
 			queue_depth = sd->queue_depth != 0 ?
 					sd->queue_depth : sdev->host->can_queue;

