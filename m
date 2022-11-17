Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED51C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240018AbiKQSgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiKQSgh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:36:37 -0500
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C391B60C4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:36:36 -0800 (PST)
Received: by mail-pf1-f181.google.com with SMTP id k22so2614265pfd.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:36:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uq8Yp6IG9XXMBmMEItW0bckONrZKpYGzu+wpVYzUfko=;
        b=lLqWtUYAePje57BqsudVwTxP1czLdnSSrUDmrimbwZHH529PBHf7mTfLHugL8Z0yWB
         Hg7ak/c747zeJcuJqnduqloJYYIZ9HGsq9Zx3hYV5OSLSpSzKYdTld9s0PDZtxDSW6I4
         aHmAc9a6gNFlDVDGhk2B3+WTmO+7RYieCkliyQHInhX7LhOLsZRwS51ueFauZBk1u5TE
         N1xJwz1E+KbdGEBkHxSOr+wh+mlOVASaOJAABy/E1B41lecxRLictBiH3cCy9bU7ZhB/
         FObHm2mxid9eE2fk+MTUa9tZDtZK08AxAOW7bdC6RIQzhlgyRrRom4uV8NmpO2YIyWe7
         OCog==
X-Gm-Message-State: ANoB5pn9HniysjDgTUU0r3fZUK97KIR/l8wAKeSHXOhkLS1R+ymwnPcd
        UHtZxYRZ8iMHSOccftvJr8s=
X-Google-Smtp-Source: AA0mqf7vulMsIf1tpPHrBLcIIl15JyFJJTId44gV2gLb1Tlo1/cTzDAve5W+NCNbO5QIJnHptYj0ug==
X-Received: by 2002:a63:ec03:0:b0:46e:e210:a491 with SMTP id j3-20020a63ec03000000b0046ee210a491mr3319569pgh.96.1668710196243;
        Thu, 17 Nov 2022 10:36:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7b21:f8f0:283b:9d21])
        by smtp.gmail.com with ESMTPSA id z11-20020aa79e4b000000b0056c0d129edfsm1479073pfq.121.2022.11.17.10.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:36:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/2] scsi: alua: Call scsi_device_put() from non-atomic context
Date:   Thu, 17 Nov 2022 10:36:26 -0800
Message-Id: <20221117183626.2656196-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221117183626.2656196-1-bvanassche@acm.org>
References: <20221117183626.2656196-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since commit f93ed747e2c7 ("scsi: core: Release SCSI devices
synchronously"), scsi_device_put() might sleep. Avoid calling it from
alua_rtpg_queue() with the pg_lock held. The lock only pretects h->pg,
anyway. To avoid the pg being freed under us, because of a race with
another thread, take a temporary reference. In alua_rtpg_queue(), verify
that the pg still belongs to the sdev being passed before actually
queueing the RTPG.

This patch fixes the following smatch warning:

drivers/scsi/device_handler/scsi_dh_alua.c:1013 alua_rtpg_queue() warn: sleeping in atomic context

alua_check_vpd() <- disables preempt
-> alua_rtpg_queue()
   -> scsi_device_put()

Cc: Martin Wilck <mwilck@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sachin Sant <sachinp@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>
Suggested-by: Martin Wilck <mwilck@suse.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 27 +++++++++++++++-------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index bd4ee294f5c7..49cc18a87473 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -354,6 +354,8 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 			    "%s: port group %x rel port %x\n",
 			    ALUA_DH_NAME, group_id, rel_port);
 
+	kref_get(&pg->kref);
+
 	/* Check for existing port group references */
 	spin_lock(&h->pg_lock);
 	old_pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
@@ -373,11 +375,11 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 		list_add_rcu(&h->node, &pg->dh_list);
 	spin_unlock_irqrestore(&pg->lock, flags);
 
-	alua_rtpg_queue(rcu_dereference_protected(h->pg,
-						  lockdep_is_held(&h->pg_lock)),
-			sdev, NULL, true);
 	spin_unlock(&h->pg_lock);
 
+	alua_rtpg_queue(pg, sdev, NULL, true);
+	kref_put(&pg->kref, release_port_group);
+
 	if (old_pg)
 		kref_put(&old_pg->kref, release_port_group);
 
@@ -986,6 +988,9 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
 {
 	int start_queue = 0;
 	unsigned long flags;
+
+	might_sleep();
+
 	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
 		return false;
 
@@ -996,11 +1001,17 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
 		force = true;
 	}
 	if (pg->rtpg_sdev == NULL) {
-		pg->interval = 0;
-		pg->flags |= ALUA_PG_RUN_RTPG;
-		kref_get(&pg->kref);
-		pg->rtpg_sdev = sdev;
-		start_queue = 1;
+		struct alua_dh_data *h = sdev->handler_data;
+
+		rcu_read_lock();
+		if (h && rcu_dereference(h->pg) == pg) {
+			pg->interval = 0;
+			pg->flags |= ALUA_PG_RUN_RTPG;
+			kref_get(&pg->kref);
+			pg->rtpg_sdev = sdev;
+			start_queue = 1;
+		}
+		rcu_read_unlock();
 	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force) {
 		pg->flags |= ALUA_PG_RUN_RTPG;
 		/* Do not queue if the worker is already running */
