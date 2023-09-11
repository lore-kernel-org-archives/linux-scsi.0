Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C331EE7FF4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbjIKECt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbjIKECo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0F41B4;
        Sun, 10 Sep 2023 21:02:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD85C433CA;
        Mon, 11 Sep 2023 04:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404959;
        bh=0Zke6p1qSsv6mPphV7L96K/SqJ/Y+ACrGIgbPRkq7Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0t9me7DO/PSX0DpqRDLp84CGuvtFTGUAhChlt6eobNsXR4NFeQKMu9Lw84Wgeaku
         dU07yoTs9RhSxVRInjanrgIMpNzJTREIHY9wagi80rHwocOrgdyFMvrZHR7v5Gs/DH
         UTF3GpLOm2zs/09Q785bQGn6Ns2Bagc6+ZZWJo//u4i5080uRpI23oRYzmb4xO0gmz
         GNB1Hu4BsO18U73juiqGodq7VUiUObvP7m9s0TpJ4uVrD8Xp0qM//wutOglqpDGEvI
         4qm3sogmUZIc/rHNpW8jw1+Kj4xc37B3JARQqC1en0p/l5my4ez7auC9CRnYy3NebQ
         WoHl8HQ86G4Jw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 10/19] ata: libata-core: Synchronize ata_port_detach() with hotplug
Date:   Mon, 11 Sep 2023 13:02:08 +0900
Message-ID: <20230911040217.253905-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The call to async_synchronize_cookie() to synchronize a port removal
and hotplug probe is done in ata_host_detach() right before calling
ata_port_detach(). Move this call at the beginning of ata_port_detach()
to ensure that this operation is always synchronized with probe.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d20ad3fc71cf..fafd5a82c5ea 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6069,6 +6069,9 @@ static void ata_port_detach(struct ata_port *ap)
 	struct ata_link *link;
 	struct ata_device *dev;
 
+	/* Ensure ata_port probe has completed */
+	async_synchronize_cookie(ap->cookie + 1);
+
 	/* Wait for any ongoing EH */
 	ata_port_wait_eh(ap);
 
@@ -6133,11 +6136,8 @@ void ata_host_detach(struct ata_host *host)
 {
 	int i;
 
-	for (i = 0; i < host->n_ports; i++) {
-		/* Ensure ata_port probe has completed */
-		async_synchronize_cookie(host->ports[i]->cookie + 1);
+	for (i = 0; i < host->n_ports; i++)
 		ata_port_detach(host->ports[i]);
-	}
 
 	/* the host is dead now, dissociate ACPI */
 	ata_acpi_dissociate(host);
-- 
2.41.0

