From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/22] fcoe: inhibit writing invalid values into the 'enabled' attribute
Date: Wed,  3 Aug 2016 15:13:11 +0200
Message-ID: <1470230002-37737-12-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbcHCNNf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:35 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The 'enabled' sysfs attribute only accepts the values '0' and '1',
so we should error out any other values.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe_sysfs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 9e6baac..9cf3d56 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -335,16 +335,24 @@ static ssize_t store_ctlr_enabled(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct fcoe_ctlr_device *ctlr = dev_to_ctlr(dev);
+	bool enabled;
 	int rc;
 
+	if (*buf == '1')
+		enabled = true;
+	else if (*buf == '0')
+		enabled = false;
+	else
+		return -EINVAL;
+
 	switch (ctlr->enabled) {
 	case FCOE_CTLR_ENABLED:
-		if (*buf == '1')
+		if (enabled)
 			return count;
 		ctlr->enabled = FCOE_CTLR_DISABLED;
 		break;
 	case FCOE_CTLR_DISABLED:
-		if (*buf == '0')
+		if (!enabled)
 			return count;
 		ctlr->enabled = FCOE_CTLR_ENABLED;
 		break;
-- 
1.8.5.6

