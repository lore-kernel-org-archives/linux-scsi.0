From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH 19/30] scsi: Remove explicit casts of [kv]alloc return values in osst driver
Date: Fri, 24 Aug 2007 02:12:57 +0200
Message-ID: <aaed77aa8511322bc32b406a952c7c960091ff3b.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:12042 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865AbXHXAPv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Aug 2007 20:15:51 -0400
Received: by fk-out-0910.google.com with SMTP id z23so556324fkz
        for <linux-scsi@vger.kernel.org>; Thu, 23 Aug 2007 17:15:49 -0700 (PDT)
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Willem Riede <osst@riede.org>, osst-users@lists.sourceforge.net, Jesper Juhl <jesper.juhl@gmail.com>

[kv]alloc() return void *. No need to cast the return value.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/scsi/osst.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 08060fb..3ad9d49 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -1404,7 +1404,7 @@ static int osst_read_back_buffer_and_rewrite(struct osst_tape * STp, struct osst
 	int			dbg              = debugging;
 #endif
 
-	if ((buffer = (unsigned char *)vmalloc((nframes + 1) * OS_DATA_SIZE)) == NULL)
+	if ((buffer = vmalloc((nframes + 1) * OS_DATA_SIZE)) == NULL)
 		return (-EIO);
 
 	printk(KERN_INFO "%s:I: Reading back %d frames from drive buffer%s\n",
@@ -2216,7 +2216,7 @@ static int osst_write_header(struct osst_tape * STp, struct osst_request ** aSRp
 	if (STp->raw) return 0;
 
 	if (STp->header_cache == NULL) {
-		if ((STp->header_cache = (os_header_t *)vmalloc(sizeof(os_header_t))) == NULL) {
+		if ((STp->header_cache = vmalloc(sizeof(os_header_t))) == NULL) {
 			printk(KERN_ERR "%s:E: Failed to allocate header cache\n", name);
 			return (-ENOMEM);
 		}
@@ -2404,7 +2404,7 @@ static int __osst_analyze_headers(struct osst_tape * STp, struct osst_request **
 				   name, ppos, update_frame_cntr);
 #endif
 		if (STp->header_cache == NULL) {
-			if ((STp->header_cache = (os_header_t *)vmalloc(sizeof(os_header_t))) == NULL) {
+			if ((STp->header_cache = vmalloc(sizeof(os_header_t))) == NULL) {
 				printk(KERN_ERR "%s:E: Failed to allocate header cache\n", name);
 				return 0;
 			}
@@ -5756,7 +5756,7 @@ static int osst_probe(struct device *dev)
 	write_lock(&os_scsi_tapes_lock);
 	if (os_scsi_tapes == NULL) {
 		os_scsi_tapes =
-			(struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
+			kmalloc(osst_max_dev * sizeof(struct osst_tape *),
 				   GFP_ATOMIC);
 		if (os_scsi_tapes == NULL) {
 			write_unlock(&os_scsi_tapes_lock);
-- 
1.5.2.2

