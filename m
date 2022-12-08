Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0253AC6377C
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiLHLDf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiLHLCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:02:48 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BB281D98
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 03:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497274; x=1702033274;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yNYIdsnzZpksEA3jejp5dI+tSwjiuvR+jdNItN4gElE=;
  b=O4BbbUnF3aaEKLCVhL8sJNdcQq+4HSTaAhXFFgktfpZ8P+ixJO10WvUw
   oZlLD6pWNtWdCvo3dp8pM2ha8K/hDJ61zBo0Oxa4ln6Jm12zmGsIheFD3
   6H6KdOMMWJtJst4F4MGXPe7Vpxcu9n86Gb0Tn+u9PLyA+QZ6/Wwj9Gu3Y
   vfUykKRrfPPBkwvykgnYx1y8F84tSol3JWPn+6FAfrn83XfHy/7z4u+Yv
   ROBI4eGbLYb91xBcxfBubvhwoD4WYwyJT3j8z6IYqnMpjTRgIHb8okj/E
   Q7Ikro+R1iztZBUGORV+arOMI3b+L1R7r88SEppYC32YBr+ZgmjFqfHJZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333399"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:13 +0800
IronPort-SDR: tNXlxMRH2gk2jPwH4/lWwYdefE8Ns78Z51Hsxft/HDCBTEqoGVUiN6UcAySWhFfz0zNBTuSNIc
 iSrcDxOA5gZgT8LIIe4lFykHICupJMU9yRmd+NEuqlJP2wCn19SulWjZUFqSFZWbn57jx4/Kdv
 J3Vzo+sclSfpDHiuPc8Pru2AnS5ki7fOR+QkdaPnPjQpvolTjNZ3gS27mGPfDJteegcG4MnElm
 MOlnxjC2kfE/T/et0CrtJVjc1k5meslMW1yoo4XLZmsreWXxS54GSEJqLugpmxbZTgxLvsP/cl
 Ipk=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:58 -0800
IronPort-SDR: Dc0Xfk/MwDDo54ueBL5q35ERT23DcEnbEdgrwtlf9ueMeaug6ySDNwyGoW7w3xK9Hc2ao3KSEB
 AKurT2KeiV4uTa28nVTV3TQ47BrOW3sCtw8gv2G2EIqcx86INMkEoe94LysE3ap2m0SlobOUm7
 ITUyq4xj0kaZi1tr6FT6KOsuXn+akUd0Kb6BAbtK6wflTEFn5e7KDkMbTCddqQ+rD8wkL8SMEq
 iXjeRI7Io6v61lA531aVWIg7TC3Buf8VvwQIAduWEYW7bBFcyD8+gQ9xYzVJ3/o3ONKsju3rfA
 3nA=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:13 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 13/25] scsi: support service action in scsi_report_opcode()
Date:   Thu,  8 Dec 2022 11:59:29 +0100
Message-Id: <20221208105947.2399894-14-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
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
---
 drivers/scsi/scsi.c        | 28 +++++++++++++++++++---------
 drivers/scsi/sd.c          | 10 +++++-----
 include/scsi/scsi_device.h |  3 ++-
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1426b9b03612..e69a5dd5abd2 100644
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
@@ -526,8 +530,14 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
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
index 77259716ca75..2b56ff4fcf8a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3038,7 +3038,7 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		return;
 	}
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY, 0) < 0) {
 		struct scsi_vpd *vpd;
 
 		sdev->no_report_opcodes = 1;
@@ -3054,10 +3054,10 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		rcu_read_unlock();
 	}
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16, 0) == 1)
 		sdkp->ws16 = 1;
 
-	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)
+	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME, 0) == 1)
 		sdkp->ws10 = 1;
 }
 
@@ -3069,9 +3069,9 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
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
index a499cdac2ce8..f6d1d9890839 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -433,7 +433,8 @@ extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
 			     int buf_len);
 extern int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
-			      unsigned int len, unsigned char opcode);
+			      unsigned int len, unsigned char opcode,
+			      unsigned short sa);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
 extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
-- 
2.38.1

