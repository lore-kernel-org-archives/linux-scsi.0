From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ps3rom: convert to use the data buffer accessors
Date: Mon, 23 Jul 2007 09:42:32 +0900
Message-ID: <20070723094232S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:46773 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbXGWA5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 20:57:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: Geert.Uytterhoeven@sonycom.com, linux-scsi@vger.kernel.org

This is against Linus' tree since scsi-misc doesn't include ps3rom
driver yet.

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ps3rom: convert to use the data buffer accessors

This converts ps3rom driver to use the new accessors for the sg lists
and the parameters.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ps3rom.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index b50f1e1..0f43d1d 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -100,16 +100,16 @@ static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf)
 	struct scatterlist *sgpnt;
 	unsigned int buflen;
 
-	buflen = cmd->request_bufflen;
+	buflen = scsi_bufflen(cmd);
 	if (!buflen)
 		return 0;
 
-	if (!cmd->request_buffer)
+	if (!scsi_sglist(cmd))
 		return -1;
 
-	sgpnt = cmd->request_buffer;
 	active = 1;
-	for (k = 0, req_len = 0, act_len = 0; k < cmd->use_sg; ++k, ++sgpnt) {
+	req_len = act_len = 0;
+	scsi_for_each_sg(cmd, sgpnt, scsi_sg_count(cmd), k) {
 		if (active) {
 			kaddr = kmap_atomic(sgpnt->page, KM_IRQ0);
 			len = sgpnt->length;
@@ -124,7 +124,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf)
 		}
 		req_len += sgpnt->length;
 	}
-	cmd->resid = req_len - act_len;
+	scsi_set_resid(cmd, req_len - act_len);
 	return 0;
 }
 
@@ -138,15 +138,15 @@ static int fetch_to_dev_buffer(struct scsi_cmnd *cmd, void *buf)
 	struct scatterlist *sgpnt;
 	unsigned int buflen;
 
-	buflen = cmd->request_bufflen;
+	buflen = scsi_bufflen(cmd);
 	if (!buflen)
 		return 0;
 
-	if (!cmd->request_buffer)
+	if (!scsi_sglist(cmd))
 		return -1;
 
-	sgpnt = cmd->request_buffer;
-	for (k = 0, req_len = 0, fin = 0; k < cmd->use_sg; ++k, ++sgpnt) {
+	req_len = fin = 0;
+	scsi_for_each_sg(cmd, sgpnt, scsi_sg_count(cmd), k) {
 		kaddr = kmap_atomic(sgpnt->page, KM_IRQ0);
 		len = sgpnt->length;
 		if ((req_len + len) > buflen) {
@@ -177,12 +177,12 @@ static int ps3rom_atapi_request(struct ps3_storage_device *dev,
 	memcpy(&atapi_cmnd.pkt, cmd->cmnd, 12);
 	atapi_cmnd.pktlen = 12;
 	atapi_cmnd.block_size = 1; /* transfer size is block_size * blocks */
-	atapi_cmnd.blocks = atapi_cmnd.arglen = cmd->request_bufflen;
+	atapi_cmnd.blocks = atapi_cmnd.arglen = scsi_bufflen(cmd);
 	atapi_cmnd.buffer = dev->bounce_lpar;
 
 	switch (cmd->sc_data_direction) {
 	case DMA_FROM_DEVICE:
-		if (cmd->request_bufflen >= CD_FRAMESIZE)
+		if (scsi_bufflen(cmd) >= CD_FRAMESIZE)
 			atapi_cmnd.proto = DMA_PROTO;
 		else
 			atapi_cmnd.proto = PIO_DATA_IN_PROTO;
@@ -190,7 +190,7 @@ static int ps3rom_atapi_request(struct ps3_storage_device *dev,
 		break;
 
 	case DMA_TO_DEVICE:
-		if (cmd->request_bufflen >= CD_FRAMESIZE)
+		if (scsi_bufflen(cmd) >= CD_FRAMESIZE)
 			atapi_cmnd.proto = DMA_PROTO;
 		else
 			atapi_cmnd.proto = PIO_DATA_OUT_PROTO;
-- 
1.5.2.4

