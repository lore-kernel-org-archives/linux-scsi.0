Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341B6FA372C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0723B207FA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UkZqOefB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKHI1i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:27:38 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26024 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfKHI1i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 03:27:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573201657; x=1604737657;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5LJPWNDx95mKmDt2bUpL3y3YI3JwCPruxNIjbgkV8iw=;
  b=UkZqOefBwSPnVsmNa44SzYqAwp+B11wix8gbpUhFp4mfqAHN2adMfAoD
   pX1ZYCsv/qVVF6oZ3Li5vOpgDFUVC6o1OZPepHZO9fqyxX1CNEWGmm/5A
   JNL1AUYw7ZpLvBo7rKuIdpQZWi0KMVzRu6QE3fL5ofArG/dvzkFzdYAs1
   Frf93ABv5BnJ+JuHH5RdTtkPQIQJgup8CGLYTqB1mbUxdx8HGBLRPUCFq
   2p2jw2AlwwhiS755+7qcgdM1O957hCfMboeUZOQ3q4qr+p8y5N4YbkVqV
   82EImqeIYa0nuqXTeLQjCEkfZNhQ1VUj1D3H+hI+FVYBLH1oNCRQisvLj
   A==;
IronPort-SDR: BV3aVY+8HZICkSEm8J3AHScQakfKd6TivPx8hqSmGB66fZUenBEf1lR9w8QhEMkpBxgOhupf5M
 cQUG03PH4AKU6PExlIAc1qKzt0mxNbfpbjoJUTvQVvN0J0WS42HVhk2IRmK59F/lloijax+WK6
 tSrOJC2U4s7trjRVqBJhty5KlL6FhBGiitAYk5RCXz/P1uwltZtUfOtH3pjczmujuMHpN4rjml
 DhxluJUZ8IcfoFNKj1+TR4jxI5DcrEhlYRQjR2cJZnonYnz2+byecKD7US5uTLRJ8ZgbwwceLF
 UHA=
X-IronPort-AV: E=Sophos;i="5.68,280,1569254400"; 
   d="scan'208";a="122457964"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2019 16:27:37 +0800
IronPort-SDR: C8XWGOV8nV+J5gyO52vRtNs5l+QXCq5vyqchdHxnRldIXyomUFvELtK6C8gGpP2Kwu40LmZQGv
 WhHMwYhkZ/oZuii/V3paM9LwIH3fb+lxqogUbDc25uWOCpZYfKgLq2835tDQY4HC5sav6Pn2UV
 +lzFfXVuj7SVBLyYJcFe1wdH6CX8HMHpXM3bylZMEwdK/Lpu0Zhm39yXojR9f7SjjSXBfvRxuY
 /6Bi6k3AOZHMjRaG9pSsZxtuV7J7l6CjstH3l7luElSmM//ZXdb2WqeSD5/EFpxdZTWqRa5jkl
 3nNpNusnbvQcpTBhV6vfZq5P
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 00:22:46 -0800
IronPort-SDR: 3B3eEmUEzLERhHLabpnl9v2eMZNf/lHl/TO3AQ+TWORX1QDSR/DbpDLDTTgWrUL/fVTRXz1+Rp
 t48bhqpwrLw4MwUG/4HkgxBa0y1Wz5hKPCSyAwfDQSLcQm7atU/qXGp+jYY1Lew/ifT0lGzki3
 zSQ3U0mG9bJTymTw0wmSl1ZRKlciZAFSfyk0qhGEM4IDHmz5XnPJDKivb8uEskrvLYv0A4zmsl
 oUC5ZIlPKAKOAC3L9lQc9NdiqG002dbp3zZXj99wYf6UU+a7LkTBfcKlj7x4en3i7Fz/Cbf9Rz
 4Ys=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2019 00:27:36 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH] target: core: Prevent memory reclaim recursion
Date:   Fri,  8 Nov 2019 17:27:35 +0900
Message-Id: <20191108082735.417876-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prevent recursion into the IO path under low memory conditions by using
GFP_NOIO in place of GFP_KERNEL when allocating a new command with
tcmu_alloc_cmd() and user ring space with tcmu_get_empty_block().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/target/target_core_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 35be1be87d2a..0b9dfa6b17bc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -499,7 +499,7 @@ static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
 			schedule_delayed_work(&tcmu_unmap_work, 0);
 
 		/* try to get new page from the mm */
-		page = alloc_page(GFP_KERNEL);
+		page = alloc_page(GFP_NOIO);
 		if (!page)
 			goto err_alloc;
 
@@ -573,7 +573,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 	struct tcmu_cmd *tcmu_cmd;
 
-	tcmu_cmd = kmem_cache_zalloc(tcmu_cmd_cache, GFP_KERNEL);
+	tcmu_cmd = kmem_cache_zalloc(tcmu_cmd_cache, GFP_NOIO);
 	if (!tcmu_cmd)
 		return NULL;
 
@@ -584,7 +584,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
 	tcmu_cmd->dbi_cnt = tcmu_cmd_get_block_cnt(tcmu_cmd);
 	tcmu_cmd->dbi = kcalloc(tcmu_cmd->dbi_cnt, sizeof(uint32_t),
-				GFP_KERNEL);
+				GFP_NOIO);
 	if (!tcmu_cmd->dbi) {
 		kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 		return NULL;
-- 
2.23.0

