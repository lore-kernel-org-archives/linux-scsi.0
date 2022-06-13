Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB8EC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 21:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348225AbiFMVpS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 17:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239450AbiFMVpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 17:45:17 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08A46419
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 14:45:16 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id cx11so6813173pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 14:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y1xiiMs+jvGJqSGFqyS+k2VD1/618zcR4FkPID0+MWU=;
        b=jMBESOjaKUq3WPe8XF20SD5xzyLE1KGdeGQqjC7TEV2CK5SN4YwgGVm6RYmmQLZkrw
         NjT+1cWZKpB4x9JhIGW2TzJ92dpx9oVdgBqqT1pqPoGLZC/lJP/xlEUNq8u34e2Rg+l/
         w4sL0B4s+zT1HhN1tY6/yyA+snUiNv6Z1kXs21biT96aI+K6R88vQuAPY24bhYHy0eDC
         3ocNPwFQ2LYdYfXvnJuQUM+UlfeHEVtIuN+hTO6ZwnAAkyZgS2Nw4XAbmJB7RGKvj3Zj
         7dO7mhYdrIwtVGHTdC+rh+o7nemgjxqVz0hX+rQIY4JN8iReQtf1aPYKOJFcAiXBR4e1
         f74A==
X-Gm-Message-State: AOAM531Cz2tk+cLIIIY4zh08BcrwEU8zydnH9lvMDh7cv/SdhhbYSpZl
        06AM7y6MkNjx3f93fJ3IeD8=
X-Google-Smtp-Source: AGRyM1ukJyw7oexegs3Vi/+T/NFaxTjwldoEEa+F9HoQFLgzgbn4llDCdLJn0nCStWld68hzRENK9Q==
X-Received: by 2002:a17:902:d707:b0:168:9a6a:936d with SMTP id w7-20020a170902d70700b001689a6a936dmr1135221ply.92.1655156716230;
        Mon, 13 Jun 2022 14:45:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6862:a290:1a09:5af5])
        by smtp.gmail.com with ESMTPSA id ji2-20020a170903324200b001622c377c3esm5585833plb.117.2022.06.13.14.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 14:45:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 2/3] scsi: ufs: Support clearing multiple commands at once
Date:   Mon, 13 Jun 2022 14:44:41 -0700
Message-Id: <20220613214442.212466-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220613214442.212466-1-bvanassche@acm.org>
References: <20220613214442.212466-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Modify ufshcd_clear_cmd() such that it supports clearing multiple
commands at once instead of one command at a time. This change will be
used in a later patch to reduce the time spent in the reset handler.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 42 ++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4ed2f6c29e80..b7120c5f0920 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -748,17 +748,28 @@ static enum utp_ocs ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 }
 
 /**
- * ufshcd_utrl_clear - Clear a bit in UTRLCLR register
+ * ufshcd_utrl_clear() - Clear requests from the controller request list.
  * @hba: per adapter instance
- * @pos: position of the bit to be cleared
+ * @mask: mask with one bit set for each request to be cleared
  */
-static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
+static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 mask)
 {
 	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
-		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
-	else
-		ufshcd_writel(hba, ~(1 << pos),
-				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+		mask = ~mask;
+	/*
+	 * From the UFSHCI specification: "UTP Transfer Request List CLear
+	 * Register (UTRLCLR): This field is bit significant. Each bit
+	 * corresponds to a slot in the UTP Transfer Request List, where bit 0
+	 * corresponds to request slot 0. A bit in this field is set to ‘0’
+	 * by host software to indicate to the host controller that a transfer
+	 * request slot is cleared. The host controller
+	 * shall free up any resources associated to the request slot
+	 * immediately, and shall set the associated bit in UTRLDBR to ‘0’. The
+	 * host software indicates no change to request slots by setting the
+	 * associated bits in this field to ‘1’. Bits in this field shall only
+	 * be set ‘1’ or ‘0’ by host software when UTRLRSR is set to ‘1’."
+	 */
+	ufshcd_writel(hba, ~mask, REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
 
 /**
@@ -2865,15 +2876,18 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	return ufshcd_compose_devman_upiu(hba, lrbp);
 }
 
-static int
-ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
+/*
+ * Clear all the requests from the controller for which a bit has been set in
+ * @mask and wait until the controller confirms that these requests have been
+ * cleared.
+ */
+static int ufshcd_clear_cmds(struct ufs_hba *hba, u32 mask)
 {
 	unsigned long flags;
-	u32 mask = 1 << tag;
 
 	/* clear outstanding transaction before retry */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_utrl_clear(hba, tag);
+	ufshcd_utrl_clear(hba, mask);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/*
@@ -2961,7 +2975,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		err = -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
 			__func__, lrbp->task_tag);
-		if (!ufshcd_clear_cmd(hba, lrbp->task_tag))
+		if (!ufshcd_clear_cmds(hba, 1U << lrbp->task_tag))
 			/* successfully cleared the command, retry if needed */
 			err = -EAGAIN;
 		/*
@@ -6989,7 +7003,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	/* clear the commands that were pending for corresponding LUN */
 	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
 		if (hba->lrb[pos].lun == lun) {
-			err = ufshcd_clear_cmd(hba, pos);
+			err = ufshcd_clear_cmds(hba, 1U << pos);
 			if (err)
 				break;
 			__ufshcd_transfer_req_compl(hba, 1U << pos);
@@ -7091,7 +7105,7 @@ static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
 		goto out;
 	}
 
-	err = ufshcd_clear_cmd(hba, tag);
+	err = ufshcd_clear_cmds(hba, 1U << tag);
 	if (err)
 		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
 			__func__, tag, err);
