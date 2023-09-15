Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475DFEE6442
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 08:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbjIOI0J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 04:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbjIOI0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 04:26:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE1F449C;
        Fri, 15 Sep 2023 01:23:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED033C433C9;
        Fri, 15 Sep 2023 08:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694765712;
        bh=g3BIcIFco/oFr9nhk2nJIvAHcMrNUjY6hk5vgy3kEqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zyfc7ra35gePyg/Pws+81nGy/H6Rfi6GIgk9FO8Ty3ycZh/cATRdY50sRISPESel1
         1jjnpwJWYAKP5F46nE/cqaDvEb9e8Vd7SRBH14bI1CUD3hKSh8cScDmcCMx7eAEvKo
         qoRSkCGLujISNhRNmKVN+mUSegAU1DI8tm6lz3mD7x+4oyRZHTe+XW6cnYSF/NX6zx
         whWkl1Iti3jkYg8LlFXEQwv2l9MyW8/YoB8x3CEPRApxXRwYrTyUo6/IR78LErHara
         6tmEt6a7rM9fSq/HmAUakODgcAOd2qb3X8yf/G7mH2v7WINFVv18PPDyJjOO/Sh+E6
         t5EtW7iCYSPgA==
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
Subject: [PATCH v3 01/23] ata: libata-core: Fix ata_port_request_pm() locking
Date:   Fri, 15 Sep 2023 17:14:45 +0900
Message-ID: <20230915081507.761711-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915081507.761711-1-dlemoal@kernel.org>
References: <20230915081507.761711-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function ata_port_request_pm() checks the port flag
ATA_PFLAG_PM_PENDING and calls ata_port_wait_eh() if this flag is set to
ensure that power management operations for a port are not secheduled
simultaneously. However, this flag check is done without holding the
port lock.

Fix this by taking the port lock on entry to the function and checking
the flag under this lock. The lock is released and re-taken if
ata_port_wait_eh() needs to be called.

Fixes: 5ef41082912b ("ata: add ata port system PM callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 drivers/ata/libata-core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 74314311295f..c4898483d716 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5040,17 +5040,20 @@ static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
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
+		spin_lock_irqsave(ap->lock, flags);
 		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
 	}
 
-	/* request PM ops to EH */
-	spin_lock_irqsave(ap->lock, flags);
-
+	/* Request PM operation to EH */
 	ap->pm_mesg = mesg;
 	ap->pflags |= ATA_PFLAG_PM_PENDING;
 	ata_for_each_link(link, ap, HOST_FIRST) {
@@ -5062,10 +5065,8 @@ static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 
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

