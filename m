Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D06EE6447
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 08:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbjIOIZ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 04:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjIOIZy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 04:25:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006073C32;
        Fri, 15 Sep 2023 01:23:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C609C433BB;
        Fri, 15 Sep 2023 08:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694765746;
        bh=jOxWM3EFcUw8KH8RxeHZOiDuMyEdT2/JG+xBMI/uyoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWGkZpwhbR6kLdzi6bVczTGg7RNcd1UpXHydB8CRhsJzQOESC1KXOIrrTPqP0DpT2
         JZU+YeYTMLl7DvA5kT1vs2KHvoSatdlxY1diThcRxcor/vjLzswhB9s+44tOQWeI7A
         j5XeiR0DeTXYG3E2Y5kZxIYYuJSInjvKxfqcVsMREleAKQ/ciWJ/hQr4h4aMLgjY59
         Shv/EyQwletwBDxSdqEILjGhC5av7VcH7gUqdrx7roRMbooKRBHwj443jAiaeWLHvU
         yHccSdR3etS6FQ55X9+tkKiQwhzq+6SLt9PvGAvNgiga/z28ab8dQagQheVxqCYohv
         /zh11Vq7R9ZfQ==
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
Subject: [PATCH v3 20/23] ata: libata-sata: Improve ata_sas_slave_configure()
Date:   Fri, 15 Sep 2023 17:15:04 +0900
Message-ID: <20230915081507.761711-21-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915081507.761711-1-dlemoal@kernel.org>
References: <20230915081507.761711-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change ata_sas_slave_configure() to return the return value of
ata_scsi_dev_config() to ensure that any error from that function is
propagated to libsas.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 drivers/ata/libata-sata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 5d31c08be013..0748e9ea4f5f 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1169,8 +1169,8 @@ EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
 int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
 {
 	ata_scsi_sdev_config(sdev);
-	ata_scsi_dev_config(sdev, ap->link.device);
-	return 0;
+
+	return ata_scsi_dev_config(sdev, ap->link.device);
 }
 EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
 
-- 
2.41.0

