From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] scsi: fix timer setup in fas216.c
Date: Thu, 18 Feb 2010 11:02:01 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1002181058140.4373@axis700.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33049 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755741Ab0BRKCE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 05:02:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, James.Bottomley@HansenPartnership.com

mod_timer() takes an absolute time and not a delay as its argument.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Not even compile-tested, but seems trivial enough...

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 4775426..9e71ac6 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2516,7 +2516,7 @@ int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 		if (info->scsi.phase == PHASE_IDLE)
 			fas216_kick(info);
 
-		mod_timer(&info->eh_timer, 30 * HZ);
+		mod_timer(&info->eh_timer, jiffies + 30 * HZ);
 		spin_unlock_irqrestore(&info->host_lock, flags);
 
 		/*
