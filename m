Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED49C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240665AbiECULC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235690AbiECUKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25812714A
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 10010210ED;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/BdPdOVSwK2PoiZPiv+15Iq6K5R4lHm4RVThf68iWA=;
        b=j0F0veGRJMbH5fArdL9I04e8GZGU07Hde7k3ocf44NNQRWioFnBBJBfbrtYrKVr2a4mP9I
        jNkbhz9VplHV5ZcMX2MOSFFSqgTS3ctPDxm+nt8ErB3bkp7L89lZM2KEqIvqIbpExvFMwy
        e1dt+y9Js4tMsCpo8hIYjbJR2R4OAWY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/BdPdOVSwK2PoiZPiv+15Iq6K5R4lHm4RVThf68iWA=;
        b=1YaDixckHpeHcKEpoUFIeOtcM+cEIHpKbOEYot4JcyUqQ9Cr4aQ4p4Q/kLmohixv0PJUam
        qfQ+XSiTtTQQ9EBg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id E70F62C14F;
        Tue,  3 May 2022 20:07:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 0169B51941D0; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/24] mptfusion: correct definitions for mptscsih_dev_reset()
Date:   Tue,  3 May 2022 22:06:45 +0200
Message-Id: <20220503200704.88003-6-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

mptscsih_dev_reset() is _not_ a device reset, but rather a
target reset. Nevertheless it's being used for either purpose.
This patch adds a correct implementation for mptscsih_dev_reset(),
and renames the original function to mptscsih_target_reset().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/message/fusion/mptscsih.c | 55 ++++++++++++++++++++++++++++++-
 drivers/message/fusion/mptscsih.h |  1 +
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 276084ed04a6..ed21cc4d2c77 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1794,7 +1794,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_dev_reset - Perform a SCSI TARGET_RESET!  new_eh variant
+ *	mptscsih_dev_reset - Perform a SCSI LOGICAL_UNIT_RESET!
  *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
  *
  *	(linux scsi_host_template.eh_dev_reset_handler routine)
@@ -1809,6 +1809,58 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 	VirtDevice	 *vdevice;
 	MPT_ADAPTER	*ioc;
 
+	/* If we can't locate our host adapter structure, return FAILED status.
+	 */
+	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
+		printk(KERN_ERR MYNAM ": lun reset: "
+		   "Can't locate host! (sc=%p)\n", SCpnt);
+		return FAILED;
+	}
+
+	ioc = hd->ioc;
+	printk(MYIOC_s_INFO_FMT "attempting lun reset! (sc=%p)\n",
+	       ioc->name, SCpnt);
+	scsi_print_command(SCpnt);
+
+	vdevice = SCpnt->device->hostdata;
+	if (!vdevice || !vdevice->vtarget) {
+		retval = 0;
+		goto out;
+	}
+
+	retval = mptscsih_IssueTaskMgmt(hd,
+				MPI_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET,
+				vdevice->vtarget->channel,
+				vdevice->vtarget->id, vdevice->lun, 0,
+				mptscsih_get_tm_timeout(ioc));
+
+ out:
+	printk (MYIOC_s_INFO_FMT "lun reset: %s (sc=%p)\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+
+	if (retval == 0)
+		return SUCCESS;
+	else
+		return FAILED;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mptscsih_target_reset - Perform a SCSI TARGET_RESET!
+ *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
+ *
+ *	(linux scsi_host_template.eh_target_reset_handler routine)
+ *
+ *	Returns SUCCESS or FAILED.
+ **/
+int
+mptscsih_target_reset(struct scsi_cmnd * SCpnt)
+{
+	MPT_SCSI_HOST	*hd;
+	int		 retval;
+	VirtDevice	 *vdevice;
+	MPT_ADAPTER	*ioc;
+
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
@@ -3257,6 +3309,7 @@ EXPORT_SYMBOL(mptscsih_slave_destroy);
 EXPORT_SYMBOL(mptscsih_slave_configure);
 EXPORT_SYMBOL(mptscsih_abort);
 EXPORT_SYMBOL(mptscsih_dev_reset);
+EXPORT_SYMBOL(mptscsih_target_reset);
 EXPORT_SYMBOL(mptscsih_bus_reset);
 EXPORT_SYMBOL(mptscsih_host_reset);
 EXPORT_SYMBOL(mptscsih_bios_param);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index a22c5eaf703c..e3d92c392673 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -120,6 +120,7 @@ extern void mptscsih_slave_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
+extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_host_reset(struct scsi_cmnd *SCpnt);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
-- 
2.29.2

