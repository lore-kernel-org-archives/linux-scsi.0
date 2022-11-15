Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415D3C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 22:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbiKOWtr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiKOWtN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 17:49:13 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D725B205D0
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 14:49:12 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so556718pjk.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 14:49:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nuFDiFaj8BoKa+mQIKw56aEJD0t2kR2pYbh6mGwaPkU=;
        b=wM1NF+M6WjEMHeVjDwbOj+bBH8UdxHM6wFH16axdCpkefE16hq7z6Epln9p9FkaLw9
         nc0+pczO7e6/78Yom7NmsL+KpScyueZ5c/72WjgYde6e/iXfukT/qr58sdDVxhubvJBD
         q3lBHSSFhXUO8ha348qdXTh85HA+6HgdI5e2BxYeOd24i+gwwGEFgWispT1MaOFwkfLG
         aRFdBF8MteEesRO8h8vUaKNgO8sXjRokPbwyj/QMRhQMh/hpr09W+hNSkYnv3eodwEZz
         PXp64FCNVpB2jQhgqZldSowlTETDgd/D2bAri9CXBWrzB0gBZza/hfc2sMqev05+lINx
         hbVQ==
X-Gm-Message-State: ANoB5pl3NVQTY7mW79haYS7DtJbn4aNLAwBdKahKxFJgwVJ3Ec41WsSW
        cPdiBRZQzbU0MR0SfB3osBq4+aTtwv0=
X-Google-Smtp-Source: AA0mqf7eiZVPevj9rI2IDpRcBnQSUaxMI1i981e8Vw9kGs3RX/iNKQeED1Vynv1RjtDjvnQ/Dt592w==
X-Received: by 2002:a17:903:32c8:b0:186:9c70:9b7d with SMTP id i8-20020a17090332c800b001869c709b7dmr6107487plr.3.1668552552211;
        Tue, 15 Nov 2022 14:49:12 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f13a:cdae:57:ff73])
        by smtp.gmail.com with ESMTPSA id ix10-20020a170902f80a00b00186b549cdc2sm10466594plb.157.2022.11.15.14.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 14:49:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: alua: Fix alua_rtpg_queue()
Date:   Tue, 15 Nov 2022 14:49:03 -0800
Message-Id: <20221115224903.2325529-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Modify alua_rtpg_queue() such that it only requests the caller to drop
the sdev reference if necessary. This patch fixes a recently introduced
regression.

Cc: Sachin Sant <sachinp@linux.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Fixes: 0b25e17e9018 ("scsi: alua: Move a scsi_device_put() call out of alua_check_vpd()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 31 ++++++++++++++--------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 693cd827e138..c1bf75673e89 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -102,7 +102,7 @@ struct alua_queue_data {
 
 static void alua_rtpg_work(struct work_struct *work);
 static bool alua_rtpg_queue(struct alua_port_group *pg,
-			    struct scsi_device *sdev,
+			    struct scsi_device *sdev, bool *put_sdev,
 			    struct alua_queue_data *qdata, bool force);
 static void alua_check(struct scsi_device *sdev, bool force);
 
@@ -374,9 +374,9 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 		list_add_rcu(&h->node, &pg->dh_list);
 	spin_unlock_irqrestore(&pg->lock, flags);
 
-	put_sdev = alua_rtpg_queue(rcu_dereference_protected(h->pg,
+	alua_rtpg_queue(rcu_dereference_protected(h->pg,
 						  lockdep_is_held(&h->pg_lock)),
-			sdev, NULL, true);
+			sdev, &put_sdev, NULL, true);
 	spin_unlock(&h->pg_lock);
 
 	if (put_sdev)
@@ -983,17 +983,23 @@ static void alua_rtpg_work(struct work_struct *work)
  *
  * Returns true if and only if alua_rtpg_work() will be called asynchronously.
  * That function is responsible for calling @qdata->fn(). If this function
- * returns true, the caller is responsible for invoking scsi_device_put(@sdev).
+ * sets *put_sdev to true, the caller is responsible for calling
+ * scsi_device_put(@sdev).
  */
-static bool __must_check alua_rtpg_queue(struct alua_port_group *pg,
-			    struct scsi_device *sdev,
+static bool alua_rtpg_queue(struct alua_port_group *pg,
+			    struct scsi_device *sdev, bool *put_sdev,
 			    struct alua_queue_data *qdata, bool force)
 {
 	int start_queue = 0;
 	unsigned long flags;
+
+	*put_sdev = false;
+
 	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
 		return false;
 
+	*put_sdev = true;
+
 	spin_lock_irqsave(&pg->lock, flags);
 	if (qdata) {
 		list_add_tail(&qdata->entry, &pg->rtpg_list);
@@ -1020,7 +1026,7 @@ static bool __must_check alua_rtpg_queue(struct alua_port_group *pg,
 	if (start_queue) {
 		if (queue_delayed_work(kaluad_wq, &pg->rtpg_work,
 				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS)))
-			sdev = NULL;
+			*put_sdev = false;
 		else
 			kref_put(&pg->kref, release_port_group);
 	}
@@ -1108,6 +1114,7 @@ static int alua_activate(struct scsi_device *sdev,
 	int err = SCSI_DH_OK;
 	struct alua_queue_data *qdata;
 	struct alua_port_group *pg;
+	bool put_sdev;
 
 	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
 	if (!qdata) {
@@ -1130,8 +1137,9 @@ static int alua_activate(struct scsi_device *sdev,
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	if (alua_rtpg_queue(pg, sdev, qdata, true)) {
-		scsi_device_put(sdev);
+	if (alua_rtpg_queue(pg, sdev, &put_sdev, qdata, true)) {
+		if (put_sdev)
+			scsi_device_put(sdev);
 		fn = NULL;
 	} else {
 		err = SCSI_DH_DEV_OFFLINED;
@@ -1153,6 +1161,7 @@ static void alua_check(struct scsi_device *sdev, bool force)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group *pg;
+	bool put_sdev;
 
 	rcu_read_lock();
 	pg = rcu_dereference(h->pg);
@@ -1161,8 +1170,8 @@ static void alua_check(struct scsi_device *sdev, bool force)
 		return;
 	}
 	rcu_read_unlock();
-
-	if (alua_rtpg_queue(pg, sdev, NULL, force))
+	alua_rtpg_queue(pg, sdev, &put_sdev, NULL, force);
+	if (put_sdev)
 		scsi_device_put(sdev);
 	kref_put(&pg->kref, release_port_group);
 }
