From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Correct late-memset() of EFT buffer.
Date: Thu, 17 Jan 2008 09:02:18 -0800
Message-ID: <1200589340-19499-12-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYAQRCe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:34 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original code would clear the buffer after the firmware had
already been initialized to use the buffer, thus potentially
and inadvertantly clearing data previously DMA'd by the
firmware.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cacfd25..7637fa7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -766,6 +766,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 			goto cont_alloc;
 		}
 
+		memset(tc, 0, EFT_SIZE);
 		rval = qla2x00_enable_eft_trace(ha, tc_dma, EFT_NUM_BUFFERS);
 		if (rval) {
 			qla_printk(KERN_WARNING, ha, "Unable to initialize "
@@ -779,7 +780,6 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 		    EFT_SIZE / 1024);
 
 		eft_size = EFT_SIZE;
-		memset(tc, 0, eft_size);
 		ha->eft_dma = tc_dma;
 		ha->eft = tc;
 
-- 
1.5.4.rc3.14.g44397

