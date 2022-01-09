Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BD0C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Jan 2022 01:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbiAIB3F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Jan 2022 20:29:05 -0500
Received: from smtp.infotech.no ([82.134.31.41]:37820 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233631AbiAIB3D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 8 Jan 2022 20:29:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0FA622041B2;
        Sun,  9 Jan 2022 02:29:01 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id isRRiutBHql8; Sun,  9 Jan 2022 02:29:00 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id DA3CE20413E;
        Sun,  9 Jan 2022 02:28:59 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v2 3/9] scsi_debug: use task set full more
Date:   Sat,  8 Jan 2022 20:28:47 -0500
Message-Id: <20220109012853.301953-4-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220109012853.301953-1-dgilbert@interlog.com>
References: <20220109012853.301953-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the internal in_use bit array in this driver is full returning
SCSI_MLQUEUE_HOST_BUSY leads to the mid-level re-issueing the
request which is unhelpful. Previously TASK SET FULL status was
only returned if ALL_TSF [0x400] is placed in the opts variable (at
load time or via sysfs). Now ignore that setting and always return
TASK SET FULL when in_use array is full. Also set DID_ABORT
together with TASK SET FULL so the mid-level gives up immediately.

Aside: the situations addressed by this patch lead to lockups and
timeouts. They have only been detected when blk_poll() is used. That
mechanism is relatively new in the SCSI subsystem suggesting the
mid-level may need more work in that area.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 40f698e331ee..8abe95a0d869 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -174,7 +174,7 @@ static const char *sdebug_version_date = "20200710";
 #define SDEBUG_OPT_MAC_TIMEOUT		128
 #define SDEBUG_OPT_SHORT_TRANSFER	0x100
 #define SDEBUG_OPT_Q_NOISE		0x200
-#define SDEBUG_OPT_ALL_TSF		0x400
+#define SDEBUG_OPT_ALL_TSF		0x400	/* ignore */
 #define SDEBUG_OPT_RARE_TSF		0x800
 #define SDEBUG_OPT_N_WCE		0x1000
 #define SDEBUG_OPT_RESET_NOISE		0x2000
@@ -861,7 +861,7 @@ static const int illegal_condition_result =
 	(DID_ABORT << 16) | SAM_STAT_CHECK_CONDITION;
 
 static const int device_qfull_result =
-	(DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
+	(DID_ABORT << 16) | SAM_STAT_TASK_SET_FULL;
 
 static const int condition_met_result = SAM_STAT_CONDITION_MET;
 
@@ -5521,18 +5521,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 		if (scsi_result)
 			goto respond_in_thread;
-		else if (SDEBUG_OPT_ALL_TSF & sdebug_opts)
-			scsi_result = device_qfull_result;
+		scsi_result = device_qfull_result;
 		if (SDEBUG_OPT_Q_NOISE & sdebug_opts)
-			sdev_printk(KERN_INFO, sdp,
-				    "%s: max_queue=%d exceeded, %s\n",
-				    __func__, sdebug_max_queue,
-				    (scsi_result ?  "status: TASK SET FULL" :
-						    "report: host busy"));
-		if (scsi_result)
-			goto respond_in_thread;
-		else
-			return SCSI_MLQUEUE_HOST_BUSY;
+			sdev_printk(KERN_INFO, sdp, "%s: max_queue=%d exceeded: TASK SET FULL\n",
+				    __func__, sdebug_max_queue);
+		goto respond_in_thread;
 	}
 	set_bit(k, sqp->in_use_bm);
 	atomic_inc(&devip->num_in_q);
-- 
2.25.1

