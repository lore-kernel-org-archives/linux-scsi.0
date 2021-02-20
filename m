Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1731FC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC4AF64ED2
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhBTViW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:38:22 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:7743 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhBTViW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:38:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857101; x=1645393101;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jZFst8sgmY9Obf1LTiiORykZGewLSEvcKZaTOWLd8ZM=;
  b=A5vTcT/5KlXLivLdCp/GsR8+emGfDaePWvaJ4Eq5jFL+hLpKGZ8hSHBw
   1YdTMuWP3XOueAPjdfRDiv+2jIoeLKv/5XWE6FPmBVqksBeKsnV9gAnuc
   1R+Gk8ljq6tyHUSnJnLhvxJBEYYAUvtqvuwL8rvMezKJiqsto+9l/Bx/k
   rrEk5R8sTEUPkL27AjJ/zofcK+349JL3bLnUb1UfopoTFhenBa1vODWy4
   NJT3oaz8mBxPoLqT7WhjNJoyRNdQ09s7o3T0/6zdspyd/hw8HaacqDyjv
   o/QbrbEaI1b1VaZzUiJtFhmee4wDbt+5ZqNyEZZ3Nkqdh/p6C0OVbbNh0
   g==;
IronPort-SDR: 4PSJJKBKyUFNe7Qo5FIzmycwC6Dj3b01MaUq8sTWXQv5/UqsR0+c8EvhlvFWXyFdnajkMFc/O3
 L61bt4R6tdnM0R39/o9rAsRCjzejgJCbLmr4KYUu4t6RkPaGJZAxzZqgkRi3IkqY21bW6Hi2ny
 N/LJi4UgYkmXjzNtDTTb+xhPhIRQqEv2gGGOM9uywUHAqA8xXUtbsI4jnP4rbh54f6kcKW2pld
 JbvjMe/nS0ZKru48NG7zeLlIo32q3DpxTTf1W77vvVpGd58P9CVOCuXctfGFec6irWiqkqlNSv
 ngk=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="160432888"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:37:16 +0800
IronPort-SDR: LPmlV04I212UqusbjREN7sFrKQX6e1iSRoXhF4CAmuZ7rbr9Ita6TkF3q8sBcBKRQMMNlPwItr
 20UzIeJbb8NhiWBbAsIyeQVEhqAKI4Qq9eb7e8IZ1wREt8C5zgDv559uUBsa5anuYtxa+9kP+T
 dI+MnPxZGj+b1YMjhkGM/1jUUt8jb86li9ansDDgTC+cDP0hJJVAmzb/baiKVnZasYmuQ2UoXL
 n5i9CRIkbkccRtmYij2oNLC+GNmyXfhf/U69nYJFlc76yoy0zYtpPF1Ck7XhC4fXEUrieLbMTn
 72M5CkMnmCV598va4V9G2ffB
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:18:49 -0800
IronPort-SDR: NHyjdOVWRCOwB/8O/oi2Y77kmQWGIdxKclv+gpsKoJofnUc/KLwTPHQkvEZzu2YTgfntWa0BN2
 nDLC8kesniOgqbNeGWXX7bz2Kq/Nr2wiAi+wGHBJXUq8nLxfTV6Ck5vEvVTJopB94DG0T0iM2v
 j7atk/BfLkUhYsqbdjQdv0p8UlQyif0k6kPyefYPhWxfmEisgys+Ol+X8PnGNsAk3Y+cl0NWr5
 9TCRfhXfahDWoefrZjEUSAmaW+UeKY9tf8p5Evgy5ssxcr4yyddC/YjJt51IuvXsnRef7AZcEa
 h7I=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:37:16 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 02/24] target/iblock: trim down line longer than 80 char
Date:   Sat, 20 Feb 2021 13:37:14 -0800
Message-Id: <20210220213714.6378-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Trim the lines that are longer than 80 char, which is inconsistent
with the rest of the code.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_iblock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 4bb34711bdc5..a2727141388e 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -816,7 +816,8 @@ static unsigned int iblock_get_lbppbe(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 	struct block_device *bd = ib_dev->ibd_bd;
-	int logs_per_phys = bdev_physical_block_size(bd) / bdev_logical_block_size(bd);
+	int logs_per_phys =
+		bdev_physical_block_size(bd) / bdev_logical_block_size(bd);
 
 	return ilog2(logs_per_phys);
 }
-- 
2.22.1

