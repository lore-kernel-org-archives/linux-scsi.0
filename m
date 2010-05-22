From: Dan Carpenter <error27@gmail.com>
Subject: [patch] scsi/qla2xxx: fix end of loop test
Date: Sat, 22 May 2010 22:37:48 +0200
Message-ID: <20100522203748.GT22515@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60865 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab0EVUiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2010 16:38:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The "fcport" variable is never null here.  I've updated the condition to
test for the end of the list_for_each_entry() loop.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index b905dfe..14ca275 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1050,7 +1050,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		break;
 	}
 
-	if (!fcport) {
+	if (&fcport->list == &vha->vp_fcports) {
 		DEBUG2(printk(KERN_ERR "%s(%ld): Failed to find port\n",
 			__func__, vha->host_no));
 		return -EINVAL;
