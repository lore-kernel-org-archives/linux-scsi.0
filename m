From: domen@coderock.org
Subject: [patch 03/11] scsi/qla1280: replace schedule_timeout() with ssleep()
Date: Sun, 06 Mar 2005 23:26:57 +0100
Message-ID: <20050306222657.683C91ED3D@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:50862 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261524AbVCFW1D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:27:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, nacc@us.ibm.com



Use ssleep() instead of schedule_timeout to guarantee the task
delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/qla1280.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/qla1280.c~ssleep-drivers_scsi_qla1280 drivers/scsi/qla1280.c
--- kj/drivers/scsi/qla1280.c~ssleep-drivers_scsi_qla1280	2005-03-05 16:11:17.000000000 +0100
+++ kj-domen/drivers/scsi/qla1280.c	2005-03-05 16:11:17.000000000 +0100
@@ -2939,7 +2939,7 @@ qla1280_bus_reset(struct scsi_qla_host *
 		ha->bus_settings[bus].failed_reset_count++;
 	} else {
 		spin_unlock_irq(HOST_LOCK);
-		schedule_timeout(reset_delay * HZ);
+		ssleep(reset_delay);
 		spin_lock_irq(HOST_LOCK);
 
 		ha->bus_settings[bus].scsi_bus_dead = 0;
_
