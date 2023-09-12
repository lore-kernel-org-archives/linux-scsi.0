Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AE2CA0ECA
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 04:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbjILELw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 00:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbjILELm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 00:11:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFF31A399C;
        Mon, 11 Sep 2023 18:32:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523EFC3279C;
        Tue, 12 Sep 2023 00:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694480241;
        bh=HNHz/1NLQsisYVxZ4YR7OWMwK4M26w6uXl/moLQU9KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcMFt/hU31LqGP3RVgyKSiEHivqhYpqweMOvB2IrBqvqIKJK+vQ0fQja9/+TLz+O+
         6knKQG0+7j52WJBRsMpTliBQ41EJqFCfSLStLE2kozqFyKD35LSi1bCwlITWzXGMBu
         f8E410qPxKnLhk2lx8wpLiA+7LL1dU70m5iPu/KjhoBJ/GV/Mva1TK9F6USCncYa1h
         AbIKMSjqcpK8eX4o2NvMEkH8LgnJXYapJ9u+Y56S3pCHThXYstlh3SGXTjEKchi5aM
         ZQpTIZjqP3x1WtwoHy153LGg1HOT5/kkAqJXy9zfh9SIwwEfmAXxxeQ817pSEAkCc+
         oMHfZuV8CEOiw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH v2 16/21] ata: libata-core: skip poweroff for devices that are runtime suspended
Date:   Tue, 12 Sep 2023 09:56:50 +0900
Message-ID: <20230912005655.368075-17-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912005655.368075-1-dlemoal@kernel.org>
References: <20230912005655.368075-1-dlemoal@kernel.org>
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
---
 drivers/ata/libata-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a4389dd807e5..c3adaa01cbe3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5219,7 +5219,8 @@ static int ata_port_pm_freeze(struct device *dev)
 
 static int ata_port_pm_poweroff(struct device *dev)
 {
-	ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
+	if (!pm_runtime_suspended(dev))
+		ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
 	return 0;
 }
 
-- 
2.41.0

