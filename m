Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30544CE79D5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 13:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbjITN4O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbjITNzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 09:55:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4861B9;
        Wed, 20 Sep 2023 06:55:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12ACEC433CA;
        Wed, 20 Sep 2023 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695218115;
        bh=fgu+9s+zIYN2vBNbGjGbJpKGkPqecQrsIWuJ5pxCRIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xjg/1A7TWqG/GUkg0ARI0fyiPyxbH2gp+uOFO9GCfNVtO+DgsJC0WYJpE38btykAl
         x5XAcVz58HpyYmXOmsBF5Rr9+8YZuaklp4yLioQC7pKAESPUdgAJotS0L0+/YcyLaR
         E/3HlIeZUoYBV+e1/IxQAims51f7peE9GAQ3LerUHaPHyVXh2X5DgEPgi4F6z2fA7z
         2imQxUkEm4tRdesLMYEQYVtmNvwE3tn6mstvC9M/JzoAyKuYZaoSjBom31b44fLbx4
         M3kDz/sdOIkXeJsjDLr+LeEFJn23t6ebPfE+uNot8rLnNxgkWeuv/+214w0ApHLV4I
         kYIy2YsJJRlnA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v4 18/23] ata: libata-core: Do not poweroff runtime suspended ports
Date:   Wed, 20 Sep 2023 22:54:34 +0900
Message-ID: <20230920135439.929695-19-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
References: <20230920135439.929695-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When powering off, there is no need to suspend a port that has already
been runtime suspended. Skip the EH PM request in ata_port_pm_poweroff()
in this case.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 drivers/ata/libata-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b46980fe69b4..35112f9e482d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5215,7 +5215,8 @@ static int ata_port_pm_freeze(struct device *dev)
 
 static int ata_port_pm_poweroff(struct device *dev)
 {
-	ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
+	if (!pm_runtime_suspended(dev))
+		ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
 	return 0;
 }
 
-- 
2.41.0

