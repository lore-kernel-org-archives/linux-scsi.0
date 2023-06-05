Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEBAC7EE23
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 10:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjFEKxC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 06:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjFEKwv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 06:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387B6102;
        Mon,  5 Jun 2023 03:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2AFD60FC8;
        Mon,  5 Jun 2023 10:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9679FC433D2;
        Mon,  5 Jun 2023 10:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685962369;
        bh=LCWH8t6kozpxMnw6bvJ/h5UUoZlbMzqTFCVsNCIPZsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohGOAXiHVBmJF07Ovr+5pCl/j6OVJXO0sKeFFkoOnTw2vNWUTaMSRSk0CaeuCA/dC
         Bp7vdmBrbtuFnKkucc0qpw5aYl/Ulfk/NpDd8kID5fEnGQAy9FnFne2S2ZGPqGVtpa
         NWCPzQ/7nMJ4ouSG6cprt6RNFjY8+8RpYRbqRc55XcEdp6bwVOunxd8H2TxX373GaT
         T9dZ8bSoMjiwWX3Q1EqMqjTmuScdGEwg4vtsK/HfSRtkBPjlVNUTW87kPXG+AiH7IJ
         D4HGfrX3anh2xMhq0tfQerHVWDqLgliVSgOP8YeydFtQFS6D++YOUCGqxDITIIMjv+
         0I98CeaIbXEcA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 3/3] ata: libata-scsi: Use ata_ncq_supported in ata_scsi_dev_config()
Date:   Mon,  5 Jun 2023 19:52:44 +0900
Message-Id: <20230605105244.1045490-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605105244.1045490-1-dlemoal@kernel.org>
References: <20230605105244.1045490-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ata_scsi_dev_config(), instead of hard-coding the test to check if
an ATA device supports NCQ by looking at the ATA_DFLAG_NCQ flag, use
ata_ncq_supported().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7bb12deab70c..9e79998e3958 100644
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

