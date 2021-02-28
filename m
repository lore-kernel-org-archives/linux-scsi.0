Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995A6C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6493364D5D
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhB1F6v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:58:51 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1300 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhB1F6l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:58:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614491920; x=1646027920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOFh94eLL2PIEwHWuY6WhNIsqglTKksaBtqtYDCeIPU=;
  b=Qaz85nd3KX06zLlL1f+8ioEBz1QtMR/JOiHuRvAYNe2+d8gks4Jrn+Tt
   +Gi9WKUKu1KimVDsYbZMjmlt4Dz3daHt7ULcyIwP3+hf226qG/yt4ejkO
   5PzfKThMKVkQWhQ2K5M6DYQ6mWu3QjmPLnOklVdFfoE2MvIpOIicuKPzb
   lkySWnAPiNraA4XRB4v/FthPzAlidhUoSYG8DmzBhcWGhaNNFjE2WE8lF
   VwbQb5dpw8rPt2zdj8q8AAWKV91t3dS7QjvXWSYLB7SEdRY5Zss9L/6Bx
   Jk/FaBP5sB6HtWtrAI8e1KyOT3oBdIjTSsPbxgAHySI5FYj0SZM8waKKf
   g==;
IronPort-SDR: fsFLjjgoiGUSGcsEzl7dJX3uy4EO//j5P3zx0HHn9mkIc+jCFP45+SGsWWWy4/hhPMrp2hI/h4
 pQkVszqhidhWp9Zu4uefRV/0LcS8amLbbbxMLq9MyeUpyUXTer2FEYIbkSiyizqLWNoJ2xUzpm
 ipg8Jyj3vU2j7b/wTq2Idarzs3n6AIaBhDzXozK3SjjPgs+NO7ThjcbC0cX4sTHofVtKB5BcNI
 LQiCgE9d/Y1YvS9sfHTTgcmX1rN/3/JdHKqyEjr3As6V8H9luSgn1wLPZXG4bZBiMAN1GPUsfT
 ZFQ=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="271564052"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:57:20 +0800
IronPort-SDR: 3zYS/Lkig+S/1524VljEmVyQfea7G6HzBVmBIPoT/84EnmWxD5ReJMoRGtHFdCDQa/UJ6sFJ2o
 gaTvd0o49HihU4aIytqOWbFY5zxcEO+3rppSaKmhIbY4+AzGocKFl5leecdiWq+RDHuyfbzlUq
 zO1uNFK2b1ubyeltKCZWt5RlAkhwu+Ijr3Ls1VGOSSs0KkdReQn+a6x888ghVSp0fXZtc9uGAF
 BHVWMpCkhFLyUxRszSZ/kLPbfROQYd3Ej6gOIlqD0DYtID2DCrELJmRvdN8AT4oVOQyq6dlvwe
 n3HhMoIl3J8ylWVF7kRVXRKj
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:38:38 -0800
IronPort-SDR: NXBoS63biWcrtsBBuMpu9e10llRkalqMFGsewdX6dVOL4yRFCIPNd5kLQMVCQyeY0WlJxqSxzZ
 YHDlt9E/HkoRNXS4+F+dRREk/wzBLdNR+TGE8zqevE/zGp6WUBQuYv+PL5dTk+QXMPKD0KA/hZ
 YU5N6s0dhLmmdhrrDCpHmad4bBI3Fz6XNvIJs9+uovE01u++yliOacocgtIjNqLn5r6V0oVTue
 twJlPU6f3bZd3go8j1Nb4Q/oN809Jl7czIXnaFTiGKZ8AnEyGt6dkAfzUhevQO3Lk5lL2zX0o+
 EOM=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:57:20 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 03/23] target/iblock: fix the type of the logs_per_phys
Date:   Sat, 27 Feb 2021 21:56:25 -0800
Message-Id: <20210228055645.22253-4-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to the ilog2() it expects 32/64 bit unsigned value.
"  147  * ilog2 - log base 2 of 32-bit or a 64-bit unsigned value"

Replace the type of the logs_per_phys from int to unsigned int.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index db9bd571acb1..12999d39c398 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -813,7 +813,7 @@ static unsigned int iblock_get_lbppbe(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 	struct block_device *bd = ib_dev->ibd_bd;
-	int logs_per_phys =
+	unsigned int logs_per_phys =
 		bdev_physical_block_size(bd) / bdev_logical_block_size(bd);
 
 	return ilog2(logs_per_phys);
-- 
2.22.1

