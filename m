Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E99E80AB1
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 14:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjI0OTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjI0OTB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 10:19:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B487F1BD;
        Wed, 27 Sep 2023 07:18:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065B9C433C9;
        Wed, 27 Sep 2023 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695824338;
        bh=WrQnUDqGdBfHxfyHbGXnZd/U0ECxKurpC+XZ4MifIbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfd35k/GPTaLrYTvoBWHvN1uCPrx3/5WO7Py4acplfHnv5f5VaaXomlx3Ha8IaD9r
         RbK72tasWFt5Rncw6Fs32GRmyzftYEB5OYtEl2BVgkFBWcy92b1h94NBEFQwUccoMQ
         n5mI1OooL7OvTsNHgrTRuikuXgrLe2Y+CH7vP/Iv/6oyoAOo2ijzDTWcXfIpN91/Al
         3XIhtn3ITGOX9kGiLLDcpZkIkkjuvl/JshThc1naybCnLjmsnXfHP20I+7O9yZUwdL
         VaNWbfxt05Yx0bWzq8I8lvNm6TzBzgPWSeuHEe3EvWnlgs+8QuZ1DC1J/j5QXCZLN2
         /DsadIPjX093Q==
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
Subject: [PATCH v8 16/23] ata: libata-core: Remove ata_port_suspend_async()
Date:   Wed, 27 Sep 2023 23:18:21 +0900
Message-ID: <20230927141828.90288-17-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230927141828.90288-1-dlemoal@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ata_port_suspend_async() is only called by ata_sas_port_suspend().
Modify ata_port_suspend() with an additional bool argument indicating an
asynchronous or synchronous suspend to allow removing that helper
function. With this change, the variable ata_port_resume_ehi can also be
removed and its value (ATA_EHI_XXX flags passed directly to
ata_port_request_pm().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-core.c | 46 +++++++++++++++------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6b38ebaad019..291fc686ff08 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5166,18 +5166,8 @@ static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 		ata_port_wait_eh(ap);
 }
 
-/*
- * On some hardware, device fails to respond after spun down for suspend.  As
- * the device won't be used before being resumed, we don't need to touch the
- * device.  Ask EH to skip the usual stuff and proceed directly to suspend.
- *
- * http://thread.gmane.org/gmane.linux.ide/46764
- */
-static const unsigned int ata_port_suspend_ehi = ATA_EHI_QUIET
-						 | ATA_EHI_NO_AUTOPSY
-						 | ATA_EHI_NO_RECOVERY;
-
-static void ata_port_suspend(struct ata_port *ap, pm_message_t mesg)
+static void ata_port_suspend(struct ata_port *ap, pm_message_t mesg,
+			     bool async)
 {
 	/*
 	 * We are about to suspend the port, so we do not care about
@@ -5187,20 +5177,18 @@ static void ata_port_suspend(struct ata_port *ap, pm_message_t mesg)
 	 */
 	cancel_delayed_work_sync(&ap->scsi_rescan_task);
 
-	ata_port_request_pm(ap, mesg, 0, ata_port_suspend_ehi, false);
-}
-
-static void ata_port_suspend_async(struct ata_port *ap, pm_message_t mesg)
-{
 	/*
-	 * We are about to suspend the port, so we do not care about
-	 * scsi_rescan_device() calls scheduled by previous resume operations.
-	 * The next resume will schedule the rescan again. So cancel any rescan
-	 * that is not done yet.
+	 * On some hardware, device fails to respond after spun down for
+	 * suspend. As the device will not be used until being resumed, we
+	 * do not need to touch the device. Ask EH to skip the usual stuff
+	 * and proceed directly to suspend.
+	 *
+	 * http://thread.gmane.org/gmane.linux.ide/46764
 	 */
-	cancel_delayed_work_sync(&ap->scsi_rescan_task);
-
-	ata_port_request_pm(ap, mesg, 0, ata_port_suspend_ehi, true);
+	ata_port_request_pm(ap, mesg, 0,
+			    ATA_EHI_QUIET | ATA_EHI_NO_AUTOPSY |
+			    ATA_EHI_NO_RECOVERY,
+			    async);
 }
 
 static int ata_port_pm_suspend(struct device *dev)
@@ -5210,7 +5198,7 @@ static int ata_port_pm_suspend(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	ata_port_suspend(ap, PMSG_SUSPEND);
+	ata_port_suspend(ap, PMSG_SUSPEND, false);
 	return 0;
 }
 
@@ -5221,13 +5209,13 @@ static int ata_port_pm_freeze(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	ata_port_suspend(ap, PMSG_FREEZE);
+	ata_port_suspend(ap, PMSG_FREEZE, false);
 	return 0;
 }
 
 static int ata_port_pm_poweroff(struct device *dev)
 {
-	ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE);
+	ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
 	return 0;
 }
 
@@ -5279,7 +5267,7 @@ static int ata_port_runtime_idle(struct device *dev)
 
 static int ata_port_runtime_suspend(struct device *dev)
 {
-	ata_port_suspend(to_ata_port(dev), PMSG_AUTO_SUSPEND);
+	ata_port_suspend(to_ata_port(dev), PMSG_AUTO_SUSPEND, false);
 	return 0;
 }
 
@@ -5309,7 +5297,7 @@ static const struct dev_pm_ops ata_port_pm_ops = {
  */
 void ata_sas_port_suspend(struct ata_port *ap)
 {
-	ata_port_suspend_async(ap, PMSG_SUSPEND);
+	ata_port_suspend(ap, PMSG_SUSPEND, true);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_suspend);
 
-- 
2.41.0

