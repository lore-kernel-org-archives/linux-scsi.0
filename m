From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] sg: fix overflow in timeout calculation
Date: Mon, 9 Feb 2015 13:45:35 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502091343310.23787@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbbBISpj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2015 13:45:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org

USER_HZ may be greater than HZ and in that case arithmetics tries to
calculate the maximum accepted timeout overflows. We need to use INT_MAX
in this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/scsi/sg.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-3.17-rc6/drivers/scsi/sg.c
===================================================================
--- linux-3.17-rc6.orig/drivers/scsi/sg.c	2014-09-26 20:10:22.000000000 +0200
+++ linux-3.17-rc6/drivers/scsi/sg.c	2014-09-26 20:10:50.000000000 +0200
@@ -90,6 +90,12 @@ static void sg_proc_cleanup(void);
  */
 #define MULDIV(X,MUL,DIV) ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL))
 
+#if USER_HZ < HZ
+#define MAX_USER_TIMEOUT MULDIV (INT_MAX, USER_HZ, HZ)
+#else
+#define MAX_USER_TIMEOUT INT_MAX
+#endif
+
 #define SG_DEFAULT_TIMEOUT MULDIV(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 
 int sg_big_buff = SG_DEF_RESERVED_SIZE;
@@ -892,8 +898,8 @@ sg_ioctl(struct file *filp, unsigned int
 			return result;
 		if (val < 0)
 			return -EIO;
-		if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
-		    val = MULDIV (INT_MAX, USER_HZ, HZ);
+		if (val >= MAX_USER_TIMEOUT)
+		    val = MAX_USER_TIMEOUT;
 		sfp->timeout_user = val;
 		sfp->timeout = MULDIV (val, HZ, USER_HZ);
 
