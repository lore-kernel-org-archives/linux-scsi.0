From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/NCR_D700.c: fix a NULL dereference
Date: Fri, 10 Mar 2006 23:24:08 +0100
Message-ID: <20060310222408.GV21864@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:8708 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1751978AbWCJWYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 17:24:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The Coverity checker spotted this NULL dereference.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.16-rc5-mm3-full/drivers/scsi/NCR_D700.c.old	2006-03-10 20:25:29.000000000 +0100
+++ linux-2.6.16-rc5-mm3-full/drivers/scsi/NCR_D700.c	2006-03-10 20:25:45.000000000 +0100
@@ -206,31 +206,31 @@ NCR_D700_probe_one(struct NCR_D700_priva
 	if (!host) {
 		ret = -ENOMEM;
 		goto detect_failed;
 	}
 
 	p->hosts[siop] = host;
 	/* FIXME: read this from SUS */
 	host->this_id = id_array[slot * 2 + siop];
 	host->irq = irq;
 	host->base = region;
 	scsi_scan_host(host);
 
 	return 0;
 
  detect_failed:
-	release_region(host->base, 64);
+	release_region(region, 64);
  region_failed:
 	kfree(hostdata);
 
 	return ret;
 }
 
 static int
 NCR_D700_intr(int irq, void *data, struct pt_regs *regs)
 {
 	struct NCR_D700_private *p = (struct NCR_D700_private *)data;
 	int i, found = 0;
 
 	for (i = 0; i < 2; i++)
 		if (p->hosts[i] &&
 		    NCR_700_intr(irq, p->hosts[i], regs) == IRQ_HANDLED)

