Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24960E7D250
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 08:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbjIZIQ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 04:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbjIZIQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 04:16:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9CE194;
        Tue, 26 Sep 2023 01:15:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE05EC433C7;
        Tue, 26 Sep 2023 08:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695716149;
        bh=B/LOcvpJHNZI8Taj8thEnE9tb7Zy6HMTbO08wRi1qFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2OvX8mhcnSZvtXWFT3nLMPa9Z6bjlA+0n5DicUH7QGDwnK0Qksqhn4HvsM68CEDW
         a7zIm9PpaEgbdnEQ+TrqA0JhKiPj8OCB48waNx9lCsqIEy1/t2nE1GTIjaiisZTPpy
         tZ6Q4oYlXRTJYnKf0Wa3ZJooQex5zgyDZ8NRAU+7SnWi2OrfIoSJZj407+rNY60m2E
         qRPRpp1gSm3hQEQKF3oB98j23F+7UrK2lc5gtu8F4esxPTPvlIqKijaYCRK4QiYmU1
         YbClLfaehRXxGHCBca1vm3jVACim6oZDv30xJMFRNNOxwsCUVk3xiBIII37+NsAfhI
         4EWDy8W774KqQ==
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
Subject: [PATCH v7 20/23] ata: libata-sata: Improve ata_sas_slave_configure()
Date:   Tue, 26 Sep 2023 17:15:04 +0900
Message-ID: <20230926081507.69346-21-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230926081507.69346-1-dlemoal@kernel.org>
References: <20230926081507.69346-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change ata_sas_slave_configure() to return the return value of
ata_scsi_dev_config() to ensure that any error from that function is
propagated to libsas.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-sata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index a701e1538482..83a9497e48e1 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1182,8 +1182,8 @@ EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
 int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
 {
 	ata_scsi_sdev_config(sdev);
-	ata_scsi_dev_config(sdev, ap->link.device);
-	return 0;
+
+	return ata_scsi_dev_config(sdev, ap->link.device);
 }
 EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
 
-- 
2.41.0

