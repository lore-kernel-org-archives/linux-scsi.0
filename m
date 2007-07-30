From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/imm.c: fix check-after-use
Date: Tue, 31 Jul 2007 00:28:19 +0200
Message-ID: <20070730222819.GF3972@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54344 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S969396AbXG3W2k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 18:28:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The Coverity checker spotted that we have already oops'ed if "cmd"
was NULL.

Since "cmd" being NULL doesn't seem to be possible at this point this 
patch removes the NULL check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

--- linux-2.6.23-rc1-mm1/drivers/scsi/imm.c.old	2007-07-30 13:58:00.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/scsi/imm.c	2007-07-30 13:58:24.000000000 +0200
@@ -740,10 +740,6 @@ static void imm_interrupt(struct work_st
 	struct Scsi_Host *host = cmd->device->host;
 	unsigned long flags;
 
-	if (!cmd) {
-		printk("IMM: bug in imm_interrupt\n");
-		return;
-	}
 	if (imm_engine(dev, cmd)) {
 		schedule_delayed_work(&dev->imm_tq, 1);
 		return;
