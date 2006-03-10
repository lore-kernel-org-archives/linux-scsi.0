From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/sim710.c: fix a NULL pointer dereference
Date: Fri, 10 Mar 2006 23:25:00 +0100
Message-ID: <20060310222500.GZ21864@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:12804 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1752197AbWCJWZB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 17:25:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes a NULL pointer dereference spotted by the Coverity 
checker.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.16-rc5-mm3-full/drivers/scsi/sim710.c.old	2006-03-10 20:48:32.000000000 +0100
+++ linux-2.6.16-rc5-mm3-full/drivers/scsi/sim710.c	2006-03-10 20:49:24.000000000 +0100
@@ -146,7 +146,7 @@ sim710_probe_common(struct device *dev, 
  out_put_host:
 	scsi_host_put(host);
  out_release:
-	release_region(host->base, 64);
+	release_region(base_addr, 64);
  out_free:
 	kfree(hostdata);
  out:

