From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] sg: fix integer overflow
Date: Fri, 24 Jan 2014 11:34:33 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401241131380.12824@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaAXQes (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 11:34:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On alpha, USER_HZ may be higher than HZ. This results in integer overflow
in MULDIV.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/scsi/sg.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-3.13/drivers/scsi/sg.c
===================================================================
--- linux-3.13.orig/drivers/scsi/sg.c	2014-01-20 21:44:02.000000000 +0100
+++ linux-3.13/drivers/scsi/sg.c	2014-01-24 17:28:02.000000000 +0100
@@ -856,8 +856,10 @@ sg_ioctl(struct file *filp, unsigned int
 			return result;
 		if (val < 0)
 			return -EIO;
+#if USER_HZ < HZ
 		if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
 		    val = MULDIV (INT_MAX, USER_HZ, HZ);
+#endif
 		sfp->timeout_user = val;
 		sfp->timeout = MULDIV (val, HZ, USER_HZ);
 
