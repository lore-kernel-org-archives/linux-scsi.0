Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25700C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D0464D5D
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhB1F62 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:58:28 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1337 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhB1F60 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:58:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614491905; x=1646027905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aZzpH4veIJNQx/5JpuGiLxAKoVEslprxcHSo1AirYuI=;
  b=m6RTZ7G6K57rNTMvaINBznS5gEmjeyQYOdP7WkrYkmqxbwd7VhLWoFsc
   6rdWbNB16VAHQVe4qrHsc+bQsY/j21qZ0FgFP8oMWppxxE9UIeJQe6EfN
   aPIpwY8sINs5xNQsgL0nWP2Qcyiqe+yUubjToW37UThv2BJAy8qjTUxSV
   sccaLSXOZJ0ddlrL04P/RkPPIWgBu/cZ5quNDqsHPpO5Z3LTY6I/9CjWs
   /MLigNYtSactpfDA1nx5gLr5twZ8nhzYLdOfh5XwN/jL/FKTAtEDmCiK8
   eROPUezbh9MpIqZ2UlgRAOHfXE/C1Yy/qGFM6OPKUQObbgYWqlEs6Sdmh
   Q==;
IronPort-SDR: 7wpjoZnW7ffI3S87aR/aOmgHsiVK0eYNxVz4Q1etfW9ceBMmm6noOO0pVcMrHtHW48NVRjBx9y
 lXFbDOjsr97EghQ/9+aj+HUqNbgY1ZWIfYmJsGeSyw5Qnpmh7aCNLiKx6i2USFouXye9DxI0V2
 F97rMYPKZuKWCIcW3ygTxDdk5dNrLJTjmeGUAiEA2r4UQzglujn30JDdOActRwFacqFrWMMQhU
 sCiQwyXdM0eBuvQwNYgeSniYRBz9anFy1mnsAgZg10hcqsdVAcYNhwNYlVkKRCIp5TZtxcudUr
 Cik=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="271564047"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:57:11 +0800
IronPort-SDR: obsuZ4L2PX/kynHBar+9vvlKl28i+sW53pDBhB5eIscFYhqMyv8l2Gu6JT8zrJyxhGvLgLFRnd
 0DRt4BEgxshT7D1jZZ0ElMxCK+pbJJz0q4XTLau8rvRlkxcgmaPfD4nKvkTyl8ZzaDBfbd2eth
 UnOoRo/VFqwCbu8bzKYeCIYrw0cY5Begm+0IrGIVjzatRhDdGLK+RTu1O4VRtTnoBnSYM54+yq
 DUYWXWNeeWZNQFnGO49t/eOAjaalxpoQIh5baWyqT9VtvAY/aaLpZL5+EqNFkZhKkV2QS/D7wz
 qTnEabNglrxp7mmPFsv0BOao
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:40:21 -0800
IronPort-SDR: Es3j4T7AdQ/ZbS26w/DXlNzOUZlLG0NKRZWwN2sSZ3G8GZMa6jwhxiIfUXvm1KsNfVd1uHYrnC
 Q5OJKYQoSrjbzPL/UqmvVhm5KxTbTnUazbkSkOFabvsv4vPoUY6rys7j75iL2vBHU4+tIFPvBA
 iYJLrgH9IxIK5SCwkuOOSPWZRmemaXodE/bo14EsMQLVXfS3eQnzHHsjLxcQYXxp743F8roePi
 WuZp7HWktVGo3q95ppt3Z+0yzVr82k4uX/aYXZbzJovnguO+2pmY2BZsiG5EaTPoErpSj7k9gh
 AS8=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:57:11 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 02/23] target/iblock: trim down line longer than 80 char
Date:   Sat, 27 Feb 2021 21:56:24 -0800
Message-Id: <20210228055645.22253-3-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
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
index 04aeed6558d6..db9bd571acb1 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -813,7 +813,8 @@ static unsigned int iblock_get_lbppbe(struct se_device *dev)
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

