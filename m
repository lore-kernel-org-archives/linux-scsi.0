Return-Path: <SRS0=Lz4Y=DB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC4EC2D0A8
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 00:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4655212CC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 00:19:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I9BYGfP6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIXAT0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 20:19:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48672 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAT0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2020 20:19:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O0FDcT021047;
        Thu, 24 Sep 2020 00:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=lzYUIq+tEc6xTX0bbMcY/R7xOwvOwpJ8gk9Ayo/019g=;
 b=I9BYGfP67uGWTPJKHj/jcUWqzk9LHV3w05P6MhP+aBCQZIoH7OVUcyuyEsJgYu/oA6HR
 y6U4SjrYZ46DIN/z70hgAi4KLSYYerKqBIosgl64zw0zyJZi7TIA/rbov3eLArDPtJH4
 gNJMKP5FrLvyHceOY02OOLtiOJly10W9J8b0lY32hM1GtYpKDv/xqtFq1JlssHxX1DQQ
 PgRnZkJz5dBRjIj5x1+O6n9M1ihA47bHQoDdbK1MIa0PlIx2/VNhAUKnGua3vO2unc6z
 BqfbOiKROkuha4UfAdk+UFo5XG4twV7y7Pw1UCWU6DyG7XW0DkcOTDD/LRheJiCqdNix rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33q5rgkra7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 00:19:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O0ERD2095741;
        Thu, 24 Sep 2020 00:19:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 33nujq7trm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 00:19:21 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08O0JLhZ105613;
        Thu, 24 Sep 2020 00:19:21 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by aserp3030.oracle.com with ESMTP id 33nujq7tr8-1;
        Thu, 24 Sep 2020 00:19:21 +0000
From:   john.p.donnelly@oracle.com
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, john.p.donnelly@oracle.com,
        michael.christie@oracle.com, bstroesser@ts.fujitsu.com
Subject: [PATCH ] scsi: page warning: 'page' may be used uninitialized
Date:   Wed, 23 Sep 2020 17:19:20 -0700
Message-Id: <20200924001920.43594-1-john.p.donnelly@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1011 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: John Donnelly <john.p.donnelly@oracle.com>

corrects: drivers/target/target_core_user.c:688:6: warning: 'page' may be used
uninitialized

Fixes: 3c58f737231e ("scsi: target: tcmu: Optimize use of
flush_dcache_page")

To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9b7592350502..86b28117787e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -681,7 +681,7 @@ static void scatter_data_area(struct tcmu_dev *udev,
 	void *from, *to = NULL;
 	size_t copy_bytes, to_offset, offset;
 	struct scatterlist *sg;
-	struct page *page;
+	struct page *page = NULL;
 
 	for_each_sg(data_sg, sg, data_nents, i) {
 		int sg_remaining = sg->length;
-- 
2.27.0

