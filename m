From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 16/18] be2iscsi: Fix possible reentrancy issue in be_iopoll
Date: Fri,  5 Apr 2013 20:38:36 -0700
Message-ID: <1365219519-3457-16-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37477 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422656Ab3DFDjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:39:12 -0400
Received: by mail-pd0-f172.google.com with SMTP id 5so2303982pdd.31
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:39:11 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Shlomo Pongratz <shlomop@mellanox.com>

From: Shlomo Pongratz <shlomop@mellanox.com>

 The driver creates "NAPI" context per core which is fine,
 however the above routine declares the ret variable as static!
 Thus there is only one instance of this variable!
 When this routine is called from more than one thread of execution,
 than the result is unpredictable.

         static unsigned int ret;
         .....

         ret = beiscsi_process_cq(pbe_eq);
                 <--------Another thread can enter here and change "ret".
         if (ret < budget) {
                ....
         }
                 <--------Another thread can enter here and change "ret".
         return ret;

 Fix - remove the "static"

Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
Acked-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 672fdf6..39ac051 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2191,7 +2191,7 @@ void beiscsi_process_all_cqs(struct work_struct *work)
 
 static int be_iopoll(struct blk_iopoll *iop, int budget)
 {
-	static unsigned int ret;
+	unsigned int ret;
 	struct beiscsi_hba *phba;
 	struct be_eq_obj *pbe_eq;
 
-- 
1.7.10.4

