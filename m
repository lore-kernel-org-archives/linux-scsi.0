From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 15/18] qla2xxx: Correct overflow during dump-processing on large-memory ISP23xx parts.
Date: Thu, 10 Jul 2008 16:56:00 -0700
Message-ID: <1215734163-40825-15-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbYGJX4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:12 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Total ram words can exceed a 16bit value on large-memory boards.
Safely extend to a 32bit width.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index cbef785..510ba64 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -216,7 +216,7 @@ qla24xx_soft_reset(scsi_qla_host_t *ha)
 
 static int
 qla2xxx_dump_ram(scsi_qla_host_t *ha, uint32_t addr, uint16_t *ram,
-    uint16_t ram_words, void **nxt)
+    uint32_t ram_words, void **nxt)
 {
 	int rval;
 	uint32_t cnt, stat, timer, words, idx;
-- 
1.5.6.2.292.ga9a3

