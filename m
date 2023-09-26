Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D12AE7D24F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 08:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbjIZIPX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 04:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjIZIPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 04:15:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EEBFC;
        Tue, 26 Sep 2023 01:15:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931F5C433C7;
        Tue, 26 Sep 2023 08:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695716112;
        bh=ldAq2tGryuf5HSb3UenWHmNL2txk3o4RbpCKtjqNOcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aL1X7dgxXdHPMvwhMMOecVcXFgLoqUbsU9x6XnVGpJ8ruF6OR7TCzE+TlftgogIlt
         wa+/LQN8s/gh4tDiYRx+YiauhD1aTY2nBBcE9kb+9W1IAXmaOiYge7OYss403bGj9D
         DC9J1lrWu9aFqcGDBflYU0A+3alvkgoTF4w7thKhizlnBfeIzhpT8l0IZlRrMdHXsO
         pOHd3BEtcS6+Cj3JABBTZsS24xPohPqoFf9HbCYOR7dVGE9phNd/uo/Q2LNV7X0jmX
         Z7maW5op9D5I9iBieK2kHU+WmkvN2dn4CMXdcF+v+ygYIHNIinP+S0zbrApc+XCstO
         oPF7tLLNuJz4Q==
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
Subject: [PATCH v7 01/23] ata: libata-core: Fix ata_port_request_pm() locking
Date:   Tue, 26 Sep 2023 17:14:45 +0900
Message-ID: <20230926081507.69346-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230926081507.69346-1-dlemoal@kernel.org>
References: <20230926081507.69346-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function ata_port_request_pm() checks the port flag
ATA_PFLAG_PM_PENDING and calls ata_port_wait_eh() if this flag is set to
ensure that power management operations for a port are not scheduled
simultaneously. However, this flag check is done without holding the
port lock.

Fix this by taking the port lock on entry to the function and checking
the flag under this lock. The lock is released and re-taken if
ata_port_wait_eh() needs to be called. The two WARN_ON() macros checking
that the ATA_PFLAG_PM_PENDING flag was cleared are removed as the first
call is racy and the second one done without holding the port lock.

Fixes: 5ef41082912b ("ata: add ata port system PM callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0072e0f9ad39..732f3d0b4fd9 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5037,17 +5037,19 @@ static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	struct ata_link *link;
 	unsigned long flags;
 
-	/* Previous resume operation might still be in
-	 * progress.  Wait for PM_PENDING to clear.
+	spin_lock_irqsave(ap->lock, flags);
+
+	/*
+	 * A previous PM operation might still be in progress. Wait for
+	 * ATA_PFLAG_PM_PENDING to clear.
 	 */
 	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
+		spin_unlock_irqrestore(ap->lock, flags);
 		ata_port_wait_eh(ap);
-		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
+		spin_lock_irqsave(ap->lock, flags);
 	}
 
-	/* request PM ops to EH */
-	spin_lock_irqsave(ap->lock, flags);
-
+	/* Request PM operation to EH */
 	ap->pm_mesg = mesg;
 	ap->pflags |= ATA_PFLAG_PM_PENDING;
 	ata_for_each_link(link, ap, HOST_FIRST) {
@@ -5059,10 +5061,8 @@ static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (!async) {
+	if (!async)
 		ata_port_wait_eh(ap);
-		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
-	}
 }
 
 /*
-- 
2.41.0

