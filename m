Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F00C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 123E064E40
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhBVN2S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:28:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:47786 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231497AbhBVN1j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:27:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A838EAFB0;
        Mon, 22 Feb 2021 13:24:15 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/31] scsi: use real inquiry data when initialising devices
Date:   Mon, 22 Feb 2021 14:23:40 +0100
Message-Id: <20210222132405.91369-7-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use dummy inquiry data when initialising devices and not just
some 'nullnullnull' string.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9af50e6f94c4..11aec38250ca 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -81,7 +81,27 @@
 #define SCSI_SCAN_TARGET_PRESENT	1
 #define SCSI_SCAN_LUN_PRESENT		2
 
-static const char *scsi_null_device_strs = "nullnullnullnull";
+/*
+ * Dummy inquiry for virtual LUNs:
+ *
+ * standard INQUIRY: [qualifier indicates no connected LU]
+ *  PQual=1  Device_type=31  RMB=0  LU_CONG=0  version=0x05  [SPC-3]
+ *  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
+ *  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
+ *  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
+ *  [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=0
+ *    length=36 (0x24)   Peripheral device type: no physical device on this lu
+ * Vendor identification: LINUX
+ * Product identification: VIRTUALLUN
+ * Product revision level: 1.0
+ */
+static const unsigned char scsi_null_inquiry[36] = {
+	0x3f, 0x00, 0x05, 0x02, 0x1f, 0x00, 0x00, 0x00,
+	0x4c, 0x49, 0x4e, 0x55, 0x58, 0x20, 0x20, 0x20,
+	0x56, 0x49, 0x52, 0x54, 0x55, 0x41, 0x4c, 0x4c,
+	0x55, 0x4e, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+	0x31, 0x2e, 0x30, 0x20
+};
 
 #define MAX_SCSI_LUNS	512
 
@@ -224,9 +244,10 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	if (!sdev)
 		goto out;
 
-	sdev->vendor = scsi_null_device_strs;
-	sdev->model = scsi_null_device_strs;
-	sdev->rev = scsi_null_device_strs;
+	sdev->type = scsi_null_inquiry[0] & 0x1f;
+	sdev->vendor = scsi_null_inquiry + 8;
+	sdev->model = scsi_null_inquiry + 16;
+	sdev->rev = scsi_null_inquiry + 32;
 	sdev->host = shost;
 	sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
 	sdev->id = starget->id;
@@ -253,11 +274,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 * slave_configure function */
 	sdev->max_device_blocked = SCSI_DEFAULT_DEVICE_BLOCKED;
 
-	/*
-	 * Some low level driver could use device->type
-	 */
-	sdev->type = -1;
-
 	/*
 	 * Assume that the device will have handshaking problems,
 	 * and then fix this field later if it turns out it
-- 
2.29.2

