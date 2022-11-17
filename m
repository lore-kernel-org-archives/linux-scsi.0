Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809D5C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239518AbiKQSgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiKQSgf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:36:35 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AA1F53
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:36:34 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id g62so2591664pfb.10
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:36:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mmXJwQRNVHGp1PPjICtnasAt06V6S6CeN/C6Fru7zmk=;
        b=Cxt++f6flQYblegJjK2p9YZdTjiSVHHRZCR1Kf1zyOStIqIZPSiOw/l6BFSvwnMl3Z
         2ZGwHA/28k11LcKBp5USO0tYuv7Gs/h2mxoRNrqnO/OtOOnxMiF7Oin/ggVYGrNdeRs0
         CuLQLIZb5Efc0EEsM6vKm79iDPXjIVpALr0lf7hv/Fj4GAolxX57KwguTyLo9sVg3SKB
         P7iA55bz9bSd1F9gaZDbxm9jTphTHatG5L3xT4ghelrldZtsf8l5Fh0/m9N61GeLAvlg
         x+N5uJBaM/0u3YKH19UPNigoQqZrPfvc3vP2j2M9R/RSmUR6QVw9PSdi0fC3N4BtZdx0
         tpIQ==
X-Gm-Message-State: ANoB5pn+1ZfusnSQvUtVTkFxLenWAwbxMXB/s8RBZxatr4IrkmDw+RoZ
        FW0lbpF/QHIMrFEfsmW7MRc=
X-Google-Smtp-Source: AA0mqf5Y6qDU4h07fNXCzhK1/UObBYrui5k6lgO5Zfwg3ektsEZ4Z/nkl/M97a4szEHcoSF6P/GnYA==
X-Received: by 2002:a63:f455:0:b0:476:e84b:ce4c with SMTP id p21-20020a63f455000000b00476e84bce4cmr3184357pgk.171.1668710194213;
        Thu, 17 Nov 2022 10:36:34 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7b21:f8f0:283b:9d21])
        by smtp.gmail.com with ESMTPSA id z11-20020aa79e4b000000b0056c0d129edfsm1479073pfq.121.2022.11.17.10.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:36:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH 1/2] scsi: alua: Revert "Move a scsi_device_put() call out of alua_check_vpd()"
Date:   Thu, 17 Nov 2022 10:36:25 -0800
Message-Id: <20221117183626.2656196-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221117183626.2656196-1-bvanassche@acm.org>
References: <20221117183626.2656196-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a bug in commit 0b25e17e9018 ("scsi: alua: Move a
scsi_device_put() call out of alua_check_vpd()"): that patch may cause
alua_rtpg_queue() callers to call scsi_device_put() even if that function
should not be called. Revert that commit to prepare for a different
solution.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Sachin Sant <sachinp@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Reported-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 23 ++++++++--------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 693cd827e138..bd4ee294f5c7 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -324,7 +324,6 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 	struct alua_port_group *pg, *old_pg = NULL;
 	bool pg_updated = false;
 	unsigned long flags;
-	bool put_sdev;
 
 	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
 	if (group_id < 0) {
@@ -374,14 +373,11 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 		list_add_rcu(&h->node, &pg->dh_list);
 	spin_unlock_irqrestore(&pg->lock, flags);
 
-	put_sdev = alua_rtpg_queue(rcu_dereference_protected(h->pg,
+	alua_rtpg_queue(rcu_dereference_protected(h->pg,
 						  lockdep_is_held(&h->pg_lock)),
 			sdev, NULL, true);
 	spin_unlock(&h->pg_lock);
 
-	if (put_sdev)
-		scsi_device_put(sdev);
-
 	if (old_pg)
 		kref_put(&old_pg->kref, release_port_group);
 
@@ -982,10 +978,9 @@ static void alua_rtpg_work(struct work_struct *work)
  *         RTPG already has been scheduled.
  *
  * Returns true if and only if alua_rtpg_work() will be called asynchronously.
- * That function is responsible for calling @qdata->fn(). If this function
- * returns true, the caller is responsible for invoking scsi_device_put(@sdev).
+ * That function is responsible for calling @qdata->fn().
  */
-static bool __must_check alua_rtpg_queue(struct alua_port_group *pg,
+static bool alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
 			    struct alua_queue_data *qdata, bool force)
 {
@@ -1024,6 +1019,8 @@ static bool __must_check alua_rtpg_queue(struct alua_port_group *pg,
 		else
 			kref_put(&pg->kref, release_port_group);
 	}
+	if (sdev)
+		scsi_device_put(sdev);
 
 	return true;
 }
@@ -1130,12 +1127,10 @@ static int alua_activate(struct scsi_device *sdev,
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	if (alua_rtpg_queue(pg, sdev, qdata, true)) {
-		scsi_device_put(sdev);
+	if (alua_rtpg_queue(pg, sdev, qdata, true))
 		fn = NULL;
-	} else {
+	else
 		err = SCSI_DH_DEV_OFFLINED;
-	}
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
@@ -1161,9 +1156,7 @@ static void alua_check(struct scsi_device *sdev, bool force)
 		return;
 	}
 	rcu_read_unlock();
-
-	if (alua_rtpg_queue(pg, sdev, NULL, force))
-		scsi_device_put(sdev);
+	alua_rtpg_queue(pg, sdev, NULL, force);
 	kref_put(&pg->kref, release_port_group);
 }
 
