From: Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] scsi/osst.c: remove unncessary casting of kmalloc.
Date: Sat, 16 Jan 2010 09:15:38 -0500
Message-ID: <503939f4cfd0b8c362a2f5a103285f8dc330b99a.1263651173.git.tfransosi@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:57664 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab0APOP6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jan 2010 09:15:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Willem Riede <osst@riede.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Thiago Farina <tfransosi@gmail.com>, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/scsi/osst.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index acb8358..72d1e79 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5842,9 +5842,8 @@ static int osst_probe(struct device *dev)
 	/* if this is the first attach, build the infrastructure */
 	write_lock(&os_scsi_tapes_lock);
 	if (os_scsi_tapes == NULL) {
-		os_scsi_tapes =
-			(struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
-				   GFP_ATOMIC);
+		os_scsi_tapes = kmalloc(osst_max_dev * sizeof(struct osst_tape *),
+					GFP_ATOMIC);
 		if (os_scsi_tapes == NULL) {
 			write_unlock(&os_scsi_tapes_lock);
 			printk(KERN_ERR "osst :E: Unable to allocate array for OnStream SCSI tapes.\n");
@@ -5852,7 +5851,7 @@ static int osst_probe(struct device *dev)
 		}
 		for (i=0; i < osst_max_dev; ++i) os_scsi_tapes[i] = NULL;
 	}
-	
+
 	if (osst_nr_dev >= osst_max_dev) {
 		write_unlock(&os_scsi_tapes_lock);
 		printk(KERN_ERR "osst :E: Too many tape devices (max. %d).\n", osst_max_dev);
@@ -5917,7 +5916,7 @@ static int osst_probe(struct device *dev)
 	tpnt->os_fw_rev = osst_parse_firmware_rev (SDp->rev);
 	tpnt->omit_blklims = 1;
 
-	tpnt->poll = (strncmp(SDp->model, "DI-", 3) == 0) || 
+	tpnt->poll = (strncmp(SDp->model, "DI-", 3) == 0) ||
 		     (strncmp(SDp->model, "FW-", 3) == 0) || OSST_FW_NEED_POLL(tpnt->os_fw_rev,SDp);
 	tpnt->frame_in_buffer = 0;
 	tpnt->header_ok = 0;
-- 
1.6.6.103.g699d2

