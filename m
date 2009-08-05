From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 5/11] mpt2sas: [Resend] Attempt only 2 config_request retry.
Date: Wed, 5 Aug 2009 11:42:41 +0530
Message-ID: <20090805061241.GF13733@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og126.obsmtp.com ([64.18.2.206]:55525 "EHLO
	exprod7og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbZHEGdk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 02:33:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Attempt only 2 config_request retry.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 7e7843f..8fee5ff 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -236,7 +236,6 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	Mpi2ConfigRequest_t *config_request;
 	int r;
 	u8 retry_count;
-	u8 issue_reset;
 	u16 wait_state_count;
 
 	if (ioc->config_cmds.status != MPT2_CMD_NOT_USED) {
@@ -247,6 +246,12 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	retry_count = 0;
 
  retry_config:
+	if (retry_count) {
+		if (retry_count > 2) /* attempt only 2 retries */
+			return -EFAULT;
+		printk(MPT2SAS_INFO_FMT "%s: attempting retry (%d)\n",
+		    ioc->name, __func__, retry_count);
+	}
 	wait_state_count = 0;
 	ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
@@ -292,31 +297,23 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		    ioc->name, __func__);
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2ConfigRequest_t)/4);
-		if (!(ioc->config_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
-		goto issue_host_reset;
+		retry_count++;
+		if ((ioc->shost_recovery) ||
+		    (ioc->config_cmds.status & MPT2_CMD_RESET))
+			goto retry_config;
+		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+		    FORCE_BIG_HAMMER);
+		goto retry_config;
 	}
+
 	if (ioc->config_cmds.status & MPT2_CMD_REPLY_VALID)
 		memcpy(mpi_reply, ioc->config_cmds.reply,
 		    sizeof(Mpi2ConfigReply_t));
 	if (retry_count)
-		printk(MPT2SAS_INFO_FMT "%s: retry completed!!\n",
-		    ioc->name, __func__);
+		printk(MPT2SAS_INFO_FMT "%s: retry (%d) completed!!\n",
+		    ioc->name, __func__, retry_count);
 	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
 	return r;
-
- issue_host_reset:
-	if (issue_reset)
-		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
-	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
-	if (!retry_count) {
-		printk(MPT2SAS_INFO_FMT "%s: attempting retry\n",
-		    ioc->name, __func__);
-		retry_count++;
-		goto retry_config;
-	}
-	return -EFAULT;
 }
 
 /**
