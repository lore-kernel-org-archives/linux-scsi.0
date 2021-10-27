Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692FEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 22:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3BC610CB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 22:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhJ0WjB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 18:39:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49674 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhJ0WjB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2021 18:39:01 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211027223633epoutp0101d951b26a2e6ca31d8968fd1bbfd2db~yBCoHudQa1102511025epoutp01g
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 22:36:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211027223633epoutp0101d951b26a2e6ca31d8968fd1bbfd2db~yBCoHudQa1102511025epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635374193;
        bh=dRzUM7qo4C+5CUwqX2psGsQ+m68DYYRc41OJ7o055vs=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=FhG3qRqzlEzLt3J81UtNATnNiJPv1vtNdTXj6kLveL2T2QVtUztW0RAHT3NMqWcry
         N20XfYkqyQqUWCWyZVj9/XEvoXdnNFlkotHfEW/MbzKWnKxMhaMSqb25NU+V7IlzfW
         /GdzLv/L6RbrJTln/9i9iZCuKJHI9jTApqINdv+U=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211027223632epcas2p18cdc62a75b8919c3e6c8a2628252a0c9~yBCm9eQL00292902929epcas2p1W;
        Wed, 27 Oct 2021 22:36:32 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.100]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Hfk7S26DHz4x9Pr; Wed, 27 Oct
        2021 22:36:20 +0000 (GMT)
X-AuditID: b6c32a46-a25ff70000002722-76-6179d4631d28
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        67.65.10018.364D9716; Thu, 28 Oct 2021 07:36:20 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
Date:   Thu, 28 Oct 2021 07:36:19 +0900
X-CMS-MailID: 20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmhW7KlcpEg2lTmC0ezNvGZvHy51U2
        i2kffjJbvDykabHqQbjFnLMNTBaLbmxjsjh+8h2jxeVdc9gsuq/vYLNYfvwfkwO3x+Ur3h47
        Z91l95iw6ACjx8ent1g8+rasYvT4vEnOo/1AN1MAe1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8
        c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QhUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OIS
        W6XUgpScAvMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IyFLx6wFZwWrPi1fRtLA+Npvi5GTg4J
        AROJOc1PWLoYuTiEBHYwSnTfecXcxcjBwSsgKPF3hzBIjbCAk0Tj9smsILaQgJLE+ouz2CHi
        ehK3Hq5hBLHZBHQkpp+4zw4yR0TgDZPE0oNHWUASzAJ1Ervn/GGDWMYrMaP9KQuELS2xfflW
        RghbQ+LHsl5mCFtU4ubqt+ww9vtj86FqRCRa752FqhGUePBzN1RcUuLY7g9MEHa9xNY7vxhB
        jpAQ6GGUOLzzFitEQl/iWsdGsMW8Ar4S21tPgdksAqoSyx9ehRrkIrF07R9WiKPlJba/nQMO
        CGYBTYn1u/RBTAkBZYkjt1hgXmnY+Jsdnc0swCfRcfgvXHzHvCdQp6lJrPu5nglijIzErXmM
        ExiVZiECehaStbMQ1i5gZF7FKJZaUJybnlpsVGAEj9vk/NxNjOC0quW2g3HK2w96hxiZOBgP
        MUpwMCuJ8F6eV54oxJuSWFmVWpQfX1Sak1p8iNEU6OGJzFKiyfnAxJ5XEm9oYmlgYmZmaG5k
        amCuJM5rKZqdKCSQnliSmp2aWpBaBNPHxMEp1cDkN+dY4jeltQpfjOTvhk8tUlJeVl4wwSLy
        ZUi3kKDF9dQFQpJzauqthZ5I/vTsn8bx3zB16zHeHVtfe3KEd87wv97CFLTiO4O8Q7f6lLi8
        Hrvog/xNrRXPblRNLDO6W8bYciHBL1PSkmWlp9z+549+lB8Wj4v9NW1Ca0zHW4lPFmcvyXB+
        lvi277H6qXaGjyGbdXRP6WZkX5evs25v3XBpLrNozrLPeVu+Ce+9HB/b53xtlrfjvovz7Bht
        /p75zCKZtf1QcuXenYpxl5eyxszjvfFF2uUS66q452rdz0WjZki0N3c4uDz89qL23J/bFwpT
        LdpzD/30m15n8XluX0OzzpvX7oEfuGOXaFimflJiKc5INNRiLipOBADoXoNKNAQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch addresses the issue of using the wrong API to create a
pre_request for HPB READ.
HPB READ candidate that require a pre-request will try to allocate a
pre-request only during request_timeout_ms (default: 0). Otherwise, it is
passed as normal READ, so deadlock problem can be resolved.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 11 +++++------
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 02fb51ae8b25..3117bd47d762 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -548,8 +548,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
 				 read_id);
 	rq->cmd_len = scsi_command_size(rq->cmd);
 
-	if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
-		return -EAGAIN;
+	blk_execute_rq_nowait(NULL, req, true, ufshpb_pre_req_compl_fn);
 
 	hpb->stats.pre_req_cnt++;
 
@@ -2315,19 +2314,19 @@ struct attribute_group ufs_sysfs_hpb_param_group = {
 static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
 {
 	struct ufshpb_req *pre_req = NULL, *t;
-	int qd = hpb->sdev_ufs_lu->queue_depth / 2;
 	int i;
 
 	INIT_LIST_HEAD(&hpb->lh_pre_req_free);
 
-	hpb->pre_req = kcalloc(qd, sizeof(struct ufshpb_req), GFP_KERNEL);
-	hpb->throttle_pre_req = qd;
+	hpb->pre_req = kcalloc(HPB_INFLIGHT_PRE_REQ, sizeof(struct ufshpb_req),
+			       GFP_KERNEL);
+	hpb->throttle_pre_req = HPB_INFLIGHT_PRE_REQ;
 	hpb->num_inflight_pre_req = 0;
 
 	if (!hpb->pre_req)
 		goto release_mem;
 
-	for (i = 0; i < qd; i++) {
+	for (i = 0; i < HPB_INFLIGHT_PRE_REQ; i++) {
 		pre_req = hpb->pre_req + i;
 		INIT_LIST_HEAD(&pre_req->list_req);
 		pre_req->req = NULL;
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index a79e07398970..411a6d625f53 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -50,6 +50,7 @@
 #define HPB_RESET_REQ_RETRIES			10
 #define HPB_MAP_REQ_RETRIES			5
 #define HPB_REQUEUE_TIME_MS			0
+#define HPB_INFLIGHT_PRE_REQ			4
 
 #define HPB_SUPPORT_VERSION			0x200
 #define HPB_SUPPORT_LEGACY_VERSION		0x100
-- 
2.25.1

