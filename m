Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1165E7D0B9
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 21:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjIUVFu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbjIUVFT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 17:05:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B12B0598;
        Thu, 21 Sep 2023 11:08:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BD4C433CA;
        Thu, 21 Sep 2023 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695319708;
        bh=flFAd8DdULULocs8cxL0Hlh1zT/I0HWgfXuDa6s6GKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDwGQlJ2OgC64uxH4SBsGUcCxZdr4brlxXU/H0gtjrlIQveZrhdqX+5oETXMySFWI
         Bjed7fmomcQXbpXRj/OFJDPitLJITeDlbtPHc51StAutKgqk08MXj/0f63leQ0us+A
         SlxhSf8cPWl2xZZBMyx2Ey0n2BXK0/1+L8TO44Fh7aauneJc4/4w2Ua50Okghwu8c1
         8DT7Ka8aTyHekzWnCgOuemwBuIskccDRqDQe5UNxrkPq7IblWhvgnlHo/YDuLyb+Os
         QJN8oVy/BjUVRR32k4TYF+7dscd7soGdSQyOoEYCOCJR1Ijj9NmWfdkEAx3aqfMkNE
         14oA8mZmpjPcg==
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
Subject: [PATCH v5 15/23] ata: libata-core: Detach a port devices on shutdown
Date:   Fri, 22 Sep 2023 03:07:50 +0900
Message-ID: <20230921180758.955317-16-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230921180758.955317-1-dlemoal@kernel.org>
References: <20230921180758.955317-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Modify ata_pci_shutdown_one() to schedule EH to unload a port devices
before freezing and thawing the port. This ensures that drives are
cleanly disabled and transitioned to standby power mode when
a PCI adapter is removed or the system is powered off.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/ata/libata-core.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index de661780a31e..6b38ebaad019 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6164,10 +6164,24 @@ EXPORT_SYMBOL_GPL(ata_pci_remove_one);
 void ata_pci_shutdown_one(struct pci_dev *pdev)
 {
 	struct ata_host *host = pci_get_drvdata(pdev);
+	struct ata_port *ap;
+	unsigned long flags;
 	int i;
 
+	/* Tell EH to disable all devices */
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
+		ap = host->ports[i];
+		spin_lock_irqsave(ap->lock, flags);
+		ap->pflags |= ATA_PFLAG_UNLOADING;
+		ata_port_schedule_eh(ap);
+		spin_unlock_irqrestore(ap->lock, flags);
+	}
+
+	for (i = 0; i < host->n_ports; i++) {
+		ap = host->ports[i];
+
+		/* Wait for EH to complete before freezing the port */
+		ata_port_wait_eh(ap);
 
 		ap->pflags |= ATA_PFLAG_FROZEN;
 
-- 
2.41.0

