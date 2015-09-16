From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 04/17] Update the ch driver to use idr helper functions.
Date: Wed, 16 Sep 2015 10:50:22 -0700
Message-ID: <1a6d624b850fa7543c9c1fcca647ddb654954296.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbbIPRvO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Sep 2015 13:51:14 -0400
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, hare@suse.com, jthumshirn@suse.de, hch@infradead.org, Lee Duncan <lduncan@suse.com>

Note: when allocating an index, in the error case,
where the just-allocated index has to be released,
the required locking around the index removal was
not present, so this conversion has the side effect
of adding locking for that error condition. This
should close a possible race condition that could
have resulted in duplicate index allocation.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/ch.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index dad959fcf6d8..2edf1f8883f9 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -909,12 +909,8 @@ static int ch_probe(struct device *dev)
 	if (NULL == ch)
 		return -ENOMEM;
 
-	idr_preload(GFP_KERNEL);
-	spin_lock(&ch_index_lock);
-	ret = idr_alloc(&ch_index_idr, ch, 0, CH_MAX_DEVS + 1, GFP_NOWAIT);
-	spin_unlock(&ch_index_lock);
-	idr_preload_end();
-
+	ret = idr_get_index_in_range(&ch_index_idr, &ch_index_lock, ch,
+				     0, CH_MAX_DEVS + 1);
 	if (ret < 0) {
 		if (ret == -ENOSPC)
 			ret = -ENODEV;
@@ -945,7 +941,7 @@ static int ch_probe(struct device *dev)
 
 	return 0;
 remove_idr:
-	idr_remove(&ch_index_idr, ch->minor);
+	idr_put_index(&ch_index_idr, &ch_index_lock, ch->minor);
 free_ch:
 	kfree(ch);
 	return ret;
@@ -955,9 +951,7 @@ static int ch_remove(struct device *dev)
 {
 	scsi_changer *ch = dev_get_drvdata(dev);
 
-	spin_lock(&ch_index_lock);
-	idr_remove(&ch_index_idr, ch->minor);
-	spin_unlock(&ch_index_lock);
+	idr_put_index(&ch_index_idr, &ch_index_lock, ch->minor);
 
 	device_destroy(ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR,ch->minor));
 	kfree(ch->dt);
-- 
2.1.4

