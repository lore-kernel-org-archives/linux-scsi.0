Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ADB2CA0ECE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 02:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbjILCH7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237228AbjILCCC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 22:02:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997C81A77B5;
        Mon, 11 Sep 2023 18:32:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D3EC32798;
        Tue, 12 Sep 2023 00:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694480235;
        bh=H7S9CWSwBWcMvM02J9ciRDGglwiD271p01jp7fyH4pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cspCOxtURVcDKek2r5iVQ31ehN4TWbzGhO5++0k/JNfJ9No1D386oCznYY5Benjk8
         f3Q3zfiGY/febzHtVt0QnyI3iXsR5H3qyWYZSrXZFNTJyRSTJWWDUPfsp3lLhygBZt
         23vp/FPDT/p8CjrvQlp82rYqbQT6YLRTf1vvbugioM22bKWaFX9kWp8eBgrjGXLeR0
         9wJRMXfOUV9oHGmXnCa80SIW8J3YLCjjEL0awkz3kfxC2NigQeq1/9GSzOMGjO6uLE
         /2HkDCqcw0QW73EX1zfv+8E8w1Gu+1hH93K7m6WkiOlvUG7u3B2ilNZPEG9IDnBYLT
         RhkoUB5Hx9UEA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH v2 12/21] ata: libata-core: Synchronize ata_port_detach() with hotplug
Date:   Tue, 12 Sep 2023 09:56:46 +0900
Message-ID: <20230912005655.368075-13-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912005655.368075-1-dlemoal@kernel.org>
References: <20230912005655.368075-1-dlemoal@kernel.org>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8d1949302a8a..9f05ad187c9e 100644
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

