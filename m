From: janitor@sternwelten.at
Subject: [patch 1/7]  scsi/mesh: replace schedule_timeout() 	with msleep()
Date: Wed, 01 Sep 2004 21:54:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2bBr-0005pP-9L@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:47545 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267515AbUIATyo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 15:54:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at







I would appreciate any comments from the janitor@sternweltens list. 



Description: Use msleep() instead of schedule_timeout() to 
guarantee the task delays for the desired time.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/mesh.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/mesh.c~msleep-drivers_scsi_mesh drivers/scsi/mesh.c
--- linux-2.6.9-rc1-bk7/drivers/scsi/mesh.c~msleep-drivers_scsi_mesh	2004-09-01 19:35:45.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/mesh.c	2004-09-01 19:35:45.000000000 +0200
@@ -388,8 +388,7 @@ static void mesh_init(struct mesh_state 
 		mesh_flush_io(mr);
 
 		/* Wait for bus to come back */
-		current->state = TASK_UNINTERRUPTIBLE;
-		schedule_timeout((init_reset_delay * HZ) / 1000);
+		msleep(init_reset_delay);
 	}
 	
 	/* Reconfigure controller */
@@ -1749,12 +1748,10 @@ static void set_mesh_power(struct mesh_s
 		return;
 	if (state) {
 		pmac_call_feature(PMAC_FTR_MESH_ENABLE, macio_get_of_node(ms->mdev), 0, 1);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ/5);
+		msleep(200);
 	} else {
 		pmac_call_feature(PMAC_FTR_MESH_ENABLE, macio_get_of_node(ms->mdev), 0, 0);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ/100);
+		msleep(10);
 	}
 }			
 
@@ -1772,8 +1769,7 @@ static int mesh_suspend(struct macio_dev
 	spin_lock_irqsave(ms->host->host_lock, flags);
 	while(ms->phase != idle) {
 		spin_unlock_irqrestore(ms->host->host_lock, flags);
-		current->state = TASK_UNINTERRUPTIBLE;
-		schedule_timeout(HZ/100);
+		msleep(10);
 		spin_lock_irqsave(ms->host->host_lock, flags);
 	}
 	ms->phase = sleeping;

_
