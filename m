From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] scsi/dmx3191d.c: fix a NULL pointer dereference
Date: Fri, 10 Mar 2006 23:24:21 +0100
Message-ID: <20060310222421.GW21864@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752075AbWCJWYW@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch fixes a NULL pointer dereference spotted by the Coverity 
checker.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.16-rc5-mm3-full/drivers/scsi/dmx3191d.c.old	2006-03-10 20:37:24.000000000 +0100
+++ linux-2.6.16-rc5-mm3-full/drivers/scsi/dmx3191d.c	2006-03-10 20:37:40.000000000 +0100
@@ -116,7 +116,7 @@ static int __devinit dmx3191d_probe_one(
  out_free_irq:
 	free_irq(shost->irq, shost);
  out_release_region:
-	release_region(shost->io_port, DMX3191D_REGION_LEN);
+	release_region(io, DMX3191D_REGION_LEN);
  out_disable_device:
 	pci_disable_device(pdev);
  out:
