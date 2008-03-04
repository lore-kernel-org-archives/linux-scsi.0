From: akpm@linux-foundation.org
Subject: [patch 5/7] scsi: le*_add_cpu conversion
Date: Tue, 04 Mar 2008 15:24:25 -0800
Message-ID: <200803042324.m24NOP97003093@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765676AbYCDX2w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 18:28:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, marcin.slusarz@gmail.com

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: James.Bottomley@HansenPartnership.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/commsup.c |    2 +-
 drivers/scsi/ips.c             |    8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/aacraid/commsup.c~scsi-le_add_cpu-conversion drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~scsi-le_add_cpu-conversion
+++ a/drivers/scsi/aacraid/commsup.c
@@ -594,7 +594,7 @@ void aac_consumer_free(struct aac_dev * 
 	if (le32_to_cpu(*q->headers.consumer) >= q->entries)
 		*q->headers.consumer = cpu_to_le32(1);
 	else
-		*q->headers.consumer = cpu_to_le32(le32_to_cpu(*q->headers.consumer)+1);
+		le32_add_cpu(q->headers.consumer, 1);
 
 	if (wasfull) {
 		switch (qid) {
diff -puN drivers/scsi/ips.c~scsi-le_add_cpu-conversion drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~scsi-le_add_cpu-conversion
+++ a/drivers/scsi/ips.c
@@ -3696,9 +3696,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * 
 			scb->cmd.basic_io.sg_count = scb->sg_len;
 
 			if (scb->cmd.basic_io.lba)
-				scb->cmd.basic_io.lba =
-				    cpu_to_le32(le32_to_cpu
-						(scb->cmd.basic_io.lba) +
+				le32_add_cpu(&scb->cmd.basic_io.lba,
 						le16_to_cpu(scb->cmd.basic_io.
 							    sector_count));
 			else
@@ -3744,9 +3742,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * 
 			scb->cmd.basic_io.sg_count = scb->sg_len;
 
 			if (scb->cmd.basic_io.lba)
-				scb->cmd.basic_io.lba =
-				    cpu_to_le32(le32_to_cpu
-						(scb->cmd.basic_io.lba) +
+				le32_add_cpu(&scb->cmd.basic_io.lba,
 						le16_to_cpu(scb->cmd.basic_io.
 							    sector_count));
 			else
_
