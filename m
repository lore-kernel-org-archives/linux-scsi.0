From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/6] qla2xxx: Correct truncation in return-code status checking.
Date: Thu,  5 Mar 2009 11:07:03 -0800
Message-ID: <1236280025-89526-5-git-send-email-andrew.vasquez@qlogic.com>
References: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5602 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZCETHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 14:07:09 -0500
In-Reply-To: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

QLA_* return codes are 'int' in size.  There were still several
legacy check-points which assumed a return-code width of 8-bits.
This could cause incorrect assumptions of 'good' status if a
return of QLA_FUNCTION_TIMEOUT.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e54ab2f..87f9abc 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3435,7 +3435,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 static int
 qla2x00_restart_isp(scsi_qla_host_t *vha)
 {
-	uint8_t		status = 0;
+	int status = 0;
 	uint32_t wait_time;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2f5f725..16c3476 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2568,7 +2568,7 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 void qla2x00_relogin(struct scsi_qla_host *vha)
 {
 	fc_port_t       *fcport;
-	uint8_t         status;
+	int status;
 	uint16_t        next_loopid = 0;
 	struct qla_hw_data *ha = vha->hw;
 
-- 
1.6.2.rc0.55.g30aa4f

