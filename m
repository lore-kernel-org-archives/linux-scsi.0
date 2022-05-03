Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BF6C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbiECULW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbiECUKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F368C26AEB
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 80D7421882;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUW4iJfuyEoe7uHxRk74VPFf3NmtImIJ0notDLIYzb0=;
        b=ZbgskNfbYSdkJ3C/w5YnQ1OsqYkqL+KpfMOpAkjhL+9rA7NVFBcLa7+flfrCGztRcgKOyn
        Tm8ixKmR9DP/LUFgjpvLThv92jxsEndgHL6zimxLOpBoCPH1e+RMOdmasH6qjyqresEmY/
        v7QnBJ5wHiSFRQoJb/ofnd7KwNgOdEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUW4iJfuyEoe7uHxRk74VPFf3NmtImIJ0notDLIYzb0=;
        b=pAd9LHPUH41EfTsFDZpkVRpxx+06Z1bgQasc00LUEueOFfzigBOEWPn83lxZqK9HyrOstk
        TuHYuzJQ1jsjpwCQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 658622C175;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 73D5B51941F6; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 24/24] mpi3mr: split off bus_reset function from host_reset
Date:   Tue,  3 May 2022 22:07:04 +0200
Message-Id: <20220503200704.88003-25-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI EH host reset is the final callback in the escalation chain;
once we reach this we need to reset the controller.
As such it defeats the purpose to skip controller reset if no
I/Os are pending and the RAID device is to be reset; especially
after kexec there might be stale commands pending in firmware
for which we have no reference whatsoever.
So this patch splits off the check for pending I/O into a
'bus_reset' function, and leaves the actual controller reset
to the host reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 57 +++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index f7cd70a15ea6..31f05e9f5ee0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3337,20 +3337,45 @@ void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout)
  * mpi3mr_eh_host_reset - Host reset error handling callback
  * @scmd: SCSI command reference
  *
- * Issue controller reset if the scmd is for a Physical Device,
- * if the scmd is for RAID volume, then wait for
- * MPI3MR_RAID_ERRREC_RESET_TIMEOUT and checke whether any
- * pending I/Os prior to issuing reset to the controller.
+ * Issue controller reset
  *
  * Return: SUCCESS of successful reset else FAILED
  */
 static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
+{
+	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	int retval = FAILED, ret;
+
+	ret = mpi3mr_soft_reset_handler(mrioc,
+	    MPI3MR_RESET_FROM_EH_HOS, 1);
+	if (ret)
+		goto out;
+
+	retval = SUCCESS;
+out:
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Host reset is %s for scmd(%p)\n",
+	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+
+	return retval;
+}
+
+/**
+ * mpi3mr_eh_bus_reset - Bus reset error handling callback
+ * @scmd: SCSI command reference
+ *
+ * Checks whether pending I/Os are present for the RAID volume;
+ * if not there's no need to reset the adapter.
+ *
+ * Return: SUCCESS of successful reset else FAILED
+ */
+static int mpi3mr_eh_bus_reset(struct scsi_cmnd *scmd)
 {
 	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
 	struct mpi3mr_stgt_priv_data *stgt_priv_data;
 	struct mpi3mr_sdev_priv_data *sdev_priv_data;
 	u8 dev_type = MPI3_DEVICE_DEVFORM_VD;
-	int retval = FAILED, ret;
+	int retval = FAILED;
 
 	sdev_priv_data = scmd->device->hostdata;
 	if (sdev_priv_data && sdev_priv_data->tgt_priv_data) {
@@ -3360,25 +3385,16 @@ static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
 
 	if (dev_type == MPI3_DEVICE_DEVFORM_VD) {
 		mpi3mr_wait_for_host_io(mrioc,
-		    MPI3MR_RAID_ERRREC_RESET_TIMEOUT);
-		if (!mpi3mr_get_fw_pending_ios(mrioc)) {
+			MPI3MR_RAID_ERRREC_RESET_TIMEOUT);
+		if (!mpi3mr_get_fw_pending_ios(mrioc))
 			retval = SUCCESS;
-			goto out;
-		}
 	}
+	if (retval == FAILED)
+		mpi3mr_print_pending_host_io(mrioc);
 
-	mpi3mr_print_pending_host_io(mrioc);
-	ret = mpi3mr_soft_reset_handler(mrioc,
-	    MPI3MR_RESET_FROM_EH_HOS, 1);
-	if (ret)
-		goto out;
-
-	retval = SUCCESS;
-out:
 	sdev_printk(KERN_INFO, scmd->device,
-	    "Host reset is %s for scmd(%p)\n",
-	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
-
+		"Bus reset is %s for scmd(%p)\n",
+		((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
 	return retval;
 }
 
@@ -4094,6 +4110,7 @@ static struct scsi_host_template mpi3mr_driver_template = {
 	.change_queue_depth		= mpi3mr_change_queue_depth,
 	.eh_device_reset_handler	= mpi3mr_eh_dev_reset,
 	.eh_target_reset_handler	= mpi3mr_eh_target_reset,
+	.eh_bus_reset_handler		= mpi3mr_eh_bus_reset,
 	.eh_host_reset_handler		= mpi3mr_eh_host_reset,
 	.bios_param			= mpi3mr_bios_param,
 	.map_queues			= mpi3mr_map_queues,
-- 
2.29.2

