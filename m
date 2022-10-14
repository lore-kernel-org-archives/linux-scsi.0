Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165F6C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Oct 2022 12:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiJNMCK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 08:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJNMCJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 08:02:09 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8AD18F924;
        Fri, 14 Oct 2022 05:02:05 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 228734121C;
        Fri, 14 Oct 2022 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1665748921; x=1667563322; bh=A4QsxFQVgNYAsqNe8gkYhy6bo
        ef34sWDk/zUFN2cHCU=; b=SeOKGtvZxG7OPzaCMnDNgCe/cIfmHpZ1EC254KLe4
        9ZeUchbmSFA2vym1Y6DcTYlXvBqL0Py9EdCUeqybGTE86yPqpsG64a2a+6lr5+P5
        DWbOtpsyOIWbMgWmOM6iUbZEa2heNKw23gJXA6W7r0URQd8Tb+ykr1cyRcOe1a5g
        iw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2tmdnwTmH4y1; Fri, 14 Oct 2022 15:02:01 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9F65441236;
        Fri, 14 Oct 2022 15:01:02 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 14 Oct 2022 15:01:02 +0300
Received: from localhost (10.199.23.220) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 14 Oct
 2022 15:01:01 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: [PATCH v2 1/3] target: core: Send mtl in blocks
Date:   Fri, 14 Oct 2022 15:00:54 +0300
Message-ID: <20221014120056.33738-2-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221014120056.33738-1-a.kovaleva@yadro.com>
References: <20221014120056.33738-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.23.220]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A MAXIMUM TRANSFER LENGTH value indicates the maximum transfer length in
logical blocks that the device server accepts for a single command. Fix
function sending the length in sectors instead of blocks.

This patch also removes the special casing for fileio in
block_size_store since this logic in now unified in
spc_emulate_evpd_b0() for all backends.

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c | 2 --
 drivers/target/target_core_file.c     | 1 -
 drivers/target/target_core_spc.c      | 6 +++++-
 include/target/target_core_base.h     | 1 -
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 416514c5c7ac..a126ae5dca08 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1100,8 +1100,6 @@ static ssize_t block_size_store(struct config_item *item,
 	}
 
 	da->block_size = val;
-	if (da->max_bytes_per_io)
-		da->hw_max_sectors = da->max_bytes_per_io / val;
 
 	pr_debug("dev[%p]: SE Device block_size changed to %u\n",
 			da->da_dev, val);
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 28aa643be5d5..f9aed9fa8ced 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -193,7 +193,6 @@ static int fd_configure_device(struct se_device *dev)
 	}
 
 	dev->dev_attrib.hw_block_size = fd_dev->fd_block_size;
-	dev->dev_attrib.max_bytes_per_io = FD_MAX_BYTES;
 	dev->dev_attrib.hw_max_sectors = FD_MAX_BYTES / fd_dev->fd_block_size;
 	dev->dev_attrib.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 7cca3b15472b..4ab10437c8a9 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -519,6 +519,7 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	struct se_device *dev = cmd->se_dev;
 	u32 mtl = 0;
 	int have_tp = 0, opt, min;
+	u32 io_max_blocks;
 
 	/*
 	 * Following spc3r22 section 6.5.3 Block Limits VPD page, when
@@ -557,7 +558,10 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 		mtl = (cmd->se_tfo->max_data_sg_nents * PAGE_SIZE) /
 		       dev->dev_attrib.block_size;
 	}
-	put_unaligned_be32(min_not_zero(mtl, dev->dev_attrib.hw_max_sectors), &buf[8]);
+	io_max_blocks = mult_frac(dev->dev_attrib.hw_max_sectors,
+			dev->dev_attrib.hw_block_size,
+			dev->dev_attrib.block_size);
+	put_unaligned_be32(min_not_zero(mtl, io_max_blocks), &buf[8]);
 
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 8c920456edd9..cb7acbbdbcfb 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -709,7 +709,6 @@ struct se_dev_attrib {
 	u32		unmap_granularity;
 	u32		unmap_granularity_alignment;
 	u32		max_write_same_len;
-	u32		max_bytes_per_io;
 	struct se_device *da_dev;
 	struct config_group da_group;
 };
-- 
2.30.2

