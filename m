Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 289CEC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 12:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbiF3Mc6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 08:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiF3Mc5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 08:32:57 -0400
X-Greylist: delayed 590 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Jun 2022 05:32:56 PDT
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7FC35240;
        Thu, 30 Jun 2022 05:32:56 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 07C5541273;
        Thu, 30 Jun 2022 12:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1656591787; x=1658406188; bh=7xSHP6I8VG1npYiDMNV82Knod
        bGC4OJdhGo0ZmDYk3w=; b=ERCm/tau7kG5eJ5kFHRNGFwWh2Mqds+JPTA3OxrmJ
        zYlSb6NlG0jx64Y0pkl+Hz4wCP53pPBHYaO715cFZ4AQy1Kqkih59Z3hen0csgsm
        M43GP/Qz30UqOdTKpKSuVnOm7VfhXJlBe8RowWTM40FvxTzumsR1gEiTHL1qlHo0
        2k=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fW21kaH5Av-i; Thu, 30 Jun 2022 15:23:07 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C4EB341272;
        Thu, 30 Jun 2022 15:23:07 +0300 (MSK)
Received: from T-EXCH-10.corp.yadro.com (172.17.11.60) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 30 Jun 2022 15:23:07 +0300
Received: from localhost (10.199.0.81) by T-EXCH-10.corp.yadro.com
 (172.17.11.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.22; Thu, 30 Jun
 2022 15:23:06 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: [PATCH 2/3] target: core: make hw_max_sectors store the sectors amount in blocks
Date:   Thu, 30 Jun 2022 15:22:40 +0300
Message-ID: <20220630122241.1658-3-a.kovaleva@yadro.com>
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

By default, hw_max_sectors stores its value in 512 blocks in iblock,
despite the fact that the block size can be 4096 bytes. Change
hw_max_sectors to store the number of sectors in hw_block_size blocks.

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_iblock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 378c80313a0f..532a30b31a7c 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -116,7 +116,8 @@ static int iblock_configure_device(struct se_device *dev)
 	q = bdev_get_queue(bd);
 
 	dev->dev_attrib.hw_block_size = bdev_logical_block_size(bd);
-	dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
+	dev->dev_attrib.hw_max_sectors = mult_frac(queue_max_hw_sectors(q),
+		SECTOR_SIZE, dev->dev_attrib.hw_block_size);
 	dev->dev_attrib.hw_queue_depth = q->nr_requests;
 
 	if (target_configure_unmap_from_queue(&dev->dev_attrib, bd))
-- 
2.30.2

