From: "Robert T. Johnson" <rtjohnso@eecs.berkeley.edu>
Subject: PATCH: 2.6.7-rc3 drivers/scsi/megaraid.c: user/kernel pointer bugs
Date: 09 Jun 2004 16:14:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086822884.32057.143.camel@dooby.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.EECS.Berkeley.EDU ([169.229.60.28]:44932 "EHLO
	relay2.EECS.Berkeley.EDU") by vger.kernel.org with ESMTP
	id S265889AbUFIXOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2004 19:14:45 -0400
Received: from relay3.EECS.Berkeley.EDU (localhost [127.0.0.1])
	by relay2.EECS.Berkeley.EDU (8.12.10/8.9.3) with ESMTP id i59NEiVe000806
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2004 16:14:44 -0700 (PDT)
Received: from localhost.localdomain (dooby.CS.Berkeley.EDU [128.32.35.171])
	by relay3.EECS.Berkeley.EDU (8.12.10/8.9.3) with ESMTP id i59NEiFp009312
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2004 16:14:44 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI developers <linux-scsi@vger.kernel.org>

Since arg is a user pointer, so are uioc_mimd and uiocp, and hence umc is 
a user pointer.  Thus reading umc->xferaddr requires dereferencing a user 
pointer, which isn't safe.  Let me know if you have any questions or I've
made an error.

Best,
Rob

P.S. megaraid.c still lists linux-megaraid-devel@dell.com as the updates
address, even though the list has been discontinued.

--- linux-2.6.7-rc3-full/drivers/scsi/megaraid.c.orig	Wed Jun  9 12:43:49 2004
+++ linux-2.6.7-rc3-full/drivers/scsi/megaraid.c	Wed Jun  9 12:43:10 2004
@@ -3815,7 +3815,8 @@ mega_n_to_m(void *arg, megacmd_t *mc)
 
 			umc = MBOX_P(uiocp);
 
-			upthru = (mega_passthru *)umc->xferaddr;
+			if (get_user(upthru, (mega_passthru **)&umc->xferaddr))
+				return (-EFAULT);
 
 			if( put_user(mc->status, (u8 *)&upthru->scsistatus) )
 				return (-EFAULT);
@@ -3831,7 +3832,8 @@ mega_n_to_m(void *arg, megacmd_t *mc)
 
 			umc = (megacmd_t *)uioc_mimd->mbox;
 
-			upthru = (mega_passthru *)umc->xferaddr;
+			if (get_user(upthru, (mega_passthru **)&umc->xferaddr))
+				return (-EFAULT);
 
 			if( put_user(mc->status, (u8 *)&upthru->scsistatus) )
 				return (-EFAULT);




