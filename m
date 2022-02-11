Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97046C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354168AbiBKWeu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354159AbiBKWek (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:40 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE91D53;
        Fri, 11 Feb 2022 14:34:38 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id n19-20020a17090ade9300b001b9892a7bf9so813418pjv.5;
        Fri, 11 Feb 2022 14:34:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=efotMu/0Uf1dkcc1uJu6R6InV4FTKLkaJ5+cOM9IBjM=;
        b=17TpFTml2b05/5mfD6Z01Ps5YD3+ghtkXinb35s+NM2wfRqyzCiDQPttAwCRneRI6j
         d9d4IHJz9nXx4eu1NVSuAqTQruoC//EEwdgX4yns64hrMYDe9tZuGvdl9paYy9nquiie
         IevN7O2Jxw68jA+67G/DDLWA3Ywb5+Oy4fXhsz40hWwleIHm+WkwncY+5TG+Bgsf/Fui
         xyNV1pNKfU0eVH0kv18HU/ntPG32uwqB6CwMCFYUgYzQCU60X9hj/t3w03BJkrVrwRp7
         Kyg32dOKzdHhcoP5RHu3HlAaYnqDHCgj4Y/vbne9u+2+VgvzqXRXDCJgSZyt18CqJHyJ
         VNCQ==
X-Gm-Message-State: AOAM532jtNrLRt1a3yhagz3ZrALagn6BaZav6y/KvDiSA1CQ6Nczs+1Z
        oMq10aeMMZPI8xmbu4Xgu94=
X-Google-Smtp-Source: ABdhPJxbWjAZr7UkuWMmvXxUU540U7D0f2rG7iWnQXIIauw/lyxKEmcdiwKqVaCBINL49y7JS4CQfQ==
X-Received: by 2002:a17:90b:4d8c:: with SMTP id oj12mr2567165pjb.111.1644618877802;
        Fri, 11 Feb 2022 14:34:37 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:37 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v3 44/48] scsi: usb: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:43 -0800
Message-Id: <20220211223247.14369-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set scsi_host_template.cmd_size instead of using the SCSI pointer for
storing driver-private data. Change the type of the argument of
uas_add_work() from struct uas_cmd_info * into struct scsi_cmnd * because
it is easier to convert a SCSI command pointer into a uas_cmd_info pointer
than the other way around.

This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Cc: linux-usb@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/usb/storage/uas.c | 43 ++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 7f2944729ecd..84dc270f6f73 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -113,7 +113,7 @@ static void uas_do_work(struct work_struct *work)
 			continue;
 
 		cmnd = devinfo->cmnd[i];
-		cmdinfo = (void *)&cmnd->SCp;
+		cmdinfo = scsi_cmd_priv(cmnd);
 
 		if (!(cmdinfo->state & IS_IN_WORK_LIST))
 			continue;
@@ -139,10 +139,9 @@ static void uas_scan_work(struct work_struct *work)
 	dev_dbg(&devinfo->intf->dev, "scan complete\n");
 }
 
-static void uas_add_work(struct uas_cmd_info *cmdinfo)
+static void uas_add_work(struct scsi_cmnd *cmnd)
 {
-	struct scsi_pointer *scp = (void *)cmdinfo;
-	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct uas_dev_info *devinfo = cmnd->device->hostdata;
 
 	lockdep_assert_held(&devinfo->lock);
@@ -163,7 +162,7 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 			continue;
 
 		cmnd = devinfo->cmnd[i];
-		cmdinfo = (void *)&cmnd->SCp;
+		cmdinfo = scsi_cmd_priv(cmnd);
 		uas_log_cmd_state(cmnd, __func__, 0);
 		/* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
 		cmdinfo->state &= ~COMMAND_INFLIGHT;
@@ -200,15 +199,14 @@ static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *prefix,
 			      int status)
 {
-	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *ci = scsi_cmd_priv(cmnd);
 
 	if (status == -ENODEV) /* too late */
 		return;
 
 	scmd_printk(KERN_INFO, cmnd,
 		    "%s %d uas-tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
-		    prefix, status, cmdinfo->uas_tag,
+		    prefix, status, ci->uas_tag,
 		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
 		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
 		    (ci->state & SUBMIT_DATA_IN_URB)    ? " s-in"  : "",
@@ -231,7 +229,7 @@ static void uas_free_unsubmitted_urbs(struct scsi_cmnd *cmnd)
 	if (!cmnd)
 		return;
 
-	cmdinfo = (void *)&cmnd->SCp;
+	cmdinfo = scsi_cmd_priv(cmnd);
 
 	if (cmdinfo->state & SUBMIT_CMD_URB)
 		usb_free_urb(cmdinfo->cmd_urb);
@@ -245,7 +243,7 @@ static void uas_free_unsubmitted_urbs(struct scsi_cmnd *cmnd)
 
 static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
 
 	lockdep_assert_held(&devinfo->lock);
@@ -263,13 +261,13 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
 			  unsigned direction)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	int err;
 
 	cmdinfo->state |= direction | SUBMIT_STATUS_URB;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata);
 	if (err) {
-		uas_add_work(cmdinfo);
+		uas_add_work(cmnd);
 	}
 }
 
@@ -329,7 +327,7 @@ static void uas_stat_cmplt(struct urb *urb)
 	}
 
 	cmnd = devinfo->cmnd[idx];
-	cmdinfo = (void *)&cmnd->SCp;
+	cmdinfo = scsi_cmd_priv(cmnd);
 
 	if (!(cmdinfo->state & COMMAND_INFLIGHT)) {
 		uas_log_cmd_state(cmnd, "unexpected status cmplt", 0);
@@ -394,7 +392,7 @@ static void uas_stat_cmplt(struct urb *urb)
 static void uas_data_cmplt(struct urb *urb)
 {
 	struct scsi_cmnd *cmnd = urb->context;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
 	struct scsi_data_buffer *sdb = &cmnd->sdb;
 	unsigned long flags;
@@ -446,7 +444,7 @@ static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 				      enum dma_data_direction dir)
 {
 	struct usb_device *udev = devinfo->udev;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct urb *urb = usb_alloc_urb(0, gfp);
 	struct scsi_data_buffer *sdb = &cmnd->sdb;
 	unsigned int pipe = (dir == DMA_FROM_DEVICE)
@@ -468,7 +466,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 				       struct scsi_cmnd *cmnd)
 {
 	struct usb_device *udev = devinfo->udev;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct urb *urb = usb_alloc_urb(0, gfp);
 	struct sense_iu *iu;
 
@@ -496,7 +494,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 {
 	struct usb_device *udev = devinfo->udev;
 	struct scsi_device *sdev = cmnd->device;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct urb *urb = usb_alloc_urb(0, gfp);
 	struct command_iu *iu;
 	int len;
@@ -558,7 +556,7 @@ static struct urb *uas_submit_sense_urb(struct scsi_cmnd *cmnd, gfp_t gfp)
 static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 			   struct uas_dev_info *devinfo)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct urb *urb;
 	int err;
 
@@ -637,12 +635,10 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd)
 {
 	struct scsi_device *sdev = cmnd->device;
 	struct uas_dev_info *devinfo = sdev->hostdata;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	unsigned long flags;
 	int idx, err;
 
-	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
-
 	/* Re-check scsi_block_requests now that we've the host-lock */
 	if (cmnd->device->host->host_self_blocked)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
@@ -712,7 +708,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd)
 			spin_unlock_irqrestore(&devinfo->lock, flags);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
-		uas_add_work(cmdinfo);
+		uas_add_work(cmnd);
 	}
 
 	devinfo->cmnd[idx] = cmnd;
@@ -730,7 +726,7 @@ static DEF_SCSI_QCMD(uas_queuecommand)
  */
 static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
 	struct urb *data_in_urb = NULL;
 	struct urb *data_out_urb = NULL;
@@ -910,6 +906,7 @@ static struct scsi_host_template uas_host_template = {
 	.this_id = -1,
 	.skip_settle_delay = 1,
 	.dma_boundary = PAGE_SIZE - 1,
+	.cmd_size = sizeof(struct uas_cmd_info),
 };
 
 #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
