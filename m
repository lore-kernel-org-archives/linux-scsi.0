Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1656C77B73
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 10:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjFEKw7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 06:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjFEKwv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 06:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3B4FF;
        Mon,  5 Jun 2023 03:52:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1C9B62288;
        Mon,  5 Jun 2023 10:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29B9C4339B;
        Mon,  5 Jun 2023 10:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685962368;
        bh=aYzso8fy5Dgl/2hBGMWOcNZpxClSlia8ZTc/DNTTbhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiWkx0YPY8FsVee3FzY5OUB0q3C/vz9iCpcPV/VgkWN1+6BbTKKk+Y8wXGV/M5N4N
         MfUMEsToaBoYjx8ONjldEUpeZGi+R5RduxZmazz5p9PO9A7vumNbhG1mkvEfg7c6fe
         ujdDYjOjCcjk63YzBCPwHIL6nxe0lBEipmvf96NmjTrn6UAij2oY1m1bY4vSPnsjag
         gv50kgHa0CGQ7R8zSMS6nQGHwe/NFmxoUqigA0sE0hXi8Zmr7joTGp31tqAPvtkCnR
         mMNrnHT8XGZY9QnUKDZY/GMXAbPV/xRIg3liporW2nSfcFmKYb7aZIqsjv8/Emhadl
         PZ7UXQhm6l7kQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 2/3] ata: libata-eh: Use ata_ncq_enabled() in ata_eh_speed_down()
Date:   Mon,  5 Jun 2023 19:52:43 +0900
Message-Id: <20230605105244.1045490-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605105244.1045490-1-dlemoal@kernel.org>
References: <20230605105244.1045490-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ata_eh_speed_down(), instead of hard-coding the test on the device
flags to detect if NCQ is supported and enabled, use ata_ncq_enabled().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c7336a0a884d..b80e68000dd3 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1817,9 +1817,7 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev,
 	verdict = ata_eh_speed_down_verdict(dev);
 
 	/* turn off NCQ? */
-	if ((verdict & ATA_EH_SPDN_NCQ_OFF) &&
-	    (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ |
-			   ATA_DFLAG_NCQ_OFF)) == ATA_DFLAG_NCQ) {
+	if ((verdict & ATA_EH_SPDN_NCQ_OFF) && ata_ncq_enabled(dev)) {
 		dev->flags |= ATA_DFLAG_NCQ_OFF;
 		ata_dev_warn(dev, "NCQ disabled due to excessive errors\n");
 		goto done;
-- 
2.40.1

