Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E2ECA9ED8
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78230222CA
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbfKDJCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:57256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728267AbfKDJCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B819B4BD;
        Mon,  4 Nov 2019 09:02:11 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 46/52] scsi_ioctl: return error code when blk_rq_map_kern() fails
Date:   Mon,  4 Nov 2019 10:01:45 +0100
Message-Id: <20191104090151.129140-47-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The callers of sg_scsi_ioctl() already need to check for
negative return values, so we can drop the usage of DRIVER_ERROR
and return the error from blk_rq_map_kern() instead.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/scsi_ioctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index f5e0ad65e86a..1ab1b8d9641c 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -485,9 +485,10 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 		break;
 	}
 
-	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO)) {
-		err = DRIVER_ERROR << 24;
-		goto error;
+	if (bytes) {
+		err = blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO);
+		if (err)
+			goto error;
 	}
 
 	blk_execute_rq(q, disk, rq, 0);
-- 
2.16.4

