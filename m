Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA3CC56201
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 17:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B46920790
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 17:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QFsCyV0a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgJ2RJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 13:09:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:38046 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbgJ2RJf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Oct 2020 13:09:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603991345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1guq/0q6IGzpRoaJ71CCy04UixufVjMPUGDXuDWeYIk=;
        b=QFsCyV0axNK1frEDNK4hEIKamyYu69DcwOl4z1RFmrGVO1c174QdnfHa97hVq1+/PIDr8J
        cHFGWOicvqr8M0p7SDo5V7QyUsmkCTijwhek3DsE8g/8hwgGjsLRcNAuebnXymPLHJrVdB
        SJp/OdSswzwPWRftd8ccXckpSFnbgiY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 36973ACF6;
        Thu, 29 Oct 2020 17:09:05 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/2] scsi: scsi_vpd_lun_id(): fix designator priorities
Date:   Thu, 29 Oct 2020 18:08:45 +0100
Message-Id: <20201029170846.14786-1-mwilck@suse.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

The current implementation of scsi_vpd_lun_id() uses the designator
length as an implicit measure of priority. This works most of the
time, but not always. For example, some Hitachi storage arrays return
this in VPD 0x83:

VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 24
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the Addressed logical unit
      vendor id: HITACHI
      vendor specific: 5030C3502025
  Designation descriptor number 2, descriptor length: 6
    designator_type: vendor specific [0x0],  code_set: Binary
    associated with the Target port
      vendor specific: 08 03
  Designation descriptor number 3, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the Addressed logical unit
      NAA 6, IEEE Company_id: 0x60e8
      Vendor Specific Identifier: 0x7c35000
      Vendor Specific Identifier Extension: 0x30c35000002025
      [0x60060e8007c350000030c35000002025]

The current code would use the first descriptor, because it's longer
than the NAA descriptor. But this is wrong, the kernel is supposed
to prefer NAA descriptors over T10 vendor ID. Designator length
should only be used to compare designators of the same type.

This patch addresses the issue by separating designator priority and
length.

Fixes: 9983bed3907c ("scsi: Add scsi_vpd_lun_id()")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 126 +++++++++++++++++++++++++++-------------
 1 file changed, 86 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 60c7a7d74852..293ee1af62c3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2949,6 +2949,78 @@ void sdev_enable_disk_events(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(sdev_enable_disk_events);
 
+static unsigned char designator_prio(const unsigned char *d)
+{
+	if (d[1] & 0x30)
+		/* not associated with LUN */
+		return 0;
+
+	if (d[3] == 0)
+		/* invalid length */
+		return 0;
+
+	/*
+	 * Order of preference for lun descriptor:
+	 * - SCSI name string
+	 * - NAA IEEE Registered Extended
+	 * - EUI-64 based 16-byte
+	 * - EUI-64 based 12-byte
+	 * - NAA IEEE Registered
+	 * - NAA IEEE Extended
+	 * - EUI-64 based 8-byte
+	 * - SCSI name string (truncated)
+	 * - T10 Vendor ID
+	 * as longer descriptors reduce the likelyhood
+	 * of identification clashes.
+	 */
+
+	switch (d[1] & 0xf) {
+	case 8:
+		/* SCSI name string, variable-length UTF-8 */
+		return 9;
+	case 3:
+		switch (d[4] >> 4) {
+		case 6:
+			/* NAA registered extended */
+			return 8;
+		case 5:
+			/* NAA registered */
+			return 5;
+		case 4:
+			/* NAA extended */
+			return 4;
+		case 3:
+			/* NAA locally assigned */
+			return 1;
+		default:
+			break;
+		}
+		break;
+	case 2:
+		switch (d[3]) {
+		case 16:
+			/* EUI64-based, 16 byte */
+			return 7;
+		case 12:
+			/* EUI64-based, 12 byte */
+			return 6;
+		case 8:
+			/* EUI64-based, 8 byte */
+			return 3;
+		default:
+			break;
+		}
+		break;
+	case 1:
+		/* T10 vendor ID */
+		return 1;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 /**
  * scsi_vpd_lun_id - return a unique device identification
  * @sdev: SCSI device
@@ -2965,7 +3037,7 @@ EXPORT_SYMBOL(sdev_enable_disk_events);
  */
 int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 {
-	u8 cur_id_type = 0xff;
+	u8 cur_id_prio = 0;
 	u8 cur_id_size = 0;
 	const unsigned char *d, *cur_id_str;
 	const struct scsi_vpd *vpd_pg83;
@@ -2978,20 +3050,6 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 		return -ENXIO;
 	}
 
-	/*
-	 * Look for the correct descriptor.
-	 * Order of preference for lun descriptor:
-	 * - SCSI name string
-	 * - NAA IEEE Registered Extended
-	 * - EUI-64 based 16-byte
-	 * - EUI-64 based 12-byte
-	 * - NAA IEEE Registered
-	 * - NAA IEEE Extended
-	 * - T10 Vendor ID
-	 * as longer descriptors reduce the likelyhood
-	 * of identification clashes.
-	 */
-
 	/* The id string must be at least 20 bytes + terminating NULL byte */
 	if (id_len < 21) {
 		rcu_read_unlock();
@@ -3001,8 +3059,9 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 	memset(id, 0, id_len);
 	d = vpd_pg83->data + 4;
 	while (d < vpd_pg83->data + vpd_pg83->len) {
-		/* Skip designators not referring to the LUN */
-		if ((d[1] & 0x30) != 0x00)
+		u8 prio = designator_prio(d);
+
+		if (prio == 0 || cur_id_prio > prio)
 			goto next_desig;
 
 		switch (d[1] & 0xf) {
@@ -3010,28 +3069,19 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 			/* T10 Vendor ID */
 			if (cur_id_size > d[3])
 				break;
-			/* Prefer anything */
-			if (cur_id_type > 0x01 && cur_id_type != 0xff)
-				break;
+			cur_id_prio = prio;
 			cur_id_size = d[3];
 			if (cur_id_size + 4 > id_len)
 				cur_id_size = id_len - 4;
 			cur_id_str = d + 4;
-			cur_id_type = d[1] & 0xf;
 			id_size = snprintf(id, id_len, "t10.%*pE",
 					   cur_id_size, cur_id_str);
 			break;
 		case 0x2:
 			/* EUI-64 */
-			if (cur_id_size > d[3])
-				break;
-			/* Prefer NAA IEEE Registered Extended */
-			if (cur_id_type == 0x3 &&
-			    cur_id_size == d[3])
-				break;
+			cur_id_prio = prio;
 			cur_id_size = d[3];
 			cur_id_str = d + 4;
-			cur_id_type = d[1] & 0xf;
 			switch (cur_id_size) {
 			case 8:
 				id_size = snprintf(id, id_len,
@@ -3049,17 +3099,14 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 						   cur_id_str);
 				break;
 			default:
-				cur_id_size = 0;
 				break;
 			}
 			break;
 		case 0x3:
 			/* NAA */
-			if (cur_id_size > d[3])
-				break;
+			cur_id_prio = prio;
 			cur_id_size = d[3];
 			cur_id_str = d + 4;
-			cur_id_type = d[1] & 0xf;
 			switch (cur_id_size) {
 			case 8:
 				id_size = snprintf(id, id_len,
@@ -3072,26 +3119,25 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 						   cur_id_str);
 				break;
 			default:
-				cur_id_size = 0;
 				break;
 			}
 			break;
 		case 0x8:
 			/* SCSI name string */
-			if (cur_id_size + 4 > d[3])
+			if (cur_id_size > d[3])
 				break;
 			/* Prefer others for truncated descriptor */
-			if (cur_id_size && d[3] > id_len)
-				break;
+			if (d[3] > id_len) {
+				prio = 2;
+				if (cur_id_prio > prio)
+					break;
+			}
+			cur_id_prio = prio;
 			cur_id_size = id_size = d[3];
 			cur_id_str = d + 4;
-			cur_id_type = d[1] & 0xf;
 			if (cur_id_size >= id_len)
 				cur_id_size = id_len - 1;
 			memcpy(id, cur_id_str, cur_id_size);
-			/* Decrease priority for truncated descriptor */
-			if (cur_id_size != id_size)
-				cur_id_size = 6;
 			break;
 		default:
 			break;
-- 
2.29.0

