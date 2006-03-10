From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] scsi/megaraid/megaraid_mm.c: fix a NULL pointer dereference
Date: Fri, 10 Mar 2006 23:24:55 +0100
Message-ID: <20060310222455.GY21864@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:11780 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1752198AbWCJWY4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 17:24:56 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela.Kolli@engenio.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org

This patch fixes a NULL pointer dereference spotted by the Coverity 
checker.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.16-rc5-mm3-full/drivers/scsi/megaraid/megaraid_mm.c.old	2006-03-10 20:45:36.000000000 +0100
+++ linux-2.6.16-rc5-mm3-full/drivers/scsi/megaraid/megaraid_mm.c	2006-03-10 20:46:04.000000000 +0100
@@ -898,10 +898,8 @@ mraid_mm_register_adp(mraid_mmadp_t *lld
 
 	adapter = kmalloc(sizeof(mraid_mmadp_t), GFP_KERNEL);
 
-	if (!adapter) {
-		rval = -ENOMEM;
-		goto memalloc_error;
-	}
+	if (!adapter)
+		return -ENOMEM;
 
 	memset(adapter, 0, sizeof(mraid_mmadp_t));
 

