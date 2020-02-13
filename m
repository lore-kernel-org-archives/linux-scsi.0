Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D02C3B18B
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 15:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 750762465D
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 15:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgBMPfD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 10:35:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:37680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388140AbgBMPcL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 10:32:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1CBEDB12D;
        Thu, 13 Feb 2020 15:32:09 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] ch: remove ch_mutex()
Date:   Thu, 13 Feb 2020 16:32:07 +0100
Message-Id: <20200213153207.123357-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200213153207.123357-1-hare@suse.de>
References: <20200213153207.123357-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ch_mutex() was introduced with a mechanical conversion, but as we
now have correct locking we can remove it altogether.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ch.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 9cbfb00ab950..4ea3b61f275f 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -44,7 +44,6 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_CHANGER_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MEDIUM_CHANGER);
 
-static DEFINE_MUTEX(ch_mutex);
 static int init = 1;
 module_param(init, int, 0444);
 MODULE_PARM_DESC(init, \
@@ -591,26 +590,22 @@ ch_open(struct inode *inode, struct file *file)
 	scsi_changer *ch;
 	int minor = iminor(inode);
 
-	mutex_lock(&ch_mutex);
 	spin_lock(&ch_index_lock);
 	ch = idr_find(&ch_index_idr, minor);
 
 	if (NULL == ch || !kref_get_unless_zero(&ch->ref)) {
 		spin_unlock(&ch_index_lock);
-		mutex_unlock(&ch_mutex);
 		return -ENXIO;
 	}
 	spin_unlock(&ch_index_lock);
 	if (scsi_device_get(ch->device)) {
 		kref_put(&ch->ref, ch_destroy);
-		mutex_unlock(&ch_mutex);
 		return -ENXIO;
 	}
 	/* Synchronize with ch_probe() */
 	mutex_lock(&ch->lock);
 	file->private_data = ch;
 	mutex_unlock(&ch->lock);
-	mutex_unlock(&ch_mutex);
 	return 0;
 }
 
-- 
2.16.4

