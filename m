Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE5FC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFAB1610FE
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238257AbhHTDan (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:30:43 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4894 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237933AbhHTDal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 23:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629430203; x=1660966203;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=+m6b8j3RINuUe0RFKMpYV8vJ6kViZNE1w9rd61chdFY=;
  b=GBy7B+v5y8O1yvsZrJkGHRQCo1cuP6aeKdk2/7boraG4fo2DnXqbvk0q
   c8h+AOZnwL9O0ExciEFRuPPJPmvWREQKVNiUr8W7nrF5TWaQgPwHsB/zj
   CZc9sTgl4c7Y4jK8ZMs+CVZN0dVLSdUZ60RgbUHNcYYFjskrs22BTiY74
   po71VyiUyFOdRecHkID05MNej2z4G8UW+CpP7y56+A94gt3K075xbLsem
   bJmk/jq6tZkwyYt2BW2/vvMyywoq0DGe6pFyRy3e5DWNJ+t3I+iEYHIAT
   FPYiM5Nwl13v3QDRngHK4h4hD4cb7nntISSM78UryDE/SyMOvGXs1yDdM
   w==;
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="182646446"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2021 11:30:02 +0800
IronPort-SDR: jrQg5TxWjpvqufP6yf3v922wgjZdHvbkUSCDcRzqf4SHGFktWvFCSrey5DNf8+ukVeIdxQrys/
 gu8VomHDa1x1yvYdhalDRSXpZSIN/aXozTxGy1PIe5gBFenZGyLCeIf6gy7HYPgs5/mASBc0fY
 mH8w2h8Xrb4OUiLLJYc1tNdGNgH9Z5chWr/VQMVFswRmilx8EX0Jb15iDWxiiepZe/FRNemYpL
 CKfIXSYmaJivQZlIpMM3Xw1UW5am2WWxB212XY6YrsndeA5Rju1e1d+wx6JfC18seDntS3bk0w
 jSdsOsAMcbcn+AyA9CUoHYjG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 20:05:24 -0700
IronPort-SDR: g7MFX9HHMbbYnX9GgQSjM+QaPVWKobqh+72RsFAoiSCMf2zqEbgVJCZuyX+y16xqmpQyM8Tahm
 7YBfjpRWQqb0wjkCT2R3tguzuOhcGjWfocJIpwbB2fFexXZkOCVH1+1rk/nMT6TiOnZDn4CIkl
 MqI1Hou18Xib3KMLs0vxYv0dXJYaugm53dhmpH0GSx3cIiEe+Sd22y45dN58o3xkbSrwGeZ/Wc
 10TeCtTsF3aL+aWV3mXThzqgOz2Aln29OJaHqfDZjDAW+162yS7LYhYZVSg9Mmn+STMX8evwC3
 MRo=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Aug 2021 20:30:03 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 2/2] scsi: fix scsi_mode_select() buffer length handling
Date:   Fri, 20 Aug 2021 12:28:13 +0900
Message-Id: <20210820032813.575032-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820032813.575032-1-damien.lemoal@wdc.com>
References: <20210820032813.575032-1-damien.lemoal@wdc.com>
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

