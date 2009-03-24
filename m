From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 04/26] qla2xxx: Correct over-allocation of firmware-dump buffer.
Date: Tue, 24 Mar 2009 09:07:58 -0700
Message-ID: <1237910900-30817-5-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762309AbZCXQIY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:24 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

fce_size should be calculated based on the FCE_SIZE #define.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 87f9abc..1d28b53 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -816,7 +816,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for FCE...\n",
 		    FCE_SIZE / 1024);
 
-		fce_size = sizeof(struct qla2xxx_fce_chain) + EFT_SIZE;
+		fce_size = sizeof(struct qla2xxx_fce_chain) + FCE_SIZE;
 		ha->flags.fce_enabled = 1;
 		ha->fce_dma = tc_dma;
 		ha->fce = tc;
-- 
1.6.2.rc0.55.g30aa4f

