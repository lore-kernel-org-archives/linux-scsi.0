Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F368EE748E9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238193AbjJBPnx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238174AbjJBPnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:43:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375DBDC
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 829F11F750;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W3rL54Hz2TzbHKZlIN3115OHVTJy8XczANMNb1VioQ8=;
        b=y0x5S7SNqjH8M6Og6B8AShJCPFoqP5j2m2PUOy1IrpplMbLrXk3uBGaxhxNlYOyoJGTWyZ
        b44qwz1cjTUtsxQk1fVyAlpj3c1qwn9Xbwkg8uCWHQTT0xdw9iI4BbuCpCvhtqJHnfhMaG
        a1tdebp9fLjAHqjw2Q7MA4VRqXFRoR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W3rL54Hz2TzbHKZlIN3115OHVTJy8XczANMNb1VioQ8=;
        b=DnVQQvC0AiYqtHRQONYOtdvtOZFUxGj4U2Ucam8LXEG8Um5MZqQxkYLxXliMXKtdg7XVtg
        A31s5plXX7pYvCBg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 57AEB2C143;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 4EABD51E753B; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 02/18] mptfusion: correct definitions for mptscsih_dev_reset()
Date:   Mon,  2 Oct 2023 17:43:12 +0200
Message-Id: <20231002154328.43718-3-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/message/fusion/mptscsih.c | 55 ++++++++++++++++++++++++++++++-
 drivers/message/fusion/mptscsih.h |  1 +
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 2bc17087d17d..9080a73b4ea6 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1793,7 +1793,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_dev_reset - Perform a SCSI TARGET_RESET!  new_eh variant
+ *	mptscsih_dev_reset - Perform a SCSI LOGICAL_UNIT_RESET!
  *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
  *
  *	(linux scsi_host_template.eh_dev_reset_handler routine)
@@ -1808,6 +1808,58 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
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
@@ -3256,6 +3308,7 @@ EXPORT_SYMBOL(mptscsih_slave_destroy);
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
2.35.3

