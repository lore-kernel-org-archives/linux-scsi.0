From: akpm@osdl.org
Subject: [patch 1/5] scsi: remove dead code from sr.c
Date: Fri, 28 Oct 2005 15:07:49 -0700
Message-ID: <200510282207.j9SM7VQ0022249@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:45238 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030262AbVJ1WHh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 18:07:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, c.jayachandran@gmail.com


From: "Jayachandran C." <c.jayachandran@gmail.com>

This patch fixes an issue reported in drivers/scsi/sr.c by Coverity

Error reported: Pointer returned from "scsi_cd" is never used

Patch description:
 Remove the scsi_cd() call as it does not have any effect.

Signed-off-by: Jayachandran C. <c.jayachandran@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sr.c~scsi-remove-dead-code-from-src drivers/scsi/sr.c
--- 25/drivers/scsi/sr.c~scsi-remove-dead-code-from-src	Fri Oct 28 15:05:56 2005
+++ 25-akpm/drivers/scsi/sr.c	Fri Oct 28 15:05:56 2005
@@ -455,7 +455,7 @@ queue:
 static int sr_block_open(struct inode *inode, struct file *file)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
+	struct scsi_cd *cd;
 	int ret = 0;
 
 	if(!(cd = scsi_cd_get(disk)))
_
