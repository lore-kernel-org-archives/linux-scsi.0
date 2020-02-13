Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044F5C2BA83
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 15:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA50D20675
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 15:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgBMPfF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 10:35:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:37682 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388141AbgBMPcK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 10:32:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1D1E3B137;
        Thu, 13 Feb 2020 15:32:09 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] ch: synchronize ch_probe() and ch_open()
Date:   Thu, 13 Feb 2020 16:32:06 +0100
Message-Id: <20200213153207.123357-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200213153207.123357-1-hare@suse.de>
References: <20200213153207.123357-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'ch' device node is created before the configuration is
being read in, which leads to a race window when ch_open() is called
before that.
To avoid any races we should be taking the device mutex during
ch_readconfig() and ch_init_elem(), and also during ch_open().
That ensures ch_probe is finished before ch_open() completes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ch.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 974afb4bd5fe..9cbfb00ab950 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -606,7 +606,10 @@ ch_open(struct inode *inode, struct file *file)
 		mutex_unlock(&ch_mutex);
 		return -ENXIO;
 	}
+	/* Synchronize with ch_probe() */
+	mutex_lock(&ch->lock);
 	file->private_data = ch;
+	mutex_unlock(&ch->lock);
 	mutex_unlock(&ch_mutex);
 	return 0;
 }
@@ -949,6 +952,9 @@ static int ch_probe(struct device *dev)
 		goto remove_idr;
 	}
 
+	mutex_init(&ch->lock);
+	kref_init(&ch->ref);
+	ch->device = sd;
 	class_dev = device_create(ch_sysfs_class, dev,
 				  MKDEV(SCSI_CHANGER_MAJOR, ch->minor), ch,
 				  "s%s", ch->name);
@@ -959,15 +965,16 @@ static int ch_probe(struct device *dev)
 		goto put_device;
 	}
 
-	mutex_init(&ch->lock);
-	kref_init(&ch->ref);
-	ch->device = sd;
+	mutex_lock(&ch->lock);
 	ret = ch_readconfig(ch);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&ch->lock);
 		goto destroy_dev;
+	}
 	if (init)
 		ch_init_elem(ch);
 
+	mutex_unlock(&ch->lock);
 	dev_set_drvdata(dev, ch);
 	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
 
-- 
2.16.4

