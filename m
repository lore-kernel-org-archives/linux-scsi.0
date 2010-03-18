From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 09/12] mptfusion: Check for command status is added after completion.
Date: Thu, 18 Mar 2010 19:23:50 +0530
Message-ID: <20100318135339.GJ22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:49963 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748Ab0CROYx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:24:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

1) Corrected name string as "MPT SAS HOST"
2) Added proper check conditions for MPT_MGMT_STATUS_COMMAND_GOOD.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 493e0c0..dd10a82 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1893,7 +1893,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
 	.proc_info			= mptscsih_proc_info,
-	.name				= "MPT SPI Host",
+	.name				= "MPT SAS Host",
 	.info				= mptscsih_info,
 	.queuecommand			= mptsas_qcmd,
 	.target_alloc			= mptsas_target_alloc,
@@ -2037,11 +2037,13 @@ static int mptsas_phy_reset(struct sas_phy *phy, int hard_reset)
 
 	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done,
 			10 * HZ);
-	if (!timeleft) {
-		/* On timeout reset the board */
+	if (!(ioc->sas_mgmt.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		error = -ETIME;
 		mpt_free_msg_frame(ioc, mf);
-		mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
-		error = -ETIMEDOUT;
+		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out_unlock;
+		if (!timeleft)
+			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
 		goto out_unlock;
 	}
 
@@ -2222,11 +2224,14 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
 
 	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done, 10 * HZ);
-	if (!timeleft) {
-		printk(MYIOC_s_ERR_FMT "%s: smp timeout!\n", ioc->name, __func__);
-		/* On timeout reset the board */
-		mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
-		ret = -ETIMEDOUT;
+	if (!(ioc->sas_mgmt.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		mpt_free_msg_frame(ioc, mf);
+		mf = NULL;
+		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto unmap;
+		if (!timeleft)
+			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
 		goto unmap;
 	}
 	mf = NULL;
@@ -4097,6 +4102,7 @@ mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	cfg.pageAddr = (channel << 8) + id;
 	cfg.cfghdr.hdr = &hdr;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.timeout = SAS_CONFIG_PAGE_TIMEOUT;
 
 	if (mpt_config(ioc, &cfg) != 0)
 		goto out;
