From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ps3rom: disable clustering
Date: Sun, 17 Feb 2008 23:46:00 +0900
Message-ID: <1203259560-15434-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52481 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758123AbYBQOrG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Feb 2008 09:47:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

ps3rom does:

scsi_for_each_sg(cmd, sgpnt, scsi_sg_count(cmd), k) {
	kaddr = kmap_atomic(sg_page(sgpnt), KM_IRQ0);

We cannot do something like that with the clustering enabled (or we
can use scsi_kmap_atomic_sg).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/ps3rom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 0cd614a..90985cd 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -427,7 +427,7 @@ static struct scsi_host_template ps3rom_host_template = {
 	.cmd_per_lun =		1,
 	.emulated =             1,		/* only sg driver uses this */
 	.max_sectors =		PS3ROM_MAX_SECTORS,
-	.use_clustering =	ENABLE_CLUSTERING,
+	.use_clustering =	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
 };
 
-- 
1.5.3.7

