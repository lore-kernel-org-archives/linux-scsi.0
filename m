From: Akinobu Mita <amgta@yacht.ocn.ne.jp>
Subject: [PATCH] fix possible race with scsi command pool
Date: Sat, 22 Jan 2005 18:57:55 +0900
Message-ID: <200501221857.55116.amgta@yacht.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yacht.ocn.ne.jp ([222.146.40.168]:38339 "EHLO
	smtp.yacht.ocn.ne.jp") by vger.kernel.org with ESMTP
	id S262687AbVAVJzN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Jan 2005 04:55:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Hello!

There is a place where the reference count of scsi_host_cmd_pool is
incremented without acquiring host_cmd_pool_mutex.

Signed-off-by: Akinobu Mita <amgta@yacht.ocn.ne.jp>

--- 2.6-mm/drivers/scsi/scsi.c.orig	2005-01-20 22:40:20.000000000 +0900
+++ 2.6-mm/drivers/scsi/scsi.c	2005-01-20 22:41:16.000000000 +0900
@@ -360,9 +360,9 @@ int scsi_setup_command_freelist(struct S
 	return 0;
 
  fail2:
+	down(&host_cmd_pool_mutex);
 	if (!--pool->users)
 		kmem_cache_destroy(pool->slab);
-	return -ENOMEM;
  fail:
 	up(&host_cmd_pool_mutex);
 	return -ENOMEM;


