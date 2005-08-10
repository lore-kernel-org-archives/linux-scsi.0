From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] remove name length check in a workqueue
Date: Wed, 10 Aug 2005 09:19:04 -0500
Message-ID: <1123683544.5093.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:41877 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965112AbVHJOTX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 10:19:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, mingo@redhat.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Ingo,

This has been in the workqueue code in day one, for no real reason that
I can see.  We just tripped over it in SCSI because the fibre channel
transport class creates one workqueue per host with the name scsi_wq_%d
which trips this after we get to 100.  Unfortunately we just came across
someone with > 100 host adapters ...

I think the solution is just to get rid of the artificial limit.

James

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -308,8 +308,6 @@ struct workqueue_struct *__create_workqu
 	struct workqueue_struct *wq;
 	struct task_struct *p;
 
-	BUG_ON(strlen(name) > 10);
-
 	wq = kmalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
 		return NULL;


