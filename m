Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69931C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CD9D230FC
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbhAVICO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 03:02:14 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:38095 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbhAVICD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 03:02:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611302522; x=1642838522;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5xfbHvgjhWJgLXZcVOEkOEdiGZ/g9yxwTbfqK6J5900=;
  b=aXNwfr1ESLrN4iIZt0APGyV2zAMWVr2KEFL3b+tUVio9WF8Ag/x5TW9q
   2DoMHAw83AWkdqrtryQxgzlSWWiNwUH6UX+FNHKX+fMZAM/OBqjqfZLJp
   3WETzLMoVAYyf/VpqxGc6K87x1iGgixPO1NBnOmTTvfqJgfTGq5fy/MAL
   3N2xLehP1B2Hg1V8706O+tEQP07EOC/PH27G1EcGNAqIBEdQklb8st5u5
   DiqIFWCbgtwoJQCmdKfemhOS86ApCkWDtakMNjKJ9os6ixOP44yL4TEBk
   jWi7DpOaExG7nQHm9TvMzkYlV3ZZYjIPw6Wcro5XZmN7Ycjsr1lwobMZO
   Q==;
IronPort-SDR: rEOPKDBnJ6XcQiQw55slCl7CK170m1B2jEUP3mkPK9AmacC7KpFQrBCSebqBV+qV0bWo5wZlro
 ZYPp/BEkrNdTt92T/HovFZPGKUmZ1L9h6Vg+nVmmWm/25C4ERJ0uiJ3OB/BMtFBXvrTicTLTQR
 CoiR5yzn9hIhG1DZdbJjff3M3mfQqEf7QnTIwby0ZWIR5J2Y1ki/juGrx/18QfNh+h/Rzobazx
 wdJmJvrU4DLlffGgFFqRO0A+LJYoCbofy5u1C2/456BC0tYXce7zgakmw1eZD9TWZKGBqO40qD
 7mA=
X-IronPort-AV: E=Sophos;i="5.79,366,1602518400"; 
   d="scan'208";a="268398849"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2021 16:00:21 +0800
IronPort-SDR: +BkBiBiQK39nb2tNLBzIPIVUJgi61aLS51cUuxMNGs1k0foSBfi04FCzaEl/qyvNNCZDTBCDKH
 QKyzlGBvdUFpRAwSe1AslqC1T7M7FJXuZDNqzRM7gMsWwrfmkPIByak5jjdFtYTLvo3T8MamOZ
 x2dPbcA+q2MVgawbjRT9u/Lefo6lqvqtOe6FzV9+4hvhELSlL9nL7IX0gxGRfkx+K9lB1dJErQ
 Zxnhg2ibRpkQz9Y0Ff5zsjYYDoXr4sWci2ez+Es3Vj1HQoW6jkyxc05BxbJjWXexOsfxjxJSqd
 z63WJ1Uf+OI0zH+SL8Wvh6yM
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 23:42:52 -0800
IronPort-SDR: DvcsHkJNFEtNvTji/LXw3hNgrcJ0I9b0dMZR16CPd3l7W226K2tH9phrbCblOykbO7PjYySuV1
 MR1ZLLwMjlq8/v6xCaH1Cb9R5gNZhauyH6vo4m1m2e3KUDbo3XSM06WdVsgfDlHOh8nhoNAe4S
 xkSboBPdJ1dx8LFAuKQtRA197nDmjJVsXWMfaEEXAwhnhwE62vrDafnYcvb9zY+CyvurAnDabb
 5rnLjvci8UkQy/q/NG8IGhTFO95xO8YvShrflxl1OQ3f4FwViCBGfyAxbxZMTPlHF3IrkyVV4p
 Ygg=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Jan 2021 00:00:20 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: [PATCH v3 3/3] zonefs: use zone write granularity as block size
Date:   Fri, 22 Jan 2021 17:00:14 +0900
Message-Id: <20210122080014.174391-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210122080014.174391-1-damien.lemoal@wdc.com>
References: <20210122080014.174391-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Zoned block devices have different granularity constraints for write
operations into sequential zones. E.g. ZBC and ZAC devices require that
writes be aligned to the device physical block size while NVMe ZNS
devices allow logical block size aligned write operations. To correctly
handle such difference, use the device zone write granularity limit to
set the block size of a zonefs volume, thus allowing the smallest
possible write unit for all zoned device types.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 fs/zonefs/super.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index bec47f2d074b..8973d77ba000 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1581,12 +1581,11 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran	= 1;
 
 	/*
-	 * The block size is set to the device physical sector size to ensure
-	 * that write operations on 512e devices (512B logical block and 4KB
-	 * physical block) are always aligned to the device physical blocks,
-	 * as mandated by the ZBC/ZAC specifications.
+	 * The block size is set to the device zone write granularity to ensure
+	 * that write operations are always aligned according to the device
+	 * interface constraints.
 	 */
-	sb_set_blocksize(sb, bdev_physical_block_size(sb->s_bdev));
+	sb_set_blocksize(sb, bdev_zone_write_granularity(sb->s_bdev));
 	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
 	sbi->s_uid = GLOBAL_ROOT_UID;
 	sbi->s_gid = GLOBAL_ROOT_GID;
-- 
2.29.2

