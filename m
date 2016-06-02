From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/14] scsi: Implement scsi_mq_resize_tags()
Date: Thu,  2 Jun 2016 16:39:11 +0200
Message-ID: <1464878356-42407-10-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990AbcFBOj1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:27 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add a function to resize the tagspace for a scsi host.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c  | 6 ++++++
 include/scsi/scsi_host.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e8fea8e..56c2724 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2133,6 +2133,12 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
 	blk_mq_free_tag_set(&shost->tag_set);
 }
 
+int scsi_mq_resize_tags(struct Scsi_Host *shost, int max_tags)
+{
+	return blk_mq_resize_tag_set(&shost->tag_set, max_tags);
+}
+EXPORT_SYMBOL_GPL(scsi_mq_resize_tags);
+
 /*
  * Function:    scsi_block_requests()
  *
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 2af2397..7cdfbd7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -826,6 +826,7 @@ static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
 
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
+extern int scsi_mq_resize_tags(struct Scsi_Host *, int);
 
 struct class_container;
 
-- 
1.8.5.6

