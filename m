From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: sg: don't return bogus Sg_requests
Date: Wed, 10 May 2017 09:41:39 +0200
Message-ID: <20170510074139.11179-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Andrey Konovalov <andreyknvl@google.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

If the list search in sg_get_rq_mark() fails to find a valid request, we
return a bogus element. This then can later lead to a GPF in sg_remove_scat().

So don't return bogus Sg_requests in sg_get_rq_mark() but NULL in case the
list search doesn't find a valid request.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0a38ba01b7b4..abfde23fa186 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2078,7 +2078,7 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
 		}
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return resp;
+	return (resp->done == 2) ? resp : NULL;
 }
 
 /* always adds to end of list */
-- 
2.12.0
