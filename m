Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1E1EB64DA
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jul 2023 02:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjGCCsT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jul 2023 22:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjGCCsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jul 2023 22:48:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E056E40;
        Sun,  2 Jul 2023 19:48:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EB9460C7A;
        Mon,  3 Jul 2023 02:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE18C433B9;
        Mon,  3 Jul 2023 02:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688352494;
        bh=6GZto+pVfutjvCNVgn2qE0kch1Ur5YkjwUQsX8M0fiQ=;
        h=From:To:Subject:Date:From;
        b=o/bZ+5ajQ0S9AB6W9WltMAv1GPT2ZfildaSo1qNlDgAwCcrr9FbGZJQyuGPrrbRUj
         QjgU5revdnbPUPuu9yrkPh1LB4KEVHqGzRS2+bb7DSF0S+10tpt5oBLHvisaPPkvWI
         DeWntvEljzSkMO3kNp6ujdpLAg63EXtJ3ASJ6jiTVCsomyJ3XnRSXEFmZTPS7uw54x
         iwMlhx+Usz7rkhWRW8BdckBi+w3rPzcAp3n1ox/wtX53G1QfOmKLMi1ah3fRzSJQMj
         8ZwTw1Z22iUyr6Ftp/BvHi6JecnUr1bpdWrTsFV89wuZ5G/LSdGU6z/BlXg0U+G7MF
         krAKEUY6F9Mtw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 0/5] Improve checks in blk_revalidate_disk_zones()
Date:   Mon,  3 Jul 2023 11:48:07 +0900
Message-ID: <20230703024812.76778-1-dlemoal@kernel.org>
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

Changes from v2:
 - Rebased on current Linus tree to fix a conflict with scsi changes in
   patch 1.
 - Added Reviewed-by tags.

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

