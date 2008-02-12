From: marcin.slusarz@gmail.com
Subject: [PATCH] scsi: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:13 +0100
Message-ID: <1202857582-15450-9-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:4852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760252AbYBLXJY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 18:09:24 -0500
Received: by fg-out-1718.google.com with SMTP id e21so4228112fga.17
        for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2008 15:09:23 -0800 (PST)
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-scsi@vger.kernel.org, aacraid@adaptec.com, James.Bottomley@HansenPartnership.com

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-scsi@vger.kernel.org
Cc: aacraid@adaptec.com
Cc: James.Bottomley@HansenPartnership.com
---
 drivers/scsi/aacraid/commsup.c |    2 +-
 drivers/scsi/ips.c             |    8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 81b3692..3ac8c82 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -594,7 +594,7 @@ void aac_consumer_free(struct aac_dev * dev, struct aac_queue *q, u32 qid)
 	if (le32_to_cpu(*q->headers.consumer) >= q->entries)
 		*q->headers.consumer = cpu_to_le32(1);
 	else
-		*q->headers.consumer = cpu_to_le32(le32_to_cpu(*q->headers.consumer)+1);
+		le32_add_cpu(q->headers.consumer, 1);
 
 	if (wasfull) {
 		switch (qid) {
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index bb152fb..f45770a 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3696,9 +3696,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 			scb->cmd.basic_io.sg_count = scb->sg_len;
 
 			if (scb->cmd.basic_io.lba)
-				scb->cmd.basic_io.lba =
-				    cpu_to_le32(le32_to_cpu
-						(scb->cmd.basic_io.lba) +
+				le32_add_cpu(&scb->cmd.basic_io.lba,
 						le16_to_cpu(scb->cmd.basic_io.
 							    sector_count));
 			else
@@ -3744,9 +3742,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 			scb->cmd.basic_io.sg_count = scb->sg_len;
 
 			if (scb->cmd.basic_io.lba)
-				scb->cmd.basic_io.lba =
-				    cpu_to_le32(le32_to_cpu
-						(scb->cmd.basic_io.lba) +
+				le32_add_cpu(&scb->cmd.basic_io.lba,
 						le16_to_cpu(scb->cmd.basic_io.
 							    sector_count));
 			else
-- 
1.5.3.7

