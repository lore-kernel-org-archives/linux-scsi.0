Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C67ECE58C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 06:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE96C217F9
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 06:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfJOGSi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 02:18:38 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:60356 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfJOGSi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Oct 2019 02:18:38 -0400
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=balsundar.p@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  balsundar.p@microsemi.com designates 208.19.100.22 as
  permitted sender) identity=mailfrom; client-ip=208.19.100.22;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="balsundar.p@microsemi.com";
  x-sender="balsundar.p@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.22; receiver=esa5.microchip.iphmx.com;
  envelope-from="balsundar.p@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: KvjZd5XEypaYYAsARAFHg02QEb7kqcHb05U1bzQu0DlROJLW8z8cQQotyWh66DbCUPFG/OWnP1
 TW2cKNjnWQY85Hz9uz8ftePYDRH+d7HAFgeBhXhcrbVe9Gn10P+ET09R1b087ivPt+V/Pl8Eo/
 zuYv/gzBIUJjUSii/NZ4AL2aTD2jkIz9d7VGYTGFnKsRHO2hfWJsSnga4QYC86A5LAs6bKUo8J
 A4MqhPwcBNe6sp4xeqvHreUO9DuEQdYI/yCCankiWEHH8xxnyRg5eQzG8oJuVZN/VdbNdA01/R
 ILM=
X-IronPort-AV: E=Sophos;i="5.67,298,1566889200"; 
   d="scan'208";a="51480645"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2019 23:18:38 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 14 Oct
 2019 23:18:36 -0700
Received: from localhost (10.41.130.77) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1713.5 via Frontend Transport; Mon, 14 Oct
 2019 23:18:36 -0700
From:   <balsundar.p@microsemi.com>
To:     <linux-scsi@vger.kernel.org>, <jejb@linux.vnet.ibm.com>
CC:     <aacraid@microsemi.com>
Subject: [PATCH 4/7] scsi: aacraid: setting different timeout for src and thor
Date:   Tue, 15 Oct 2019 11:52:01 +0530
Message-ID: <1571120524-6037-5-git-send-email-balsundar.p@microsemi.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571120524-6037-1-git-send-email-balsundar.p@microsemi.com>
References: <1571120524-6037-1-git-send-email-balsundar.p@microsemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Balsundar P <balsundar.p@microsemi.com>

Set 180 secs timeout for thor and 60 secs for src controllers

Signed-off-by: Balsundar P <balsundar.p@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  |  3 ++-
 drivers/scsi/aacraid/aacraid.h |  2 ++
 drivers/scsi/aacraid/linit.c   | 10 +++++++---
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 2388143d59f5..e36608ce937a 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1477,6 +1477,7 @@ static struct aac_srb * aac_scsi_common(struct fib * fib, struct scsi_cmnd * cmd
 	struct aac_srb * srbcmd;
 	u32 flag;
 	u32 timeout;
+	struct aac_dev *dev = fib->dev;
 
 	aac_fib_init(fib);
 	switch(cmd->sc_data_direction){
@@ -1503,7 +1504,7 @@ static struct aac_srb * aac_scsi_common(struct fib * fib, struct scsi_cmnd * cmd
 	srbcmd->flags    = cpu_to_le32(flag);
 	timeout = cmd->request->timeout/HZ;
 	if (timeout == 0)
-		timeout = 1;
+		timeout = (dev->sa_firmware ? AAC_SA_TIMEOUT : AAC_ARC_TIMEOUT);
 	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
 	srbcmd->retry_limit = 0; /* Obsolete parameter */
 	srbcmd->cdb_size = cpu_to_le32(cmd->cmd_len);
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3fdd4583cbb5..f76a33cb0259 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -108,6 +108,8 @@ enum {
 #define AAC_BUS_TARGET_LOOP		(AAC_MAX_BUSES * AAC_MAX_TARGETS)
 #define AAC_MAX_NATIVE_SIZE		2048
 #define FW_ERROR_BUFFER_SIZE		512
+#define AAC_SA_TIMEOUT			180
+#define AAC_ARC_TIMEOUT			60
 
 #define get_bus_number(x)	(x/AAC_MAX_TARGETS)
 #define get_target_number(x)	(x%AAC_MAX_TARGETS)
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 644f7f5c61a2..acc0250a4b62 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -392,6 +392,7 @@ static int aac_slave_configure(struct scsi_device *sdev)
 	int chn, tid;
 	unsigned int depth = 0;
 	unsigned int set_timeout = 0;
+	int timeout = 0;
 	bool set_qd_dev_type = false;
 	u8 devtype = 0;
 
@@ -484,10 +485,13 @@ static int aac_slave_configure(struct scsi_device *sdev)
 
 	/*
 	 * Firmware has an individual device recovery time typically
-	 * of 35 seconds, give us a margin.
+	 * of 35 seconds, give us a margin. Thor devices can take longer in
+	 * error recovery, hence different value
 	 */
-	if (set_timeout && sdev->request_queue->rq_timeout < (45 * HZ))
-		blk_queue_rq_timeout(sdev->request_queue, 45*HZ);
+	if (set_timeout) {
+		timeout = aac->sa_firmware ? AAC_SA_TIMEOUT : AAC_ARC_TIMEOUT;
+		blk_queue_rq_timeout(sdev->request_queue, timeout*HZ);
+	}
 
 	if (depth > 256)
 		depth = 256;
-- 
2.18.1

