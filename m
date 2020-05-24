Return-Path: <SRS0=1EFY=7G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFBFC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C875620776
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387725AbgEXP62 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 May 2020 11:58:28 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43434 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgEXP62 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 May 2020 11:58:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2A01420423F;
        Sun, 24 May 2020 17:58:26 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id feIX13gAInlH; Sun, 24 May 2020 17:58:24 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 4E3E8204255;
        Sun, 24 May 2020 17:58:21 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC v2 4/6] scsi: improve scsi_device_lookup
Date:   Sun, 24 May 2020 11:58:12 -0400
Message-Id: <20200524155814.5895-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200524155814.5895-1-dgilbert@interlog.com>
References: <20200524155814.5895-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the __scsi_device_lookup() function is given a "ctl" (i.e. the
latter part of "hctl" tuple), improve the loop to find a matching
device (LU) in the given host. Rather than loop over all LUs in the
host, first loop over all targets to find a match on "ct" then, if
found, loop over all LUs in that target for a match on "l". These
nested loops are better since they don't visit LUs belonging to
non-matching targets. This improvement flows through to the locked
version of this function, namely scsi_device_lookup().

Remove a 21 year old comment by the author that no longer seem
relevant.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 0fb650aebcfb..9e7658aebdb7 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -35,7 +35,6 @@
  *
  *  Jiffies wrap fixes (host->resetting), 3 Dec 1998 Andrea Arcangeli
  *
- *  out_of_space hacks, D. Gilbert (dpg) 990608
  */
 
 #include <linux/module.h>
@@ -789,16 +788,31 @@ EXPORT_SYMBOL(scsi_device_lookup_by_target);
 struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
 		uint channel, uint id, u64 lun)
 {
-	unsigned long l_idx;
+	unsigned long l_idx, m_idx;
+	struct scsi_target *starg;
 	struct scsi_device *sdev;
 
-	xa_for_each_marked(&shost->__devices, l_idx, sdev,
+	if (xa_empty(&shost->__devices))
+		return NULL;
+	if (xa_empty(&shost->__targets))
+		goto inconsistent;
+	xa_for_each(&shost->__targets, l_idx, starg) {
+		if (!(starg->id == id && starg->channel == channel))
+			continue;
+		xa_for_each_marked(&starg->devices, m_idx, sdev,
+				   SCSI_XA_NON_SDEV_DEL) {
+			if (sdev->lun == lun)
+				return sdev;
+		}
+	}
+	return NULL;
+inconsistent:
+	xa_for_each_marked(&shost->__devices, m_idx, sdev,
 			   SCSI_XA_NON_SDEV_DEL) {
-		if (sdev->channel == channel && sdev->id == id &&
-				sdev->lun ==lun)
+		if (sdev->id == id && sdev->channel == channel &&
+		    sdev->lun == lun)
 			return sdev;
 	}
-
 	return NULL;
 }
 EXPORT_SYMBOL(__scsi_device_lookup);
-- 
2.25.1

