Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8265AC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 644836113C
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhHSJLF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:11:05 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36668 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237404AbhHSJLA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:11:00 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7E742200AF;
        Thu, 19 Aug 2021 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eK/t7pmo8GHdF6c1lZC/Gmf72Uc6J6nsxUGygxwqV6o=;
        b=zod77GEablEOjlvf7HGETAgmagywKTCZZ6Ay1q1aUUxZG/NjMUfISFnlJrdOzlcg2qO/Y5
        tfia35ZlQTfmDj7FSQ2uEoeL4I1Lg1ywCD0eqzdb2iWRHgaUnI0mvxJ5vpGVZeay75OTa1
        sbYcQSt79qm5nIWdKNUvsxOuBr4IK8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364223;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eK/t7pmo8GHdF6c1lZC/Gmf72Uc6J6nsxUGygxwqV6o=;
        b=KpnJjiWL/QuPN6TM5fAlNmeTBVqAP7fwU7V/D4WYb/13iGtUyYn8uhQ4vXZOIIGFCnU+WY
        M79mk/JeRXDbdACw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B7A21A3B9F;
        Thu, 19 Aug 2021 09:10:13 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6A5AF518D280; Thu, 19 Aug 2021 11:10:23 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 1/3] mptfusion: correct definitions for mptscsih_dev_reset()
Date:   Thu, 19 Aug 2021 11:10:15 +0200
Message-Id: <20210819091017.94142-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819091017.94142-1-hare@suse.de>
References: <20210819091017.94142-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

mptscsih_dev_reset() is _not_ a device reset, but rather a
target reset. Nevertheless it's being used for either purpose.
This patch adds a correct implementation for mptscsih_dev_reset(),
and renames the original function to mptscsih_target_reset().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/message/fusion/mptscsih.c | 55 ++++++++++++++++++++++++++++++-
 drivers/message/fusion/mptscsih.h |  1 +
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index ce2e5b21978e..fb4e6b201d55 100644
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
@@ -3249,6 +3301,7 @@ EXPORT_SYMBOL(mptscsih_slave_destroy);
 EXPORT_SYMBOL(mptscsih_slave_configure);
 EXPORT_SYMBOL(mptscsih_abort);
 EXPORT_SYMBOL(mptscsih_dev_reset);
+EXPORT_SYMBOL(mptscsih_target_reset);
 EXPORT_SYMBOL(mptscsih_bus_reset);
 EXPORT_SYMBOL(mptscsih_host_reset);
 EXPORT_SYMBOL(mptscsih_bios_param);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 2baeefd9be7a..d8c195c48b7b 100644
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

