From: Thomas Gleixner <tglx@linutronix.de>
Subject: scsi/fcoe: Fix preempt count leak in fcoe_filter_frames()
Date: Fri, 11 Nov 2011 20:52:01 +0100 (CET)
Message-ID: <alpine.LFD.2.02.1111112049370.2694@ionos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:35234 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab1KKTwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2011 14:52:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>

The error exit path leaks preempt count. Add the missing put_cpu().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index cefbe44..f3f440c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1624,6 +1624,7 @@ static inline int fcoe_filter_frames(struct fc_lport *lport,
 	stats->InvalidCRCCount++;
 	if (stats->InvalidCRCCount < 5)
 		printk(KERN_WARNING "fcoe: dropping frame with CRC error\n");
+	put_cpu();
 	return -EINVAL;
 }
 
