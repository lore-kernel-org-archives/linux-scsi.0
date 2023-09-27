Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0280E80AAF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 14:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbjI0OTe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjI0OTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 10:19:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE711B9;
        Wed, 27 Sep 2023 07:18:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518A8C433C8;
        Wed, 27 Sep 2023 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695824336;
        bh=nRftvtXnga/jrlbpRmeNLEXg+UJSvM6XOdo4yjkCmUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CECjxo2A5LKcq/lpHQY5PJ/KEs6TxHyOQ9ApPJYmyWAbVH/Nf8EAcrl2O8UIJxSWM
         yMjy3/sNYFk1+B+n3h+mp7mly3P3yRLCuVJmwMTZ8lAnuT57K8+dC2HWP0vgHYr4Fx
         7F2o2wuB/adssKKOoDDkllUKw7/9gvqUA4Ydib2D3/GLedHWb430eYhl7l7P+n2UYf
         FHgIO2dpvtplabfD07vYIBDiuuBsYzKfjg2tfE2p6pnpD6u6jeIgk5OfqCqDHVOSRS
         QJn/sW3P4ZS6QDgzu+oXv1KAiJvtI6stq2LEJDFBMqm0D0m6VzjfmjmxmkSMmBKI35
         fdtcKmJW/VgfQ==
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
Subject: [PATCH v8 15/23] ata: libata-core: Detach a port devices on shutdown
Date:   Wed, 27 Sep 2023 23:18:20 +0900
Message-ID: <20230927141828.90288-16-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230927141828.90288-1-dlemoal@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
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
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

