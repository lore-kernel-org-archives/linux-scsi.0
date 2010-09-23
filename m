From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 7/7] qla2xxx: hook scsi eh into fc_block_scsi_eh
Date: Thu, 23 Sep 2010 00:17:25 -0500
Message-ID: <1285219045-14645-8-git-send-email-michaelc@cs.wisc.edu>
References: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab0IWFLp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 01:11:45 -0400
In-Reply-To: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

qla2xxx is calling fc_block_scsi_eh, but it is not passing
up TRANSPORT_FAILED if returned.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla2xxx/qla_os.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bdd53f0..7523041 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -834,7 +834,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	srb_t *spt;
 	int got_ref = 0;
 
-	fc_block_scsi_eh(cmd);
+	ret = fc_block_scsi_eh(cmd);
+	if (ret)
+		return ret;
 
 	if (!CMD_SP(cmd))
 		return SUCCESS;
@@ -964,9 +966,11 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
-	int err;
+	int err, ret;
 
-	fc_block_scsi_eh(cmd);
+	ret = fc_block_scsi_eh(cmd);
+	if (ret)
+		return ret;
 
 	if (!fcport)
 		return FAILED;
@@ -1045,7 +1049,10 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	unsigned int id, lun;
 	unsigned long serial;
 
-	fc_block_scsi_eh(cmd);
+	ret = fc_block_scsi_eh(cmd);
+	if (ret)
+		return ret;
+	ret = FAILED;
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
@@ -1107,7 +1114,10 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	unsigned long serial;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	fc_block_scsi_eh(cmd);
+	ret = fc_block_scsi_eh(cmd);
+	if (ret)
+		return ret;
+	ret = FAILED;
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
-- 
1.7.2.2

