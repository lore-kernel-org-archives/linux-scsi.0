Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0724E7D0A2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 20:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjIUUcM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjIUUbs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 16:31:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28ADFB05A5;
        Thu, 21 Sep 2023 11:08:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5235DC433C8;
        Thu, 21 Sep 2023 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695319715;
        bh=uvMbiXNNIjl/dA+3/T/1VF15D65NW5iWk83KkwR7epg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oieQdGBh1TIVcXf+RWlxuUHcRldwIWOUmxyvhOg+lmx0rYhyletewYD3iHHqa/kf4
         KziWTHP+Q4cy6S9Hs2Jz9i3hUF8K0rlZL/fcJ6EU5rYj2XQY2dIkjiz6EPxvFdQO/1
         svnUFg5OLKMMvAdc6TDeZV9yZ8MRJcWQYaJ0qL3VZWxYAsp9qQ/g2LoU+3guKjR+pP
         AoQEHjy1MxcUub32C5jSwSuujxUNcLIVDPJQJp01U1Gfge7ug2+G4O6eTTOLKyCg7d
         rumt0RM9/fR5cJ45WPBdRG1UeSTpwPJ1Oy/UvZO3hBWrkqfC99PVaNKWiyN9ZfldFi
         pjsvqnj40VXcg==
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
Subject: [PATCH v5 19/23] ata: libata-core: Do not resume runtime suspended ports
Date:   Fri, 22 Sep 2023 03:07:54 +0900
Message-ID: <20230921180758.955317-20-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230921180758.955317-1-dlemoal@kernel.org>
References: <20230921180758.955317-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi disk driver does not resume disks that have been runtime
suspended by the user. To be consistent with this behavior, do the same
for ata ports and skip the PM request in ata_port_pm_resume() if the
port was already runtime suspended. With this change, it is no longer
necessary to force the PM state of the port to ACTIVE as the PM core
code will take care of that when handling runtime resume.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/ata/libata-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 35112f9e482d..e0973f5614b0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5230,10 +5230,8 @@ static void ata_port_resume(struct ata_port *ap, pm_message_t mesg,
 
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

