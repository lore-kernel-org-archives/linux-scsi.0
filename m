From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sg: reset 'res_in_use' after unlinking reserved array
Date: Mon, 24 Apr 2017 10:26:36 +0200
Message-ID: <1493022396-107620-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32962 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1166636AbdDXI0j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Apr 2017 04:26:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Once the reserved page array is unused we can reset the
'res_in_use' state; here we can do a lazy update without
holding the mutex as we only need to check against
concurrent access, not concurrent release.

Fixes: 1bc0eb0 ("scsi: sg: protect accesses to 'reserved' page array")
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8147147..06503c1 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2056,6 +2056,8 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	req_schp->page_order = 0;
 	req_schp->sglist_len = 0;
 	srp->res_used = 0;
+	/* Called without mutex lock to avoid deadlock */
+	sfp->res_in_use = 0;
 }
 
 static Sg_request *
-- 
1.8.5.6
