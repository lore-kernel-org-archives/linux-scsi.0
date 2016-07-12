From: tom.ty89@gmail.com
Subject: [PATCH v6 1/2] libata-scsi: reject WRITE SAME (16) with n_block that exceeds limit
Date: Wed, 13 Jul 2016 04:31:22 +0800
Message-ID: <844c07e66ad6d410029d80e6b32e8f1480fa9f47.1468354842.git.tom.ty89@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36384 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbcGLUcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 16:32:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, sergei.shtylyov@cogentembedded.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

Currently if a WRITE SAME (16) command is issued to the SATL with
"number of blocks" that is larger than the "Maximum write same length"
(which is the maximum number of blocks per TRIM command allowed in
libata, currently 65535 * 512 / 8 blocks), the SATL will accept the
command and translate it to a TRIM command with the upper limit.

However, according to SBC (as of sbc4r11.pdf), the "device server"
should terminate the command with "Invalid field in CDB" in that case.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..392aebb 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3305,7 +3305,13 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param_len;
 
 	buf = page_address(sg_page(scsi_sglist(scmd)));
-	size = ata_set_lba_range_entries(buf, 512, block, n_block);
+
+	if (n_block <= 65535 * 512 / 8) {
+		size = ata_set_lba_range_entries(buf, 512, block, n_block);
+	} else {
+		fp = 2;
+		goto invalid_fld;
+	}
 
 	if (ata_ncq_enabled(dev) && ata_fpdma_dsm_supported(dev)) {
 		/* Newer devices support queued TRIM commands */
-- 
2.9.0

