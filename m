Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7C4E7D24F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 08:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbjIZIQ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 04:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbjIZIQQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 04:16:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB191139;
        Tue, 26 Sep 2023 01:15:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20F0C433C9;
        Tue, 26 Sep 2023 08:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695716147;
        bh=R1tYu+zCjKRGxXsPNNRChzgkkzMhM2utM9Va0s9nexk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3YPeUoiGGIh7llRrR8KL4Il7nRd/J/40k2J8KqqDD6/t4d4+17ifDks3N1ONPXAw
         VBroHseuQtAqNmODqgRshpxZemKxJokhmrnTsqDbtXVfH99Fw8eI24NffbKMbueLcF
         aGxbPXWm6HZGZLLlbqIUEN+BN30icYjWDmciBlHda+hqyosO9lgbrmDfmuSoalKw/e
         6rRkq9P3XTriPCM3g4WxASxPkh3RrG+7YGgaC7er/wXQz7Kph6GAwSeUEhwyIB2WLM
         BwCIKnltL+nzPIAzs4+N4qk/sgF1mpZvCp9g1oIboxskPSebTRrmk8nUCvQ9SPoBzk
         DS1m8MV6MQKBw==
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
Subject: [PATCH v7 19/23] ata: libata-core: Do not resume runtime suspended ports
Date:   Tue, 26 Sep 2023 17:15:03 +0900
Message-ID: <20230926081507.69346-20-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230926081507.69346-1-dlemoal@kernel.org>
References: <20230926081507.69346-1-dlemoal@kernel.org>
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
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index df6ed386e6fc..58f03031a259 100644
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

