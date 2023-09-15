Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD3EEE6442
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 08:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjIOI1T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 04:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjIOI1O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 04:27:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFC03ABA;
        Fri, 15 Sep 2023 01:25:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0499C433B9;
        Fri, 15 Sep 2023 08:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694765741;
        bh=LE4iH3AHIqlDXMEXWQkzC0CG96IX1D3ZEf3pbwhWkpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VasldwvkKi3pzaf13CnMRSjzqh/mrg8qHQ55PeUf+fz/oyuI4sLjBTUBFR8vRP6q9
         4h+BD3N7gNC66f5jvZynF3Bsj+MVwTbsScglEdSUVfh/oxat6qrgU+otmLi4JJZL4J
         5i1uRQZ0LGM08USpmalylzkIgKnKRGsjUQY0QofNqzEud1/sT+EOCYO5fxObOeOqV2
         OAFAmrCzzEqkCqwfdF9ht+qs2/N/2518/Y3UtJ5XFUZgXrwdsusKhi3oj4tcmwjWR0
         z3c6zAhsVHM+YFbIJKvpur/CRZyRXgHvSs0KGJlsYqVM74+MzTdlztqMB+Lt201LEl
         d2KSv7YYszRSA==
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
Subject: [PATCH v3 17/23] ata: libata-core: Remove ata_port_resume_async()
Date:   Fri, 15 Sep 2023 17:15:01 +0900
Message-ID: <20230915081507.761711-18-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915081507.761711-1-dlemoal@kernel.org>
References: <20230915081507.761711-1-dlemoal@kernel.org>
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

