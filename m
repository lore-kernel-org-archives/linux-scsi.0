From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] hpsa: fix uninitialized variable
Date: Tue, 22 Nov 2016 16:05:38 +0100
Message-ID: <1479827138-2211-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755533AbcKVPFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Nov 2016 10:05:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

With the recent patch to hpsa this warning is issued:

drivers/scsi/hpsa.c: In function 'hpsa_slave_alloc':
drivers/scsi/hpsa.c:2033:5: error: 'sd' may be used uninitialized in this function [-Werror=maybe-uninitialized]

The patch that caused this is marked for stable backports,
so this one has to be backported on top as well.

Fixes: 4eb307f7b18d ("scsi: hpsa: use bus '3' for legacy HBA devices")

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5834117..ac11201 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2025,7 +2025,7 @@ static struct hpsa_scsi_dev_t *lookup_hpsa_scsi_dev(struct ctlr_info *h,
 
 static int hpsa_slave_alloc(struct scsi_device *sdev)
 {
-	struct hpsa_scsi_dev_t *sd;
+	struct hpsa_scsi_dev_t *sd = NULL;
 	unsigned long flags;
 	struct ctlr_info *h;
 
-- 
1.8.5.6

