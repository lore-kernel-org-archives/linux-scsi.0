From: Bo Liu <bo-liu@hotmail.com>
Subject: ata1: failed to reset engine (errno=-95)
Date: Tue, 14 Jul 2009 11:56:55 +0800
Message-ID: <COL115-W38B10F5E215313909FF9799F230@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from col0-omc4-s2.col0.hotmail.com ([65.55.34.204]:25042 "EHLO
	col0-omc4-s2.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbZGNECK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2009 00:02:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi, ALL
 
      I patch these code for my 2.6.23 kernel.
 
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1142,12 +1142,15 @@ static int ahci_reset_controller(struct ata_host *host)
                        readl(mmio + HOST_CTL); /* flush */
                }
 
-               /* reset must complete within 1 second, or
+               /*
+                * to perform host reset, OS should set HOST_RESET
+                * and poll until this bit is read to be "0".
+                * reset must complete within 1 second, or
                 * the hardware should be considered fried.
                 */
-               ssleep(1);
+               tmp = ata_wait_register(mmio + HOST_CTL, HOST_RESET,
+                                       HOST_RESET, 10, 1000);
 
-               tmp = readl(mmio + HOST_CTL);
                if (tmp & HOST_RESET) {
                        dev_printk(KERN_ERR, host->dev,
                                   "controller reset failed (0x%x)\n", tmp);

 
      Then everything is ok, except the below error:
      "ata1: failed to reset engine (errno=-95)."  
 
      Is someone know the reason? I think maybe i must patch more patches.But I don't know which.
         
      Thank you very much!

---

Best regards


Bo Liu
_________________________________________________________________
Invite your mail contacts to join your friends list with Windows Live Spaces. It's easy!
http://spaces.live.com/spacesapi.aspx?wx_action=create&wx_url=/friends.aspx&mkt=en-us
