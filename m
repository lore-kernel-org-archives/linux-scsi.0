Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CBDC47425
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 08:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B82B2074A
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 08:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgI3IDD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 04:03:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:60976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbgI3IDC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 04:03:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 72C47AFAA;
        Wed, 30 Sep 2020 08:03:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] scsi_dh_alua: return BLK_STS_AGAIN for ALUA transitioning state
Date:   Wed, 30 Sep 2020 10:02:54 +0200
Message-Id: <20200930080256.90964-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200930080256.90964-1-hare@suse.de>
References: <20200930080256.90964-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the ALUA state indicates transitioning we should not retry
the command immediately, but rather complete the command with
BLK_STS_AGAIN to signal the completion handler that it might
be retried.
This allows multipathing to redirect the command to another path
if possible, and avoid stalls during lengthy transitioning times.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 drivers/scsi/scsi_lib.c                    | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 308bda2e9c00..a68222e324e9 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1092,7 +1092,7 @@ static blk_status_t alua_prep_fn(struct scsi_device *sdev, struct request *req)
 	case SCSI_ACCESS_STATE_LBA:
 		return BLK_STS_OK;
 	case SCSI_ACCESS_STATE_TRANSITIONING:
-		return BLK_STS_RESOURCE;
+		return BLK_STS_AGAIN;
 	default:
 		req->rq_flags |= RQF_QUIET;
 		return BLK_STS_IOERR;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f0ee11dc07e4..b628aa0d824c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1726,6 +1726,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		    scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
+	case BLK_STS_AGAIN:
+		scsi_req(req)->result = DID_BUS_BUSY << 16;
+		if (req->rq_flags & RQF_DONTPREP)
+			scsi_mq_uninit_cmd(cmd);
+		break;
 	default:
 		if (unlikely(!scsi_device_online(sdev)))
 			scsi_req(req)->result = DID_NO_CONNECT << 16;
-- 
2.16.4

