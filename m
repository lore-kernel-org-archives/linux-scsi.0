Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D21C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE4D464E2F
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhBTVl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:41:28 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43957 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhBTVlO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857275; x=1645393275;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cFraFuGaZvjFcSBrZOICDluVzeLEnOLktlPkgx7ydOs=;
  b=ZvdAmq7SG3AaOaKAfiA9ALXeLmeiUjrhne8b8PFtIGOiR3Il99PPADJW
   HR0pOQyFZ0nA4Wc3JtNwi45xbuU/PUn7GJmf8iG9ITueJjKnZyIEtiknn
   0ba5HW+onVfK3fp4TSGymc3hHDjNEm59J2ohYp+uvWCH8I7vOLv0M2fDf
   Id05EkiBiFaIYAeutHV4r6QHDoYZhaY4Y7FwAi9K58jHfzz7nzAKp+rOs
   DTYTq6pktTZu5FWSPvJ+DWQnbW0yuVz+ZIECCsok8FeNHbO1TfQI50N4/
   PkrK6VE6Ahx6kTStOXSjOI9c0iVJmAuG8Jilf541kZdo97z6hDly5w4qb
   A==;
IronPort-SDR: 7NV6V4MXG7A/n6t1IzSlZ9/nCVZ8CT24XzIqerPKwZcKGXDOmYdQhJQNIdt9U6nh6ldwGDb85/
 XaowBKjWEHMotdYXZN9i6engizaCBk60ZQeIMJVNl1k49zztbtSlfvax2Fw9smj3S/l5bqd0oW
 SAEdYYUtopjHmf08LZPsmcwo5XL20FqY8xcEZUPp2sOqqCP2y5fISf6NEsA6JF01G4B/T5ZebB
 qKMuWJaUvZVjyWEfHdwOWLVIP++JJuFY2RBq5XOiWZc7tcGfsdFbkOfVE1W8x7l2WRNv16p96C
 vuk=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="161591308"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:40:09 +0800
IronPort-SDR: cG9McoxxNwP8rQ0t1MYURafz73cpcsnDJsSC8BKhe8/OGnMhRCHk+K85onckbUNZWqmkKCjPeA
 ipmmWucAGn45Jnr+ZqJm8nIJL8KxTuCBdfNaIRLGAxIknJxCBDA+IrU75dg/yWxMhxbKH+/YQI
 6HRJXX47lKMp+AWZMJ3y3B8Hs2nElxgEGxGzRgXaeESxERcvbtOsoizb1jeRj6R2ZuC3BVovqb
 fmU2g0TJMP9u3KM4cQJYZK/gqoaowyn785G/SIkiPhqdhgsMNJvBdvy9RC5uqy7ZXOmfu4fflY
 aEsmHsCfZCoTpK6yKypi1Gs8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:21:43 -0800
IronPort-SDR: 7LkzrnyJl3V3rMm+XvpCSVv9JyvJYm4Qm5a9Nhy9i/wkSuJujVGhi4lga/q8TehaegMUAH+Lh2
 9A5cJ1NxsSeRo+J3pdaAmixwbfQwck9fRNI0xIBOjna0estx2RShog6+DWtFBPduOzdvLEk04m
 ftan7dt6H3JOSgxB0yffvkTuM9Y1H9PjxpLr+w9q7Mnq0xrSpHLRrcjaMAThil5ye1KDxXnLPo
 mFlpwru/oMXryWy73FFZMJeOmPKd04n5sWVqUaif0m7WtBr7cdXkpZKP+P7oYdF/smlAT6dk+/
 KAg=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:40:09 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 18/24] target/configfs: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:40:07 -0800
Message-Id: <20210220214007.7185-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_configfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 0ec9fe1ebade..d6554468ef65 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3012,9 +3012,7 @@ static ssize_t target_tg_pt_gp_members_show(struct config_item *item,
 	struct t10_alua_tg_pt_gp *tg_pt_gp = to_tg_pt_gp(item);
 	struct se_lun *lun;
 	ssize_t len = 0, cur_len;
-	unsigned char buf[TG_PT_GROUP_NAME_BUF];
-
-	memset(buf, 0, TG_PT_GROUP_NAME_BUF);
+	unsigned char buf[TG_PT_GROUP_NAME_BUF] = { };
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_for_each_entry(lun, &tg_pt_gp->tg_pt_gp_lun_list,
-- 
2.22.1

