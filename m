From: domen@coderock.org
Subject: [patch 1/3] scsi/qla1280: replace schedule_timeout() with ssleep()
Date: Mon, 20 Jun 2005 23:55:07 +0200
Message-ID: <20050620215506.376578000@nd47.coderock.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:55962 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262091AbVFTWCZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 18:02:25 -0400
Content-Disposition: inline; filename=ssleep-drivers_scsi_qla1280.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, Nishanth Aravamudan <nacc@us.ibm.com>, domen@coderock.org

From: Nishanth Aravamudan <nacc@us.ibm.com>



Use ssleep() instead of schedule_timeout to guarantee the task
delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---
 qla1280.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: quilt/drivers/scsi/qla1280.c
===================================================================
--- quilt.orig/drivers/scsi/qla1280.c
+++ quilt/drivers/scsi/qla1280.c
@@ -2829,7 +2829,7 @@ qla1280_bus_reset(struct scsi_qla_host *
 		ha->bus_settings[bus].failed_reset_count++;
 	} else {
 		spin_unlock_irq(HOST_LOCK);
-		schedule_timeout(reset_delay * HZ);
+		ssleep(reset_delay);
 		spin_lock_irq(HOST_LOCK);
 
 		ha->bus_settings[bus].scsi_bus_dead = 0;

--
