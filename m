Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FED3C433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D39464EB2
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBTVij (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:38:39 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:38402 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhBTVic (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:38:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857112; x=1645393112;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MpSgnprcjeS7I0iYE914cF1ddXsLy/QJDigDjwIt4mU=;
  b=fmD4Tsti1iMEUvFiSCET7KZU2E6sAAZW2FtFZflo8aign4T530GdF2Dv
   y8YwPnLUz/XndVgdBAWXwIBEUUZZPT85npWCDb+VOtRtUYQHe6qWs8k2d
   9K9aJvMcMos/bOcMB+x8j7J0UoiuIucETb3jYKqmGOqxKiI+BTjfthXYm
   RZhHj2YeQrP2DhgA8naUxuAjSUexDAC5KIxxTWJtw+r31GB9JbuSM/ukE
   Imb5E1/GKRXvQQLT0wZTpQKcuIUFU1OjQLXKG5+pAoEUPxKpRUq/OUet9
   a7pU8ydJMUjZtsp8onXY2woGC5V8dzKNbjy9P+D3i8+fyKcOLQXIQq3hh
   Q==;
IronPort-SDR: /VKUmK49+rq8utSRhAzXuRBZlm0sntQOIGYsqfvkw8KBIIfbHYJ7VBK7odAWzLBhV+WnlMFwLP
 oJrkKyE3Xd5kIP+hcY4FvVAyDC2zR4yOMANBaLF8U4rDgtY3wP3KE421Ev/MYo2KI6p7LQszZu
 OUYBlI89KNwWW1YHdgxptBOO+Faiv6ntjlpR3fjLdxjFj7uSNgTyKsKah9B+PbVj4pCXzU/1hx
 4+0d3+I5uYhp8b+bygND6oBcvZVM+mmhUDz9QF0c019tctg1nTqken1u9NyFchyFov5ADKBfGZ
 dh4=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="161591262"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:37:27 +0800
IronPort-SDR: DbOzXyTaAt3PvZtnDJErvHcHS7dn8Y5i6oAWouTC2r4mthwg+PFpHRHscreuBqCj0yzkiLhgap
 iS6ZAyjRC/SZRZRPC2tnedQvzlNX4gwEtUobkeG7FAVErpKmXdH325kk/I0yrpv+fFeZeb1Rzc
 FkfZomP7mCT2gtiUV6JLCRUP32E4RsKWmKtFwWHYaVATjcU138j8jZ5ydb8lQlTI0Ry6jFsxYk
 Y8HsDs9KN9btQ9V3O3uONi3fFpuRCnY2Ep4BT/6Cd8WCLalx6PEstfuOx5HyoprpMVUlpKP0J8
 BFg8yZzXHU22Jxy5v67KnMB5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:20:49 -0800
IronPort-SDR: xnF6LwXWRf6Vend4FSTWJXEvr7/iW9tygZY6xHM+3omNNfWrZ3QmCEQmtxP0NkS39BtPYMdRpf
 hXyeXF6y33D1+6vOTRQ50lj/Z1v1wfAgoN8pFN4BB/1gAlkqU34kL/jFs0JFIVfgPpnAInhkaN
 wkDW2DbbxVJZ6dFNoUBPCIK2i327rhzvjRCDK4ADxk5ij+XhDgs9ps77zptzLrqZEWZ50nDJ5D
 NPwliVG69aI5ZGRzY1h9Y+dOoQntvlh1/N/47HSmx5JyIu1f98nxQf03KlsuWpwPoLLUMvmxK6
 45M=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:37:27 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 03/24] target/iblock: fix the type of the logs_per_phys
Date:   Sat, 20 Feb 2021 13:37:25 -0800
Message-Id: <20210220213725.6444-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to the ilog2() it expects 32/64 bit unsigned value.
"  147  * ilog2 - log base 2 of 32-bit or a 64-bit unsigned value"

Replace the type of the logs_per_phys from int to unsigned int.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index a2727141388e..e63e2eb49570 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -816,7 +816,7 @@ static unsigned int iblock_get_lbppbe(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 	struct block_device *bd = ib_dev->ibd_bd;
-	int logs_per_phys =
+	unsigned int logs_per_phys =
 		bdev_physical_block_size(bd) / bdev_logical_block_size(bd);
 
 	return ilog2(logs_per_phys);
-- 
2.22.1

