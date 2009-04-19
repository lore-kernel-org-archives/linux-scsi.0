From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/4] libosd: potential ERR_PTR dereference in osd_initiator.c
Date: Sun, 19 Apr 2009 19:07:47 +0300
Message-ID: <49EB4C53.2000902@panasas.com>
References: <49EB4A42.9030502@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:8163 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756907AbZDSQJL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Apr 2009 12:09:11 -0400
In-Reply-To: <49EB4A42.9030502@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: Dan Carpenter <error27@gmail.com>


bio_map_kern() returns an ERR_PTR() not NULL.

Found by smatch (http://repo.or.cz/w/smatch.git).  Compile tested.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 2a5f077..76de889 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -612,9 +612,9 @@ static int _osd_req_list_objects(struct osd_request *or,
 
 	WARN_ON(or->in.bio);
 	bio = bio_map_kern(q, list, len, or->alloc_flags);
-	if (!bio) {
+	if (IS_ERR(bio)) {
 		OSD_ERR("!!! Failed to allocate list_objects BIO\n");
-		return -ENOMEM;
+		return PTR_ERR(bio);
 	}
 
 	bio->bi_rw &= ~(1 << BIO_RW);
-- 
1.6.2.1


