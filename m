From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] aic79xx: NULL dereference in debug code
Date: Fri, 20 Jul 2012 14:30:57 +0300
Message-ID: <20120720113057.GC22245@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:26001 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2GTLbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2012 07:31:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

"ahd" can be NULL here and it gets dereferenced inside the call to
ahd_name().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 25417d0..5db8925 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -6120,7 +6120,8 @@ ahd_alloc(void *platform_arg, char *name)
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_MEMORY) != 0) {
 		printk("%s: scb size = 0x%x, hscb size = 0x%x\n",
-		       ahd_name(ahd), (u_int)sizeof(struct scb),
+		       ahd ? ahd_name(ahd) : "(null)",
+		       (u_int)sizeof(struct scb),
 		       (u_int)sizeof(struct hardware_scb));
 	}
 #endif
