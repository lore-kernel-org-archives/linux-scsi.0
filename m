Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA67C3F2D0
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51E912467F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CebjJu05"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgCJJrZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:47:25 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26528 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgCJJrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 05:47:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583833652; x=1615369652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pqB/3oPl/1fWSriQZpKfkdGTuPJZ67HVd0K1UzVhqTc=;
  b=CebjJu05B9IMZPx9OkKFDWOyZftvTAsIey5/75sh6YllxndpU07PE4+P
   eoAW/vRC9JJfq297978zGt2ugs/ZbMXOGU04tcPE1yWNEYjwESxSvF0EE
   9XH4fwIu5VROw5jCFV9fdE8Zb8o3fPrj7HI5KCoM01v9f8Oh3Yqg8nPmX
   oY8mojaBFVXlnTQJpTn5gGYsNctM+li1JaOvXXB6qL3y6B3VoYaqoDCu1
   plZx9/Me3CKVtQ45FkxfFbMpEX+LiXKndmaTJlFQK/AO0lcAcpY3WjJvJ
   w11b81KWLlywl+X83J5zb7hBmpe1z4O1avv/SV3CCOPw5dSGH86F7bNkL
   Q==;
IronPort-SDR: ckdZpa0zJLLy2RL7u1toGjwqkeJAikfLav2VH8FKLnU0bSV9igBukSa4mBa5Tul/aScG//+YxK
 qnfw9ROXUTobDypV1OCo4XnsKC4pckbv1s/XVGIsT24phsOPkcVugNxXD7A7Lp1ynIkDIBiyP9
 wVcudpECQLu9SUSES+Hw6YV3B+K59npaa+bmMY4oEki7p/kn+GLqEUZ2YdozYs+HDLhjk43DZJ
 8RaJRB2NUUaHBcYBzIWgS+BJMjc9mNGGe3egwzhq3TpNXDkLleUzXu/9u1zh6K7d+Zhb3WfaS8
 TC4=
X-IronPort-AV: E=Sophos;i="5.70,536,1574092800"; 
   d="scan'208";a="234082798"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2020 17:47:31 +0800
IronPort-SDR: dHBU6kzNfYf16mQjUAYaluCQ8i4vwGELhTd3Y0hJY3csFp1V0UvrkKX4//2xRIOIOiMqwGsZPE
 mN/Ibqe8KRUuogYmjwY78KnJ+BrYQKCAtRe48pIp2iGkWKoOQ9Km3Li9ORLmJzG6fU5LCyvZ0u
 9MgQzIpcWTa51T8r8y+h8yCzf1QEkekqrqZxNcFJsJRw9qToSbOIGp1waCCqXdQBW7NcL51edg
 FEos/epKJ0Q4PgSvinx0f5skgSCnH05TeclUJgl7YUtzC4ANdTY+BVDSQsJqyvkCfso2Z9S1Ai
 SpbilabETWrFwkYlHICK+lKZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 02:39:04 -0700
IronPort-SDR: 0l51rYSZ/52f+/VoROrDouuBTc3i+alL24k7q8VvrCJ2HeEv5we53SEtMl5nnUuupI+kp3Xx78
 wabpi44vZV7GmwOPXeN6wg6P8x/5cK35OFg1sxNiOOuoOFrUsWzsWIPdzfgjNQmh6iVPI/cjuy
 09KS2WFqhIST4gwhmFkpYlT8+U2nC07LY20vMwYtJ+GRP8MqI7n3yEIMJwR/HvFw92G4zOmOjc
 WoSaJ3WzMoGgPyBZAq6cDA90bJthc2Tqjh0D4Aauyl/a8lJWnIJlJNjYABo66JFDvK6HblYQHB
 Sfc=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2020 02:47:23 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 08/11] block: delay un-dispatchable request
Date:   Tue, 10 Mar 2020 18:46:50 +0900
Message-Id: <20200310094653.33257-9-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a LLDD can't dispatch a request to a specific zone, it will return
BLK_STS_ZONE_RESOURCE indicating this request needs to be delayed, e.g.
because the zone it will be dispatched to is still write-locked.

If this happens set the request aside in a local list to continue trying
dispatching requests such as READ requests or a WRITE/ZONE_APPEND
requests targetting other zones. This way we can still keep a high queue
depth without starving other requests even if one request can't be
served due to zone write-locking.

All requests put aside in the local list due to BLK_STS_ZONE_RESOURCE
are placed back at the head of the dispatch list for retrying the next
time the device queues are run again.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-mq.c          | 27 +++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c |  1 +
 2 files changed, 28 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f7ab75ef4d0e..89eb062825a7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1195,6 +1195,19 @@ static void blk_mq_handle_dev_resource(struct request *rq,
 	__blk_mq_requeue_request(rq);
 }
 
+static void blk_mq_handle_zone_resource(struct request *rq,
+					struct list_head *zone_list)
+{
+	/*
+	 * If we end up here it is because we cannot dispatch a request to a
+	 * specific zone due to LLD level zone-write locking or other zone
+	 * related resource not being available. In this case, set the request
+	 * aside in zone_list for retrying it later.
+	 */
+	list_add(&rq->queuelist, zone_list);
+	__blk_mq_requeue_request(rq);
+}
+
 /*
  * Returns true if we did some work AND can potentially do more.
  */
@@ -1206,6 +1219,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 	bool no_tag = false;
 	int errors, queued;
 	blk_status_t ret = BLK_STS_OK;
+	LIST_HEAD(zone_list);
 
 	if (list_empty(list))
 		return false;
@@ -1264,6 +1278,16 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
 			blk_mq_handle_dev_resource(rq, list);
 			break;
+		} else if (ret == BLK_STS_ZONE_RESOURCE) {
+			/*
+			 * Move the request to zone_list and keep going through
+			 * the dipatch list to find more requests the drive
+			 * accepts.
+			 */
+			blk_mq_handle_zone_resource(rq, &zone_list);
+			if (list_empty(list))
+				break;
+			continue;
 		}
 
 		if (unlikely(ret != BLK_STS_OK)) {
@@ -1275,6 +1299,9 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		queued++;
 	} while (!list_empty(list));
 
+	if (!list_empty(&zone_list))
+		list_splice_tail_init(&zone_list, list);
+
 	hctx->dispatched[queued_to_index(queued)]++;
 
 	/*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41fa54c..ea327f320b7f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1706,6 +1706,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
+	case BLK_STS_ZONE_RESOURCE:
 		if (atomic_read(&sdev->device_busy) ||
 		    scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
-- 
2.24.1

