Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BF6EEB580
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbjIKECy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbjIKECr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73556CCB;
        Sun, 10 Sep 2023 21:02:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3805C433C8;
        Mon, 11 Sep 2023 04:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404961;
        bh=FStmI6kiukZ1VyfmmHjQgHR8Avc6poR78gUoPe+cxHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRRj/ht6UOGZRj51noq77E658icpY2y8tq369TI08Ajz+knfltVh+MpcND79d4Q65
         XW177fq3JY5aAr9MU8Rt3BQSAH7yowm8zGHIMiynfTLDGl1elveu8ARXicRtqO4fy+
         gY41eDTCs3+g0MDQ9vEeDN1EohqyxY5QDV2xBuISgOZYJl7IfoIqqlhIjdxzFQDk9t
         WAi/Uq0FKfDJFf4jMGNmNOFjRFOukThXjx4Wv2BiM351ZWLNix2p8+rVrC0qIZPPrx
         yLmDKLuojcyQUKSJ4wXQdhX5gBHiZgmtM7WWssw1eSYtjOeBmRKyDNhoqhh0Z6NfOT
         YMQvS0YDN28Sw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 11/19] ata: libata-core: Detach a port devices on shutdown
Date:   Mon, 11 Sep 2023 13:02:09 +0900
Message-ID: <20230911040217.253905-12-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
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
---
 drivers/ata/libata-core.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fafd5a82c5ea..fa70d0ef92e5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6168,10 +6168,24 @@ EXPORT_SYMBOL_GPL(ata_pci_remove_one);
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

