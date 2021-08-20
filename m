Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453D2C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 07:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DDB661056
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 07:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbhHTHFf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 03:05:35 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20637 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbhHTHFa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 03:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629443092; x=1660979092;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=+m6b8j3RINuUe0RFKMpYV8vJ6kViZNE1w9rd61chdFY=;
  b=Oo1UaIZ7+llEZAPxWKLPfrmx1vNS1oy2x2eNTvWu55feWv7bFJ85uG3S
   aTxZBzLbft9yoBY7RRVsbBWERmtuihy8xL08Hbp+gfjbpX7OAXMlRVv2S
   h0jzdK1ZzwAKiytQJJNXrA/rPIviXgmzGjvEiCvErtMn96VJLtfnzzqfv
   gbxT1zRB75GF56h5uG53GCsmPXDX9n9x2TSfBMbl4SDVRC1WoSL/R93sc
   K+p7Hxj3uLT9ZCdxfxKVrfFC9qzisfK0T9/WvANyPWnGDpLY9X5RqCDE8
   hpjtp5IUbzD8fEbBj5MxSVN9CGR4HsgvDxmRobEx1CRtm2DjUeSD+jVG/
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="182663596"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2021 15:04:37 +0800
IronPort-SDR: k4KtyRAU4EQQ4R8YRT7dstRODK04hiy6Z+VVNFp1pT0aaHMVN2o6o3EANJYVGHcRvUCrQdh6C0
 VHdxO2DUw5dicSVhXyEk55KYRRRLMoh7AJj2hc9Oss93VLaZQMgfZX5IQN8VEMbqI2yKWwSu39
 XnS8Wu50YCEp4NhEFjMSh6OCOxv5TWI+MavbamNQU2blkE28kwAP/FowKCcWEC0Z3cn4Jf/ssv
 qbAH8Ly+a28nXsXj2NW0qVuc+wFr5/lsZlRdQQUuqFmGWhg0OH542PeNVlT3jqVeEkWwjww45p
 e0jG5zyYtYE5dGOrTvOFqvQu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 23:39:57 -0700
IronPort-SDR: no5C0tgnaYcu6yR7ueNkguo0j/08TT03CkD6NFwGtonIUNAV+E1Nf0gk1eVFX9Jz9XPmZSgp0e
 LReEUvKabrPl/DHbVtCUuc9LyNJ2Lrt77ru0ZKhAbg8BZ20O8tVMxtOoh2pY+RLFtnM2QBKWHZ
 wFJtaIWUgGVqd2RpoQEawnmB769OYUQZYwsYvoF9MbR41Dtlqv26Wv5GzGhkogtqBG9GlBYV9D
 vSqwS+8MGbnCElWtq4rllIbbYUlwBo4WAxLGfm5ivy8ESG6C/n6BvrGZujd3HgXIJXHyzFFsS7
 dAI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Aug 2021 00:04:38 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 2/3] scsi: fix scsi_mode_select() buffer length handling
Date:   Fri, 20 Aug 2021 16:02:54 +0900
Message-Id: <20210820070255.682775-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820070255.682775-1-damien.lemoal@wdc.com>
References: <20210820070255.682775-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The MODE SELECT (6) command allows handling mode page buffers that are
up to 255 bytes, including the 4 byte header needed in front of the page
buffer. For requests larger than this limit, automatically use the
MODE SENSE 10 command.

In both cases, since scsi_mode_select() adds the mode select page
header, checks on the buffer length value must include this header size
to avoid overflows of the command CDB allocatione length field.

While at it, use put_unaligned_be16() for setting the header block
descriptor length and CDB allocation length when using MODE SELECT 10.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_lib.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 327ea74a5e31..c9a825f583d6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2026,8 +2026,15 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 	memset(cmd, 0, sizeof(cmd));
 	cmd[1] = (pf ? 0x10 : 0) | (sp ? 0x01 : 0);
 
-	if (sdev->use_10_for_ms) {
-		if (len > 65535)
+	/*
+	 * Use MODE SENSE 10 if the device asked for it or if the mode page
+	 * and the mode select header cannot fit within the maximumm 255B of
+	 * the MODE SELECT (6) command.
+	 */
+	if (sdev->use_10_for_ms ||
+	    len + 4 > 255 ||
+	    data->block_descriptor_length > 255) {
+		if (len > 65535 - 8)
 			return -EINVAL;
 		real_buffer = kmalloc(8 + len, GFP_KERNEL);
 		if (!real_buffer)
@@ -2040,15 +2047,13 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 		real_buffer[3] = data->device_specific;
 		real_buffer[4] = data->longlba ? 0x01 : 0;
 		real_buffer[5] = 0;
-		real_buffer[6] = data->block_descriptor_length >> 8;
-		real_buffer[7] = data->block_descriptor_length;
+		put_unaligned_be16(data->block_descriptor_length,
+				   &real_buffer[6]);
 
 		cmd[0] = MODE_SELECT_10;
-		cmd[7] = len >> 8;
-		cmd[8] = len;
+		put_unaligned_be16(len, &cmd[7]);
 	} else {
-		if (len > 255 || data->block_descriptor_length > 255 ||
-		    data->longlba)
+		if (data->longlba)
 			return -EINVAL;
 
 		real_buffer = kmalloc(4 + len, GFP_KERNEL);
-- 
2.31.1

