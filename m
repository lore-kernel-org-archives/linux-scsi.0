From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 1/2] don't zero out sense_buffer in queuecommand
Date: Sun, 13 Jan 2008 15:46:12 +0900
Message-ID: <457feffcfc40101ad9884914d8f223cd425ee5b6.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:34216 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYAMGqV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jan 2008 01:46:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

LLDs don't need to zero out scsi_cmnd::sense_buffer in queuecommand
since scsi-ml does. This is a preparation of the future changes to
allocate the sense_buffer only when necessary.

Many LLDs zero out the sense_buffer before touching it on the error
case. This patch lets them alone for now because new APIs for them
would be added later on.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aic7xxx_old.c          |    1 -
 drivers/scsi/eata_pio.c             |    1 -
 drivers/scsi/ips.c                  |    3 ---
 drivers/scsi/libsas/sas_scsi_host.c |    1 -
 4 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 8f8db5f..2b402fa 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -10293,7 +10293,6 @@ static int aic7xxx_queue(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
   aic7xxx_position(cmd) = scb->hscb->tag;
   cmd->scsi_done = fn;
   cmd->result = DID_OK;
-  memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
   aic7xxx_error(cmd) = DID_OK;
   aic7xxx_status(cmd) = 0;
   cmd->host_scribble = NULL;
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 9579507..b5a6092 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -369,7 +369,6 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 	cp = &hd->ccb[y];
 
 	memset(cp, 0, sizeof(struct eata_ccb));
-	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
 
 	cp->status = USED;	/* claim free slot */
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index e54d30c..b1b2295 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2736,8 +2736,6 @@ ips_next(ips_ha_t * ha, int intr)
 		SC->result = DID_OK;
 		SC->host_scribble = NULL;
 
-		memset(SC->sense_buffer, 0, sizeof (SC->sense_buffer));
-
 		scb->target_id = SC->device->id;
 		scb->lun = SC->device->lun;
 		scb->bus = SC->device->channel;
@@ -3821,7 +3819,6 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 			/* attempted, a Check Condition occurred, and Sense   */
 			/* Data indicating an Invalid CDB OpCode is returned. */
 			sp = (char *) scb->scsi_cmd->sense_buffer;
-			memset(sp, 0, sizeof (scb->scsi_cmd->sense_buffer));
 
 			sp[0] = 0x70;	/* Error Code               */
 			sp[2] = ILLEGAL_REQUEST;	/* Sense Key 5 Illegal Req. */
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 828fed1..9c04225 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -148,7 +148,6 @@ static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
 	if (!task)
 		return NULL;
 
-	*(u32 *)cmd->sense_buffer = 0;
 	task->uldd_task = cmd;
 	ASSIGN_SAS_TASK(cmd, task);
 
-- 
1.5.3.4

