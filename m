Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0298C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 00:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243411AbiDLAuG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 20:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243399AbiDLAtx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 20:49:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5174931538;
        Mon, 11 Apr 2022 17:46:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09F42B819B4;
        Tue, 12 Apr 2022 00:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4097EC385A4;
        Tue, 12 Apr 2022 00:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724394;
        bh=8T0lBgoQWoXo++1zYYQNpWjrWSrfxMcdgn4fLJG3isI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng5CfoKyu7Uwm8/T6A5Y0xlcKQyEmsZbMA+y4tjExHDvET7Z5i2jqEN+hA0Zkqfp+
         r2mF7jprWoZsaEfm9TcrTdIUR+NHLPCUI6j3+sP/YVSoXbZ/Z4Ry2msE8hcHOhJdRn
         8pp6KZfm5O6tG/dFhh4L+1gcJDTe8kjmZw3EoGdwGGZTVTf0TK/9VeLgZnQdreeHHH
         DNOcVUh9B9XVebr+MjYj9G5iiR+DAbo0/VyKGlFfZCdv3NlcrDi1zX4SmMTmeP//gY
         N6OJdkZ75wPqrVb5ZDgbNpmuOgX96wzpxmxAk97zcZKm1W6ilKXYI2rOiYapKlHQLT
         h01h4ucEsIsNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Galakhov <agalakhov@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        john.garry@huawei.com, bvanassche@acm.org,
        chenxiang66@hisilicon.com, yuyufen@huawei.com,
        thunder.leizhen@huawei.com, yang.guang5@zte.com.cn,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 42/49] scsi: mvsas: Add PCI ID of RocketRaid 2640
Date:   Mon, 11 Apr 2022 20:44:00 -0400
Message-Id: <20220412004411.349427-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Alexey Galakhov <agalakhov@gmail.com>

[ Upstream commit 5f2bce1e222028dc1c15f130109a17aa654ae6e8 ]

The HighPoint RocketRaid 2640 is a low-cost SAS controller based on Marvell
chip. The chip in question was already supported by the kernel, just the
PCI ID of this particular board was missing.

Link: https://lore.kernel.org/r/20220309212535.402987-1-agalakhov@gmail.com
Signed-off-by: Alexey Galakhov <agalakhov@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvsas/mv_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index dcae2d4464f9..26d12035f472 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -646,6 +646,7 @@ static struct pci_device_id mvs_pci_table[] = {
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
 	{ PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
+	{ PCI_VDEVICE(TTI, 0x2640), chip_6440 },
 	{ PCI_VDEVICE(TTI, 0x2710), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2720), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2721), chip_9480 },
-- 
2.35.1

