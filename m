Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FA9FA3744
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 22:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJaWrp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJaWrn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 18:47:43 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF7012AD5
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:43 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso11463034pjc.5
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=73dxzlm048Biqtr6aKwohKxv7jZHIoAym6uGuW/+ewc=;
        b=ymC4r5np5IfsF1D2OrpCu2Vef0wJN9s97WrW9JeCOuW8Q2bd1ezzaqSvAc24WXfKN6
         tp7ymGylW8MUpLmYMdX+3qR6l34fLW8GySdsVnzyEcMoOn+lsOCcH/sT0QQolXaTfO+/
         jZP7o81BA2pObLwuQL+tULlf/jSYHeVj58swkfY+/a10RPxhJX1LLFN0FvR0EfrDPwPU
         hxi3SVOKM3NuvY/hdmSr4iUaxIUKjgV0hy1evWryuweKohfsXOPgSDe4rhkFevK7Km5S
         T94vdBnr0aNNc7VxAGcysqEMbblhpsK7dPD4LyZv3qbK3pTDaSY4XcSzSZdxNhTf3rZJ
         XVgQ==
X-Gm-Message-State: ACrzQf0/EY4CjljyPgb9TonOfSM4qBOGuqtyfBkVvEUnptmmbG4Wjjgu
        jVVTNaLXVkOsFpkAotxXPHc=
X-Google-Smtp-Source: AMsMyM50dHHgZNruETBOyejxjfHSu8kj6WDSNVYTbwbzqD6sbCs6SmoLXhelA0gSM57viPd6tABbgA==
X-Received: by 2002:a17:902:b945:b0:181:c6b6:abc with SMTP id h5-20020a170902b94500b00181c6b60abcmr16423415pls.75.1667256462601;
        Mon, 31 Oct 2022 15:47:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8574:e82f:b860:3ad0])
        by smtp.gmail.com with ESMTPSA id x6-20020a626306000000b00565c8634e55sm5096019pfb.135.2022.10.31.15.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 15:47:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/4] scsi: alua: Move a scsi_device_put() call out of alua_check_vpd()
Date:   Mon, 31 Oct 2022 15:47:25 -0700
Message-Id: <20221031224728.2607760-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
In-Reply-To: <20221031224728.2607760-1-bvanassche@acm.org>
References: <20221031224728.2607760-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following smatch warning:

drivers/scsi/device_handler/scsi_dh_alua.c:1013 alua_rtpg_queue() warn: sleeping in atomic context

alua_check_vpd() <- disables preempt
-> alua_rtpg_queue()
   -> scsi_device_put()

Cc: Hannes Reinecke <hare@suse.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 23 ++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 610a51538f03..f7bc81cc59ab 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -324,6 +324,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 	struct alua_port_group *pg, *old_pg = NULL;
 	bool pg_updated = false;
 	unsigned long flags;
+	bool put_sdev;
 
 	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
 	if (group_id < 0) {
@@ -373,11 +374,14 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 		list_add_rcu(&h->node, &pg->dh_list);
 	spin_unlock_irqrestore(&pg->lock, flags);
 
-	alua_rtpg_queue(rcu_dereference_protected(h->pg,
+	put_sdev = alua_rtpg_queue(rcu_dereference_protected(h->pg,
 						  lockdep_is_held(&h->pg_lock)),
 			sdev, NULL, true);
 	spin_unlock(&h->pg_lock);
 
+	if (put_sdev)
+		scsi_device_put(sdev);
+
 	if (old_pg)
 		kref_put(&old_pg->kref, release_port_group);
 
@@ -968,9 +972,10 @@ static void alua_rtpg_work(struct work_struct *work)
  *         RTPG already has been scheduled.
  *
  * Returns true if and only if alua_rtpg_work() will be called asynchronously.
- * That function is responsible for calling @qdata->fn().
+ * That function is responsible for calling @qdata->fn(). If this function
+ * returns true, the caller is responsible for invoking scsi_device_put(@sdev).
  */
-static bool alua_rtpg_queue(struct alua_port_group *pg,
+static bool __must_check alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
 			    struct alua_queue_data *qdata, bool force)
 {
@@ -1009,8 +1014,6 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
 		else
 			kref_put(&pg->kref, release_port_group);
 	}
-	if (sdev)
-		scsi_device_put(sdev);
 
 	return true;
 }
@@ -1117,10 +1120,12 @@ static int alua_activate(struct scsi_device *sdev,
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	if (alua_rtpg_queue(pg, sdev, qdata, true))
+	if (alua_rtpg_queue(pg, sdev, qdata, true)) {
+		scsi_device_put(sdev);
 		fn = NULL;
-	else
+	} else {
 		err = SCSI_DH_DEV_OFFLINED;
+	}
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
@@ -1146,7 +1151,9 @@ static void alua_check(struct scsi_device *sdev, bool force)
 		return;
 	}
 	rcu_read_unlock();
-	alua_rtpg_queue(pg, sdev, NULL, force);
+
+	if (alua_rtpg_queue(pg, sdev, NULL, force))
+		scsi_device_put(sdev);
 	kref_put(&pg->kref, release_port_group);
 }
 
