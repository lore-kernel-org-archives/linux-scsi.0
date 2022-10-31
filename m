Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0BEFA3741
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 22:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJaWrr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJaWrp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 18:47:45 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0697614D17
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:45 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id p21so8146115plr.7
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MapLoBMbG0Bhg1AX8rjvQRMJT4NqZWs+WU5rHhIdvd8=;
        b=I39598ud9Ox6RqP9qMm2H9fUSranx+/V0HHQphNnavVmTrHptsqdyzZIPvy+iwCLVx
         zU4fGZp2kLoLSHAyJNTbitloRjsBPFRorDbMxJs+OVCzGKpB96S0MG6iwDNglog49rO6
         ffqqMRJqBXlTdKQQMj2ztdJeaMXgneOjMoiORgIqXnbu9fWRHQnvX56HPgCLLgAQh2vh
         lfRkjlUFitMrSQNIzUwbmiXUMXprZ4FO4ytzAQv/jQhabZfq3dqwurei2CNNjUZDOm1s
         BF+zyLmpnJ9QfwB3rnpQDUbVpt1gQ9wWb8gfe/n/eJ4iOczt+nnYOf0FKpWpUw4P2roQ
         g6gw==
X-Gm-Message-State: ACrzQf3xHXo2zSMK29/HyeY0a+/VY+oB3WMK3ZiJZn5g2shuy/6J8ONO
        c2nNXlvS8rSyLTTlaXawWQg=
X-Google-Smtp-Source: AMsMyM7unrUg0w4fGGjAIURb6/B15MvsAYxU1rLMIqXH5XvePUsRwMzNuUoqTc3sy0bUpcEH3vj0hQ==
X-Received: by 2002:a17:902:bd47:b0:17f:685b:27ee with SMTP id b7-20020a170902bd4700b0017f685b27eemr15755677plx.22.1667256464387;
        Mon, 31 Oct 2022 15:47:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8574:e82f:b860:3ad0])
        by smtp.gmail.com with ESMTPSA id x6-20020a626306000000b00565c8634e55sm5096019pfb.135.2022.10.31.15.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 15:47:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/4] scsi: alua: Move a scsi_device_put() call out of alua_rtpg_select_sdev()
Date:   Mon, 31 Oct 2022 15:47:26 -0700
Message-Id: <20221031224728.2607760-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
In-Reply-To: <20221031224728.2607760-1-bvanassche@acm.org>
References: <20221031224728.2607760-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move a scsi_device_put() call from alua_rtpg_select_sdev() to its
callers. This patch fixes the following smatch complaint:

drivers/scsi/device_handler/scsi_dh_alua.c:853 alua_rtpg_select_sdev() warn: sleeping in atomic context

alua_rtpg_work() <- disables preempt
-> alua_rtpg_select_sdev()
   -> scsi_device_put()

Cc: Hannes Reinecke <hare@suse.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 38 ++++++++++++++--------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f7bc81cc59ab..693cd827e138 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -815,14 +815,19 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	return SCSI_DH_RETRY;
 }
 
-static bool alua_rtpg_select_sdev(struct alua_port_group *pg)
+/*
+ * The caller must call scsi_device_put() on the returned pointer if it is not
+ * NULL.
+ */
+static struct scsi_device * __must_check
+alua_rtpg_select_sdev(struct alua_port_group *pg)
 {
 	struct alua_dh_data *h;
-	struct scsi_device *sdev = NULL;
+	struct scsi_device *sdev = NULL, *prev_sdev;
 
 	lockdep_assert_held(&pg->lock);
 	if (WARN_ON(!pg->rtpg_sdev))
-		return false;
+		return NULL;
 
 	/*
 	 * RCU protection isn't necessary for dh_list here
@@ -849,22 +854,22 @@ static bool alua_rtpg_select_sdev(struct alua_port_group *pg)
 		pr_warn("%s: no device found for rtpg\n",
 			(pg->device_id_len ?
 			 (char *)pg->device_id_str : "(nameless PG)"));
-		return false;
+		return NULL;
 	}
 
 	sdev_printk(KERN_INFO, sdev, "rtpg retry on different device\n");
 
-	scsi_device_put(pg->rtpg_sdev);
+	prev_sdev = pg->rtpg_sdev;
 	pg->rtpg_sdev = sdev;
 
-	return true;
+	return prev_sdev;
 }
 
 static void alua_rtpg_work(struct work_struct *work)
 {
 	struct alua_port_group *pg =
 		container_of(work, struct alua_port_group, rtpg_work.work);
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *prev_sdev = NULL;
 	LIST_HEAD(qdata_list);
 	int err = SCSI_DH_OK;
 	struct alua_queue_data *qdata, *tmp;
@@ -905,7 +910,7 @@ static void alua_rtpg_work(struct work_struct *work)
 
 		/* If RTPG failed on the current device, try using another */
 		if (err == SCSI_DH_RES_TEMP_UNAVAIL &&
-		    alua_rtpg_select_sdev(pg))
+		    (prev_sdev = alua_rtpg_select_sdev(pg)))
 			err = SCSI_DH_IMM_RETRY;
 
 		if (err == SCSI_DH_RETRY || err == SCSI_DH_IMM_RETRY ||
@@ -917,9 +922,7 @@ static void alua_rtpg_work(struct work_struct *work)
 				pg->interval = ALUA_RTPG_RETRY_DELAY;
 			pg->flags |= ALUA_PG_RUN_RTPG;
 			spin_unlock_irqrestore(&pg->lock, flags);
-			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
-					   pg->interval * HZ);
-			return;
+			goto queue_rtpg;
 		}
 		if (err != SCSI_DH_OK)
 			pg->flags &= ~ALUA_PG_RUN_STPG;
@@ -934,9 +937,7 @@ static void alua_rtpg_work(struct work_struct *work)
 			pg->interval = 0;
 			pg->flags &= ~ALUA_PG_RUNNING;
 			spin_unlock_irqrestore(&pg->lock, flags);
-			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
-					   pg->interval * HZ);
-			return;
+			goto queue_rtpg;
 		}
 	}
 
@@ -950,6 +951,9 @@ static void alua_rtpg_work(struct work_struct *work)
 	pg->rtpg_sdev = NULL;
 	spin_unlock_irqrestore(&pg->lock, flags);
 
+	if (prev_sdev)
+		scsi_device_put(prev_sdev);
+
 	list_for_each_entry_safe(qdata, tmp, &qdata_list, entry) {
 		list_del(&qdata->entry);
 		if (qdata->callback_fn)
@@ -961,6 +965,12 @@ static void alua_rtpg_work(struct work_struct *work)
 	spin_unlock_irqrestore(&pg->lock, flags);
 	scsi_device_put(sdev);
 	kref_put(&pg->kref, release_port_group);
+	return;
+
+queue_rtpg:
+	if (prev_sdev)
+		scsi_device_put(prev_sdev);
+	queue_delayed_work(kaluad_wq, &pg->rtpg_work, pg->interval * HZ);
 }
 
 /**
