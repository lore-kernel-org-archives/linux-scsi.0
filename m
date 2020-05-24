Return-Path: <SRS0=1EFY=7G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E11C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8210A20776
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387737AbgEXP6a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 May 2020 11:58:30 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43438 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387636AbgEXP63 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 May 2020 11:58:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9DB42204248;
        Sun, 24 May 2020 17:58:27 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ayn6TEaUUNRT; Sun, 24 May 2020 17:58:26 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 7255020423B;
        Sun, 24 May 2020 17:58:23 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC v2 6/6] scsi: count number of targets
Date:   Sun, 24 May 2020 11:58:14 -0400
Message-Id: <20200524155814.5895-7-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200524155814.5895-1-dgilbert@interlog.com>
References: <20200524155814.5895-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If less than 2 used to flatten iteration in __scsi_device_lookup().
The majority of hosts will have 1 target and 1 LU (device).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi.c      | 12 ++++--------
 drivers/scsi/scsi_scan.c |  5 ++++-
 include/scsi/scsi_host.h |  1 +
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1b1fc8d4e5c2..6acd85ce21dd 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -557,10 +557,6 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 	unsigned long flags, l_idx;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (xa_empty(&shost->__devices)) {
-		next = NULL;
-		goto unlock;
-	}
 	do {
 		if (!next) {	/* get first element iff first iteration */
 			l_idx = 0;
@@ -578,7 +574,6 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 				break;
 		}
 	} while (next);
-unlock:
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (prev)
@@ -818,8 +813,9 @@ struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
 
 	if (xa_empty(&shost->__devices))
 		return NULL;
-	if (xa_empty(&shost->__targets))
-		goto inconsistent;
+	if (shost->num_targets < 2)
+		goto flat_iteration;
+
 	xa_for_each(&shost->__targets, l_idx, starg) {
 		if (!(starg->id == id && starg->channel == channel))
 			continue;
@@ -830,7 +826,7 @@ struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
 		}
 	}
 	return NULL;
-inconsistent:
+flat_iteration:
 	xa_for_each_marked(&shost->__devices, m_idx, sdev,
 			   SCSI_XA_NON_SDEV_DEL) {
 		if (sdev->id == id && sdev->channel == channel &&
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c055ee083ea9..d665da2b01a4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -320,7 +320,9 @@ static void scsi_target_destroy(struct scsi_target *starget)
 		shost->hostt->target_destroy(starget);
 	/* XARRAY: was list_del_init(); why the _init ?  */
 	e_starg = xa_erase(&shost->__targets, starget->sh_idx);
-	if (e_starg != starget)
+	if (e_starg == starget)
+		--shost->num_targets;
+	else
 		pr_err("%s: bad xa_erase()\n", __func__);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(dev);
@@ -465,6 +467,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		return NULL;
 	}
 	starget->sh_idx = u_idx;
+	++shost->num_targets;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
 	transport_setup_device(dev);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0e94b1feb8e9..f49298a4c452 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -528,6 +528,7 @@ struct Scsi_Host {
 	 */
 	struct xarray		__devices;	/* array of scsi_debug objs */
 	struct xarray		__targets;	/* array of scsi_target objs */
+	int			num_targets;	/* modified under host_lock */
 
 	struct list_head	starved_list;
 
-- 
2.25.1

