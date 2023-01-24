Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F700C61D9D
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbjAXTDv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbjAXTDi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:03:38 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37CD4B4AD;
        Tue, 24 Jan 2023 11:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674587016; x=1706123016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tWcH+ezRg/kwhnexReKYcxZ35N6BGIua5vM2sIwNQTk=;
  b=Mk0fZv9XTib/CnxVF7cFsl6jEabhf0ZhKIEg8MQkHQ4sfKkAwXyIL9Gv
   NuuSLyb3+R/wLGRZ2C8H3cdZmwJO+kboQ+k2YjURvBmSaEcbl9U7HomYf
   mP/ZgCQgo8erLsTyiTPhdNWynGlm0rXjHogFdD8qt370SM6FWqGGCrTkn
   DIr0J4lHjsdeeblx/BB0ZPr1FYNqrPfn2DhudxHJcOf1T3CQbNBFRR9TD
   EYHVr+x4dXdyGL8EiYkuUIZBOr5DeRap3A0zM7kTP4qB2i1TuTVemgG0b
   sTq5r3dmUbb/39jp0MwVf1jNgHPVXtA1SKbVRGiFGUeUH21HjOTTmvZUe
   g==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472946"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:35 +0800
IronPort-SDR: fJs1s7gmOLNq7Je/V8kF43nePRhq8ysOcT3P4SBFAfjS7j6h3gdS9T0mCj6iCvAJ+MuH4P1nbG
 lprySJXpg5cUGeiZ5qCW9toreFlg9IDz6gjP3x+64pLuchSlSTwQbjA/NpiOlGxXLMl1WpbiwU
 qnVKC2HJsW52Vn6cWr20QcEnX7Oe2N8H3bgmUBNvHzjOLeYTG+C4fmYkGi1jOPk9oIYz3DSmM2
 loibBF/lBnfV2iZij4XrPR83JeNfTPePaUbmH2ZxxsSZBoAZ4jW2IY6mPgCkCM2jgdJ69pIVU1
 OKg=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:23 -0800
IronPort-SDR: 4b6pU8JszX5Mkv6QEpiCtvIFA456383YlzbSajRm2w02XgkZiiwUseX9z+J3Cd5kuTCNYIPWO2
 tVwqp5azQah9eTKE08vOqK2WahLi44Z8xm4CHLcAiBKrjqDdJ4OUxdVPP5x5LExCIcGfOIyFiS
 oOJ6w5dbKma2ceCOPBdjPDMksSXr6kiZehvE/58inyGT5mU4cLVvviO+0hyaD6uPbIbJEV8S0f
 kXxrBdFUG40TzrAz+MQXVaWOS1msm0QoV2pJ1oHIVStUn9ADW0/LWZy1+GuYub+i4Pl3UHmVvB
 GlQ=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:33 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 06/18] scsi: support service action in scsi_report_opcode()
Date:   Tue, 24 Jan 2023 20:02:52 +0100
Message-Id: <20230124190308.127318-7-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124190308.127318-1-niklas.cassel@wdc.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

The REPORT_SUPPORTED_OPERATION_CODES command allows checking for support
of commands that have the same opcode but different service actions,
such as READ 32 and WRITE 32. However, the current implementation of
scsi_report_opcode() only allows checking an operation code without a
service action differentiation.

Add the "sa" argument to scsi_report_opcode() to allow passing a service
action. If a non-zero service action is specified, the reporting
options field value is set to 3 to have the service action field taken
into account by the device. If no service action field is specified
(zero), the reporting options field is set to 1 as before.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c        | 28 +++++++++++++++++++---------
 drivers/scsi/sd.c          | 10 +++++-----
 include/scsi/scsi_device.h |  5 +++--
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 00ee47a04403..579c3153b9f3 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -494,18 +494,22 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 }
 
 /**
- * scsi_report_opcode - Find out if a given command opcode is supported
+ * scsi_report_opcode - Find out if a given command is supported
  * @sdev:	scsi device to query
  * @buffer:	scratch buffer (must be at least 20 bytes long)
  * @len:	length of buffer
- * @opcode:	opcode for command to look up
- *
- * Uses the REPORT SUPPORTED OPERATION CODES to look up the given
- * opcode. Returns -EINVAL if RSOC fails, 0 if the command opcode is
- * unsupported and 1 if the device claims to support the command.
+ * @opcode:	opcode for the command to look up
+ * @sa:		service action for the command to look up
+ *
+ * Uses the REPORT SUPPORTED OPERATION CODES to check support for the
+ * command identified with @opcode and @sa. If the command does not
+ * have a service action, @sa must be 0. Returns -EINVAL if RSOC fails,
+ * 0 if the command is not supported and 1 if the device claims to
+ * support the command.
  */
 int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
-		       unsigned int len, unsigned char opcode)
+		       unsigned int len, unsigned char opcode,
+		       unsigned short sa)
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
@@ -529,8 +533,14 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	memset(cmd, 0, 16);
 	cmd[0] = MAINTENANCE_IN;
 	cmd[1] = MI_REPORT_SUPPORTED_OPERATION_CODES;
-	cmd[2] = 1;		/* One command format */
-	cmd[3] = opcode;
+	if (!sa) {
+		cmd[2] = 1;	/* One command format */
+		cmd[3] = opcode;
+	} else {
+		cmd[2] = 3;	/* One command format with service action */
+		cmd[3] = opcode;
+		put_unaligned_be16(sa, &cmd[4]);
+	}
 	put_unaligned_be32(request_len, &cmd[6]);
 	memset(buffer, 0, len);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7582e02a8d5a..45945bfeee92 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3058,7 +3058,7 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		return;
 	}
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY, 0) < 0) {
 		struct scsi_vpd *vpd;
 
 		sdev->no_report_opcodes = 1;
@@ -3074,10 +3074,10 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		rcu_read_unlock();
 	}
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16, 0) == 1)
 		sdkp->ws16 = 1;
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME, 0) == 1)
 		sdkp->ws10 = 1;
 }
 
@@ -3089,9 +3089,9 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
 		return;
 
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE,
-			SECURITY_PROTOCOL_IN) == 1 &&
+			SECURITY_PROTOCOL_IN, 0) == 1 &&
 	    scsi_report_opcode(sdev, buffer, SD_BUF_SIZE,
-			SECURITY_PROTOCOL_OUT) == 1)
+			SECURITY_PROTOCOL_OUT, 0) == 1)
 		sdkp->security = 1;
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 15e005982032..8978c2a58702 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -431,8 +431,9 @@ extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries, struct scsi_sense_hdr *sshdr);
 extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
 			     int buf_len);
-extern int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
-			      unsigned int len, unsigned char opcode);
+int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
+		       unsigned int len, unsigned char opcode,
+		       unsigned short sa);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
 extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
-- 
2.39.1

