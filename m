Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67100E7D250
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 08:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbjIZIQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 04:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbjIZIQL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 04:16:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB01126;
        Tue, 26 Sep 2023 01:15:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B47C433CD;
        Tue, 26 Sep 2023 08:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695716145;
        bh=qrUl5SH+B8SP/ZoBFwIfkCLObB6aWz8x19i2XQMuplw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9NWQcjZaeDfKbyQMR+/6W9/6ysKZ+5zMVHyurpWzjuVAZXhloxrwwc8ttlNvTocX
         1EuKp6fKTzbRpaYOrruCyGzIXyF080CzQQTX/XRl4DYpFHwCnIef9XSZR41zGxZJaU
         Gu2eIut3BFZ0/Cx8s3CdPUPr3kxcoaJoWV81uOK8eJ1HaBowtkJi75PIFsYO8VCU2Y
         gFRa8fCdJB1aluY7z+mXJH3PSnaKXBcOrVQhpQvRGQVn1o3rChtMwZ1ZhmTDKwmP01
         NaNY4HYB4456ShikSnaKG8M81+Gs9Xtf73nN4vyVkZmUqQDDmuRnL2MxN5Sn/7iIjO
         KfEAd30stdGGg==
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
Subject: [PATCH v7 18/23] ata: libata-core: Do not poweroff runtime suspended ports
Date:   Tue, 26 Sep 2023 17:15:02 +0900
Message-ID: <20230926081507.69346-19-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230926081507.69346-1-dlemoal@kernel.org>
References: <20230926081507.69346-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When powering off, there is no need to suspend a port that has already
been runtime suspended. Skip the EH PM request in ata_port_pm_poweroff()
in this case.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6773a1e52dad..df6ed386e6fc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5215,7 +5215,8 @@ static int ata_port_pm_freeze(struct device *dev)
 
 static int ata_port_pm_poweroff(struct device *dev)
 {
-	ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
+	if (!pm_runtime_suspended(dev))
+		ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
 	return 0;
 }
 
-- 
2.41.0

