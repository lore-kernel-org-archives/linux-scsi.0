Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19010CE79D1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 13:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbjITN4K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236536AbjITNzj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 09:55:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2A6DE;
        Wed, 20 Sep 2023 06:55:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5580C433C8;
        Wed, 20 Sep 2023 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695218108;
        bh=Cr8/NML99HfS5iRQ+YunyI5GV0kDLyHjEuSUU/ED3Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyK9F7H7Qnjfu+vDlzQQ7CekugLi2uplMs9JGtZIfWwNDTmed+EiZOLSWIgTu8NJ8
         3muaJvZdgfc+Xv8I0KT7RijtYeOqOE33dkEZwvnZj1HwCG9WtvyRXFdUiGJ8OXYmuk
         2ClzikdGkv3S47OGk0C61oDNnTAKXbkQTAYx+Cjhqz27IA5QXkJ0Ops2L9pUAKuUOu
         QTDvAmLLbZdqJyX4up0tAoEY0cVIN7dNH71DgZMyfgm6XlhKvfQBh6deHTVezpFrbQ
         z/mAYrhk0cumpg2HzTNshhCglWAuIpHg5HK1N4uHLIjVYCD4aXyLHACgeWnmOld5uX
         wBlaP0sGYeF8w==
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
Subject: [PATCH v4 14/23] ata: libata-core: Synchronize ata_port_detach() with hotplug
Date:   Wed, 20 Sep 2023 22:54:30 +0900
Message-ID: <20230920135439.929695-15-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
References: <20230920135439.929695-1-dlemoal@kernel.org>
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
index 8e326a445765..de661780a31e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6065,6 +6065,9 @@ static void ata_port_detach(struct ata_port *ap)
 	struct ata_link *link;
 	struct ata_device *dev;
 
+	/* Ensure ata_port probe has completed */
+	async_synchronize_cookie(ap->cookie + 1);
+
 	/* Wait for any ongoing EH */
 	ata_port_wait_eh(ap);
 
@@ -6129,11 +6132,8 @@ void ata_host_detach(struct ata_host *host)
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

