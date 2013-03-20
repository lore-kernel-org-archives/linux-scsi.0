From: Shlomo Pongratz <shlomop@mellanox.com>
Subject: [PATCH] [SCSI] be2iscsi: fix reentrancy issue in be_iopoll
Date: Wed, 20 Mar 2013 11:09:55 +0200
Message-ID: <1363770595-16912-1-git-send-email-shlomop@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:45318 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808Ab3CTJKD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Mar 2013 05:10:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jayamohank@serverengines.com, michaelc@cs.wisc.edu, Shlomo Pongratz <shlomop@mellanox.com>

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
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 4e2733d..8efe216 100644
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
1.7.1

