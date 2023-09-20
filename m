Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B44CCE79D1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 13:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbjITN4P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbjITNzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 09:55:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F95E9;
        Wed, 20 Sep 2023 06:55:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36394C433C9;
        Wed, 20 Sep 2023 13:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695218113;
        bh=gGXXd0sNohYZ2QX/DYrm77jo5QxX/KViDYSPQEP3gCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKfwX5qpqMYYuEizfn2LXrAXn7tspF5503EA9ZVvO/z2Ffu5L/d/J+QE88szPcg+Y
         zGRZqiv6/NTbN5kXSo7ssXUwvxwJBfmZ9kyk/dc7YXxOWzx+GreOl8GIucvGDFcIY4
         V5qH7P4qfAdNhiBMm8BZYBHMA2nE+NG9Al28QMSkPibYmlkI63S1bC2f6i3cKXMlUX
         nxzoX7ABalKxDzZ9KdzemGm0sjVkpoTwsTgCknotg4iCP4gn79lifDqvM7Wk6UbNa0
         apDayXoU7WCy3vmJxNnMZcVOL94ftmqL2XeH6aQMJ1NfINJD0DliGCNCAB87hG8m1j
         Jhd44LpGdOtnw==
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
Subject: [PATCH v4 17/23] ata: libata-core: Remove ata_port_resume_async()
Date:   Wed, 20 Sep 2023 22:54:33 +0900
Message-ID: <20230920135439.929695-18-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
References: <20230920135439.929695-1-dlemoal@kernel.org>
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
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 drivers/ata/libata-core.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b3615862ea30..b46980fe69b4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5219,22 +5219,17 @@ static int ata_port_pm_poweroff(struct device *dev)
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
@@ -5273,7 +5268,7 @@ static int ata_port_runtime_suspend(struct device *dev)
 
 static int ata_port_runtime_resume(struct device *dev)
 {
-	ata_port_resume(to_ata_port(dev), PMSG_AUTO_RESUME);
+	ata_port_resume(to_ata_port(dev), PMSG_AUTO_RESUME, false);
 	return 0;
 }
 
@@ -5303,7 +5298,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_suspend);
 
 void ata_sas_port_resume(struct ata_port *ap)
 {
-	ata_port_resume_async(ap, PMSG_RESUME);
+	ata_port_resume(ap, PMSG_RESUME, true);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_resume);
 
-- 
2.41.0

