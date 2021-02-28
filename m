Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9703FC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6962D64E51
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhB1GB2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:01:28 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23195 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhB1GBJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:01:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492068; x=1646028068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mDfhgYvCsUBpfe6h7Sy6Z6rwnG2TX7oz1s2rwqccbKk=;
  b=jhN+cYt64+1BfHU73uj7SiOYqZmSQ4+Y6nk7VM9FG3ql3WiJ19N9+vvW
   vvzjZyhZLXf1YZLCwKSWBd+2scxHAuApo3OSsWAFgfX3+mmR1Eaq/taR8
   A60ZJbf+qSIp+hgHZsvwZqV5NpNL+dvCt9RBh50J2UFGwjJ8HSVIWehuh
   5O1DTHZibwKCulfKN06zRfush0xcFUoKVVXLspPBPaHzauZTwJ7dd8D5U
   RHMj5CVj4dovyKN5k3/Rr7HNVukBv8uATG41DkSC4GnGA7WQ5qx4CvTyR
   HeJMl2tQ6qkqDuahlg/ZQS8KnYnR4IVF1dLDpZsKTyoCiff6/NaYQXluT
   w==;
IronPort-SDR: sQ0H+IS+BljVkEG9SxBpGoh2fClbhI/wg86WX3Bbg56egah233Y+uTW5y5cbAetIWFv4U8zNTa
 O3VFmmD7Rinhga2M9GZLx84AvVAA5/DcWzgRf5n03hlFMjy3pFU/THZYWRKbilBuFVST3Ff0hU
 QJiinLbGng9JtzFckRHhXvli1HfDQ/RIZcpcSyb2CxEUFYYx0rwfXu7LdaDVYlmqfGB9zx5rM5
 lXdx1DUL/+Kw4ZkrXDaROdN9u6QYfvHE88DdhIR21by3+Qg/tG7KFpgE+uO1idFRk9FXRQ2Ibb
 0NU=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="271564180"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 14:00:14 +0800
IronPort-SDR: lp0ihUvwsgRbyJ/C7XrVDxyCNOR7V4cbzJjO02OsHM7WxLLJIhcOjkqsBQSlWcEHCJoQb31nPW
 6oXkwu0YB42g2Yll4lC/PIzrsOr5ThiVcYWRScHizOK0QAbh1CEZjQb6sUYnX7YoVR5k0zYrm6
 xQyVgXIUFJmU2yDLtMf/zNiLklqylqX3WB89xEH9Vzx9FYOM7Bp9O9Px4Ehl1zUvpwogY6kFQO
 1HUiLi9WtAIgS7uzEV8MIjVbmMe7+saT9796WG5drBrMDtCNraPQnlZCn1CsDhWF039kLHsI65
 PdDQ92UkZbkU10rgA4Ks3onk
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:43:24 -0800
IronPort-SDR: JXkKii/dA5B9Bd0EKSrhcb0usHXMbjDb9796XCctEJk9xgtHLlF10iCOa1MuNtLwJm7mcWCCIc
 JJZStGnIiwUeQe3pKMpeFtgXOvJuCnRLKG3m8y9jpBSaLRhKIVGaYG8Zp2IFwKX4M33bcxLufs
 Ss0l3iTvxJilx695aTBEDYdd+jXEllrWkoas/25dxe7oX4mHGzSKnrtPwAUtN5uykzoRwo5Ap/
 t9yx2NxVZc2bmNveEkLyRLKGz3Gb4IzOLmwLgRQHoCgRqe3TVnmcr97dhWwlWNLbWY+hrjhMYI
 wlI=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 22:00:14 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 21/23] target/pr: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:43 -0800
Message-Id: <20210228055645.22253-22-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of initializing the array with memset, use declare init pattern
that is present under the kernel tree in other drivers so we can remove
the memset call.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 942b93d12295..3644d2642929 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1202,10 +1202,10 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(
 	struct se_session *sess)
 {
 	struct se_portal_group *tpg = nacl->se_tpg;
-	unsigned char buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
+	unsigned char buf[PR_REG_ISID_LEN] = { };
+	unsigned char *isid_ptr = NULL;
 
 	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
-		memset(&buf[0], 0, PR_REG_ISID_LEN);
 		tpg->se_tpg_tfo->sess_get_initiator_sid(sess, &buf[0],
 					PR_REG_ISID_LEN);
 		isid_ptr = &buf[0];
-- 
2.22.1

