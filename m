Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B44C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjCIV4r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjCIVzy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:55:54 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDD9F5A82;
        Thu,  9 Mar 2023 13:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398948; x=1709934948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xfP0q9unEE65K1fq/LCJa6CH3/esgv14YbIzfBwqXBk=;
  b=fzG6JEAGJiBu/9L86y+I4WKaSOmNcXxiB+HE+PwHJEdnOg4V1XUnfMqy
   18yFEgFZsAZ0L543ldwwpFg7KjncAqWNZ0rTj9Ji6tV0oNzauY95otGmv
   NH/B3nEDqwikuSRFu40LFbofPxUn51WMABIzoefvfF9CPcLSYO3bR0kwR
   gB1ZUedJ3F+L47tuq1vLEx9HmZ7g0oods7xGpZm8CS6xAPEjXruy1fYIT
   y87ga+rCWxkpdQLierXhTmDY1pYUSJIGoK36AT11VEqH5CessyoKZeBXD
   barP7m5NMvT0PLODNJJBqBD/XValQG+JK7ms0zSHjx8Q1e3fSSm6beEt5
   g==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225270995"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:55:47 +0800
IronPort-SDR: Y3C9QpdfzQ0nhfhX4/HEDsLDtR7c+QT919NrLPaWMfT9qj+jbhMz4x965eDrpM7VogvU26dRUd
 iAw+2ekyt8/3dYMFEymICXf122Of6FFybxTWTy4A2SxKCvb57ieXux6ZqKV+lE0AiceOMjAWDh
 P8zXJv/k/jXJ7M2km/RtPIcDA1xp00So7e+cnoOgyBGEFmdk9jt+bcy4rUhNOvnL2Pk0Ab0RdS
 Ld7CEBqWKKjJCnN+PiqKrc2zSKu+VebrK9Nx2mcYoCtxDyb/1zLKKPc0FGyZcWaL+05SEfhYcC
 icI=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:40 -0800
IronPort-SDR: 3OEmCx+x4mtNvesYp/Isw0ho5dzCKnDx59kAawfh+2xmQ1mjLHAlQmeZrFUtXSpMh7NjBUvxZI
 1VqmjHG8xuyP/A7F99UkawKaCwtsQlN1I3wpyeFHOV8WafJat8HjlxXKLSxFRtdmNGEU11l3vX
 SxUmsFrGeog6e5RQzkxRJDjPUX/wKke26CT49srPLr6F3BiPBYas+Vle0c0Y0GrD025kaMiylh
 93+k3KsSHEnC0yG9g/vfyzqScEapAVAgbYwAonlDH4HLMcqGgPBToc5iK1d2OBLRm/V16CB1J7
 ui0=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:55:45 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 07/19] scsi: support service action in scsi_report_opcode()
Date:   Thu,  9 Mar 2023 22:54:59 +0100
Message-Id: <20230309215516.3800571-8-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c        | 28 +++++++++++++++++++---------
 drivers/scsi/sd.c          | 10 +++++-----
 include/scsi/scsi_device.h |  5 +++--
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 7d2210a006f0..43ef70556027 100644
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
index 8e856a7a6338..c4be44832b49 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3052,7 +3052,7 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		return;
 	}
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY, 0) < 0) {
 		struct scsi_vpd *vpd;
 
 		sdev->no_report_opcodes = 1;
@@ -3068,10 +3068,10 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		rcu_read_unlock();
 	}
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16, 0) == 1)
 		sdkp->ws16 = 1;
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME, 0) == 1)
 		sdkp->ws10 = 1;
 }
 
@@ -3083,9 +3083,9 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
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
index ff4ad3596fa7..9564b47cf2ab 100644
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
2.39.2

