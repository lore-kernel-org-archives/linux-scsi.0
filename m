From: Boaz Harrosh <bharrosh@panasas.com>
Subject: ABORT_TASK defined in aic94xx_sas.h
Date: Wed, 06 Feb 2008 15:38:33 +0200
Message-ID: <47A9B859.6020208@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:42246 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762378AbYBFNio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 08:38:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Luben Tuikov <luben_tuikov@adaptec.com>

include/scsi/scsi.h as a definition:
#define ABORT_TASK          0x0d

on the other hand drivers/scsi/aic94xx/aic94xx_sas.h has:
#define ABORT_TASK              0x03

am I right in thinking that aic94xx_sas.h is wrong in
polluting the global name-space?

If you ask me aic94xx_sas.h is a global name-space minefield

(This gives me problems when trying to pull in scsi_eh.h into
aic94xx source files)

perhaps:
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Wed, 6 Feb 2008 15:35:37 +0200
Subject: [PATCH] aic94xx_sas: avoid conflict with scsi.h

  drivers/scsi/aic94xx/aic94xx_sas.h would redefine ABORT_TASK
  as a different value.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/aic94xx/aic94xx_sas.h |    2 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sas.h b/drivers/scsi/aic94xx/aic94xx_sas.h
index fa7c529..912e6b7 100644
--- a/drivers/scsi/aic94xx/aic94xx_sas.h
+++ b/drivers/scsi/aic94xx/aic94xx_sas.h
@@ -292,7 +292,7 @@ struct scb_header {
 #define INITIATE_SSP_TASK       0x00
 #define INITIATE_LONG_SSP_TASK  0x01
 #define INITIATE_BIDIR_SSP_TASK 0x02
-#define ABORT_TASK              0x03
+#define SCB_ABORT_TASK          0x03
 #define INITIATE_SSP_TMF        0x04
 #define SSP_TARG_GET_DATA       0x05
 #define SSP_TARG_GET_DATA_GOOD  0x06
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 87b2f6e..b52124f 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -369,7 +369,7 @@ int asd_abort_task(struct sas_task *task)
 		return -ENOMEM;
 	scb = ascb->scb;
 
-	scb->header.opcode = ABORT_TASK;
+	scb->header.opcode = SCB_ABORT_TASK;
 
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SATA:
-- 
1.5.3.3

