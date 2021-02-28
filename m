Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0276C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9670364E54
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhB1GAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:00:37 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18184 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhB1GAd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:00:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492032; x=1646028032;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+jBH3B9Q6pKVBaot5iX6d5s0M0bipagzFsfwsamEsDc=;
  b=n9i7yDlz6q6UIG73+8kNHVnH0k0mo00zn7702v/4X7Y6Kf4bRY7y/Kt0
   r3mN9fKabp1P1tGQzfbDE9Dvj7FZymyNSyAZA7Gq8PS8DU776BoSFPZO9
   Lcrwlumy+qwp8ByV7OigCgQ7HwuMLoXneL6OYVRdVbpLoxJic6poZCg73
   lflmeN8/k2DltEV9pYnMkADqjfeVXdeEl6XrYoQpymRpoAsJqRSLWZJQd
   +uvfH9ZcTJxsTFeOmgQuiFtycKfExDKH0aXCCPqdbofqd7jR3UWlu7SC7
   NQ3WN8XlAnjQIJ/QXBLz4jbwOuWhMrzzgxu1lAY0bo6rlVtVpT5y/OZzc
   g==;
IronPort-SDR: fhPe+NGfsvL5Mv5CleOTYciBvNPqedGQrn5hvbmKgBQh5lVCTBD0R3WenIraIRwwn4iwGworfG
 GFHCKM2zLz3pol/jjn+zgxNe9Ygb13OKwWXxEe/W9YqIjuYAjfAqtXV/qZLDzP0SeZNOc2Fpwx
 Ty7dYhnvP9JrzVvKul9jLSelTDFNsc4tPXIi2bvOgUubTDrXda0KVgTQwA7I34vX9npoDFf5m/
 0tFpJ2Ym3WyAegfIwFat5vh+aPt90oWHpkUx4/8p/d+Bc60fcHX6Q1VIP2bItUccJkG8VnWjjg
 GrE=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="165466175"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:59:27 +0800
IronPort-SDR: A77fSMUn9ccD3QB3jTi5SoUpB4zMII5ziS6WVXKYJHHBbbaUHBHs2i0eWzFeuGRxHnf8bTUMUD
 6RlOWSWHTIEeh4IFPidexfWxeRJA8stoJ1rD2VSablrJuNTxPwspOUO0Ih2ATHSpD8xb3qVV73
 5wt1nbQ4ii2y/kMv9mMv3jJANYXkLay52ZaeEB8i9u+591/SLy/n8dmv39Be3yKX4/RHLruCuM
 +JzCNngEtMmq9ghHj8t7B3tFVSRHy7YdDdQipZHvQBAi61OE0Pk7JTQht8jsIIN8abNtt4iuF9
 Ypv6FZT6qiYKgoH0H/eibFKg
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:40:46 -0800
IronPort-SDR: UunuyBAsdL1uuIPhzM9KiEkV8SxB3D4QGxm9ibJ5BzxqqzQmaUl3d5c4y99zb8dte/QBnUrvyJ
 JBAA+bBu/9rvIUvdBaykVk3u+sGCMnMZVwRBcbCeWt+kqJJ9WbrjqiuCsaHNpCqt2m7zfLCljJ
 PdNP5CQMr3m+BENPDe8NmTIk2sP4kM400zj0hphqjbD/zcip/519Uk4KdH/0yCx3jbAolRb6i9
 U81ST/Wmy51dV6mKKwfBkey8EwGdc+aB23CFF59RUGVJHiT9O9jW7CdQPgTdEyIGyZcdpqI+BS
 wF4=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:59:27 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 17/23] target/configfs: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:39 -0800
Message-Id: <20210228055645.22253-18-chaitanya.kulkarni@wdc.com>
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
 drivers/target/target_core_configfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ca5b083d2958..0ec9fe1ebade 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2609,9 +2609,7 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 	struct se_hba *hba;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
 	ssize_t len = 0, cur_len;
-	unsigned char buf[LU_GROUP_NAME_BUF];
-
-	memset(buf, 0, LU_GROUP_NAME_BUF);
+	unsigned char buf[LU_GROUP_NAME_BUF] = { };
 
 	spin_lock(&lu_gp->lu_gp_lock);
 	list_for_each_entry(lu_gp_mem, &lu_gp->lu_gp_mem_list, lu_gp_mem_list) {
-- 
2.22.1

