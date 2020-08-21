Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E932C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 15:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58866207DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 15:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgHUPnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 11:43:19 -0400
Received: from smtp.infotech.no ([82.134.31.41]:48345 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgHUPme (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 11:42:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2D19620425A;
        Fri, 21 Aug 2020 17:42:18 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Q4tdIIRPFXZh; Fri, 21 Aug 2020 17:42:16 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id D026420426C;
        Fri, 21 Aug 2020 17:42:15 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        john.garry@huawei.com
Subject: [PATCH v6 08/10] scsi: simplify scsi_target() inline
Date:   Fri, 21 Aug 2020 11:42:02 -0400
Message-Id: <20200821154204.9298-9-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821154204.9298-1-dgilbert@interlog.com>
References: <20200821154204.9298-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A review of the code indicates this scsi_device.h comment for
a struct scsi_device member is misleading:
    struct scsi_target *sdev_target; /* used only for single_lun */

sdev_target is set once in scsi_alloc_sdev() to the new sdev's
parent and not altered thereafter. This in turn implies that the
often-used scsi_target(struct scsi_device *sdev) inline function
is going the long way around finding its parent. Simplify it and
rework that comment.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/scsi/scsi_device.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5292787246ca..b0ba534b6f06 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -141,7 +141,7 @@ struct scsi_device {
 	struct scsi_vpd __rcu *vpd_pg80;
 	struct scsi_vpd __rcu *vpd_pg89;
 	unsigned char current_tag;	/* current tag */
-	struct scsi_target      *sdev_target;   /* used only for single_lun */
+	struct scsi_target      *sdev_target;   /* parent of this object */
 
 	blist_flags_t		sdev_bflags; /* black/white flags as also found in
 				 * scsi_devinfo.[hc]. For now used only to
@@ -337,7 +337,7 @@ static inline struct Scsi_Host *starget_to_shost(struct scsi_target *starg)
 #define to_scsi_target(d)	container_of(d, struct scsi_target, dev)
 static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
 {
-	return to_scsi_target(sdev->sdev_gendev.parent);
+	return sdev->sdev_target;
 }
 #define transport_class_to_starget(class_dev) \
 	to_scsi_target(class_dev->parent)
-- 
2.25.1

