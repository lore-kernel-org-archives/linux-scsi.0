From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/9] dm-mpath: check kstrdup return value in parse_hw_handler
Date: Thu, 30 Apr 2015 19:32:23 +0200
Message-ID: <1430415151-30948-2-git-send-email-hch@lst.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbbD3Rdp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 13:33:45 -0400
In-Reply-To: <1430415151-30948-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6395347..01e5f8e 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -732,6 +732,9 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 		return 0;
 
 	m->hw_handler_name = kstrdup(dm_shift_arg(as), GFP_KERNEL);
+	if (!m->hw_handler_name)
+		return -ENOMEM;
+
 	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_name),
 				     "scsi_dh_%s", m->hw_handler_name)) {
 		ti->error = "unknown hardware handler type";
-- 
1.9.1

