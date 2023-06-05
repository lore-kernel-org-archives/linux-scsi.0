Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81F2C7EE32
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 01:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjFEBcW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Jun 2023 21:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbjFEBcS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jun 2023 21:32:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CE4A1;
        Sun,  4 Jun 2023 18:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22F5561CD7;
        Mon,  5 Jun 2023 01:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6475C4339B;
        Mon,  5 Jun 2023 01:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685928736;
        bh=v5d23/NZdpgwB/MjRjLHUqehpJQ8dARmruT3SeSfyT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOhoKSWcpvGBzYSMlBXa2MI12V2eMseGw1pWbgt1XjSNkiaAS3AWOVzHY84bF8ZoI
         VEHpIgXr0z5jWOVAR2RRxn9hQeG05D3PaKUiRLgKNggPSMlQA4e4Wmg4bCXcY+Gk9M
         Pb9vTX+nAaS2VwkmNZXveON5Vf221IiPgwqQWFOPmuJCDDrxxo30AL+GE9T9zDPRJh
         lkDLvLYG3RGWq6ljIvpnvjAKIE4sEFKaFNOk1luonf+sNi9EdkE/0WmGGG7yGW0W0o
         PbIPjAWFiok16X7418iecZ3MYRZ3tTaLDpvoKuoZn1cQ3zLzxZEXyX2o0YJyUHTpRP
         9n2IVFFjZEDoQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 3/3] ata: libata-scsi: Use ata_ncq_supported in ata_scsi_dev_config()
Date:   Mon,  5 Jun 2023 10:32:12 +0900
Message-Id: <20230605013212.573489-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605013212.573489-1-dlemoal@kernel.org>
References: <20230605013212.573489-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ata_scsi_dev_config(), instead of hardconing the test to check if
an ATA device supports NCQ by looking at the ATA_DFLAG_NCQ flag, use
ata_ncq_supported().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8ce90284eb34..22e2e9ab6b60 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1122,7 +1122,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
-	if (dev->flags & ATA_DFLAG_NCQ)
+	if (ata_ncq_supported(dev))
 		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
 	depth = min(ATA_MAX_QUEUE, depth);
 	scsi_change_queue_depth(sdev, depth);
-- 
2.40.1

