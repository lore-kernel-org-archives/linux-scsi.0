From: domen@coderock.org
Subject: [patch 4/7] scsi/qla_os: replace schedule_timeout() with ssleep()
Date: Wed, 12 Jan 2005 00:22:57 +0100
Message-ID: <20050111232257.909231F226@trashy.coderock.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:30917 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262935AbVAKXXG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 18:23:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, nacc@us.ibm.com




Any comments would be, as always, appreciated.

-Nish

Description: Use ssleep() instead of schedule_timeout() to guarantee the
task delays as expected. Change the values of the constants being used
appropriately. I left the arithmetic there as it was before, even though
it could be easily simplified away.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/qla2xxx/qla_os.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~ssleep-drivers_scsi_qla2xxx_qla_os drivers/scsi/qla2xxx/qla_os.c
--- kj/drivers/scsi/qla2xxx/qla_os.c~ssleep-drivers_scsi_qla2xxx_qla_os	2005-01-10 18:00:26.000000000 +0100
+++ kj-domen/drivers/scsi/qla2xxx/qla_os.c	2005-01-10 18:00:26.000000000 +0100
@@ -885,8 +885,8 @@ qla2x00_queuecommand(struct scsi_cmnd *c
 static int
 qla2x00_eh_wait_on_command(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
 {
-#define ABORT_POLLING_PERIOD	HZ
-#define ABORT_WAIT_TIME		((10 * HZ) / (ABORT_POLLING_PERIOD))
+#define ABORT_POLLING_PERIOD	1000
+#define ABORT_WAIT_TIME		((10 * 1000) / ABORT_POLLING_PERIOD)
 
 	int		found = 0;
 	int		done = 0;
@@ -923,8 +923,7 @@ qla2x00_eh_wait_on_command(scsi_qla_host
 
 		spin_unlock_irq(ha->host->host_lock);
 
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(ABORT_POLLING_PERIOD);
+		msleep(ABORT_POLLING_PERIOD);
 
 		spin_lock_irq(ha->host->host_lock);
 
_
