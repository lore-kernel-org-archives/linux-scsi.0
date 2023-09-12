Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53827CA0ECD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 03:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241577AbjILDDH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 23:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241635AbjILDCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 23:02:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9343D1A6657;
        Mon, 11 Sep 2023 18:32:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4A8C3279D;
        Tue, 12 Sep 2023 00:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694480242;
        bh=rLTABGw2P+3lAhdcqxZYbLfxgEQDV7q07O7Gd8bqHzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quYSDvMqGfB5cZ1JKED+yTIcC5wgNa3WQDX7BVbTBFM9AQcjUbOTqWFq2iVqanjHP
         pFVky+8aT503G9OPZdjLYmEJgeJ/5wA0vA/mLdR0zojhBsMgE4BUlVgEss9e1T7S/s
         LgQv9QsvMfRCDjFZalmOirMFdA2HYm9zIGiopCptEmyIjE4spvJDmLwO7kH8+Wqc3Q
         8KWgVQVeyYbFHRSCb/Lj69ykZrVpgYUeOV7MgjBT6xntkEeRBf4belFNWSXkAzBSau
         NIqY1Mv7FyuhlHlcKHizkf/LFXvLtQEpptwCW32N2FkuEfpVX6fzHnMPxPkcZAzekx
         DR2HGCcDgP8ZA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH v2 17/21] ata: libata-core: Do not resume ports that have been runtime suspended
Date:   Tue, 12 Sep 2023 09:56:51 +0900
Message-ID: <20230912005655.368075-18-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912005655.368075-1-dlemoal@kernel.org>
References: <20230912005655.368075-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi disk driver does not resume disks that have been runtime
suspended by the user. To be consistent with this behavior, do the same
for ata ports and skip the PM request in ata_port_pm_resume() if the
port was already runtime suspended. With this change, it is no longer
necessary to for the PM state of the port to ACTIVE as the PM core code
will take care of that when handling runtime resume.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c3adaa01cbe3..080b451e7ddd 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5234,10 +5234,8 @@ static void ata_port_resume(struct ata_port *ap, pm_message_t mesg,
 
 static int ata_port_pm_resume(struct device *dev)
 {
-	ata_port_resume(to_ata_port(dev), PMSG_RESUME, true);
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	if (!pm_runtime_suspended(dev))
+		ata_port_resume(to_ata_port(dev), PMSG_RESUME, true);
 	return 0;
 }
 
-- 
2.41.0

