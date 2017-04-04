From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] scsi: Add template flag 'host_tagset'
Date: Tue,  4 Apr 2017 14:07:45 +0200
Message-ID: <1491307665-47656-3-git-send-email-hare@suse.de>
References: <1491307665-47656-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50240 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752545AbdDDMIN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Apr 2017 08:08:13 -0400
In-Reply-To: <1491307665-47656-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Omar Sandoval <osandov@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add a host template flag 'host_tagset' to enable the use of a
global tagmap for block-mq.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c  | 2 ++
 include/scsi/scsi_host.h | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba22866..00036cb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2193,6 +2193,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	shost->tag_set.cmd_size = cmd_size;
 	shost->tag_set.numa_node = NUMA_NO_NODE;
 	shost->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
+	if (shost->hostt->host_tagset)
+		shost->tag_set.flags |= BLK_MQ_F_GLOBAL_TAGS;
 	shost->tag_set.flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 	shost->tag_set.driver_data = shost;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3cd8c3b..dff3ec1 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -457,6 +457,11 @@ struct scsi_host_template {
 	unsigned no_async_abort:1;
 
 	/*
+	 * True if the host supports a host-wide tagspace
+	 */
+	unsigned host_tagset:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
-- 
1.8.5.6
