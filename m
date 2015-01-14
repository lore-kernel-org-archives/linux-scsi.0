From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] scsi: Avoid crashing if device uses DIX but adapter does not support it
Date: Wed, 14 Jan 2015 16:13:37 -0500
Message-ID: <1421270017-14103-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbbANVNk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2015 16:13:40 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t0ELDdY9028158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 16:13:40 -0500
Received: from emilne.csb ([10.18.25.104])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t0ELDduh002852
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 16:13:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

This can happen if a multipathed device uses DIX and another path is
added via an adapter that does not support it.  Multipath should not
allow this path to be added, but we should not depend upon that to avoid
crashing.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6d5c0b8..4f14f4a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1143,7 +1143,17 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 		struct scsi_data_buffer *prot_sdb = cmd->prot_sdb;
 		int ivecs, count;
 
-		BUG_ON(prot_sdb == NULL);
+		if (prot_sdb == NULL) {
+			/*
+			 * This can happen if someone (e.g. multipath)
+			 * queues a command to a device on an adapter
+			 * that does not support T10 PI.
+			 */
+			WARN_ON_ONCE(1);
+			error = BLKPREP_KILL;
+			goto err_exit;
+		}
+
 		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
 
 		if (scsi_alloc_sgtable(prot_sdb, ivecs, is_mq)) {
-- 
1.7.11.7

