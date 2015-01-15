From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Avoid crashing if device uses DIX but adapter does not support it
Date: Wed, 14 Jan 2015 20:18:29 -0500
Message-ID: <yq1fvbcvo2i.fsf@sermon.lab.mkp.net>
References: <1421270017-14103-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40736 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbbAOBSe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 20:18:34 -0500
In-Reply-To: <1421270017-14103-1-git-send-email-emilne@redhat.com> (Ewan
	D. Milne's message of "Wed, 14 Jan 2015 16:13:37 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan> This can happen if a multipathed device uses DIX and another path
Ewan> is added via an adapter that does not support it.  Multipath
Ewan> should not allow this path to be added,

No it shouldn't :)

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

s/T10 PI/DIX/

+			 */
+			WARN_ON_ONCE(1);
+			error = BLKPREP_KILL;
+			goto err_exit;
+		}
+
 		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
 
 		if (scsi_alloc_sgtable(prot_sdb, ivecs, is_mq)) {

Failing more gracefully is OK with me.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
