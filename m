Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC12CE7A88
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Sep 2023 00:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjIWAaZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 20:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjIWAaL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 20:30:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B521B8;
        Fri, 22 Sep 2023 17:29:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66629C433CB;
        Sat, 23 Sep 2023 00:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695428997;
        bh=nRftvtXnga/jrlbpRmeNLEXg+UJSvM6XOdo4yjkCmUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JA8QrhUH8Pq002FQd1A8AodNCB8sI3nqGmBaa58UoAogqXDBlzQiMsDUy3RSSRwjx
         NHY836uHaXzQRGRRon2/+4bpqBtr/dfG/n+JXBDYYbfBZwRAFU5spX20U4uJS33qpj
         hqJu6wSalNkQYjj5mYgC/+UnpEBiYOjKPKYnSWaZ7gO5P6XLdxG/OO1dq8DU6AQEe0
         7dpGwnSTjchVN7wVM5OO1410/DvNnHw4xzTI7r6mrURxziCLy1+Kz59M6GILEohjC0
         FD4w8PHo9qd96GUBaoB2egTYf0NSctnBK/3tOf1NLMGfUl0giWRWn7uHIYdNHsQnNy
         oB6M49aGj8bVQ==
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
Subject: [PATCH v6 15/23] ata: libata-core: Detach a port devices on shutdown
Date:   Sat, 23 Sep 2023 09:29:24 +0900
Message-ID: <20230923002932.1082348-16-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923002932.1082348-1-dlemoal@kernel.org>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
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

