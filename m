From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: [PATCH] SCSI/libsrp: fix bug in ADDITIONAL CDB LENGTH interpretation
Date: Wed, 9 Dec 2009 19:52:19 +0100
Message-ID: <200912091952.19978.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:39132 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbZLISw1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2009 13:52:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

Fix a bug in the interpretation of the ADDITIONAL CDB LENGTH (add_cdb_len)
field of SRP_CMD requests. According to the SRP specification, the layout
of this single-byte field is as follows:
* Bits 0 and 1 are reserved.
* Bits 2 to 7 represent the ADDITIONAL CDB LENGTH field, symbolically
  represented as n.
* Still according to the SRP specification, the ADDITIONAL CDB section
  takes 4*n bytes.

Currently libsrp is only used by the ibmvscsi driver. Since the ibmvscsi
driver doesn't support large CDB's, this bug hasn't caused any problems yet.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 9ad38e8..710919f 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -327,7 +327,7 @@ int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 	int offset, err = 0;
 	u8 format;
 
-	offset = cmd->add_cdb_len * 4;
+	offset = (cmd->add_cdb_len >> 2) * 4;
 
 	dir = srp_cmd_direction(cmd);
 	if (dir == DMA_FROM_DEVICE)
@@ -365,7 +365,7 @@ static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
 {
 	struct srp_direct_buf *md;
 	struct srp_indirect_buf *id;
-	int len = 0, offset = cmd->add_cdb_len * 4;
+	int len = 0, offset = (cmd->add_cdb_len >> 2) * 4;
 	u8 fmt;
 
 	if (dir == DMA_TO_DEVICE)
