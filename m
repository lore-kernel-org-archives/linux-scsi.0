Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD06C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 830D6600CC
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbhHQJR0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:26 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47534 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237391AbhHQJRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:16 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DBAC020015;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6GrJM0aouw/ZIvxMipA2gaYCMM+Hn6y+AkmstV+ltU=;
        b=e4JYa0KiJtVr8A3U0l0mUHXHNxceOr7yMvGoCu4p/K5q4jIipxZxAEW85V08GWQRjMcUtY
        YNFBNwv91tw8M25GxwDQQbgL8bK7ErIEfhcAYTXWzWNeThLa9bNKo7Dhm+FTcKW+jtYAnG
        HQ3rdnYR2EcQ29cUop1giffXCxLhHlc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6GrJM0aouw/ZIvxMipA2gaYCMM+Hn6y+AkmstV+ltU=;
        b=dyNT5LRwQxF8qF4E+V96p9ehe0t+/Nf23D68vzuHYIxi2RDVBstPxNrQ3+5SkFIxSBmKEA
        GpSaVWt1X7nWyrAA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id CDF91A3B9C;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CB8CB518CE71; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 09/51] mpi3mr: split off bus_reset function from host_reset
Date:   Tue, 17 Aug 2021 11:14:14 +0200
Message-Id: <20210817091456.73342-10-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
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
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 57 +++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 24ac7ddec749..456a24317bb5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2879,20 +2879,45 @@ void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout)
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
@@ -2902,25 +2927,16 @@ static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
 
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
 
@@ -3575,6 +3591,7 @@ static struct scsi_host_template mpi3mr_driver_template = {
 	.change_queue_depth		= mpi3mr_change_queue_depth,
 	.eh_device_reset_handler	= mpi3mr_eh_dev_reset,
 	.eh_target_reset_handler	= mpi3mr_eh_target_reset,
+	.eh_bus_reset_handler		= mpi3mr_eh_bus_reset,
 	.eh_host_reset_handler		= mpi3mr_eh_host_reset,
 	.bios_param			= mpi3mr_bios_param,
 	.map_queues			= mpi3mr_map_queues,
-- 
2.29.2

