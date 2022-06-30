Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8186BC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 12:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbiF3Mc7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 08:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbiF3Mc5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 08:32:57 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9296D3586F;
        Thu, 30 Jun 2022 05:32:56 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A79A64126D;
        Thu, 30 Jun 2022 12:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1656591786; x=1658406187; bh=o5TMd3+w5SD/UGNqIuI+bzNa+
        wTz0e8p5bdlpOIx8/U=; b=YUVmv7NZFKG3ow700kviTltU3Ea6HJz5qDD5vbGnf
        jghQGvclFwdEdw3kx4fy4lKsEM++w6/vODGRoPPRlLDb0V2YIQWAFVL3cAOIXJHR
        1N2EbNhZRfUlD9EHLlfy7R/iCrY6YG3BTH9QfNtMqOldqwqJxkj9Y0q+/sTeYDTj
        0s=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dAGJOajWX470; Thu, 30 Jun 2022 15:23:06 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4A00640889;
        Thu, 30 Jun 2022 15:23:06 +0300 (MSK)
Received: from T-EXCH-10.corp.yadro.com (172.17.11.60) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 30 Jun 2022 15:23:06 +0300
Received: from localhost (10.199.0.81) by T-EXCH-10.corp.yadro.com
 (172.17.11.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.22; Thu, 30 Jun
 2022 15:23:05 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: [PATCH 1/3] target: core: Send mtl in blocks
Date:   Thu, 30 Jun 2022 15:22:39 +0300
Message-ID: <20220630122241.1658-2-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630122241.1658-1-a.kovaleva@yadro.com>
References: <20220630122241.1658-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.81]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-10.corp.yadro.com (172.17.11.60)
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
 drivers/target/target_core_spc.c      | 7 ++++++-
 include/target/target_core_base.h     | 1 -
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index bbcbbfa72b07..51943369887a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1089,8 +1089,6 @@ static ssize_t block_size_store(struct config_item *item,
 	}
 
 	da->block_size = val;
-	if (da->max_bytes_per_io)
-		da->hw_max_sectors = da->max_bytes_per_io / val;
 
 	pr_debug("dev[%p]: SE Device block_size changed to %u\n",
 			da->da_dev, val);
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index e68f1cc8ef98..dcf4c8e47e8b 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -189,7 +189,6 @@ static int fd_configure_device(struct se_device *dev)
 	}
 
 	dev->dev_attrib.hw_block_size = fd_dev->fd_block_size;
-	dev->dev_attrib.max_bytes_per_io = FD_MAX_BYTES;
 	dev->dev_attrib.hw_max_sectors = FD_MAX_BYTES / fd_dev->fd_block_size;
 	dev->dev_attrib.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index c14441c89bed..c3d90e811617 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -513,6 +513,7 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	struct se_device *dev = cmd->se_dev;
 	u32 mtl = 0;
 	int have_tp = 0, opt, min;
+	u32 io_max_blocks;
 
 	/*
 	 * Following spc3r22 section 6.5.3 Block Limits VPD page, when
@@ -547,11 +548,15 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	 * XXX: Currently assumes single PAGE_SIZE per scatterlist for fabrics
 	 * enforcing maximum HW scatter-gather-list entry limit
 	 */
+	io_max_blocks = mult_frac(
+			dev->dev_attrib.hw_max_sectors,
+			dev->dev_attrib.hw_block_size,
+			dev->dev_attrib.block_size);
 	if (cmd->se_tfo->max_data_sg_nents) {
 		mtl = (cmd->se_tfo->max_data_sg_nents * PAGE_SIZE) /
 		       dev->dev_attrib.block_size;
 	}
-	put_unaligned_be32(min_not_zero(mtl, dev->dev_attrib.hw_max_sectors), &buf[8]);
+	put_unaligned_be32(min_not_zero(mtl, io_max_blocks), &buf[8]);
 
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c2b36f7d917d..748d1afbadaa 100644
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

