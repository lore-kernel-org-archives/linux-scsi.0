From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/5] qla2xxx: Correct (again) overflow during dump-processing on large-memory ISP23xx parts.
Date: Wed, 17 Jun 2009 10:30:31 -0700
Message-ID: <1245259832-8595-5-git-send-email-andrew.vasquez@qlogic.com>
References: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:16588 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbZFQRab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 13:30:31 -0400
In-Reply-To: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Commit 7b867cf76fbcc8d77867cbec6f509f71dce8a98f ([SCSI] qla2xxx:
Refactor qla data structures) inadvertently reverted
e792121ec85672c1fa48f79d13986a3f4f56c590 ([SCSI] qla2xxx: Correct
overflow during dump-processing on large-memory ISP23xx parts.).

Cc: stable@kernel.org
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 4a990f4..cca8e4a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -216,7 +216,7 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
 
 static int
 qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint16_t *ram,
-    uint16_t ram_words, void **nxt)
+    uint32_t ram_words, void **nxt)
 {
 	int rval;
 	uint32_t cnt, stat, timer, words, idx;
-- 
1.6.3.2.306.g4f4fa

