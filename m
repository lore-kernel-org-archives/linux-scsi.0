From: "Jayachandran C." <jchandra@digeo.com>
Subject: [PATCH] scsi: remove dead code from sr.c
Date: Tue, 18 Oct 2005 17:11:16 -0700
Message-ID: <20051019001116.GA5338@random.pao.digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from packet.digeo.com ([12.110.80.53]:56773 "EHLO packet.digeo.com")
	by vger.kernel.org with ESMTP id S932182AbVJSALm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2005 20:11:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org

This patch fixes an issue reported in drivers/scsi/sr.c by Coverity

Error reported: Pointer returned from "scsi_cd" is never used

Patch description:
 Remove the scsi_cd() call as it does not have any effect.

Signed-off-by: Jayachandran C. <c.jayachandran at gmail.com>
---

 sr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.13-rc4-git2.clean/drivers/scsi/sr.c	2005-10-13 11:42:33.000000000 -0700
+++ linux-2.6.13-rc4-git2.jc/drivers/scsi/sr.c	2005-10-14 15:28:32.961695641 -0700
@@ -455,7 +455,7 @@
 static int sr_block_open(struct inode *inode, struct file *file)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
+	struct scsi_cd *cd;
 	int ret = 0;
 
 	if(!(cd = scsi_cd_get(disk)))
