Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CED6EE6442
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 08:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjIOI0S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 04:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbjIOI0O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 04:26:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEE03AB2;
        Fri, 15 Sep 2023 01:24:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F83C433BA;
        Fri, 15 Sep 2023 08:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694765745;
        bh=MGyUTr147OXTgvJoJwfeJdXivkMDvvXqnQv8JHunP8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQGtx68aOodF4YT/Iknf367EzGBH2L8fIAvqeAgpJpu0JPhC+EbxksuBf1gsAimD9
         IGJIYTupCgBc6/pR63RKGk+cK6UCG65wsWA1qwPEYb5LxATIimd7gBu4N2bkK8l5KD
         nOlBGExoYpVRGroZdiSmKHfAtbGrg8PDb3Cja+Veis19tcW4/fGJ0mYYUQMrD0qXf3
         LLh0Npb/5M29zC9JZoir2TrdIYm0SmPqJMpl9FhQmgUmPQhAXmrqH4+PDPk5FnbNPl
         jSX98Z5mowShMKDCt/nsVwvuvhYshr3OoWOU7s6vgwyGKpyI4PYaQzCTD8zgQxUQCP
         D9Wr8yZ0hiLLQ==
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
Subject: [PATCH v3 19/23] ata: libata-core: Do not resume runtime suspended ports
Date:   Fri, 15 Sep 2023 17:15:03 +0900
Message-ID: <20230915081507.761711-20-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915081507.761711-1-dlemoal@kernel.org>
References: <20230915081507.761711-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi disk driver does not resume disks that have been runtime
suspended by the user. To be consistent with this behavior, do the same
for ata ports and skip the PM request in ata_port_pm_resume() if the
port was already runtime suspended. With this change, it is no longer
necessary to for the PM state of the port to ACTIVE as the PM core code
will take care of that when handling runtime resume.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 drivers/ata/libata-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c3adaa01cbe3..080b451e7ddd 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5234,10 +5234,8 @@ static void ata_port_resume(struct ata_port *ap, pm_message_t mesg,
 
 static int ata_port_pm_resume(struct device *dev)
 {
-	ata_port_resume(to_ata_port(dev), PMSG_RESUME, true);
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	if (!pm_runtime_suspended(dev))
+		ata_port_resume(to_ata_port(dev), PMSG_RESUME, true);
 	return 0;
 }
 
-- 
2.41.0

