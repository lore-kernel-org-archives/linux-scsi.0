Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F92CA0EC7
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 01:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjILBOc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 21:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjILBOX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 21:14:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354953E1D1;
        Mon, 11 Sep 2023 18:03:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3A6C3279B;
        Tue, 12 Sep 2023 00:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694480240;
        bh=C1HsbQi2la2V04e3k2OPKNpxNTVhh2TIOvP0cEy8ins=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpLbuKagvZ3AkwNRlktIq1NCOjuLC/2HjnjIs/hPLTSyVHNYLuBTYpwd6phXEIz87
         lL9lO6pe48HetnHtLemT2RBtJqTrn8Hr1EHWSuJW7/iv5D4TbvsUH3DtyOoFgXDzJX
         gB6Bl+jYsIoqLB8CLjEcN0dqKPoP+nvdmbIKUVBCZY98XLf8g/bsz4p8wg5xSRKYNe
         K6jyyHwLt9W9ULTHuhyPMPTPgtLjinzJmAV/dJFZEajiFCvv8/S2xIMJ6NzwN/JmLT
         gQ1YOvTB17ozllQ+rl55/raULXDjsOuEAAZ/xngIOoFaXtyLGTrDP3l963voLPrZ3+
         G9KlrLCGRGA1Q==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH v2 15/21] ata: libata-core: Remove ata_port_resume_async()
Date:   Tue, 12 Sep 2023 09:56:49 +0900
Message-ID: <20230912005655.368075-16-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912005655.368075-1-dlemoal@kernel.org>
References: <20230912005655.368075-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove ata_port_resume_async() and replace it with a modified
ata_port_resume() taking an additional bool argument indicating if
ata EH resume operation should be executed synchronously or
asynchronously. With this change, the variable ata_port_resume_ehi is
not longer necessary and its value (ATA_EHI_XXX flags) passed directly
to ata_port_request_pm().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index cdfe71ae6a6c..a4389dd807e5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5223,22 +5223,17 @@ static int ata_port_pm_poweroff(struct device *dev)
 	return 0;
 }
 
-static const unsigned int ata_port_resume_ehi = ATA_EHI_NO_AUTOPSY
-						| ATA_EHI_QUIET;
-
-static void ata_port_resume(struct ata_port *ap, pm_message_t mesg)
+static void ata_port_resume(struct ata_port *ap, pm_message_t mesg,
+			    bool async)
 {
-	ata_port_request_pm(ap, mesg, ATA_EH_RESET, ata_port_resume_ehi, false);
-}
-
-static void ata_port_resume_async(struct ata_port *ap, pm_message_t mesg)
-{
-	ata_port_request_pm(ap, mesg, ATA_EH_RESET, ata_port_resume_ehi, true);
+	ata_port_request_pm(ap, mesg, ATA_EH_RESET,
+			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET,
+			    async);
 }
 
 static int ata_port_pm_resume(struct device *dev)
 {
-	ata_port_resume_async(to_ata_port(dev), PMSG_RESUME);
+	ata_port_resume(to_ata_port(dev), PMSG_RESUME, true);
 	pm_runtime_disable(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
@@ -5277,7 +5272,7 @@ static int ata_port_runtime_suspend(struct device *dev)
 
 static int ata_port_runtime_resume(struct device *dev)
 {
-	ata_port_resume(to_ata_port(dev), PMSG_AUTO_RESUME);
+	ata_port_resume(to_ata_port(dev), PMSG_AUTO_RESUME, false);
 	return 0;
 }
 
@@ -5307,7 +5302,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_suspend);
 
 void ata_sas_port_resume(struct ata_port *ap)
 {
-	ata_port_resume_async(ap, PMSG_RESUME);
+	ata_port_resume(ap, PMSG_RESUME, true);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_resume);
 
-- 
2.41.0

