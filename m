Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB59EB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jun 2023 08:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjF3Ijk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jun 2023 04:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF3Ijj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2023 04:39:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7F11BDB;
        Fri, 30 Jun 2023 01:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5349616F7;
        Fri, 30 Jun 2023 08:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A78C433C8;
        Fri, 30 Jun 2023 08:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688114377;
        bh=Rc6sCD5uTdJFBlUMasF2QuJU2L8t22jN/jo1b9z3E+A=;
        h=From:To:Subject:Date:From;
        b=CQbEzPnfqFQwdVFvIKB82JazqyQtAa6LHu/kcp3zZGiaF33rp46ld0AkrIs4JJHm3
         zfZ6PXPT0NPs3DzU45D99PBqL6diPzLsEX4N9wUkm+VNGMIuBZiwtAZPgEzhUZqIKJ
         JqlH3onQ47ZqrOJurNM9fEfy5xpKg3ItYhmKUVOai8vPqqU5caczw3FmP5T0OCNoq4
         5c7lKIdok6KRwHKE9b3QsxoCjA/RVimpQSbn2+4XUhVRRmMj1X/Sb/tJbEwiGrUVDH
         9viD4rkLjBte8jLz9ar4G9ndhkf2gxS6IEuzPl4dWPIwdhbxFPf1nacdWWfWL6SZ2U
         Sl/3Pu5Xu5DmA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 0/5] Improve checks in blk_revalidate_disk_zones()
Date:   Fri, 30 Jun 2023 17:39:30 +0900
Message-ID: <20230630083935.433334-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_revalidate_disk_zones() implements checks of the zones of a zoned
block device, verifying that the zone size is a power of 2 number of
sectors, that all zones (except possibly the last one) have the same
size and that zones cover the entire addressing space of the device.

While these checks are appropriate to verify that well tested hardware
devices have an adequate zone configurations, they lack in certain areas
which may result in issues with potentially buggy emulated devices
implemented with user drivers such as ublk or tcmu. Specifically, this
function does not check if the device driver indicated support for the
mandatory zone append writes, that is, if the device
max_zone_append_sectors queue limit is set to a non-zero value.
Additionally, invalid zones such as a zero length zone with a start
sector equal to the device capacity will not be detected and result in
out of bounds use of the zone bitmaps prepared with the callback
function blk_revalidate_zone_cb().

This series address these issues by modifying the 4 block device drivers
that currently support zoned block devices to ensure that they all set a
zoned device zone size and max zone append sectors limit before
executing blk_revalidate_disk_zones(). With these changes in place, 
patch 5 improves blk_revalidate_disk_zones() to address the missing
checks, relying on the fact that the zone size and zone append limit are
normally set when this function is called.

Changes from v1:
 - Updated this cover letter and commit messages to include better
   explain for these patches
 - Reworked patch 5 to simplify the checks
  
Damien Le Moal (5):
  scsi: sd_zbc: Set zone limits before revalidating zones
  nvme: zns: Set zone limits before revalidating zones
  block: nullblk: Set zone limits before revalidating zones
  block: virtio_blk: Set zone limits before revalidating zones
  block: improve checks in blk_revalidate_disk_zones()

 block/blk-zoned.c              | 86 ++++++++++++++++++++--------------
 drivers/block/null_blk/zoned.c | 16 ++-----
 drivers/block/virtio_blk.c     | 34 ++++++--------
 drivers/nvme/host/zns.c        |  9 ++--
 drivers/scsi/sd_zbc.c          | 12 ++---
 5 files changed, 79 insertions(+), 78 deletions(-)

-- 
2.41.0

