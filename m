From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 31] drivers/scsi/ide-scsi.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:01:57 +0200
Message-ID: <200707312001.58138.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4522 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390AbXGaSB6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 14:01:58 -0400
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/ide-scsi.c | 34642 -> 34536 (-106 bytes)
 drivers/scsi/ide-scsi.o | 171728 -> 171524 (-204 bytes)

 drivers/scsi/ide-scsi.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/ide-scsi.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/ide-scsi.c	2007-07-31 14:09:51.000000000 +0200
@@ -328,17 +328,15 @@ static int idescsi_check_condition(ide_d
 	u8             *buf;

 	/* stuff a sense request in front of our current request */
-	pc = kmalloc (sizeof (idescsi_pc_t), GFP_ATOMIC);
-	rq = kmalloc (sizeof (struct request), GFP_ATOMIC);
-	buf = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
-	if (pc == NULL || rq == NULL || buf == NULL) {
+	pc = kzalloc(sizeof(idescsi_pc_t), GFP_ATOMIC);
+	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
+	buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
+	if (!pc || !rq || !buf) {
 		kfree(buf);
 		kfree(rq);
 		kfree(pc);
 		return -ENOMEM;
 	}
-	memset (pc, 0, sizeof (idescsi_pc_t));
-	memset (buf, 0, SCSI_SENSE_BUFFERSIZE);
 	ide_init_drive_cmd(rq);
 	rq->special = (char *) pc;
 	pc->rq = rq;
