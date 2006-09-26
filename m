From: David Brownell <david-b@pacbell.net>
Subject: fix compile-time divide-by-zero in scsi_ioctl
Date: Tue, 26 Sep 2006 08:48:48 -0700
Message-ID: <20060926154848.CFDC63DAF7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:61023 "HELO
	smtp104.sbc.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1030752AbWI0UQP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 16:16:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This fixes a compiler-reported divide-by-zero when HZ < 100.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Index: at91/block/scsi_ioctl.c
===================================================================
--- at91.orig/block/scsi_ioctl.c	2006-07-30 01:17:34.000000000 -0700
+++ at91/block/scsi_ioctl.c	2006-07-30 01:44:17.000000000 -0700
@@ -63,7 +63,7 @@ static int scsi_get_bus(request_queue_t 
 
 static int sg_get_timeout(request_queue_t *q)
 {
-	return q->sg_timeout / (HZ / USER_HZ);
+	return q->sg_timeout / max(1,(HZ / USER_HZ));
 }
 
 static int sg_set_timeout(request_queue_t *q, int __user *p)
