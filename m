Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF36EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 06:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjF2G0L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jun 2023 02:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjF2G0H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2023 02:26:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89D02D56;
        Wed, 28 Jun 2023 23:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AF07613F7;
        Thu, 29 Jun 2023 06:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBE7C433C8;
        Thu, 29 Jun 2023 06:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688019964;
        bh=8RqCu/onJv58TzXNwEU9CLDkGzmYgA7eGXK/nH0yQEw=;
        h=From:To:Subject:Date:From;
        b=IWR+rRSApsvsEe8aMd+mXoYjtjEidNjyRqSyP7XfUavtaUGGwj/fF6BN1cB4ZslAo
         /AJSlJVRCqyJzdx2lWKOSbQT8rjOGX9Z8aJdljtPiLHiSTKEgSGEpceD4Pkrerf7mw
         kTb8KsSnG+nqOCel2Gy/ZC+y+2F1V9FkXHEEMl5QTJ0omEOrsE0m+WqB+dIMr54P5B
         IJ380ynzWz9QMstiWmjakwM6gxJBc+ckkgqconBVD3iCEjv1gJx+A7/qKdKc6p/WuX
         0lgcXBxgZb2tXP1AlZrcdkQNpB5bk6EtbebRDT+sllWcR8HKCWMZqvgDQOLmui/qJY
         0d32yvf6hUclw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0/5] Improve checks in blk_revalidate_disk_zones()
Date:   Thu, 29 Jun 2023 15:25:57 +0900
Message-ID: <20230629062602.234913-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series slightly modifies the 4 block device drivers that support
zoned block devices to ensure that they all call
blk_revalidate_disk_zones() with the zone size and max zone append
limits set. This is done in the first 4 patches.

With these changes, the last patch improves blk_revalidate_disk_zones()
to better check a zoned device zones and the device limits.

Damien Le Moal (5):
  scsi: sd_zbc: Set zone limits before revalidating zones
  nvme: zns: Set zone limits before revalidating zones
  block: nullblk: Set zone limits before revalidating zones
  block: virtio_blk: Set zone limits before revalidating zones
  block: improve checks in blk_revalidate_disk_zones()

 block/blk-zoned.c              | 99 +++++++++++++++++++++-------------
 drivers/block/null_blk/zoned.c | 21 +++-----
 drivers/block/virtio_blk.c     | 35 ++++++------
 drivers/nvme/host/zns.c        |  9 ++--
 drivers/scsi/sd_zbc.c          | 12 ++---
 5 files changed, 96 insertions(+), 80 deletions(-)

-- 
2.41.0

