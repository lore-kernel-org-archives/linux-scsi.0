Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2421E743C3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbjJBPo0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbjJBPoI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:44:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87262D3
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id EC5021F88B;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gWkOFOqvBsxR7MF/5cU1bu/2b5N4kmT1EyqF1iryo4Q=;
        b=FiL8eFgQVDcjWpenF0uWUva778RHIDVxPX8PCIugOO9/mBGYjlBMIEuczzWwqGz1YmN8TH
        KnR+lL3Nh/p354EnGVfjrIEA7S/Y8z2VuGH7Qu9bXjxgfTm9zBp0LL7LQ0M49dRVmD1z1B
        yjtkMktlLbvP05N6LsD0zsTWlfOt3VU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gWkOFOqvBsxR7MF/5cU1bu/2b5N4kmT1EyqF1iryo4Q=;
        b=Kixq/ZFY19G1EIWtpYYffW979Ws8FXPSTh0kXuk7/hxjx/Cib355EX7bCQGZeNNfh05r7x
        1Be4B97POWpYy9CA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id C8EBB2C165;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id D635051E755B; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 18/18] mpi3mr: split off bus_reset function from host_reset
Date:   Mon,  2 Oct 2023 17:43:28 +0200
Message-Id: <20231002154328.43718-19-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 57 +++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 89ba015c5d7e..040031eb0c12 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4012,20 +4012,45 @@ static inline void mpi3mr_setup_divert_ws(struct mpi3mr_ioc *mrioc,
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
@@ -4035,25 +4060,16 @@ static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
 
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
 
@@ -4900,6 +4916,7 @@ static const struct scsi_host_template mpi3mr_driver_template = {
 	.change_queue_depth		= mpi3mr_change_queue_depth,
 	.eh_device_reset_handler	= mpi3mr_eh_dev_reset,
 	.eh_target_reset_handler	= mpi3mr_eh_target_reset,
+	.eh_bus_reset_handler		= mpi3mr_eh_bus_reset,
 	.eh_host_reset_handler		= mpi3mr_eh_host_reset,
 	.bios_param			= mpi3mr_bios_param,
 	.map_queues			= mpi3mr_map_queues,
-- 
2.35.3

