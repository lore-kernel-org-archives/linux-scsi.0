From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: [PATCH][RFC]skip_settle_delay support for MPT fusion driver
Date: Tue, 02 Nov 2004 15:24:51 +0900
Message-ID: <200411020624.AA03729@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:2237 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S286506AbUKBGZo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2004 01:25:44 -0500
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72]) by fgwmail6.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id iA26PgqK005991 for <linux-scsi@vger.kernel.org>; Tue, 2 Nov 2004 15:25:42 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s0.gw.fujitsu.co.jp by m2.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id iA26Pgf1017333 for <linux-scsi@vger.kernel.org>; Tue, 2 Nov 2004 15:25:42 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s0.gw.fujitsu.co.jp (s0 [127.0.0.1])
	by s0.gw.fujitsu.co.jp (Postfix) with ESMTP id 46A1EA7D06
	for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2004 15:25:42 +0900 (JST)
Received: from fjmail505.fjmail.jp.fujitsu.com (fjmail505-0.fjmail.jp.fujitsu.com [10.59.80.104])
	by s0.gw.fujitsu.co.jp (Postfix) with ESMTP id E2347A7D04
	for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2004 15:25:41 +0900 (JST)
Received: from fukuchi.jp.fujitsu.com
 (fjscan501-0.fjmail.jp.fujitsu.com [10.59.80.120])
 by fjmail505.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0I6J00CJBGISQC@fjmail505.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Tue,  2 Nov 2004 15:25:40 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com, linux-scsi@vger.kernel.org

Eric,

This patch supports skip_settle_delay flag to skip 10 seconds sleep
at bus reset sequence.

Thanks,
M.Fukuchi

diff -uarN linux-2.6.9/drivers/message/fusion/mptscsih.c linux-2.6.9-
reset/drivers/message/fusion/mptscsih.c
--- linux-2.6.9/drivers/message/fusion/mptscsih.c	2004-10-19 06:55:36.000000000 +0900
+++ linux-2.6.9-reset/drivers/message/fusion/mptscsih.c	2004-11-02 14:56:02.254776796 +0900
@@ -2510,6 +2510,8 @@
 {
 	MPT_SCSI_HOST	*hd;
 	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
+	int             loop_count = 10 * 4; /* Wait 10 seconds */
+	unsigned long   flags;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -2543,7 +2545,18 @@
 		spin_lock_irq(host_lock);
 		return FAILED;
 	}
+	do {
+		spin_lock_irqsave(&hd->ioc->FreeQlock, flags);
+		if (hd->tmState == TM_STATE_NONE) {
+			spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
+		msleep(250);
+	} while (--loop_count);
 	spin_lock_irq(host_lock);
+	if (loop_count == 0)
+		return FAILED;
 	return SUCCESS;
 }
 
@@ -3322,6 +3335,7 @@
 	.max_sectors			= 8192,
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.skip_settle_delay		= 1,
 };
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
