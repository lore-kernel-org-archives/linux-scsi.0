Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF16C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6469A610F9
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbhHTDam (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:30:42 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4898 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbhHTDal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 23:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629430202; x=1660966202;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=1TkJ3vB1HtpkRnuxbMMe1MIpNKIlZkwUFRryFfPqUdA=;
  b=aCHlKt3usPvjS033+66h8UWDy2vNHu1U5idxOMr3dI4mrZAuTDjomsPC
   Pd9+mgWB91a2WMzpuqN5a8K4ezP0Z1aU+A78iGE7EMBVxGZrEAihnvdVf
   EGV+a92nZvAtzgRGI26BeUY9enJddpYovmNWhDfWWE4B+3/gfYVV3NCA+
   Ht7Xz7H98jWS/GgRkqKBOiTDf2PVz/VxKw75u00Rr9rjDmpisVU+n2O1c
   qLQb4ZWYgXxGqJkEagkGPUkQ9QbaYVVX24jBW+ug5xO2FwjXS/HPDeq9L
   OIY09eq7DUNdPpADIPLJw2vFoclX2nlagSMYWVUUvv15R0Cy5PEZTKBY7
   w==;
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="182646445"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2021 11:30:01 +0800
IronPort-SDR: GpnjGQ/NQXkCwtvyocQ7MJCikbqV47qpa5GCeIEJUkkt4I2ZXK/ENIUUQnvnYX0K40HkBeDrJK
 1nvHdHY2yDOkdT4ZZX8je8AytmqOhSIQkds7235iTc5QPtsMKyKZ53agPVKDa1z3C5LX7h6aRc
 jJSfpmiAB/+pF4pbGIa1z/sN5t4u5FzG/4nzf+GUlaie1gcYOqo8ytf7Wc8aJm7ZaDKyNLXP2j
 A6HuaT1xxu0mdCmX9UwSLRK6ZNyt9TSaO/N8InO/L0zac4snwdqIIfx1YqNW3/YCkWryThptR4
 3NcK2rOPYMNU8i71ppxA5sEn
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 20:05:23 -0700
IronPort-SDR: W7KegB0CKiaZ92/5JDOsTKfvJ7KW32Qce4+i2lR4zcdjNvTaSv2iV6T0XXgdyuOZQekoSBYLi2
 bLYlzSTlRXP7CSEbMaXfkVqq6d9Z6m57xFTKTJWappjKrdzbFvOPGn2CRb1W4gIsskqg/CVH6Y
 X+w92GTFCUyNIliSG4UeNAOoJI3r0trcGyzVOOTtNrXQfF9dHG1ais+su7SufXZnqUYD5Fhr2I
 3DqXnUhfyWEDVOnEs+j20snvE6PnzFhp9KA4XVJzA3n+ZqnFrokUmyZfHNbvrXIjto08DBlAAY
 VNQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Aug 2021 20:30:02 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 1/2] scsi: fix scsi_mode_sense() buffer length handling
Date:   Fri, 20 Aug 2021 12:28:12 +0900
Message-Id: <20210820032813.575032-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820032813.575032-1-damien.lemoal@wdc.com>
References: <20210820032813.575032-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Several problems exist with scsi_mode_sense() buffer length handling:
1) The allocation length field of the MODE SENSE 10 command is 16-bits,
   occupying bytes 7 and 8 of the CDB. With this command, access to mode
   pages larger than 255 bytes is thus possible. However, the CDB
   allocation length field is set by assigning len to byte 8 only, thus
   truncating buffer length larger than 255.
2) If scsi_mode_sense() is called with len smaller than 8 with
   sdev->use_10_for_ms set, or smaller than 4 otherwise, the buffer
   length is increased to 8 and 4 respectively, and the buffer is zero
   filled with these increased values, thus corrupting the memory
   following the buffer.

Fix these 2 problems by using put_unaligned_be16() to set the allocation
length field of MODE SENSE 10 CDB and by returning an error when len is
too small.

Furthermore, if len is larger than 255B, always try MODE SENSE 10 first,
even if the device driver did not set sdev->use_10_for_ms. In case of
invalid opcode error for MODE SENSE 10, access to mode pages larger
than 255 bytes are not retried using MODE SENSE (6). To avoid buffer
length overflows for the MODE_SENSE 10 case, check that len is smaller
than 65535 bytes

While at it, also fix the folowing:
* use get_unaligned_be16() to retrieve the mode data length and block
  descriptor length fields of the mode sense reply header instead of
  using an open coded calculation.
* Fix the kdoc dbd argument explanation: the DBD bit stands for
  Disable Block Descriptor, which is the opposite of what the dbd
  argument description was.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_lib.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 572673873ddf..327ea74a5e31 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2075,7 +2075,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
 /**
  *	scsi_mode_sense - issue a mode sense, falling back from 10 to six bytes if necessary.
  *	@sdev:	SCSI device to be queried
- *	@dbd:	set if mode sense will allow block descriptors to be returned
+ *	@dbd:	set to prevent mode sense from returning block descriptors
  *	@modepage: mode page being requested
  *	@buffer: request buffer (may not be smaller than eight bytes)
  *	@len:	length of request buffer.
@@ -2110,18 +2110,18 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		sshdr = &my_sshdr;
 
  retry:
-	use_10_for_ms = sdev->use_10_for_ms;
+	use_10_for_ms = sdev->use_10_for_ms || len > 255;
 
 	if (use_10_for_ms) {
-		if (len < 8)
-			len = 8;
+		if (len < 8 || len > 65535)
+			return -EINVAL;
 
 		cmd[0] = MODE_SENSE_10;
-		cmd[8] = len;
+		put_unaligned_be16(len, &cmd[7]);
 		header_length = 8;
 	} else {
 		if (len < 4)
-			len = 4;
+			return -EINVAL;
 
 		cmd[0] = MODE_SENSE;
 		cmd[4] = len;
@@ -2145,9 +2145,15 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
 			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
 				/*
-				 * Invalid command operation code
+				 * Invalid command operation code: retry using
+				 * MODE SENSE (6) if this was a MODE SENSE 10
+				 * request, except if the request mode page is
+				 * too large for MODE SENSE single byte
+				 * allocation length field.
 				 */
 				if (use_10_for_ms) {
+					if (len > 255)
+						return -EIO;
 					sdev->use_10_for_ms = 0;
 					goto retry;
 				}
@@ -2171,12 +2177,11 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		data->longlba = 0;
 		data->block_descriptor_length = 0;
 	} else if (use_10_for_ms) {
-		data->length = buffer[0]*256 + buffer[1] + 2;
+		data->length = get_unaligned_be16(&buffer[0]) + 2;
 		data->medium_type = buffer[2];
 		data->device_specific = buffer[3];
 		data->longlba = buffer[4] & 0x01;
-		data->block_descriptor_length = buffer[6]*256
-			+ buffer[7];
+		data->block_descriptor_length = get_unaligned_be16(&buffer[6]);
 	} else {
 		data->length = buffer[0] + 1;
 		data->medium_type = buffer[1];
-- 
2.31.1

