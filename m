Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25C2CE79D4
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 13:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbjITNyu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbjITNyu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 09:54:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2B3AC;
        Wed, 20 Sep 2023 06:54:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBFAC433C7;
        Wed, 20 Sep 2023 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695218084;
        bh=ZCI4sSkQUqW7rYXvjYJUsHOX8MS/EUoAf6/mwe1rYmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKHlgBYBvPM+8HauXDpbTX24s/HRIaaNp+VyJj4eVqUdbV7IZA7l5wrK0ZRWNhi2e
         tWgeXYTdvYEFEiHI+BU9Afyksyw+xjnvVNeKXfdeFglrfTbQWQq1p2TiGnN2WtPDWu
         O+bUEltpLgqQOWF+j3CiZsdS3gopJR7v5hGGQj6vvClJ49d6bJHquY3SK7U4fZfuZa
         uykgJFKIiLHPtSC11+8dGNOYCGuKlobHf8m/M9cVgutVsHdEbKCtNw+ykq5wQ2zqQh
         CeaSqPx+CZqbRasoFuoteFdm98ZPaKYruveZfzWmpMVitER6+7SzeSqP9WGODyTfxp
         VghloZKnihSnA==
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
Subject: [PATCH v4 01/23] ata: libata-core: Fix ata_port_request_pm() locking
Date:   Wed, 20 Sep 2023 22:54:17 +0900
Message-ID: <20230920135439.929695-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
References: <20230920135439.929695-1-dlemoal@kernel.org>
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

