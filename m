Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EE6EE6442
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 08:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjIOIZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 04:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbjIOIZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 04:25:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6B52D4A;
        Fri, 15 Sep 2023 01:23:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CF7C433AD;
        Fri, 15 Sep 2023 08:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694765736;
        bh=KJoyWvVWhsIz4VVso+iFvB6Gta5M3O5M/mkqnLKFAMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOHIwpDXHQeN0cKfb8Tg7KzXDw7VargqVzd76etLNp6rMvtOt4i2g3/YMGoAEumdY
         H9CGFmkxHKto93ya71zo1m/wxHsnmwBio2Bi+w+UeCKMozQqGLfVgcn2ML/BMjnQLC
         KWz1gWzzyDbyIxlYHPu68gwgO8tnU0bUTyoZsMqB+0BAYYs7qCaK3kdVW40nFzX0rB
         LU2ZdfhEGvvA9dwg96a2eD6LVbSGqWMWWOQPFVmlAUh/K8IodMXob//uCJfs49+CIG
         QqKGlHiR9UDK+qo/aJlEYJnwRysr0j4UKC6H7x0mzJ1qV32cocsDHmeenUKINj7Y70
         U2yUuFUM77vIw==
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
Subject: [PATCH v3 14/23] ata: libata-core: Synchronize ata_port_detach() with hotplug
Date:   Fri, 15 Sep 2023 17:14:58 +0900
Message-ID: <20230915081507.761711-15-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915081507.761711-1-dlemoal@kernel.org>
References: <20230915081507.761711-1-dlemoal@kernel.org>
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
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
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

