From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove an escaped __MOD_DEC_USE_COUNT
Date: Thu, 20 Feb 2003 20:48:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030220204800.A19547@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

we should be using module_put really, __MOD_DEC_USE_COUNT will die soon

--- 1.9/drivers/scsi/pluto.c	Tue Feb  4 12:55:10 2003
+++ edited/drivers/scsi/pluto.c	Thu Feb 20 19:26:15 2003
@@ -287,7 +287,7 @@
 	struct pluto *pluto = (struct pluto *)host->hostdata;
 	fc_channel *fc = pluto->fc;
 
-	if (fc->module) __MOD_DEC_USE_COUNT(fc->module);
+	module_put(fc->module);
 	
 	fc->fcp_register(fc, TYPE_SCSI_FCP, 1);
 	PLND((" releasing pluto.\n"));
