Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB98C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 15:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 169B661428
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 15:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhENPdk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 11:33:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:45052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234836AbhENPdk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 May 2021 11:33:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621006347; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=vXoWfYLeM8+X4AHQkKvn+ewcoY2pHT5wQ2fkYuijgAk=;
        b=WNMv54Tgy0P1UMZ3Vkg1Y9NANNwLq7HFlxXYCV+j+4b6E4hIzBFgYMm9fITwL6lBn1AGLG
        ie7oiVgtAhd5KbFpOrWjG6By9FASOyHmLtOfB8jkltMBygZtg8hYHMPyE4bN2IXykGkeTM
        CH8WDrikABweVy8SJe1fnT7ZllstbwI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A3929B03A;
        Fri, 14 May 2021 15:32:27 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>, emilne@redhat.com,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: alua: retry RTPG on a different path after failure
Date:   Fri, 14 May 2021 17:32:14 +0200
Message-Id: <20210514153214.5626-1-mwilck@suse.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

If an RTPG fails, we can't infer anything wrt the state of the
ports in the port group, except that we were unable to reach
the one port on which the RTPG had failed. "offline" is just a
secondary port state, which means that we can't infer the state
of any port in the PG from the failure (in fact, even the failed
port might still be in "active/optimized" primary port access
state).

Therefore, when we encounter an RTPG failure, we should retry the
RTPG on a different port. This avoids falsely setting
port states to offline for unreachable ports. To do this ports
on which an RTPG has failed are temporarily set to "disabled" to
avoid repeating the afiled I/O on the same target port. Once the
RTPG has either succeed on one port or failed on all ports of the
PG, the ports are enabled again.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 70 +++++++++++++++++++++-
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index efa8c0381476..03b7f255644f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -88,6 +88,7 @@ struct alua_dh_data {
 	struct scsi_device	*sdev;
 	int			init_error;
 	struct mutex		init_mutex;
+	bool			disabled;
 };
 
 struct alua_queue_data {
@@ -569,6 +570,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			kfree(buff);
 			if (driver_byte(retval) == DRIVER_ERROR)
 				return SCSI_DH_DEV_TEMP_BUSY;
+			if (host_byte(retval) == DID_NO_CONNECT)
+				return SCSI_DH_RES_TEMP_UNAVAIL;
 			return SCSI_DH_IO;
 		}
 
@@ -807,6 +810,51 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	return SCSI_DH_RETRY;
 }
 
+static bool alua_rtpg_select_sdev(struct alua_port_group *pg)
+{
+	struct alua_dh_data *h;
+	struct scsi_device *sdev = NULL;
+
+	lockdep_assert_held(&pg->lock);
+	if (WARN_ON(!pg->rtpg_sdev))
+		return false;
+
+	/*
+	 * RCU protection isn't necessary for dh_list here
+	 * as we hold pg->lock, but for access to h->pg.
+	 */
+	rcu_read_lock();
+	list_for_each_entry_rcu(h, &pg->dh_list, node) {
+		if (!h->sdev)
+			continue;
+		if (h->sdev == pg->rtpg_sdev) {
+			h->disabled = true;
+			continue;
+		}
+		if (rcu_dereference(h->pg) == pg &&
+		    !h->disabled &&
+		    !scsi_device_get(h->sdev)) {
+			sdev = h->sdev;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	if (!sdev) {
+		pr_warn("%s: no device found for rtpg\n",
+			(pg->device_id_len ?
+			 (char *)pg->device_id_str : "(nameless PG)"));
+		return false;
+	}
+
+	sdev_printk(KERN_INFO, sdev, "rtpg retry on different device\n");
+
+	scsi_device_put(pg->rtpg_sdev);
+	pg->rtpg_sdev = sdev;
+
+	return true;
+}
+
 static void alua_rtpg_work(struct work_struct *work)
 {
 	struct alua_port_group *pg =
@@ -815,6 +863,7 @@ static void alua_rtpg_work(struct work_struct *work)
 	LIST_HEAD(qdata_list);
 	int err = SCSI_DH_OK;
 	struct alua_queue_data *qdata, *tmp;
+	struct alua_dh_data *h;
 	unsigned long flags;
 
 	spin_lock_irqsave(&pg->lock, flags);
@@ -848,9 +897,18 @@ static void alua_rtpg_work(struct work_struct *work)
 		}
 		err = alua_rtpg(sdev, pg);
 		spin_lock_irqsave(&pg->lock, flags);
-		if (err == SCSI_DH_RETRY || pg->flags & ALUA_PG_RUN_RTPG) {
+
+		/* If RTPG failed on the current device, try using another */
+		if (err == SCSI_DH_RES_TEMP_UNAVAIL &&
+		    alua_rtpg_select_sdev(pg))
+			err = SCSI_DH_IMM_RETRY;
+
+		if (err == SCSI_DH_RETRY || err == SCSI_DH_IMM_RETRY ||
+		    pg->flags & ALUA_PG_RUN_RTPG) {
 			pg->flags &= ~ALUA_PG_RUNNING;
-			if (!pg->interval && !(pg->flags & ALUA_PG_RUN_RTPG))
+			if (err == SCSI_DH_IMM_RETRY)
+				pg->interval = 0;
+			else if (!pg->interval && !(pg->flags & ALUA_PG_RUN_RTPG))
 				pg->interval = ALUA_RTPG_RETRY_DELAY;
 			pg->flags |= ALUA_PG_RUN_RTPG;
 			spin_unlock_irqrestore(&pg->lock, flags);
@@ -878,6 +936,12 @@ static void alua_rtpg_work(struct work_struct *work)
 	}
 
 	list_splice_init(&pg->rtpg_list, &qdata_list);
+	/*
+	 * We went through an RTPG, for good or bad.
+	 * Re-enable all devices for the next attempt.
+	 */
+	list_for_each_entry(h, &pg->dh_list, node)
+		h->disabled = false;
 	pg->rtpg_sdev = NULL;
 	spin_unlock_irqrestore(&pg->lock, flags);
 
@@ -962,6 +1026,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 	int err = SCSI_DH_DEV_UNSUPP, tpgs;
 
 	mutex_lock(&h->init_mutex);
+	h->disabled = false;
 	tpgs = alua_check_tpgs(sdev);
 	if (tpgs != TPGS_MODE_NONE)
 		err = alua_check_vpd(sdev, h, tpgs);
@@ -1080,7 +1145,6 @@ static void alua_check(struct scsi_device *sdev, bool force)
 		return;
 	}
 	rcu_read_unlock();
-
 	alua_rtpg_queue(pg, sdev, NULL, force);
 	kref_put(&pg->kref, release_port_group);
 }
-- 
2.31.1

